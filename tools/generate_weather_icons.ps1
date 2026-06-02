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

function Draw-Base($G, [string]$Bg, [string]$Border) {
    $brush = Solid $Bg 238
    $pen = Pen-Hex $Border 8 230
    $G.FillEllipse($brush, 24, 24, 208, 208)
    $G.DrawEllipse($pen, 24, 24, 208, 208)
    $brush.Dispose()
    $pen.Dispose()
}

function Draw-Cloud($G, [string]$Fill, [string]$Line, [int]$Alpha = 245) {
    $brush = Solid $Fill $Alpha
    $pen = Pen-Hex $Line 7 220
    $G.FillEllipse($brush, 54, 108, 72, 54)
    $G.FillEllipse($brush, 96, 82, 78, 78)
    $G.FillEllipse($brush, 145, 105, 62, 58)
    $G.FillRectangle($brush, 82, 130, 102, 38)
    $G.DrawArc($pen, 54, 108, 72, 54, 190, 220)
    $G.DrawArc($pen, 96, 82, 78, 78, 190, 190)
    $G.DrawArc($pen, 145, 105, 62, 58, 280, 160)
    $G.DrawLine($pen, 74, 168, 188, 168)
    $brush.Dispose()
    $pen.Dispose()
}

function New-Icon([string]$Name, [string]$Kind) {
    $folder = Join-Path $Root "assets/icons/weather"
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
    $path = Join-Path $folder $Name
    $bitmap = [System.Drawing.Bitmap]::new(256, 256, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.Clear([System.Drawing.Color]::Transparent)

    switch ($Kind) {
        "sun" {
            Draw-Base $graphics "#f3d777" "#aa7f28"
            $rayPen = Pen-Hex "#fff0a8" 8 220
            for ($i = 0; $i -lt 12; $i++) {
                $angle = [Math]::PI * 2.0 * $i / 12.0
                $x1 = 128 + [Math]::Cos($angle) * 54
                $y1 = 128 + [Math]::Sin($angle) * 54
                $x2 = 128 + [Math]::Cos($angle) * 82
                $y2 = 128 + [Math]::Sin($angle) * 82
                $graphics.DrawLine($rayPen, [single]$x1, [single]$y1, [single]$x2, [single]$y2)
            }
            $rayPen.Dispose()
            $sun = Solid "#fff2a6" 245
            $line = Pen-Hex "#b98024" 6 220
            $graphics.FillEllipse($sun, 82, 82, 92, 92)
            $graphics.DrawEllipse($line, 82, 82, 92, 92)
            $sun.Dispose(); $line.Dispose()
        }
        "cloud" {
            Draw-Base $graphics "#b9d1d0" "#567c83"
            Draw-Cloud $graphics "#eef2e3" "#6e8580"
        }
        "rain" {
            Draw-Base $graphics "#8fb5c8" "#3f6f83"
            Draw-Cloud $graphics "#e7ece4" "#5c7472"
            $rainPen = Pen-Hex "#4d91ba" 7 230
            $graphics.DrawLine($rainPen, 86, 182, 72, 212)
            $graphics.DrawLine($rainPen, 128, 180, 114, 214)
            $graphics.DrawLine($rainPen, 170, 181, 156, 212)
            $rainPen.Dispose()
        }
        "storm" {
            Draw-Base $graphics "#6f758c" "#323a54"
            Draw-Cloud $graphics "#cfd2d5" "#535865"
            $bolt = [System.Drawing.PointF[]]@(
                [System.Drawing.PointF]::new(125, 158),
                [System.Drawing.PointF]::new(102, 214),
                [System.Drawing.PointF]::new(136, 198),
                [System.Drawing.PointF]::new(124, 234),
                [System.Drawing.PointF]::new(174, 174),
                [System.Drawing.PointF]::new(142, 186)
            )
            $brush = Solid "#ffd45c" 250
            $pen = Pen-Hex "#875c1c" 5 230
            $graphics.FillPolygon($brush, $bolt)
            $graphics.DrawPolygon($pen, $bolt)
            $brush.Dispose(); $pen.Dispose()
        }
    }

    $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
}

New-Icon "sun.png" "sun"
New-Icon "cloud.png" "cloud"
New-Icon "rain.png" "rain"
New-Icon "storm.png" "storm"
Write-Host "Generated weather icons."
