param(
    [string]$Root = (Resolve-Path ".").Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

function Color-Hex([string]$Hex, [int]$Alpha = 255) {
    $value = $Hex.TrimStart("#")
    if ($value.Length -eq 3) {
        $value = -join ($value.ToCharArray() | ForEach-Object { "$_$_" })
    }
    return [System.Drawing.Color]::FromArgb(
        $Alpha,
        [Convert]::ToInt32($value.Substring(0, 2), 16),
        [Convert]::ToInt32($value.Substring(2, 2), 16),
        [Convert]::ToInt32($value.Substring(4, 2), 16)
    )
}

function Solid([string]$Hex, [int]$Alpha = 255) {
    return [System.Drawing.SolidBrush]::new((Color-Hex $Hex $Alpha))
}

function Pen-Hex([string]$Hex, [float]$Width, [int]$Alpha = 255) {
    $pen = [System.Drawing.Pen]::new((Color-Hex $Hex $Alpha), $Width)
    $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    return $pen
}

function Points([double[]]$Values) {
    $points = New-Object "System.Drawing.PointF[]" ([int]($Values.Length / 2))
    for ($i = 0; $i -lt $Values.Length; $i += 2) {
        $points[[int]($i / 2)] = [System.Drawing.PointF]::new([single]$Values[$i], [single]$Values[$i + 1])
    }
    return ,$points
}

function New-RoundPath([float]$X, [float]$Y, [float]$W, [float]$H, [float]$R) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $d = $R * 2.0
    $path.AddArc($X, $Y, $d, $d, 180, 90)
    $path.AddArc($X + $W - $d, $Y, $d, $d, 270, 90)
    $path.AddArc($X + $W - $d, $Y + $H - $d, $d, $d, 0, 90)
    $path.AddArc($X, $Y + $H - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    return $path
}

function Fill-Round($G, $Brush, [float]$X, [float]$Y, [float]$W, [float]$H, [float]$R) {
    $path = New-RoundPath $X $Y $W $H $R
    $G.FillPath($Brush, $path)
    $path.Dispose()
}

function Draw-Round($G, $Pen, [float]$X, [float]$Y, [float]$W, [float]$H, [float]$R) {
    $path = New-RoundPath $X $Y $W $H $R
    $G.DrawPath($Pen, $path)
    $path.Dispose()
}

function Fill-Poly($G, $Brush, [double[]]$Values) {
    $G.FillPolygon($Brush, (Points $Values))
}

function Draw-Poly($G, $Pen, [double[]]$Values) {
    $G.DrawPolygon($Pen, (Points $Values))
}

function Draw-Line($G, [string]$Color, [float]$Width, [double]$X1, [double]$Y1, [double]$X2, [double]$Y2, [int]$Alpha = 255) {
    $pen = Pen-Hex $Color $Width $Alpha
    $G.DrawLine($pen, [single]$X1, [single]$Y1, [single]$X2, [single]$Y2)
    $pen.Dispose()
}

function Draw-Bezier($G, [string]$Color, [float]$Width, [double[]]$Values, [int]$Alpha = 255) {
    $pen = Pen-Hex $Color $Width $Alpha
    $G.DrawBezier(
        $pen,
        [single]$Values[0], [single]$Values[1],
        [single]$Values[2], [single]$Values[3],
        [single]$Values[4], [single]$Values[5],
        [single]$Values[6], [single]$Values[7]
    )
    $pen.Dispose()
}

function Draw-Leaf($G, [float]$Cx, [float]$Cy, [float]$Sx, [float]$Sy, [float]$Angle, [string]$Fill, [string]$Line = "#295330") {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $path.AddBezier(0, 0, -0.50, -0.55, -0.82, -0.15, 0, 1.0)
    $path.AddBezier(0, 1.0, 0.82, -0.15, 0.50, -0.55, 0, 0)
    $m = [System.Drawing.Drawing2D.Matrix]::new()
    $m.Scale($Sx, $Sy)
    $m.Rotate($Angle)
    $m.Translate($Cx, $Cy, [System.Drawing.Drawing2D.MatrixOrder]::Append)
    $path.Transform($m)
    $brush = Solid $Fill 245
    $pen = Pen-Hex $Line 3 170
    $G.FillPath($brush, $path)
    $G.DrawPath($pen, $path)
    $brush.Dispose()
    $pen.Dispose()
    $m.Dispose()
    $path.Dispose()
}

function Draw-Droplet($G, [float]$Cx, [float]$Cy, [float]$Scale, [string]$Fill) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $path.AddBezier(0, -20, -18, 5, -12, 24, 0, 30)
    $path.AddBezier(0, 30, 12, 24, 18, 5, 0, -20)
    $m = [System.Drawing.Drawing2D.Matrix]::new()
    $m.Scale($Scale, $Scale)
    $m.Translate($Cx, $Cy, [System.Drawing.Drawing2D.MatrixOrder]::Append)
    $path.Transform($m)
    $brush = Solid $Fill 235
    $G.FillPath($brush, $path)
    $brush.Dispose()
    $m.Dispose()
    $path.Dispose()
}

