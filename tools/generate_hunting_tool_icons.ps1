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

function New-BaseIcon([string]$Path, [string]$Bg, [string]$Border) {
    $bitmap = [System.Drawing.Bitmap]::new(256, 256, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.Clear([System.Drawing.Color]::Transparent)

    $shadow = Solid "#000000" 38
    $graphics.FillEllipse($shadow, 45, 207, 166, 20)
    $shadow.Dispose()

    $base = Solid $Bg 232
    $line = Pen-Hex $Border 5 220
    Fill-Round $graphics $base 32 32 192 192 44
    $round = Round-Path 32 32 192 192 44
    $graphics.DrawPath($line, $round)
    $round.Dispose()
    $base.Dispose(); $line.Dispose()

    return @{ Bitmap = $bitmap; Graphics = $graphics; Path = $Path }
}

function Save-Icon($Icon) {
    $Icon.Bitmap.Save($Icon.Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $Icon.Graphics.Dispose()
    $Icon.Bitmap.Dispose()
}

function New-SpearIcon([string]$Path) {
    $icon = New-BaseIcon $Path "#e7dcc6" "#8b6b3e"
    $g = $icon.Graphics
    Draw-Line $g "#6b4727" 13 73 185 176 72
    Draw-Line $g "#d1a45f" 4 82 176 168 83 220
    Draw-Line $g "#3e3329" 7 150 89 191 50
    $head = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(183, 43),
        [System.Drawing.PointF]::new(203, 34),
        [System.Drawing.PointF]::new(195, 56),
        [System.Drawing.PointF]::new(174, 79)
    )
    $brush = Solid "#d9d3c5" 245
    $pen = Pen-Hex "#5d5b55" 4 230
    $g.FillPolygon($brush, $head)
    $g.DrawPolygon($pen, $head)
    $brush.Dispose(); $pen.Dispose()
    Draw-Line $g "#81592d" 8 139 98 159 117
    Draw-Line $g "#f2cf83" 4 135 103 154 121 220
    Save-Icon $icon
}

function New-BowIcon([string]$Path) {
    $icon = New-BaseIcon $Path "#dce8d8" "#66824b"
    $g = $icon.Graphics
    $bowPen = Pen-Hex "#7a4b26" 12 235
    $g.DrawBezier($bowPen, 87, 191, 142, 156, 156, 86, 115, 49)
    $bowPen.Dispose()
    $stringPen = Pen-Hex "#e6e1c8" 3 230
    $g.DrawLine($stringPen, 87, 191, 115, 49)
    $stringPen.Dispose()
    Draw-Line $g "#3f2d1e" 6 67 150 183 93
    $arrowHead = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(185, 92),
        [System.Drawing.PointF]::new(205, 83),
        [System.Drawing.PointF]::new(195, 105)
    )
    $headBrush = Solid "#d8d5c8" 245
    $headPen = Pen-Hex "#58544b" 3 230
    $g.FillPolygon($headBrush, $arrowHead)
    $g.DrawPolygon($headPen, $arrowHead)
    $headBrush.Dispose(); $headPen.Dispose()
    Draw-Line $g "#5d7a3c" 5 80 144 55 135
    Draw-Line $g "#8f3f30" 5 80 144 58 158
    Draw-Line $g "#3f2d1e" 4 73 166 165 118
    Draw-Line $g "#3f2d1e" 4 79 179 170 132
    Save-Icon $icon
}

$folder = Join-Path $Root "assets/icons/items"
if (-not (Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

New-SpearIcon (Join-Path $folder "wooden_spear.png")
New-BowIcon (Join-Path $folder "simple_bow.png")
Write-Host "Generated hunting tool icons."
