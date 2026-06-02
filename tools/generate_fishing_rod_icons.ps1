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

function Round-Path([float]$X, [float]$Y, [float]$W, [float]$H, [float]$R) {
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
    $path = Round-Path $X $Y $W $H $R
    $G.FillPath($Brush, $path)
    $path.Dispose()
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

function Draw-Fish($G, [float]$Cx, [float]$Cy, [float]$S, [string]$Fill, [string]$Line) {
    $brush = Solid $Fill 238
    $pen = Pen-Hex $Line 5 220
    $G.FillEllipse($brush, $Cx - 38 * $S, $Cy - 18 * $S, 76 * $S, 36 * $S)
    $tail = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new($Cx + 30 * $S, $Cy),
        [System.Drawing.PointF]::new($Cx + 55 * $S, $Cy - 22 * $S),
        [System.Drawing.PointF]::new($Cx + 55 * $S, $Cy + 22 * $S)
    )
    $G.FillPolygon($brush, $tail)
    $G.DrawEllipse($pen, $Cx - 38 * $S, $Cy - 18 * $S, 76 * $S, 36 * $S)
    $G.DrawPolygon($pen, $tail)
    $brush.Dispose(); $pen.Dispose()
}

function New-Icon([string]$Name, [bool]$Reinforced) {
    $folder = Join-Path $Root "assets/icons/items"
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
    $graphics.FillEllipse($shadow, 46, 207, 164, 20)
    $shadow.Dispose()

    $base = Solid "#d7e7df" 232
    $border = Pen-Hex "#4e8c91" 5 210
    Fill-Round $graphics $base 32 32 192 192 44
    $round = Round-Path 32 32 192 192 44
    $graphics.DrawPath($border, $round)
    $round.Dispose()
    $base.Dispose(); $border.Dispose()

    Draw-Bezier $graphics "#7a542f" 12 @(69,182, 96,105, 139,63, 190,72)
    Draw-Bezier $graphics "#d4aa67" 4 @(74,176, 101,108, 141,72, 185,76) 190
    Draw-Bezier $graphics "#e7eadb" 3 @(188,74, 190,117, 163,130, 145,153) 230
    Draw-Line $graphics "#e7eadb" 3 145 153 137 166 230
    Draw-Fish $graphics 125 177 0.45 "#5aa8c6" "#2f6375"
    if ($Reinforced) {
        Draw-Line $graphics "#415f46" 6 92 136 139 72 220
        Draw-Line $graphics "#415f46" 6 111 119 154 68 220
        $wrap = Pen-Hex "#f0d18a" 5 230
        $graphics.DrawArc($wrap, 84, 124, 31, 20, 15, 290)
        $graphics.DrawArc($wrap, 101, 105, 31, 20, 15, 290)
        $wrap.Dispose()
    }

    $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose(); $bitmap.Dispose()
}

New-Icon "simple_fishing_rod.png" $false
New-Icon "reinforced_fishing_rod.png" $true
Write-Host "Generated fishing rod icons."