function Draw-Fish($G, [float]$Cx, [float]$Cy, [float]$S, [string]$Fill, [string]$Line) {
    $brush = Solid $Fill 240
    $pen = Pen-Hex $Line 4 210
    $G.FillEllipse($brush, $Cx - 42 * $S, $Cy - 20 * $S, 82 * $S, 40 * $S)
    $tail = @(
        [double]($Cx + 32 * $S), [double]$Cy,
        [double]($Cx + 62 * $S), [double]($Cy - 25 * $S),
        [double]($Cx + 62 * $S), [double]($Cy + 25 * $S)
    )
    Fill-Poly $G $brush $tail
    $G.DrawEllipse($pen, $Cx - 42 * $S, $Cy - 20 * $S, 82 * $S, 40 * $S)
    Draw-Poly $G $pen $tail
    $eye = Solid "#263135" 240
    $G.FillEllipse($eye, $Cx - 25 * $S, $Cy - 6 * $S, 8 * $S, 8 * $S)
    $eye.Dispose()
    $brush.Dispose()
    $pen.Dispose()
}

function Draw-Symbol($G, [string]$Kind) {
    switch ($Kind) {
        "wild_potato" {
            $body = Solid "#8b6033" 245
            $dark = Pen-Hex "#5b3b20" 5 210
            $G.FillEllipse($body, 70, 94, 116, 78)
            $G.DrawEllipse($dark, 70, 94, 116, 78)
            Draw-Line $G "#4d8d43" 8 126 98 120 58
            Draw-Leaf $G 105 62 28 48 -38 "#5fa85a"
            Draw-Leaf $G 139 58 28 50 34 "#73b560"
            $mark = Solid "#6d4726" 170
            $G.FillEllipse($mark, 102, 124, 14, 9)
            $G.FillEllipse($mark, 142, 139, 11, 8)
            $mark.Dispose(); $body.Dispose(); $dark.Dispose()
        }
        "palm_frond" {
            Draw-Line $G "#365b32" 9 67 165 185 78
            foreach ($i in 0..7) {
                $x = 78 + $i * 14
                Draw-Line $G "#5ba856" 7 $x (158 - $i * 10) ($x - 27) (130 - $i * 12)
                Draw-Line $G "#72bd64" 7 $x (158 - $i * 10) ($x + 38) (135 - $i * 14)
            }
        }
        "vine" {
            Draw-Bezier $G "#397646" 13 @(65,172, 52,86, 170,76, 181,155)
            Draw-Bezier $G "#74b65a" 6 @(69,172, 70,103, 156,94, 173,155)
            Draw-Leaf $G 93 105 22 38 -40 "#6fbf63"
            Draw-Leaf $G 141 92 22 36 42 "#82c76a"
            Draw-Leaf $G 172 137 20 34 18 "#67aa55"
        }
        "rope" {
            $pen = Pen-Hex "#b9823d" 17 245
            $G.DrawArc($pen, 62, 78, 132, 96, 16, 305)
            $pen.Dispose()
            for ($i = 0; $i -lt 8; $i++) {
                Draw-Line $G "#f0c27a" 3 (78 + $i * 14) 87 (67 + $i * 14) 125 170
            }
            Draw-Line $G "#6d4724" 8 80 159 54 189
            Draw-Line $G "#6d4724" 8 164 154 193 187
        }
        "animal_hide" {
            $hide = Solid "#bb8354" 245
            Fill-Poly $G $hide @(83,72, 119,89, 154,69, 178,103, 164,142, 183,174, 139,188, 115,167, 80,184, 67,142, 86,111)
            $line = Pen-Hex "#5e3925" 5 210
            Draw-Poly $G $line @(83,72, 119,89, 154,69, 178,103, 164,142, 183,174, 139,188, 115,167, 80,184, 67,142, 86,111)
            $spot = Solid "#6e472e" 150
            $G.FillEllipse($spot, 108, 111, 21, 14)
            $G.FillEllipse($spot, 142, 139, 26, 17)
            $spot.Dispose(); $hide.Dispose(); $line.Dispose()
        }
        "snare_trap" {
            $loop = Pen-Hex "#d5ad6c" 13 245
            $G.DrawEllipse($loop, 63, 64, 129, 94)
            $loop.Dispose()
            Draw-Line $G "#855830" 9 128 154 128 199
            Draw-Line $G "#855830" 9 94 178 164 178
            Draw-Line $G "#ead296" 5 92 78 162 146
        }
        "clay" {
            $clay = Solid "#a85b3e" 245
            $G.FillEllipse($clay, 55, 127, 148, 48)
            $G.FillEllipse($clay, 83, 91, 91, 70)
            $line = Pen-Hex "#693525" 5 190
            $G.DrawArc($line, 73, 114, 111, 51, 6, 168)
            Draw-Line $G "#d8895e" 6 86 143 178 143 185
            $clay.Dispose(); $line.Dispose()
        }
        "sharp_stone" {
            $stone = Solid "#8d9790" 245
            Fill-Poly $G $stone @(124,53, 181,181, 65,151)
            $line = Pen-Hex "#4a5350" 6 210
            Draw-Poly $G $line @(124,53, 181,181, 65,151)
            Draw-Line $G "#d5ddd6" 5 124 65 105 147 180
            Draw-Line $G "#626d66" 4 124 65 152 162 170
            $stone.Dispose(); $line.Dispose()
        }
        "stone_knife" {
            $blade = Solid "#b8c7be" 245
            Fill-Poly $G $blade @(128,45, 167,122, 132,137, 93,124)
            $line = Pen-Hex "#52615c" 5 210
            Draw-Poly $G $line @(128,45, 167,122, 132,137, 93,124)
            Draw-Line $G "#6e4525" 14 126 137 103 196
            Draw-Line $G "#d0a25b" 5 115 153 100 191 180
            $blade.Dispose(); $line.Dispose()
        }
        "survival_axe" {
            Draw-Line $G "#79502c" 15 105 185 145 72
            $head = Solid "#aeb8ae" 245
            Fill-Poly $G $head @(133,61, 187,84, 161,120, 126,110)
            Fill-Poly $G $head @(133,61, 91,82, 111,115, 126,110)
            $line = Pen-Hex "#4e5a55" 5 210
            Draw-Poly $G $line @(133,61, 187,84, 161,120, 126,110)
            Draw-Poly $G $line @(133,61, 91,82, 111,115, 126,110)
            $head.Dispose(); $line.Dispose()
        }
        "lighter" {
            $body = Solid "#d68f38" 245
            Fill-Round $G $body 86 82 82 105 12
            $cap = Solid "#cfd6ce" 245
            Fill-Round $G $cap 89 61 76 36 8
            Draw-Line $G "#5f4730" 5 92 116 162 116 180
            Draw-Droplet $G 127 48 0.65 "#ffcf55"
            $body.Dispose(); $cap.Dispose()
        }
        "torch" {
            Draw-Line $G "#76502d" 18 111 191 142 76
            $wrap = Solid "#d6ba80" 245
            Fill-Round $G $wrap 103 84 58 36 8
            $wrap.Dispose()
            Draw-Droplet $G 132 55 1.0 "#ffb643"
            Draw-Droplet $G 132 63 0.55 "#f36c32"
        }
        "mud_wall" {
            $brick = Solid "#8f5a3a" 245
            Fill-Round $G $brick 59 76 138 112 9
            $mortar = Pen-Hex "#d3a577" 5 190
            Draw-Round $G $mortar 59 76 138 112 9
            foreach ($y in @(111,146)) { Draw-Line $G "#d3a577" 5 61 $y 195 $y 190 }
            foreach ($x in @(102,151)) { Draw-Line $G "#d3a577" 5 $x 76 $x 111 190 }
            foreach ($x in @(82,130,176)) { Draw-Line $G "#d3a577" 5 $x 146 $x 188 190 }
            $brick.Dispose(); $mortar.Dispose()
        }
        "cooked_meat" {
            $meat = Solid "#9d4c2f" 245
            $G.FillEllipse($meat, 74, 91, 99, 76)
            $bone = Pen-Hex "#f1dfb5" 16 245
            $G.DrawLine($bone, 155, 143, 198, 179)
            $G.FillEllipse((Solid "#f1dfb5" 245), 188, 170, 24, 20)
            $line = Pen-Hex "#5d2d21" 5 210
            $G.DrawEllipse($line, 74, 91, 99, 76)
            Draw-Line $G "#e19055" 5 93 119 143 113 180
            $meat.Dispose(); $bone.Dispose(); $line.Dispose()
        }
        "raw_meat" {
            $meat = Solid "#b33a35" 245
            Fill-Poly $G $meat @(78,93, 125,72, 176,97, 183,151, 138,181, 84,157)
            $fat = Solid "#f3b9ad" 210
            Fill-Poly $G $fat @(108,102, 143,96, 163,124, 139,145, 101,134)
            $line = Pen-Hex "#682621" 5 210
            Draw-Poly $G $line @(78,93, 125,72, 176,97, 183,151, 138,181, 84,157)
            $meat.Dispose(); $fat.Dispose(); $line.Dispose()
        }
        "dried_fish" {
            Draw-Line $G "#c79b59" 5 128 56 128 92 200
            Draw-Fish $G 120 132 0.90 "#c08b4a" "#684525"
            foreach ($x in @(96,118,140)) { Draw-Line $G "#7a4d28" 4 $x 114 $x 150 170 }
        }
        "fish_trap" {
            $basket = Solid "#b47b3d" 230
            Fill-Poly $G $basket @(65,105, 194,78, 174,177, 82,180)
            $pen = Pen-Hex "#68411f" 5 210
            Draw-Poly $G $pen @(65,105, 194,78, 174,177, 82,180)
            foreach ($x in @(91,117,143,169)) { Draw-Line $G "#f0c27a" 4 $x 95 ($x - 13) 178 185 }
            foreach ($y in @(113,137,160)) { Draw-Line $G "#f0c27a" 4 72 $y 184 ($y - 21) 185 }
            $basket.Dispose(); $pen.Dispose()
        }
        "leaf_shelter" {
            $roof = Solid "#5d934b" 245
            Fill-Poly $G $roof @(62,154, 131,70, 196,154)
            Draw-Line $G "#3d4b2e" 8 63 154 196 154
            Draw-Line $G "#77512e" 10 84 180 131 72
            Draw-Line $G "#77512e" 10 174 180 131 72
            foreach ($x in @(88,110,132,154,176)) { Draw-Line $G "#7fc06a" 5 $x 137 ($x + 16) 154 190 }
            $roof.Dispose()
        }
        "drying_rack" {
            Draw-Line $G "#774d2a" 9 70 185 96 82
            Draw-Line $G "#774d2a" 9 186 185 160 82
            Draw-Line $G "#774d2a" 9 86 102 171 102
            foreach ($x in @(101,128,155)) {
                Draw-Line $G "#c7a06d" 4 $x 103 $x 131 210
                Draw-Fish $G $x 150 0.38 "#c38c4a" "#65411f"
            }
        }
        "workbench" {
            $wood = Solid "#8d5a30" 245
            Fill-Round $G $wood 61 103 135 48 7
            Draw-Line $G "#5e351c" 8 76 151 71 188
            Draw-Line $G "#5e351c" 8 180 151 185 188
            Draw-Line $G "#d49a56" 4 72 120 187 120 180
            Draw-Line $G "#cfd6ce" 7 96 84 142 84
            Draw-Line $G "#cfd6ce" 7 142 84 159 68
            $wood.Dispose()
        }
        "rain_collector" {
            $cloth = Solid "#4f9e9d" 230
            Fill-Poly $G $cloth @(61,85, 196,82, 159,140, 99,140)
            Draw-Line $G "#346e72" 6 61 85 196 82
            Draw-Line $G "#346e72" 6 99 140 159 140
            $bowl = Solid "#8c6a3a" 245
            $G.FillPie($bowl, 84, 139, 89, 62, 0, 180)
            Draw-Droplet $G 128 112 0.50 "#76c9df"
            Draw-Droplet $G 151 121 0.38 "#9bdceb"
            $cloth.Dispose(); $bowl.Dispose()
        }
        "medkit" {
            $box = Solid "#f0e8d6" 245
            Fill-Round $G $box 66 82 124 101 14
            Draw-Line $G "#b13b35" 21 128 106 128 160
            Draw-Line $G "#b13b35" 21 101 133 155 133
            Draw-Round $G (Pen-Hex "#72553a" 5 200) 66 82 124 101 14
            Draw-Line $G "#72553a" 5 103 82 103 68
            Draw-Line $G "#72553a" 5 153 82 153 68
            Draw-Line $G "#72553a" 5 103 68 153 68
            $box.Dispose()
        }
        "handheld_game" {
            $case = Solid "#6f6f83" 245
            Fill-Round $G $case 60 80 136 92 20
            $screen = Solid "#b9d5bf" 245
            Fill-Round $G $screen 93 95 70 42 6
            $dark = Solid "#242633" 245
            $G.FillEllipse($dark, 75, 122, 14, 14)
            $G.FillEllipse($dark, 171, 116, 12, 12)
            $G.FillEllipse($dark, 157, 133, 12, 12)
            Draw-Line $G "#343746" 5 72 105 91 105
            Draw-Line $G "#343746" 5 82 95 82 115
            $case.Dispose(); $screen.Dispose(); $dark.Dispose()
        }
        "survival_guide" {
            $cover = Solid "#405e45" 245
            Fill-Round $G $cover 76 61 105 137 9
            Draw-Line $G "#f0d88f" 7 99 84 158 84
            Draw-Line $G "#f0d88f" 5 100 112 157 112
            Draw-Line $G "#f0d88f" 5 100 135 148 135
            Draw-Line $G "#27382a" 5 94 61 94 198
            $page = Pen-Hex "#e8dec4" 5 180
            Draw-Round $G $page 76 61 105 137 9
            $cover.Dispose(); $page.Dispose()
        }
        "palm_tree" {
            Draw-Line $G "#7c512f" 15 122 185 139 83
            Draw-Line $G "#a46e3d" 5 126 167 140 149 180
            foreach ($spec in @(
                @(133,82,52,32,-77), @(133,82,58,34,-42), @(133,82,60,35,2),
                @(133,82,55,33,44), @(133,82,49,31,82)
            )) { Draw-Leaf $G $spec[0] $spec[1] $spec[2] $spec[3] $spec[4] "#5eb25a" }
        }
        "coconut_palm" {
            Draw-Line $G "#79502e" 14 118 186 137 86
            foreach ($spec in @(
                @(136,86,52,31,-68), @(136,86,56,33,-30), @(136,86,58,34,22), @(136,86,50,31,68)
            )) { Draw-Leaf $G $spec[0] $spec[1] $spec[2] $spec[3] $spec[4] "#5fae58" }
            $nut = Solid "#7d542d" 245
            $G.FillEllipse($nut, 118, 94, 20, 20)
            $G.FillEllipse($nut, 136, 99, 19, 19)
            $G.FillEllipse($nut, 126, 112, 18, 18)
            $nut.Dispose()
        }
        "wild_potato_patch" {
            $soil = Solid "#6f4a2b" 245
            $G.FillEllipse($soil, 58, 139, 141, 42)
            foreach ($x in @(86,124,162)) {
                Draw-Line $G "#4d8b42" 6 $x 145 $x 104
                Draw-Leaf $G ($x - 13) 111 18 31 -37 "#69aa58"
                Draw-Leaf $G ($x + 14) 108 18 31 34 "#75b862"
            }
            $pot = Solid "#9a6638" 245
            $G.FillEllipse($pot, 103, 152, 28, 18)
            $G.FillEllipse($pot, 144, 150, 25, 17)
            $soil.Dispose(); $pot.Dispose()
        }
        "berry_bush" {
            $bush = Solid "#4f8c48" 245
            $G.FillEllipse($bush, 62, 105, 70, 67)
            $G.FillEllipse($bush, 104, 79, 83, 83)
            $G.FillEllipse($bush, 122, 118, 70, 63)
            $berry = Solid "#c43b43" 245
            foreach ($p in @(@(96,128),@(132,109),@(160,143),@(116,153),@(148,123))) { $G.FillEllipse($berry, $p[0], $p[1], 14, 14) }
            $bush.Dispose(); $berry.Dispose()
        }
        "driftwood_pile" {
            foreach ($line in @(
                @(67,151,174,116), @(82,179,191,147), @(66,126,154,171)
            )) {
                Draw-Line $G "#8b5a31" 20 $line[0] $line[1] $line[2] $line[3]
                Draw-Line $G "#d29957" 4 $line[0] $line[1] $line[2] $line[3] 180
            }
        }
        "fallen_tree" {
            Draw-Line $G "#83552f" 31 55 138 201 118
            Draw-Line $G "#c98b4c" 6 68 136 189 120 160
            $ring = Pen-Hex "#e3ba73" 5 210
            $G.DrawEllipse($ring, 47, 123, 26, 31)
            $G.DrawEllipse($ring, 184, 106, 26, 31)
            $ring.Dispose()
            Draw-Line $G "#5d3b22" 10 132 123 150 91
        }
        "vine_thicket" {
            foreach ($v in @(
                @(61,172,91,85,162,95,188,157),
                @(83,187,68,112,178,73,174,180),
                @(55,133,120,71,163,158,204,96)
            )) { Draw-Bezier $G "#3c7c45" 9 $v 230 }
            foreach ($p in @(@(86,110,-38),@(145,94,28),@(172,153,46),@(116,170,-22))) {
                Draw-Leaf $G $p[0] $p[1] 18 30 $p[2] "#72b95f"
            }
        }
        "freshwater_spring" {
            $pool = Solid "#4ca7bd" 230
            $G.FillEllipse($pool, 55, 124, 147, 55)
            $foam = Pen-Hex "#c4f1f3" 6 210
            $G.DrawArc($foam, 78, 133, 98, 27, 185, 160)
            Draw-Droplet $G 111 87 0.58 "#8fd9e9"
            Draw-Droplet $G 144 103 0.45 "#a7e9ef"
            $pool.Dispose(); $foam.Dispose()
        }
        "clay_bank" {
            $bank = Solid "#9b5d3d" 245
            Fill-Poly $G $bank @(58,116, 196,91, 186,159, 74,178)
            Draw-Line $G "#d58d62" 6 72 128 185 108 190
            Draw-Line $G "#6e3929" 6 79 155 178 137 190
            $water = Pen-Hex "#5faec0" 8 210
            $G.DrawArc($water, 63, 162, 131, 29, 195, 150)
            $bank.Dispose(); $water.Dispose()
        }
        "stone_outcrop" {
            $stone = Solid "#8a938c" 245
            Fill-Poly $G $stone @(67,163, 90,98, 130,73, 176,103, 196,164)
            $line = Pen-Hex "#4d5854" 6 210
            Draw-Poly $G $line @(67,163, 90,98, 130,73, 176,103, 196,164)
            Draw-Line $G "#cfd7d1" 5 130 78 122 159 180
            Draw-Line $G "#68736d" 5 130 78 164 158 180
            $stone.Dispose(); $line.Dispose()
        }
        "reed_patch" {
            foreach ($x in @(75,96,119,141,164,184)) {
                Draw-Line $G "#416d43" 7 $x 183 ($x + (($x % 3) - 1) * 11) 83
                $head = Solid "#b78d48" 245
                $G.FillEllipse($head, $x - 6, 76, 12, 31)
                $head.Dispose()
            }
            Draw-Line $G "#5da056" 5 62 184 197 184 190
        }
    }
}

