param(
    [string]$Root = (Resolve-Path ".").Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

function Color-Hex([string]$Hex, [int]$Alpha = 255) {
    $value = $Hex.TrimStart("#")
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

function Fill-Poly($G, $Brush, [double[]]$Values) {
    $G.FillPolygon($Brush, (Points $Values))
}

function Draw-Line($G, [string]$Color, [float]$Width, [double]$X1, [double]$Y1, [double]$X2, [double]$Y2, [int]$Alpha = 255) {
    $pen = Pen-Hex $Color $Width $Alpha
    $G.DrawLine($pen, [single]$X1, [single]$Y1, [single]$X2, [single]$Y2)
    $pen.Dispose()
}

function Draw-Bezier($G, [string]$Color, [float]$Width, [double[]]$Values, [int]$Alpha = 255) {
    $pen = Pen-Hex $Color $Width $Alpha
    $G.DrawBezier($pen, [single]$Values[0], [single]$Values[1], [single]$Values[2], [single]$Values[3], [single]$Values[4], [single]$Values[5], [single]$Values[6], [single]$Values[7])
    $pen.Dispose()
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

function Draw-Drop($G, [float]$Cx, [float]$Cy, [float]$Scale, [string]$Fill) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $path.AddBezier(0, -27, -24, 5, -16, 34, 0, 42)
    $path.AddBezier(0, 42, 16, 34, 24, 5, 0, -27)
    $matrix = [System.Drawing.Drawing2D.Matrix]::new()
    $matrix.Scale($Scale, $Scale)
    $matrix.Translate($Cx, $Cy, [System.Drawing.Drawing2D.MatrixOrder]::Append)
    $path.Transform($matrix)
    $brush = Solid $Fill 238
    $G.FillPath($brush, $path)
    $brush.Dispose()
    $matrix.Dispose()
    $path.Dispose()
}

function Draw-Leaf($G, [float]$Cx, [float]$Cy, [float]$Sx, [float]$Sy, [float]$Angle, [string]$Fill) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $path.AddBezier(0, -1, -0.85, -0.45, -0.78, 0.55, 0, 1)
    $path.AddBezier(0, 1, 0.78, 0.55, 0.85, -0.45, 0, -1)
    $matrix = [System.Drawing.Drawing2D.Matrix]::new()
    $matrix.Scale($Sx, $Sy)
    $matrix.Rotate($Angle)
    $matrix.Translate($Cx, $Cy, [System.Drawing.Drawing2D.MatrixOrder]::Append)
    $path.Transform($matrix)
    $brush = Solid $Fill 238
    $G.FillPath($brush, $path)
    $brush.Dispose()
    $matrix.Dispose()
    $path.Dispose()
}

function Draw-Fish($G, [float]$Cx, [float]$Cy, [float]$S) {
    $brush = Solid "#5aa8c6" 238
    $pen = Pen-Hex "#285e78" 7 220
    $G.FillEllipse($brush, $Cx - 47 * $S, $Cy - 22 * $S, 88 * $S, 44 * $S)
    Fill-Poly $G $brush @([double]($Cx + 33 * $S), [double]$Cy, [double]($Cx + 66 * $S), [double]($Cy - 28 * $S), [double]($Cx + 66 * $S), [double]($Cy + 28 * $S))
    $G.DrawEllipse($pen, $Cx - 47 * $S, $Cy - 22 * $S, 88 * $S, 44 * $S)
    $brush.Dispose(); $pen.Dispose()
}

function Draw-Paw($G, [float]$Cx, [float]$Cy, [float]$S, [string]$Fill) {
    $brush = Solid $Fill 238
    $G.FillEllipse($brush, $Cx - 19 * $S, $Cy - 7 * $S, 38 * $S, 29 * $S)
    foreach ($p in @(@(-26,-22), @(-8,-30), @(11,-30), @(28,-20))) {
        $G.FillEllipse($brush, $Cx + $p[0] * $S - 8 * $S, $Cy + $p[1] * $S - 8 * $S, 16 * $S, 16 * $S)
    }
    $brush.Dispose()
}

function Draw-Check($G, [string]$Color = "#f1e9b5") {
    Draw-Line $G $Color 16 82 135 113 164
    Draw-Line $G $Color 16 113 164 178 88
}

function Draw-Hammer($G) {
    Draw-Line $G "#7f5632" 18 105 179 154 98
    $head = Solid "#b9c2b6" 238
    Fill-Poly $G $head @(127,75, 184,95, 172,122, 118,106)
    Fill-Poly $G $head @(127,75, 88,91, 103,115, 118,106)
    $head.Dispose()
}

function Draw-Snare($G, [bool]$Broken = $false) {
    $pen = Pen-Hex "#d9b776" 16 238
    $G.DrawEllipse($pen, 62, 66, 132, 93)
    $pen.Dispose()
    Draw-Line $G "#7d542d" 10 127 156 127 196
    if ($Broken) {
        Draw-Line $G "#d64f3b" 10 88 84 118 124
        Draw-Line $G "#d64f3b" 10 118 84 88 124
    }
}

function Draw-Symbol($G, [string]$Kind) {
    switch ($Kind) {
        "wet_ground" {
            $mud = Solid "#7b5b3e" 232
            $G.FillEllipse($mud, 58, 139, 139, 45)
            Draw-Drop $G 125 89 0.75 "#5cb7d3"
            Draw-Line $G "#3a2d22" 7 84 155 174 150 160
            $mud.Dispose()
        }
        "rain_puddle" {
            $pool = Solid "#4aa6bf" 232
            $G.FillEllipse($pool, 52, 128, 151, 52)
            Draw-Drop $G 102 86 0.54 "#a9e8f0"
            Draw-Drop $G 151 101 0.44 "#a9e8f0"
            $pool.Dispose()
        }
        "storm_debris" {
            Draw-Bezier $G "#4c8ca4" 10 @(57,102, 105,52, 163,77, 193,119)
            Draw-Bezier $G "#4c8ca4" 8 @(67,152, 118,199, 174,177, 196,133)
            Draw-Line $G "#916132" 18 75 166 180 108
            Draw-Line $G "#d2a165" 5 83 162 172 113 180
        }
        "washed_away" {
            Draw-Bezier $G "#54a9c5" 17 @(54,143, 88,112, 121,171, 158,137)
            Draw-Bezier $G "#54a9c5" 17 @(112,143, 141,111, 169,169, 204,136)
            Draw-Line $G "#f0dc91" 10 88 86 169 86
            Fill-Poly $G (Solid "#f0dc91" 238) @(168,61, 202,86, 168,111)
        }
        "damaged_trap" {
            Draw-Snare $G $true
        }
        "trap_catch" {
            Draw-Snare $G $false
            Draw-Paw $G 154 118 0.72 "#d65f3e"
        }
        "hunt_success" {
            Draw-Paw $G 103 126 1.05 "#ba623d"
            Draw-Check $G "#f1e9b5"
        }
        "animal_tracks" {
            Draw-Paw $G 93 139 0.70 "#75503a"
            Draw-Paw $G 150 99 0.70 "#75503a"
        }
        "found_objects" {
            $box = Solid "#b78042" 238
            Fill-Round $G $box 75 102 106 76 10
            Draw-Line $G "#f2d082" 8 81 126 176 126
            Draw-Line $G "#f2d082" 7 128 103 128 177
            Draw-Line $G "#fff0a8" 7 178 78 178 103
            Draw-Line $G "#fff0a8" 7 165 91 191 91
            $box.Dispose()
        }
        "fishing_spot" {
            Draw-Fish $G 118 121 0.82
            $ripple = Pen-Hex "#bfeaf1" 7 210
            $G.DrawArc($ripple, 69, 151, 118, 32, 187, 166)
            $ripple.Dispose()
        }
        "fresh_gather" {
            Draw-Line $G "#4f7a3a" 9 126 178 126 97
            Draw-Leaf $G 101 118 26 42 -38 "#65b65a"
            Draw-Leaf $G 151 108 28 44 42 "#7ac864"
            Draw-Leaf $G 125 84 22 35 0 "#8ed26d"
        }
        "picked_over" {
            $basket = Solid "#a8743d" 238
            Fill-Poly $G $basket @(68,110, 190,111, 171,178, 86,177)
            Draw-Line $G "#f0c17d" 6 83 132 176 132 190
            Draw-Line $G "#f0c17d" 6 91 154 169 154 190
            Draw-Line $G "#45311f" 9 100 92 159 92
            $basket.Dispose()
        }
        "worked_ground" {
            Draw-Hammer $G
            Draw-Line $G "#b98342" 9 66 169 184 169
            Draw-Line $G "#b98342" 7 87 144 168 144
        }
        "developed" {
            Draw-Hammer $G
            Draw-Check $G "#f4e58a"
        }
        "fully_surveyed" {
            $map = Solid "#ead79f" 238
            Fill-Poly $G $map @(67,79, 112,95, 145,77, 190,94, 190,178, 145,161, 112,180, 67,164)
            Draw-Line $G "#8b7448" 5 112 96 112 179 185
            Draw-Line $G "#8b7448" 5 145 78 145 161 185
            Draw-Check $G "#3f6f4b"
            $map.Dispose()
        }
        "first_survey" {
            $lens = Pen-Hex "#e5d9a3" 15 238
            $G.DrawEllipse($lens, 68, 67, 86, 86)
            $lens.Dispose()
            Draw-Line $G "#e5d9a3" 16 139 139 184 184
            Draw-Line $G "#5b7d4e" 6 90 112 132 102
        }
        "trap_set" {
            Draw-Snare $G $false
            Draw-Line $G "#70a85b" 9 80 178 177 178
        }
        "development_25" {
            Draw-Hammer $G
            Draw-Line $G "#f0c866" 12 72 190 108 190
        }
        "development_50" {
            Draw-Hammer $G
            Draw-Line $G "#f0c866" 12 72 190 128 190
        }
        "development_75" {
            Draw-Hammer $G
            Draw-Line $G "#f0c866" 12 72 190 157 190
        }
        "development_100" {
            Draw-Hammer $G
            Draw-Check $G "#f4e58a"
        }
    }
}

function New-Icon([string]$Name, [string]$Kind, [string]$Base, [string]$Border) {
    $folder = Join-Path $Root "assets/icons/tile_memory"
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
    $path = Join-Path $folder $Name
    $bitmap = [System.Drawing.Bitmap]::new(256, 256, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.Clear([System.Drawing.Color]::Transparent)
    $shadow = Solid "#000000" 42
    $graphics.FillEllipse($shadow, 47, 207, 162, 20)
    $shadow.Dispose()
    $baseBrush = Solid $Base 232
    $borderPen = Pen-Hex $Border 5 210
    Fill-Round $graphics $baseBrush 32 32 192 192 44
    Draw-Round $graphics $borderPen 32 32 192 192 44
    $baseBrush.Dispose(); $borderPen.Dispose()
    Draw-Symbol $graphics $Kind
    $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
}

$icons = @(
    @("wet_ground.png", "wet_ground", "#d4e4df", "#5b938f"),
    @("rain_puddle.png", "rain_puddle", "#d1e9ec", "#4aa6bf"),
    @("storm_debris.png", "storm_debris", "#e5d4b7", "#8b6a43"),
    @("washed_away.png", "washed_away", "#d4e7ea", "#4c9fbc"),
    @("damaged_trap.png", "damaged_trap", "#ead7ba", "#b95a46"),
    @("trap_catch.png", "trap_catch", "#ead3bb", "#b4553a"),
    @("hunt_success.png", "hunt_success", "#ead5bf", "#b96a43"),
    @("animal_tracks.png", "animal_tracks", "#e5d8c2", "#75503a"),
    @("found_objects.png", "found_objects", "#ead8b7", "#b78042"),
    @("fishing_spot.png", "fishing_spot", "#d2e8eb", "#4d9fba"),
    @("fresh_gather.png", "fresh_gather", "#dcecc9", "#5b9a49"),
    @("picked_over.png", "picked_over", "#e6d6bb", "#a8743d"),
    @("worked_ground.png", "worked_ground", "#ead6b7", "#b98342"),
    @("developed.png", "developed", "#ead9ae", "#bd933c"),
    @("fully_surveyed.png", "fully_surveyed", "#e8ddb6", "#7d7250"),
    @("first_survey.png", "first_survey", "#e6deb8", "#6f8056"),
    @("trap_set.png", "trap_set", "#eadabf", "#a77942"),
    @("development_25.png", "development_25", "#ead7b6", "#b98342"),
    @("development_50.png", "development_50", "#ead7b6", "#b98342"),
    @("development_75.png", "development_75", "#ead7b6", "#b98342"),
    @("development_100.png", "development_100", "#ead9ae", "#bd933c")
)

foreach ($icon in $icons) {
    New-Icon $icon[0] $icon[1] $icon[2] $icon[3]
}

Write-Host "Generated $($icons.Count) tile memory icon files."
