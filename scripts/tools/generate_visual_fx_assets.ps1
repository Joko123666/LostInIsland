$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$code = @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

public static class VisualFxAssetGenerator
{
    static Color A(int a, int r, int g, int b)
    {
        return Color.FromArgb(a, r, g, b);
    }

    static void Save(Bitmap bitmap, string path)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        bitmap.Save(path, ImageFormat.Png);
        Console.WriteLine("generated " + path + " " + bitmap.Width + "x" + bitmap.Height);
    }

    public static void GenerateMapVignette(string path)
    {
        int w = 2048;
        int h = 1536;
        using (var bitmap = new Bitmap(w, h, PixelFormat.Format32bppArgb))
        using (var g = Graphics.FromImage(bitmap))
        {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.Clear(Color.Transparent);

            using (var edgePath = new GraphicsPath())
            {
                edgePath.AddEllipse(-w * 0.18f, -h * 0.18f, w * 1.36f, h * 1.34f);
                using (var brush = new PathGradientBrush(edgePath))
                {
                    brush.CenterPoint = new PointF(w * 0.50f, h * 0.48f);
                    brush.CenterColor = A(0, 0, 0, 0);
                    brush.SurroundColors = new Color[] { A(190, 8, 18, 24) };
                    g.FillPath(brush, edgePath);
                }
            }

            using (var topLightPath = new GraphicsPath())
            {
                topLightPath.AddEllipse(-w * 0.34f, -h * 0.44f, w * 0.96f, h * 0.80f);
                using (var brush = new PathGradientBrush(topLightPath))
                {
                    brush.CenterPoint = new PointF(w * 0.12f, h * 0.08f);
                    brush.CenterColor = A(72, 255, 234, 170);
                    brush.SurroundColors = new Color[] { A(0, 255, 234, 170) };
                    g.FillPath(brush, topLightPath);
                }
            }

            using (var lowerShade = new LinearGradientBrush(new Rectangle(0, 0, w, h), A(0, 0, 0, 0), A(72, 0, 12, 18), 90f))
                g.FillRectangle(lowerShade, 0, 0, w, h);

            Save(bitmap, path);
        }
    }

    public static void GenerateSunRays(string path)
    {
        int w = 2048;
        int h = 1536;
        using (var bitmap = new Bitmap(w, h, PixelFormat.Format32bppArgb))
        using (var g = Graphics.FromImage(bitmap))
        {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.Clear(Color.Transparent);

            PointF origin = new PointF(w * 0.08f, h * -0.06f);
            float[] starts = new float[] { 0.10f, 0.21f, 0.34f, 0.49f, 0.66f };
            float[] widths = new float[] { 0.10f, 0.08f, 0.12f, 0.09f, 0.11f };
            for (int i = 0; i < starts.Length; i++)
            {
                using (var brush = new SolidBrush(A(28 - i * 2, 255, 235, 164)))
                {
                    PointF p1 = new PointF(w * starts[i], h);
                    PointF p2 = new PointF(w * (starts[i] + widths[i]), h);
                    PointF p3 = new PointF(origin.X + 70 + i * 45, origin.Y + 10);
                    PointF p4 = new PointF(origin.X - 40 + i * 30, origin.Y - 20);
                    g.FillPolygon(brush, new PointF[] { p4, p3, p2, p1 });
                }
            }

            using (var glowPath = new GraphicsPath())
            {
                glowPath.AddEllipse(-w * 0.18f, -h * 0.32f, w * 0.74f, h * 0.64f);
                using (var glow = new PathGradientBrush(glowPath))
                {
                    glow.CenterPoint = new PointF(w * 0.06f, h * 0.03f);
                    glow.CenterColor = A(86, 255, 244, 188);
                    glow.SurroundColors = new Color[] { A(0, 255, 244, 188) };
                    g.FillPath(glow, glowPath);
                }
            }

            Save(bitmap, path);
        }
    }

    public static void GenerateCharacterGlow(string path)
    {
        int w = 1024;
        int h = 1536;
        using (var bitmap = new Bitmap(w, h, PixelFormat.Format32bppArgb))
        using (var g = Graphics.FromImage(bitmap))
        {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.Clear(Color.Transparent);

            using (var lightPath = new GraphicsPath())
            {
                lightPath.AddEllipse(-w * 0.22f, -h * 0.08f, w * 1.10f, h * 0.64f);
                using (var light = new PathGradientBrush(lightPath))
                {
                    light.CenterPoint = new PointF(w * 0.28f, h * 0.16f);
                    light.CenterColor = A(112, 255, 226, 168);
                    light.SurroundColors = new Color[] { A(0, 255, 226, 168) };
                    g.FillPath(light, lightPath);
                }
            }

            using (var sidePath = new GraphicsPath())
            {
                sidePath.AddEllipse(w * 0.48f, h * 0.05f, w * 0.72f, h * 0.92f);
                using (var shade = new PathGradientBrush(sidePath))
                {
                    shade.CenterPoint = new PointF(w * 0.96f, h * 0.42f);
                    shade.CenterColor = A(78, 12, 30, 38);
                    shade.SurroundColors = new Color[] { A(0, 12, 30, 38) };
                    g.FillPath(shade, sidePath);
                }
            }

            using (var bottom = new LinearGradientBrush(new Rectangle(0, 0, w, h), A(0, 0, 0, 0), A(110, 0, 10, 14), 90f))
                g.FillRectangle(bottom, 0, 0, w, h);

            using (var edgePath = new GraphicsPath())
            {
                edgePath.AddRectangle(new Rectangle(0, 0, w, h));
                using (var edge = new PathGradientBrush(edgePath))
                {
                    edge.CenterPoint = new PointF(w * 0.52f, h * 0.44f);
                    edge.CenterColor = A(0, 0, 0, 0);
                    edge.SurroundColors = new Color[] { A(78, 0, 0, 0) };
                    g.FillPath(edge, edgePath);
                }
            }

            Save(bitmap, path);
        }
    }

    public static void GenerateActionCutinPanel(string path)
    {
        int w = 2048;
        int h = 256;
        using (var bitmap = new Bitmap(w, h, PixelFormat.Format32bppArgb))
        using (var g = Graphics.FromImage(bitmap))
        {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.Clear(Color.Transparent);

            using (var baseBrush = new LinearGradientBrush(new Rectangle(0, 0, w, h), A(0, 0, 0, 0), A(210, 9, 18, 20), 0f))
                g.FillRectangle(baseBrush, 0, 0, w, h);
            using (var baseBrush2 = new LinearGradientBrush(new Rectangle(0, 0, w, h), A(220, 9, 18, 20), A(0, 0, 0, 0), 0f))
                g.FillRectangle(baseBrush2, 0, 0, w, h);
            using (var warm = new LinearGradientBrush(new Rectangle(0, 0, w, h), A(84, 214, 160, 72), A(0, 214, 160, 72), 0f))
                g.FillRectangle(warm, 0, 0, w, h);

            using (var pathShape = new GraphicsPath())
            {
                pathShape.AddEllipse(w * 0.16f, -h * 0.85f, w * 0.64f, h * 2.65f);
                using (var glow = new PathGradientBrush(pathShape))
                {
                    glow.CenterPoint = new PointF(w * 0.38f, h * 0.46f);
                    glow.CenterColor = A(102, 255, 218, 128);
                    glow.SurroundColors = new Color[] { A(0, 255, 218, 128) };
                    g.FillPath(glow, pathShape);
                }
            }

            using (var line = new Pen(A(130, 255, 224, 134), 2f))
            {
                g.DrawLine(line, 0, 28, w, 12);
                g.DrawLine(line, 0, h - 18, w, h - 42);
            }
            using (var shade = new LinearGradientBrush(new Rectangle(0, 0, w, h), A(0, 0, 0, 0), A(120, 0, 0, 0), 90f))
                g.FillRectangle(shade, 0, 0, w, h);

            Save(bitmap, path);
        }
    }

    public static void GenerateActionStreaks(string path)
    {
        int w = 2048;
        int h = 1152;
        using (var bitmap = new Bitmap(w, h, PixelFormat.Format32bppArgb))
        using (var g = Graphics.FromImage(bitmap))
        {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.Clear(Color.Transparent);
            Random r = new Random(42031);

            for (int i = 0; i < 36; i++)
            {
                int y = r.Next(150, h - 160);
                int len = r.Next(140, 560);
                int x = r.Next(-280, w - 80);
                int alpha = r.Next(22, 86);
                using (var pen = new Pen(A(alpha, 255, 232, 158), r.Next(2, 7)))
                {
                    pen.StartCap = LineCap.Round;
                    pen.EndCap = LineCap.Round;
                    g.DrawLine(pen, x, y, x + len, y - r.Next(18, 72));
                }
            }

            for (int i = 0; i < 8; i++)
            {
                using (var brush = new SolidBrush(A(18, 255, 238, 176)))
                {
                    int y = 180 + i * 96;
                    PointF[] poly = new PointF[] {
                        new PointF(-120, y + 20),
                        new PointF(w + 120, y - 86),
                        new PointF(w + 120, y - 50),
                        new PointF(-120, y + 56)
                    };
                    g.FillPolygon(brush, poly);
                }
            }

            Save(bitmap, path);
        }
    }

    public static void GenerateImpactRing(string path)
    {
        int w = 512;
        int h = 512;
        using (var bitmap = new Bitmap(w, h, PixelFormat.Format32bppArgb))
        using (var g = Graphics.FromImage(bitmap))
        {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.Clear(Color.Transparent);
            using (var pathShape = new GraphicsPath())
            {
                pathShape.AddEllipse(34, 34, w - 68, h - 68);
                using (var glow = new PathGradientBrush(pathShape))
                {
                    glow.CenterPoint = new PointF(w * 0.5f, h * 0.5f);
                    glow.CenterColor = A(0, 255, 238, 150);
                    glow.SurroundColors = new Color[] { A(146, 255, 226, 128) };
                    g.FillPath(glow, pathShape);
                }
            }
            using (var pen = new Pen(A(210, 255, 232, 148), 8f))
                g.DrawEllipse(pen, 46, 46, w - 92, h - 92);
            using (var pen = new Pen(A(76, 255, 255, 220), 2f))
                g.DrawEllipse(pen, 88, 88, w - 176, h - 176);
            Save(bitmap, path);
        }
    }
}
"@

Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
[VisualFxAssetGenerator]::GenerateMapVignette((Join-Path $projectRoot 'assets\ui\map_vignette.png'))
[VisualFxAssetGenerator]::GenerateSunRays((Join-Path $projectRoot 'assets\ui\map_sun_rays.png'))
[VisualFxAssetGenerator]::GenerateCharacterGlow((Join-Path $projectRoot 'assets\ui\character_panel_glow.png'))
[VisualFxAssetGenerator]::GenerateActionCutinPanel((Join-Path $projectRoot 'assets\ui\action_cutin\action_cutin_panel.png'))
[VisualFxAssetGenerator]::GenerateActionStreaks((Join-Path $projectRoot 'assets\ui\action_cutin\action_streaks.png'))
[VisualFxAssetGenerator]::GenerateImpactRing((Join-Path $projectRoot 'assets\ui\action_cutin\impact_ring.png'))
