$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$code = @"
using System;
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public static class DetailedHexTileGenerator
{
    static readonly int W = 184;
    static readonly int H = 160;
    static readonly int OutW = 552;
    static readonly int OutH = 480;
    static readonly string[][] Layout = new string[][] {
        new string[] {"ocean","ocean","ocean","ocean","ocean","ocean","ocean","ocean","ocean","ocean"},
        new string[] {"ocean","ocean","ocean","ocean","ocean","ocean","ocean","ocean","ocean","ocean"},
        new string[] {"ocean","ocean","cave","hill","forest","forest","ruins","hill","ocean","ocean"},
        new string[] {"ocean","ocean","hill","forest","forest","meadow","ruins","river","ocean","ocean"},
        new string[] {"ocean","ocean","meadow","meadow","forest","meadow","river","river","ocean","ocean"},
        new string[] {"ocean","ocean","beach","meadow","meadow","forest","river","marsh","ocean","ocean"},
        new string[] {"ocean","ocean","beach","cave","meadow","forest","meadow","marsh","ocean","ocean"},
        new string[] {"ocean","ocean","beach","beach","meadow","meadow","forest","river","ocean","ocean"},
        new string[] {"ocean","ocean","ocean","ocean","ocean","ocean","ocean","ocean","ocean","ocean"},
        new string[] {"ocean","ocean","ocean","ocean","ocean","ocean","ocean","ocean","ocean","ocean"}
    };

    static Color C(string hex, int alpha = 255)
    {
        hex = hex.TrimStart('#');
        return Color.FromArgb(alpha, Convert.ToInt32(hex.Substring(0, 2), 16), Convert.ToInt32(hex.Substring(2, 2), 16), Convert.ToInt32(hex.Substring(4, 2), 16));
    }

    static SolidBrush B(string hex, int alpha = 255) { return new SolidBrush(C(hex, alpha)); }
    static Pen P(string hex, float size = 1f, int alpha = 255) { return new Pen(C(hex, alpha), size) { StartCap = LineCap.Round, EndCap = LineCap.Round, LineJoin = LineJoin.Round }; }

    static PointF[] HexPoints(int w = -1, int h = -1)
    {
        if (w < 0) w = W;
        if (h < 0) h = H;
        return new PointF[] {
            new PointF(w * 0.50f, 2f),
            new PointF(w - 3f, h * 0.27f),
            new PointF(w - 3f, h * 0.73f),
            new PointF(w * 0.50f, h - 2f),
            new PointF(3f, h * 0.73f),
            new PointF(3f, h * 0.27f)
        };
    }

    static GraphicsPath HexPath()
    {
        var path = new GraphicsPath();
        path.AddPolygon(HexPoints());
        return path;
    }

    static void Speckles(Graphics g, Random r, string[] palette, int count, int alpha, int minSize, int maxSize)
    {
        for (int i = 0; i < count; i++)
        {
            using (var brush = B(palette[r.Next(palette.Length)], alpha))
            {
                int s = r.Next(minSize, maxSize);
                g.FillEllipse(brush, r.Next(10, W - 12), r.Next(10, H - 12), s, s);
            }
        }
    }

    static void RandEllipse(Graphics g, Random r, string hex, int alpha, int minX, int maxX, int minY, int maxY, int minS, int maxS)
    {
        using (var brush = B(hex, alpha))
        {
            int s = r.Next(minS, maxS);
            g.FillEllipse(brush, r.Next(minX, maxX), r.Next(minY, maxY), s, (int)(s * (0.65 + r.NextDouble() * 0.55)));
        }
    }

    static void Curve(Graphics g, string hex, int alpha, float size, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4)
    {
        using (var pen = P(hex, size, alpha))
            g.DrawBezier(pen, new PointF(x1, y1), new PointF(x2, y2), new PointF(x3, y3), new PointF(x4, y4));
    }

    static void FineStrokes(Graphics g, Random r, string[] palette, int count, int alpha, float width, int minLength, int maxLength)
    {
        for (int i = 0; i < count; i++)
        {
            using (var pen = P(palette[r.Next(palette.Length)], width + (float)r.NextDouble() * 0.45f, alpha))
            {
                int x = r.Next(12, W - 12);
                int y = r.Next(12, H - 12);
                int len = r.Next(minLength, maxLength);
                float angle = (float)(r.NextDouble() * Math.PI * 2.0);
                g.DrawLine(pen, x, y, x + (float)Math.Cos(angle) * len, y + (float)Math.Sin(angle) * len);
            }
        }
    }

    static void SoftContour(Graphics g, Random r, string hex, int alpha, float width, int count)
    {
        for (int i = 0; i < count; i++)
        {
            float y = r.Next(20, H - 20);
            Curve(g, hex, alpha, width, -8, y, 38, y + r.Next(-18, 18), 112, y + r.Next(-16, 20), W + 8, y + r.Next(-10, 12));
        }
    }

    static void FinishOcean(Graphics g, Random r)
    {
        FineStrokes(g, r, new string[] {"#d7ffff", "#83d6dd", "#2a86a7"}, 42, 65, 0.9f, 5, 16);
        for (int i = 0; i < 8; i++)
        {
            float y = 18 + i * 16 + r.Next(-5, 6);
            Curve(g, "#eafffb", 88, 1.2f, 4, y, 50, y - 12, 96, y + 14, W - 6, y - 2);
        }
        using (var deep = new LinearGradientBrush(new Rectangle(0, 0, W, H), Color.FromArgb(0, 10, 53, 72), Color.FromArgb(58, 5, 42, 61), 45f))
            g.FillRectangle(deep, 0, 0, W, H);
    }

    static void FinishBeach(Graphics g, Random r)
    {
        FineStrokes(g, r, new string[] {"#fff2c5", "#d4a76d", "#9b7650"}, 55, 78, 1.0f, 4, 13);
        SoftContour(g, r, "#866341", 42, 1.0f, 5);
        for (int i = 0; i < 8; i++)
        {
            using (var shell = P("#fff6d2", 1.2f, 145))
            {
                int x = r.Next(24, 154);
                int y = r.Next(32, 128);
                g.DrawArc(shell, x, y, r.Next(5, 11), r.Next(3, 8), 180, 190);
            }
        }
    }

    static void FinishMeadow(Graphics g, Random r)
    {
        FineStrokes(g, r, new string[] {"#d5e27e", "#7dbb45", "#315f2f", "#f0d95c"}, 74, 92, 1.15f, 5, 15);
        SoftContour(g, r, "#2e5a30", 36, 1.0f, 4);
        using (var path = P("#d6c078", 2.0f, 65))
            g.DrawBezier(path, 10, 112, 54, 98, 112, 122, 176, 78);
    }

    static void FinishForest(Graphics g, Random r)
    {
        FineStrokes(g, r, new string[] {"#6fa650", "#2e793e", "#173a2b", "#9fbd62"}, 58, 75, 1.0f, 4, 12);
        for (int i = 0; i < 12; i++)
        {
            int x = r.Next(18, 154);
            int y = r.Next(20, 122);
            using (var shade = B("#071811", 44)) g.FillEllipse(shade, x - 4, y + 12, 34, 14);
            using (var leaf = B(i % 3 == 0 ? "#7bac4b" : "#2c7b3c", 92)) g.FillEllipse(leaf, x, y, r.Next(18, 34), r.Next(12, 24));
            using (var shine = B("#b7d575", 45)) g.FillEllipse(shine, x + 5, y + 2, r.Next(8, 18), r.Next(5, 12));
        }
    }

    static void FinishRiver(Graphics g, Random r)
    {
        FineStrokes(g, r, new string[] {"#e9ffff", "#76d3df", "#2b7d94"}, 42, 92, 1.0f, 5, 17);
        for (int i = 0; i < 11; i++) RandEllipse(g, r, "#eef0cf", 132, 18, 160, 32, 130, 3, 8);
        using (var current = P("#efffff", 1.2f, 94))
            g.DrawBezier(current, 4, 118, 46, 82, 92, 100, 178, 42);
    }

    static void FinishMarsh(Graphics g, Random r)
    {
        FineStrokes(g, r, new string[] {"#b2a85f", "#395843", "#6c7f55"}, 64, 86, 1.15f, 5, 16);
        for (int i = 0; i < 10; i++)
        {
            int x = r.Next(20, 158);
            int y = r.Next(34, 130);
            using (var water = B("#7fc7bc", 52)) g.FillEllipse(water, x, y, r.Next(18, 36), r.Next(6, 15));
        }
    }

    static void FinishCave(Graphics g, Random r)
    {
        FineStrokes(g, r, new string[] {"#a5a089", "#4f555c", "#222832"}, 62, 80, 1.15f, 5, 16);
        SoftContour(g, r, "#11161e", 50, 1.3f, 5);
        for (int i = 0; i < 7; i++)
        {
            using (var facet = P("#d1c597", 1.3f, 82))
            {
                int x = r.Next(24, 156);
                int y = r.Next(24, 126);
                g.DrawLine(facet, x, y, x + r.Next(8, 24), y + r.Next(-14, 14));
            }
        }
    }

    static void FinishHill(Graphics g, Random r)
    {
        FineStrokes(g, r, new string[] {"#d5c890", "#7a725d", "#5a644f"}, 64, 86, 1.15f, 5, 15);
        for (int i = 0; i < 9; i++)
        {
            using (var contour = P("#3f473c", 1.15f, 54))
            {
                int x = r.Next(12, 120);
                int y = r.Next(28, 124);
                g.DrawArc(contour, x, y, r.Next(44, 88), r.Next(14, 34), 190, 145);
            }
        }
    }

    static void FinishRuins(Graphics g, Random r)
    {
        FineStrokes(g, r, new string[] {"#b8b296", "#6b7466", "#2e6a37"}, 58, 76, 1.0f, 4, 13);
        using (var road = P("#c1b98a", 3.0f, 62))
            g.DrawBezier(road, 8, 124, 46, 102, 112, 118, 180, 70);
        for (int i = 0; i < 8; i++)
        {
            using (var crack = P("#2d3f37", 1.1f, 128))
            {
                int x = r.Next(28, 152);
                int y = r.Next(32, 128);
                g.DrawLine(crack, x, y, x + r.Next(-10, 14), y + r.Next(6, 18));
            }
        }
    }

    static void StrategicFinish(Graphics g, string terrain, Random r)
    {
        switch (terrain)
        {
            case "ocean": FinishOcean(g, r); break;
            case "beach": FinishBeach(g, r); break;
            case "meadow": FinishMeadow(g, r); break;
            case "forest": FinishForest(g, r); break;
            case "river": FinishRiver(g, r); break;
            case "marsh": FinishMarsh(g, r); break;
            case "cave": FinishCave(g, r); break;
            case "hill": FinishHill(g, r); break;
            case "ruins": FinishRuins(g, r); break;
        }
        using (var light = new LinearGradientBrush(new Rectangle(0, 0, W, H), Color.FromArgb(50, 255, 244, 204), Color.FromArgb(46, 22, 26, 30), 135f))
            g.FillRectangle(light, 0, 0, W, H);
        using (var path = HexPath())
        using (var ambient = new PathGradientBrush(path))
        {
            ambient.CenterColor = Color.FromArgb(0, 255, 255, 255);
            ambient.SurroundColors = new Color[] { Color.FromArgb(44, 0, 0, 0) };
            g.FillPath(ambient, path);
        }
    }

    static void Base(Graphics g, string terrain)
    {
        string top = "#6d8f9b";
        string bottom = "#345b71";
        switch (terrain)
        {
            case "ocean": top = "#2b8db6"; bottom = "#126080"; break;
            case "beach": top = "#e9cf8d"; bottom = "#b88751"; break;
            case "meadow": top = "#8fbd55"; bottom = "#4f8139"; break;
            case "forest": top = "#416f38"; bottom = "#1f4c31"; break;
            case "river": top = "#55a9b8"; bottom = "#276f86"; break;
            case "marsh": top = "#697d55"; bottom = "#3d5744"; break;
            case "cave": top = "#575656"; bottom = "#24282f"; break;
            case "hill": top = "#9b9276"; bottom = "#5e6653"; break;
            case "ruins": top = "#8a8b79"; bottom = "#4e6254"; break;
        }
        using (var brush = new LinearGradientBrush(new Rectangle(0, 0, W, H), C(top), C(bottom), 90f))
            g.FillRectangle(brush, 0, 0, W, H);
    }

    static void Ocean(Graphics g, Random r)
    {
        Speckles(g, r, new string[] {"#6ac4d4", "#2f9fc0", "#1d6c8f", "#9ad9df"}, 70, 80, 2, 6);
        for (int i = 0; i < 9; i++)
        {
            float y = 18 + i * 14 + r.Next(-4, 4);
            Curve(g, "#bfe8e8", 125, 2.4f, -12, y, 45, y - 14, 80, y + 13, 196, y - 2);
            Curve(g, "#155c7b", 70, 1.8f, -8, y + 8, 34, y - 2, 112, y + 17, 198, y + 10);
        }
        for (int i = 0; i < 10; i++) RandEllipse(g, r, "#ffffff", 45, 20, 150, 14, 138, 5, 16);
    }

    static void Beach(Graphics g, Random r)
    {
        Speckles(g, r, new string[] {"#f4e2aa", "#c49b62", "#8f6f49", "#fff1bc"}, 115, 105, 2, 5);
        using (var water = B("#4fa9bd", 170))
        {
            g.FillEllipse(water, -45, -16, 100, 82);
            g.FillEllipse(water, 122, 112, 112, 68);
        }
        Curve(g, "#eff6df", 145, 3.0f, -2, 45, 35, 22, 50, 48, 80, 18);
        Curve(g, "#eff6df", 125, 2.6f, 118, 119, 145, 98, 168, 119, 197, 100);
        for (int i = 0; i < 5; i++)
        {
            using (var pen = P("#7b4d33", 4f, 160))
            {
                int x = r.Next(36, 138);
                int y = r.Next(58, 124);
                g.DrawLine(pen, x, y, x + r.Next(15, 32), y + r.Next(-6, 8));
            }
        }
        for (int i = 0; i < 9; i++) RandEllipse(g, r, "#f8f1d1", 205, 24, 154, 42, 132, 5, 12);
        for (int i = 0; i < 7; i++) RandEllipse(g, r, "#6b6a61", 140, 18, 160, 38, 138, 5, 10);
    }

    static void Meadow(Graphics g, Random r)
    {
        Speckles(g, r, new string[] {"#b7d66e", "#76ad46", "#3f7b35", "#e7d15e"}, 145, 100, 2, 6);
        string[] grass = {"#315e2b", "#467f32", "#a1c957"};
        for (int i = 0; i < 34; i++)
        {
            using (var pen = P(grass[r.Next(grass.Length)], 2.0f, 155))
            {
                int x = r.Next(12, 170);
                int y = r.Next(18, 143);
                g.DrawLine(pen, x, y, x + r.Next(-7, 8), y - r.Next(5, 16));
            }
        }
        string[] flowers = {"#f3d85b", "#f0f1dc", "#d97067", "#7eacd7"};
        for (int i = 0; i < 11; i++) RandEllipse(g, r, flowers[r.Next(flowers.Length)], 190, 22, 162, 28, 132, 4, 8);
        for (int i = 0; i < 5; i++) RandEllipse(g, r, "#5e634d", 120, 25, 155, 38, 126, 7, 15);
    }

    static void Forest(Graphics g, Random r)
    {
        Speckles(g, r, new string[] {"#2f6b37", "#1f4f31", "#5b8c42", "#122f26"}, 105, 120, 3, 8);
        string[] leafColors = {"#1f5d33", "#2f7a3f", "#5c9842", "#173f2d"};
        for (int i = 0; i < 18; i++)
        {
            int x = r.Next(18, 148);
            int y = r.Next(22, 120);
            using (var trunk = P("#5f3c26", 5f, 150)) g.DrawLine(trunk, x + 8, y + 18, x + 8, y + 42);
            using (var shadow = B("#0c221b", 65)) g.FillEllipse(shadow, x - 6, y + 30, 34, 14);
            for (int j = 0; j < 4; j++)
                using (var b = B(leafColors[r.Next(leafColors.Length)], 225))
                    g.FillEllipse(b, x + r.Next(-10, 12), y + r.Next(-8, 12), r.Next(22, 36), r.Next(18, 30));
        }
        for (int i = 0; i < 8; i++) RandEllipse(g, r, "#b23b35", 165, 36, 150, 50, 132, 4, 7);
    }

    static void River(Graphics g, Random r)
    {
        Meadow(g, r);
        using (var river = new GraphicsPath())
        {
            river.StartFigure();
            river.AddBezier(-16, 120, 32, 82, 54, 58, 82, -8);
            river.AddBezier(106, -10, 100, 68, 158, 84, 202, 34);
            river.AddBezier(198, 56, 148, 112, 126, 126, 94, 178);
            river.AddBezier(70, 172, 62, 122, 22, 142, -16, 154);
            river.CloseFigure();
            using (var water = new PathGradientBrush(river))
            {
                water.CenterColor = C("#79cfde", 238);
                water.SurroundColors = new Color[] { C("#2b7994", 238) };
                g.FillPath(water, river);
            }
            using (var shore = P("#d8c98d", 4f, 125)) g.DrawPath(shore, river);
        }
        for (int i = 0; i < 7; i++)
            Curve(g, "#e8ffff", 130, 2.0f, r.Next(20, 145), r.Next(35, 120), r.Next(45, 160), r.Next(40, 115), r.Next(60, 170), r.Next(42, 124), r.Next(75, 185), r.Next(42, 124));
    }

    static void Marsh(Graphics g, Random r)
    {
        Speckles(g, r, new string[] {"#465940", "#6c7b4f", "#2e483e", "#7f744e"}, 125, 105, 3, 9);
        for (int i = 0; i < 11; i++) RandEllipse(g, r, "#3d7c79", 125, 12, 158, 22, 128, 13, 33);
        for (int i = 0; i < 28; i++)
        {
            using (var pen = P("#a2a75f", 2.6f, 170))
            {
                int x = r.Next(16, 168);
                int y = r.Next(32, 146);
                g.DrawLine(pen, x, y, x + r.Next(-7, 8), y - r.Next(18, 34));
            }
        }
        for (int i = 0; i < 8; i++) RandEllipse(g, r, "#1c342d", 80, 18, 158, 38, 128, 7, 18);
    }

    static void Cave(Graphics g, Random r)
    {
        Speckles(g, r, new string[] {"#737373", "#41454b", "#20242b", "#9b927d"}, 115, 100, 3, 9);
        using (var mouth = new GraphicsPath())
        {
            mouth.AddBezier(46, 122, 42, 62, 68, 27, 96, 22);
            mouth.AddBezier(96, 22, 132, 28, 151, 66, 138, 127);
            mouth.AddLine(138, 127, 46, 122);
            using (var dark = new PathGradientBrush(mouth))
            {
                dark.CenterColor = C("#11151d", 250);
                dark.SurroundColors = new Color[] { C("#44464c", 215) };
                g.FillPath(dark, mouth);
            }
            using (var rim = P("#a29b87", 5f, 150)) g.DrawPath(rim, mouth);
        }
        for (int i = 0; i < 9; i++)
        {
            using (var pen = P("#20252d", 2f, 150))
            {
                int x = r.Next(30, 155);
                int y = r.Next(28, 132);
                g.DrawLine(pen, x, y, x + r.Next(8, 25), y + r.Next(-16, 16));
            }
        }
        for (int i = 0; i < 6; i++) RandEllipse(g, r, "#8fd2cf", 120, 42, 142, 36, 118, 3, 7);
    }

    static void Hill(Graphics g, Random r)
    {
        Speckles(g, r, new string[] {"#9f987b", "#6e735c", "#bbb08b", "#505849"}, 120, 115, 3, 8);
        string[] rock = {"#746f5b", "#8c866d", "#5e6854"};
        for (int i = 0; i < 9; i++)
        {
            int x = r.Next(12, 138);
            int y = r.Next(28, 126);
            var poly = new PointF[] { new PointF(x, y + r.Next(18, 32)), new PointF(x + r.Next(18, 36), y - r.Next(3, 13)), new PointF(x + r.Next(36, 56), y + r.Next(16, 34)) };
            using (var b = B(rock[r.Next(rock.Length)], 205)) g.FillPolygon(b, poly);
            using (var p = P("#d0c49d", 2f, 90)) g.DrawLine(p, poly[1], poly[2]);
        }
        for (int i = 0; i < 18; i++)
        {
            using (var pen = P("#c2ba76", 1.8f, 120))
            {
                int x = r.Next(18, 166);
                int y = r.Next(38, 142);
                g.DrawLine(pen, x, y, x + r.Next(-6, 7), y - r.Next(5, 12));
            }
        }
    }

    static void Ruins(Graphics g, Random r)
    {
        Meadow(g, r);
        string[] stone = {"#8b8f7f", "#6e746a", "#a7a38d"};
        for (int i = 0; i < 13; i++)
        {
            int x = r.Next(20, 142);
            int y = r.Next(28, 124);
            int w = r.Next(16, 36);
            int h = r.Next(10, 26);
            using (var b = B(stone[r.Next(stone.Length)], 215)) g.FillRectangle(b, x, y, w, h);
            using (var p = P("#35473b", 1.4f, 135))
            {
                g.DrawRectangle(p, x, y, w, h);
                g.DrawLine(p, x + r.Next(2, w), y, x + r.Next(0, w), y + h);
            }
        }
        for (int i = 0; i < 12; i++)
        {
            using (var pen = P("#2e6a37", 2.2f, 150))
            {
                int x = r.Next(24, 158);
                int y = r.Next(36, 134);
                g.DrawLine(pen, x, y, x + r.Next(-8, 10), y - r.Next(8, 22));
            }
        }
    }

    static void Terrain(Graphics g, string terrain, Random r)
    {
        Base(g, terrain);
        switch (terrain)
        {
            case "ocean": Ocean(g, r); break;
            case "beach": Beach(g, r); break;
            case "meadow": Meadow(g, r); break;
            case "forest": Forest(g, r); break;
            case "river": River(g, r); break;
            case "marsh": Marsh(g, r); break;
            case "cave": Cave(g, r); break;
            case "hill": Hill(g, r); break;
            case "ruins": Ruins(g, r); break;
            default: Meadow(g, r); break;
        }
    }

    static void VignetteAndBorder(Graphics g)
    {
        using (var path = HexPath())
        {
            using (var glow = new PathGradientBrush(path))
            {
                glow.CenterColor = Color.FromArgb(0, 0, 0, 0);
                glow.SurroundColors = new Color[] { Color.FromArgb(82, 0, 0, 0) };
                g.FillPath(glow, path);
            }
            using (var border = P("#243330", 3.2f, 175)) g.DrawPolygon(border, HexPoints());
            using (var inner = P("#fff4d0", 1.2f, 45)) g.DrawPolygon(inner, HexPoints(W - 4, H - 4));
        }
    }

    public static void Generate(string outDir)
    {
        Directory.CreateDirectory(outDir);
        for (int y = 0; y < 10; y++)
        {
            for (int x = 0; x < 10; x++)
            {
                string terrain = Layout[y][x];
                int seed = terrain.GetHashCode() ^ (x * 73856093) ^ (y * 19349663);
                var r = new Random(seed & 0x7fffffff);
                using (var bitmap = new Bitmap(OutW, OutH, PixelFormat.Format32bppArgb))
                using (var g = Graphics.FromImage(bitmap))
                using (var path = HexPath())
                {
                    g.SmoothingMode = SmoothingMode.AntiAlias;
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.Clear(Color.Transparent);
                    g.ScaleTransform((float)OutW / (float)W, (float)OutH / (float)H);
                    g.SetClip(path, CombineMode.Replace);
                    Terrain(g, terrain, r);
                    StrategicFinish(g, terrain, r);
                    g.ResetClip();
                    VignetteAndBorder(g);
                    bitmap.Save(Path.Combine(outDir, string.Format("tile_{0}_{1}.png", x, y)), ImageFormat.Png);
                }
            }
        }
        GenerateFog(outDir);
    }

    static void GenerateFog(string outDir)
    {
        var r = new Random(822736);
        using (var bitmap = new Bitmap(OutW, OutH, PixelFormat.Format32bppArgb))
        using (var g = Graphics.FromImage(bitmap))
        using (var path = HexPath())
        {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.InterpolationMode = InterpolationMode.HighQualityBicubic;
            g.PixelOffsetMode = PixelOffsetMode.HighQuality;
            g.Clear(Color.Transparent);
            g.ScaleTransform((float)OutW / (float)W, (float)OutH / (float)H);
            g.SetClip(path, CombineMode.Replace);
            using (var baseBrush = new LinearGradientBrush(new Rectangle(0, 0, W, H), C("#8193a1", 190), C("#1d2a33", 215), 90f))
                g.FillRectangle(baseBrush, 0, 0, W, H);
            string[] fog = {"#d9e4e6", "#b5c5ca", "#526471", "#f0f4ec"};
            for (int i = 0; i < 32; i++)
            {
                using (var b = B(fog[r.Next(fog.Length)], r.Next(34, 96)))
                    g.FillEllipse(b, r.Next(-25, 155), r.Next(-10, 145), r.Next(34, 82), r.Next(12, 36));
            }
            for (int i = 0; i < 9; i++)
            {
                float y = r.Next(18, 142);
                Curve(g, "#eef6f0", 75, 3.0f, -10, y, 34, y - 16, 96, y + 18, 198, y - 2);
            }
            g.ResetClip();
            using (var border = P("#d5e3de", 1.6f, 80)) g.DrawPolygon(border, HexPoints());
            bitmap.Save(Path.Combine(outDir, "fog_tile.png"), ImageFormat.Png);
        }
    }
}
"@

Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
$outDir = Join-Path $projectRoot 'assets\tiles\detail_hex'
[DetailedHexTileGenerator]::Generate($outDir)

$count = (Get-ChildItem $outDir -Filter '*.png').Count
Write-Output "generated=$count dir=$outDir"
