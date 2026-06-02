$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$code = @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

public static class RasterAssetUpscaler
{
    public static bool ResizePng(string path, int targetW, int targetH)
    {
        if (!File.Exists(path))
            return false;

        int sourceW;
        int sourceH;
        string tempPath = path + ".upscale.tmp.png";
        if (File.Exists(tempPath))
            File.Delete(tempPath);

        using (var source = Image.FromFile(path))
        {
            sourceW = source.Width;
            sourceH = source.Height;
            if (sourceW >= targetW && sourceH >= targetH)
            {
                Console.WriteLine("skip " + path + " " + sourceW + "x" + sourceH);
                return false;
            }

            using (var output = new Bitmap(targetW, targetH, PixelFormat.Format32bppArgb))
            {
                output.SetResolution(source.HorizontalResolution, source.VerticalResolution);
                using (var g = Graphics.FromImage(output))
                using (var attrs = new ImageAttributes())
                {
                    g.CompositingMode = CompositingMode.SourceCopy;
                    g.CompositingQuality = CompositingQuality.HighQuality;
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    attrs.SetWrapMode(WrapMode.TileFlipXY);
                    g.DrawImage(
                        source,
                        new Rectangle(0, 0, targetW, targetH),
                        0,
                        0,
                        sourceW,
                        sourceH,
                        GraphicsUnit.Pixel,
                        attrs
                    );
                }

                output.Save(tempPath, ImageFormat.Png);
            }
        }

        File.Delete(path);
        File.Move(tempPath, path);
        Console.WriteLine("upscaled " + path + " " + sourceW + "x" + sourceH + " -> " + targetW + "x" + targetH);
        return true;
    }
}
"@

Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')

function Resize-Asset {
    param(
        [string]$RelativePath,
        [int]$Width,
        [int]$Height
    )
    $path = Join-Path $projectRoot $RelativePath
    [RasterAssetUpscaler]::ResizePng($path, $Width, $Height) | Out-Null
}

Get-ChildItem (Join-Path $projectRoot 'assets\icons') -Recurse -Filter '*.png' | ForEach-Object {
    [RasterAssetUpscaler]::ResizePng($_.FullName, 256, 256) | Out-Null
}

Get-ChildItem (Join-Path $projectRoot 'assets\tiles') -File -Filter '*.png' | ForEach-Object {
    [RasterAssetUpscaler]::ResizePng($_.FullName, 512, 512) | Out-Null
}

Resize-Asset 'assets\ui\fog_patch.png' 512 512
Resize-Asset 'assets\ui\action_cutin\survival_action_backdrop.png' 3434 1832

Resize-Asset 'assets\sprites\characters\player_cowboy_shot.png' 2048 3072
Resize-Asset 'assets\sprites\characters\partner_cowboy_shot.png' 2048 3072
Resize-Asset 'assets\sprites\characters\survivor_pair_teens.png' 2048 3072

Resize-Asset 'assets\maps\island_world_map.png' 3072 2048
Resize-Asset 'assets\maps\island_world_map_flat_tiles.png' 3344 1882
Resize-Asset 'assets\maps\island_world_map_large_tiles.png' 3344 1882
Resize-Asset 'assets\maps\island_world_map_rpg_tiles.png' 3238 1942