function New-Icon([string]$RelativePath, [string]$Kind, [string]$Base, [string]$Accent) {
    $path = Join-Path $Root $RelativePath
    $folder = Split-Path $path -Parent
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }

    $format = [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
    $bitmap = [System.Drawing.Bitmap]::new(256, 256, $format)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.Clear([System.Drawing.Color]::Transparent)

    $shadow = Solid "#000000" 44
    $graphics.FillEllipse($shadow, 45, 206, 166, 22)
    $shadow.Dispose()

    $baseBrush = Solid $Base 232
    $accentPen = Pen-Hex $Accent 4 190
    Fill-Round $graphics $baseBrush 31 31 194 194 45
    Draw-Round $graphics $accentPen 31 31 194 194 45
    $baseBrush.Dispose()
    $accentPen.Dispose()

    Draw-Symbol $graphics $Kind
    $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
}

$icons = @(
    @("assets/icons/items/wild_potato.png", "wild_potato", "#efe1b9", "#9f6b35"),
    @("assets/icons/items/palm_frond.png", "palm_frond", "#dcefc7", "#4e8f45"),
    @("assets/icons/items/vine.png", "vine", "#d7eccb", "#3d7d46"),
    @("assets/icons/items/rope.png", "rope", "#efe0bc", "#a87538"),
    @("assets/icons/items/animal_hide.png", "animal_hide", "#ead1ad", "#9a6747"),
    @("assets/icons/items/snare_trap.png", "snare_trap", "#eadfc5", "#9a7345"),
    @("assets/icons/items/clay.png", "clay", "#e5c0a9", "#9c5338"),
    @("assets/icons/items/sharp_stone.png", "sharp_stone", "#d9dfda", "#747d78"),
    @("assets/icons/items/stone_knife.png", "stone_knife", "#dfe5dd", "#6f7b75"),
    @("assets/icons/items/survival_axe.png", "survival_axe", "#d9e1d8", "#686f68"),
    @("assets/icons/items/lighter.png", "lighter", "#f0dab6", "#bc782e"),
    @("assets/icons/items/torch.png", "torch", "#f0d7b0", "#c47233"),
    @("assets/icons/items/mud_wall.png", "mud_wall", "#e3b68b", "#8d5637"),
    @("assets/icons/items/cooked_meat.png", "cooked_meat", "#edd0b3", "#985031"),
    @("assets/icons/items/raw_meat.png", "raw_meat", "#f0c8c1", "#a23331"),
    @("assets/icons/items/dried_fish.png", "dried_fish", "#ead2aa", "#9b7040"),
    @("assets/icons/items/fish_trap.png", "fish_trap", "#ead7b5", "#94602e"),
    @("assets/icons/items/leaf_shelter.png", "leaf_shelter", "#dce9c9", "#5c8948"),
    @("assets/icons/items/drying_rack.png", "drying_rack", "#ead3ae", "#86552e"),
    @("assets/icons/items/workbench.png", "workbench", "#ead2ae", "#85542d"),
    @("assets/icons/items/rain_collector.png", "rain_collector", "#d1e8e8", "#4e9ba0"),
    @("assets/icons/items/medkit.png", "medkit", "#eee4d2", "#b84a40"),
    @("assets/icons/items/handheld_game.png", "handheld_game", "#d4d6df", "#6a6f84"),
    @("assets/icons/items/survival_guide.png", "survival_guide", "#dce3c8", "#405e45"),
    @("assets/icons/objects/palm_tree.png", "palm_tree", "#dcedc7", "#578e49"),
    @("assets/icons/objects/coconut_palm.png", "coconut_palm", "#dcecc7", "#578e49"),
    @("assets/icons/objects/wild_potato_patch.png", "wild_potato_patch", "#ead9b6", "#8a5c34"),
    @("assets/icons/objects/berry_bush.png", "berry_bush", "#d9ecc9", "#598f4b"),
    @("assets/icons/objects/driftwood_pile.png", "driftwood_pile", "#ead3b1", "#8c5b32"),
    @("assets/icons/objects/fallen_tree.png", "fallen_tree", "#ead2ae", "#83552f"),
    @("assets/icons/objects/vine_thicket.png", "vine_thicket", "#d9eccb", "#417f45"),
    @("assets/icons/objects/freshwater_spring.png", "freshwater_spring", "#cfeaec", "#4ca7bd"),
    @("assets/icons/objects/clay_bank.png", "clay_bank", "#e7c0a7", "#9b5d3d"),
    @("assets/icons/objects/stone_outcrop.png", "stone_outcrop", "#dbe0dc", "#737d78"),
    @("assets/icons/objects/reed_patch.png", "reed_patch", "#deebc4", "#577a3f")
)

foreach ($icon in $icons) {
    New-Icon $icon[0] $icon[1] $icon[2] $icon[3]
}

Write-Host "Generated $($icons.Count) distinct icon files."
