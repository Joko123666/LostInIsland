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

function Draw-Drop($G, [float]$Cx, [float]$Cy, [float]$Scale) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $path.AddBezier(0, -26, -23, 5, -15, 33, 0, 40)
    $path.AddBezier(0, 40, 15, 33, 23, 5, 0, -26)
    $matrix = [System.Drawing.Drawing2D.Matrix]::new()
    $matrix.Scale($Scale, $Scale)
    $matrix.Translate($Cx, $Cy, [System.Drawing.Drawing2D.MatrixOrder]::Append)
    $path.Transform($matrix)
    $brush = Solid "#71c8dc" 240
    $G.FillPath($brush, $path)
    $brush.Dispose(); $matrix.Dispose(); $path.Dispose()
}

function Draw-Leaf($G, [float]$Cx, [float]$Cy, [float]$Sx, [float]$Sy, [float]$Angle) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $path.AddBezier(0, -1, -0.86, -0.42, -0.78, 0.54, 0, 1)
    $path.AddBezier(0, 1, 0.78, 0.54, 0.86, -0.42, 0, -1)
    $matrix = [System.Drawing.Drawing2D.Matrix]::new()
    $matrix.Scale($Sx, $Sy)
    $matrix.Rotate($Angle)
    $matrix.Translate($Cx, $Cy, [System.Drawing.Drawing2D.MatrixOrder]::Append)
    $path.Transform($matrix)
    $brush = Solid "#6fbd5b" 240
    $G.FillPath($brush, $path)
    $brush.Dispose(); $matrix.Dispose(); $path.Dispose()
}

function Draw-Symbol($G, [string]$Kind) {
    Draw-Line $G "#5f4327" 13 82 188 108 80
    $flag = Solid "#f0d989" 245
    $G.FillPolygon($flag, [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(105, 67),
        [System.Drawing.PointF]::new(184, 87),
        [System.Drawing.PointF]::new(105, 113)
    ))
    $flag.Dispose()
    switch ($Kind) {
        "camp" {
            Draw-Drop $G 139 95 0.55
            Draw-Drop $G 139 102 0.34
        }
        "storage" {
            $box = Solid "#9a6a3a" 245
            Fill-Round $G $box 122 83 41 31 5
            Draw-Line $G "#f0c77c" 5 124 97 161 97
            $box.Dispose()
        }
        "water" {
            Draw-Drop $G 142 95 0.62
        }
        "resource" {
            Draw-Leaf $G 139 95 20 33 -25
            Draw-Leaf $G 156 98 18 30 35
        }
        "danger" {
            Draw-Line $G "#b74234" 10 143 78 143 105
            $brush = Solid "#b74234" 245
            $G.FillEllipse($brush, 137, 113, 12, 12)
            $brush.Dispose()
        }
    }
}

function New-Icon([string]$Name, [string]$Kind, [string]$Base, [string]$Border) {
    $folder = Join-Path $Root "assets/icons/tile_mark"
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
    $path = Join-Path $folder $Name
    $bitmap = [System.Drawing.Bitmap]::new(256, 256, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.Clear([System.Drawing.Color]::Transparent)
    $shadow = Solid "#000000" 40
    $graphics.FillEllipse($shadow, 47, 207, 162, 20)
    $shadow.Dispose()
    $baseBrush = Solid $Base 232
    $borderPen = Pen-Hex $Border 5 210
    Fill-Round $graphics $baseBrush 32 32 192 192 44
    $pathRound = Round-Path 32 32 192 192 44
    $graphics.DrawPath($borderPen, $pathRound)
    $pathRound.Dispose()
    $baseBrush.Dispose(); $borderPen.Dispose()
    Draw-Symbol $graphics $Kind
    $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose(); $bitmap.Dispose()
}

$icons = @(
    @("camp.png", "camp", "#ead8b8", "#a86f35"),
    @("storage.png", "storage", "#e7d7bb", "#9a6a3a"),
    @("water.png", "water", "#d2e9eb", "#4f9cad"),
    @("resource.png", "resource", "#daeac7", "#60954e"),
    @("danger.png", "danger", "#ead0c6", "#b74234")
)

foreach ($icon in $icons) {
    New-Icon $icon[0] $icon[1] $icon[2] $icon[3]
}

Write-Host "Generated $($icons.Count) tile mark icon files."
