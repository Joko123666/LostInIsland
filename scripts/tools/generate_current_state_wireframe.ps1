$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$code = @"
using System;
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public static class CurrentStateWireframe
{
    const int W = 1600;
    const int H = 900;

    static readonly string[][] Terrain = new string[][] {
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

    static FontFamily UiFamily()
    {
        try { return new FontFamily("Malgun Gothic"); }
        catch { return FontFamily.GenericSansSerif; }
    }

    static Color C(string hex, int alpha = 255)
    {
        hex = hex.TrimStart('#');
        return Color.FromArgb(alpha, Convert.ToInt32(hex.Substring(0, 2), 16), Convert.ToInt32(hex.Substring(2, 2), 16), Convert.ToInt32(hex.Substring(4, 2), 16));
    }

    static SolidBrush B(string hex, int alpha = 255) { return new SolidBrush(C(hex, alpha)); }
    static Pen P(string hex, float size = 1f, int alpha = 255) { return new Pen(C(hex, alpha), size) { StartCap = LineCap.Round, EndCap = LineCap.Round, LineJoin = LineJoin.Round }; }

    static GraphicsPath RoundRect(float x, float y, float w, float h, float r)
    {
        float d = r * 2f;
        var path = new GraphicsPath();
        path.AddArc(x, y, d, d, 180, 90);
        path.AddArc(x + w - d, y, d, d, 270, 90);
        path.AddArc(x + w - d, y + h - d, d, d, 0, 90);
        path.AddArc(x, y + h - d, d, d, 90, 90);
        path.CloseFigure();
        return path;
    }

    static void Panel(Graphics g, float x, float y, float w, float h, string fill, string stroke, float radius = 10f, int alpha = 245)
    {
        using (var path = RoundRect(x, y, w, h, radius))
        using (var brush = B(fill, alpha))
        using (var pen = P(stroke, 1.6f, 210))
        {
            g.FillPath(brush, path);
            g.DrawPath(pen, path);
        }
    }

    static void Text(Graphics g, string text, float x, float y, float w, float h, float size, string color, FontStyle style = FontStyle.Regular, StringAlignment align = StringAlignment.Near)
    {
        using (var family = UiFamily())
        using (var font = new Font(family, size, style, GraphicsUnit.Pixel))
        using (var brush = B(color))
        using (var format = new StringFormat())
        {
            format.Alignment = align;
            format.LineAlignment = StringAlignment.Near;
            format.Trimming = StringTrimming.EllipsisCharacter;
            g.DrawString(text, font, brush, new RectangleF(x, y, w, h), format);
        }
    }

    static void CenterText(Graphics g, string text, float x, float y, float w, float h, float size, string color, FontStyle style = FontStyle.Regular)
    {
        using (var family = UiFamily())
        using (var font = new Font(family, size, style, GraphicsUnit.Pixel))
        using (var brush = B(color))
        using (var format = new StringFormat())
        {
            format.Alignment = StringAlignment.Center;
            format.LineAlignment = StringAlignment.Center;
            format.Trimming = StringTrimming.EllipsisCharacter;
            g.DrawString(text, font, brush, new RectangleF(x, y, w, h), format);
        }
    }

    static void StatusMeter(Graphics g, float x, float y, float w, string icon, string label, int value, string color)
    {
        Panel(g, x, y, w, 38, "#273330", "#46554b", 8, 230);
        CenterText(g, icon, x + 8, y + 6, 28, 26, 17, "#f3ead1", FontStyle.Bold);
        Text(g, label, x + 42, y + 6, 78, 22, 14, "#e6dec9", FontStyle.Bold);
        Text(g, value.ToString(), x + w - 42, y + 6, 34, 22, 14, "#f4e8bc", FontStyle.Bold, StringAlignment.Far);
        using (var bg = B("#111918", 235))
        using (var fg = B(color, 235))
        using (var outline = P("#141b19", 1f, 220))
        {
            var rr = RoundRect(x + 42, y + 25, w - 54, 6, 3);
            g.FillPath(bg, rr);
            rr.Dispose();
            var fill = RoundRect(x + 42, y + 25, Math.Max(4, (w - 54) * value / 100f), 6, 3);
            g.FillPath(fg, fill);
            g.DrawPath(outline, fill);
            fill.Dispose();
        }
    }

    static GraphicsPath Hex(float cx, float cy, float r)
    {
        var pts = new PointF[6];
        for (int i = 0; i < 6; i++)
        {
            double a = Math.PI / 180.0 * (60 * i - 30);
            pts[i] = new PointF(cx + r * (float)Math.Cos(a), cy + r * (float)Math.Sin(a));
        }
        var path = new GraphicsPath();
        path.AddPolygon(pts);
        return path;
    }

    static Color TerrainColor(string terrain)
    {
        switch (terrain)
        {
            case "beach": return C("#c99d5b");
            case "meadow": return C("#6e9d49");
            case "forest": return C("#2f6b3f");
            case "river": return C("#3f9db5");
            case "marsh": return C("#667c54");
            case "cave": return C("#565a5d");
            case "hill": return C("#8d8467");
            case "ruins": return C("#777f70");
            default: return C("#1e657d");
        }
    }

    static string TerrainMark(string terrain)
    {
        switch (terrain)
        {
            case "beach": return "해";
            case "meadow": return "초";
            case "forest": return "숲";
            case "river": return "강";
            case "marsh": return "습";
            case "cave": return "굴";
            case "hill": return "언";
            case "ruins": return "폐";
            default: return "해";
        }
    }

    static bool Playable(int x, int y) { return x >= 2 && x <= 7 && y >= 2 && y <= 7; }
    static bool Revealed(int x, int y) { return x == 2 && y == 7; }
    static bool AdjacentToStart(int x, int y)
    {
        return (x == 3 && y == 7) || (x == 2 && y == 6) || (x == 2 && y == 8) || (x == 1 && y == 7) || (x == 1 && y == 6) || (x == 1 && y == 8);
    }

    static void DrawMap(Graphics g, float x, float y, float w, float h)
    {
        Panel(g, x, y, w, h, "#111917", "#4e5e53", 12, 250);
        Text(g, "중앙 월드맵 - 10x10 헥스 타일 / region_hex 이미지 타일 / 현재 위치 중심 카메라", x + 26, y + 18, w - 52, 26, 19, "#f0e6cc", FontStyle.Bold);

        float startX = x + 160;
        float startY = y + 118;
        float r = 32f;
        float dx = 56f;
        float dy = 48f;
        for (int yy = 0; yy < 10; yy++)
        {
            for (int xx = 0; xx < 10; xx++)
            {
                float cx = startX + xx * dx + ((yy % 2 == 1) ? dx / 2f : 0f);
                float cy = startY + yy * dy;
                using (var path = Hex(cx, cy, r))
                using (var fill = new SolidBrush(TerrainColor(Terrain[yy][xx])))
                using (var fog = B("#74818a", 185))
                using (var edge = P("#1d2926", 2f, 220))
                {
                    g.FillPath(fill, path);
                    if (!Playable(xx, yy))
                    {
                        using (var block = B("#0a0e0f", 195)) g.FillPath(block, path);
                    }
                    else if (!Revealed(xx, yy) && !AdjacentToStart(xx, yy))
                    {
                        g.FillPath(fog, path);
                    }
                    else if (AdjacentToStart(xx, yy) && !Revealed(xx, yy))
                    {
                        using (var softFog = B("#a9b6b6", 95)) g.FillPath(softFog, path);
                    }
                    g.DrawPath(edge, path);
                }
                string mark = TerrainMark(Terrain[yy][xx]);
                if (Playable(xx, yy) && (Revealed(xx, yy) || AdjacentToStart(xx, yy)))
                    CenterText(g, mark, cx - 18, cy - 16, 36, 32, 16, "#f6edcf", FontStyle.Bold);
            }
        }

        float pcx = startX + 2 * dx + (7 % 2 == 1 ? dx / 2f : 0f);
        float pcy = startY + 7 * dy;
        using (var player = B("#f5d15a"))
        using (var pen = P("#18120a", 3f, 220))
        {
            g.FillEllipse(player, pcx - 15, pcy - 37, 30, 30);
            g.DrawEllipse(pen, pcx - 15, pcy - 37, 30, 30);
        }
        CenterText(g, "P", pcx - 12, pcy - 35, 24, 24, 16, "#16120b", FontStyle.Bold);

        Panel(g, x + 36, y + 66, 266, 42, "#1d2926", "#697866", 8, 232);
        Text(g, "좌상단 아이콘 메뉴", x + 52, y + 76, 160, 24, 15, "#e8dec8", FontStyle.Bold);
        string[] icons = {"가", "도", "제", "맵", "거", "log", "잠", "설"};
        for (int i = 0; i < icons.Length; i++)
        {
            Panel(g, x + 204 + i * 30, y + 73, 24, 24, "#2f4039", "#81764a", 6, 235);
            CenterText(g, icons[i], x + 204 + i * 30, y + 74, 24, 22, 9, "#f4e4b7", FontStyle.Bold);
        }

        Panel(g, x + w - 314, y + 72, 248, 178, "#17211f", "#d4b354", 88, 238);
        CenterText(g, "원형 행동 / 추천", x + w - 292, y + 92, 204, 24, 16, "#f1dfad", FontStyle.Bold);
        ActionBubble(g, x + w - 198, y + 135, "이동");
        ActionBubble(g, x + w - 252, y + 183, "조사");
        ActionBubble(g, x + w - 143, y + 183, "채집");
        ActionBubble(g, x + w - 198, y + 224, "휴식");

        Panel(g, x + 320, y + h - 68, 410, 42, "#192421", "#75815e", 8, 226);
        Text(g, "감각 피드백: 바람, 안개, 날씨, 시간대 조명, 획득 카드 이동, 컷씬 전환", x + 338, y + h - 57, 430, 24, 15, "#e8e0c5");
    }

    static void ActionBubble(Graphics g, float cx, float cy, string label)
    {
        Panel(g, cx - 39, cy - 16, 78, 32, "#263932", "#e5bd52", 16, 248);
        CenterText(g, label, cx - 35, cy - 12, 70, 24, 14, "#fff1c8", FontStyle.Bold);
    }

    static void DrawCharacterPanel(Graphics g, float x, float y, float w, float h, string title, bool player)
    {
        Panel(g, x, y, w, h, "#111817", "#35453f", 10, 250);
        Text(g, title, x + 18, y + 14, w - 36, 24, 20, "#f0e6cc", FontStyle.Bold);
        Panel(g, x + 20, y + 52, w - 40, 246, "#25322f", player ? "#d7b34c" : "#6d756c", 8, 245);
        using (var silhouette = B(player ? "#d4b76b" : "#64726d", 210))
        using (var shade = B("#0c1110", 80))
        {
            g.FillEllipse(shade, x + 66, y + 265, w - 132, 18);
            g.FillEllipse(silhouette, x + w / 2 - 34, y + 78, 68, 68);
            g.FillRectangle(silhouette, x + w / 2 - 45, y + 142, 90, 112);
            g.FillRectangle(silhouette, x + w / 2 - 60, y + 182, 28, 78);
            g.FillRectangle(silhouette, x + w / 2 + 32, y + 182, 28, 78);
        }
        string face = player ? "긴장했지만 버팀" : "아직 미합류";
        Panel(g, x + 38, y + 265, w - 76, 28, "#151f1c", player ? "#cfae4e" : "#5e6a64", 8, 238);
        CenterText(g, face, x + 44, y + 270, w - 88, 18, 13, "#f2e6c5", FontStyle.Bold);

        if (player)
        {
            StatusMeter(g, x + 18, y + 314, w - 36, "♥", "체력", 100, "#d85b58");
            StatusMeter(g, x + 18, y + 358, w - 36, "↯", "기력", 100, "#d6b74d");
            StatusMeter(g, x + 18, y + 402, w - 36, "●", "허기", 100, "#86ad55");
            StatusMeter(g, x + 18, y + 446, w - 36, "◆", "수분", 100, "#4daec5");
            Text(g, "위생/감정: 양호 · 안정", x + 24, y + 496, w - 48, 24, 14, "#cec7af");
        }
        else
        {
            Text(g, "상태: 아직 발견 전", x + 24, y + 320, w - 48, 24, 15, "#d6ceba", FontStyle.Bold);
            Text(g, "합류 후 이 영역에 감정, 위치, 관계 반응이 표시된다.", x + 24, y + 350, w - 48, 50, 14, "#aaa898");
            Panel(g, x + 24, y + 414, w - 48, 42, "#242c2a", "#4c5551", 8, 220);
            Text(g, "대화/지시/요청은 파트너 메뉴에서 분기", x + 36, y + 426, w - 72, 22, 13, "#d7cfb7");
        }

        Text(g, player ? "소지 카드" : "동행자 카드", x + 20, y + h - 132, w - 40, 22, 15, "#efe4c5", FontStyle.Bold);
        for (int i = 0; i < 6; i++)
        {
            float cx = x + 20 + (i % 3) * ((w - 54) / 3f);
            float cy = y + h - 102 + (i / 3) * 42;
            Panel(g, cx, cy, (w - 70) / 3f, 34, "#25332f", "#526158", 6, 235);
            CenterText(g, player ? (i == 0 ? "열매" : i == 1 ? "식수" : "빈칸") : "대기", cx + 4, cy + 7, (w - 78) / 3f, 18, 11, "#e7ddc2");
        }
    }

    static void DrawBottom(Graphics g, float x, float y, float w, float h)
    {
        Panel(g, x, y, w, h, "#0f1715", "#394940", 10, 252);
        Panel(g, x + 18, y + 16, 92, 30, "#d2b75f", "#f0d884", 8, 245);
        CenterText(g, "정보", x + 18, y + 20, 92, 22, 14, "#19150e", FontStyle.Bold);
        Panel(g, x + 118, y + 16, 92, 30, "#22332e", "#5b675e", 8, 235);
        CenterText(g, "카드", x + 118, y + 20, 92, 22, 14, "#e8ddc5", FontStyle.Bold);
        Panel(g, x + 24, y + 62, 104, 92, "#31443d", "#746b45", 8, 235);
        CenterText(g, "타일\n미리보기", x + 34, y + 78, 84, 54, 15, "#eee3c6", FontStyle.Bold);
        Text(g, "현재 선택: 해변(2,7)", x + 150, y + 64, 260, 24, 17, "#efe7cc", FontStyle.Bold);
        Text(g, "안개가 걷힌 현재 위치. 채집 가능한 열매/식수, 조사 후 인접 타일 개방.", x + 150, y + 94, 520, 46, 14, "#cdc6b1");
        string[] chips = {"위험 낮음", "자원 약간", "조사 전", "개발 0"};
        for (int i = 0; i < chips.Length; i++)
        {
            Panel(g, x + 150 + i * 104, y + 134, 92, 26, "#24352f", "#61705d", 8, 235);
            CenterText(g, chips[i], x + 150 + i * 104, y + 139, 92, 16, 12, "#eee2c0", FontStyle.Bold);
        }
        Text(g, "로그는 결과창 대신 누적. 획득 아이템만 사라지는 말풍선/카드 이동으로 피드백. 이벤트는 컷씬 후 선택지로 전환.", x + 686, y + 68, 448, 50, 14, "#cfc7ad");
        Panel(g, x + w - 188, y + 62, 150, 82, "#25332f", "#d6b75b", 8, 235);
        CenterText(g, "획득 토스트\n+ 컷씬 레이어", x + w - 178, y + 78, 130, 44, 14, "#f1e4be", FontStyle.Bold);
    }

    static void DrawTimeBar(Graphics g, float x, float y, float w, float h)
    {
        Panel(g, x, y, w, h, "#ded5b8", "#5d6256", 10, 246);
        Text(g, "시간 흐름", x + 18, y + 12, 120, 22, 17, "#232920", FontStyle.Bold);
        Text(g, "1일차 · 06:00 · 맑음", x + w - 176, y + 13, 150, 22, 15, "#252a22", FontStyle.Bold, StringAlignment.Far);
        string[] phases = {"아침", "낮", "저녁", "밤", "새벽"};
        string[] cols = {"#e8c66b", "#d99d42", "#a76061", "#32405d", "#6f8091"};
        float sx = x + 34;
        float sy = y + 46;
        float sw = w - 68;
        for (int i = 0; i < phases.Length; i++)
        {
            using (var brush = B(cols[i], 220))
                g.FillRectangle(brush, sx + i * sw / phases.Length, sy, sw / phases.Length, 14);
            CenterText(g, phases[i], sx + i * sw / phases.Length, sy + 18, sw / phases.Length, 20, 12, "#293025", FontStyle.Bold);
        }
        using (var marker = B("#fff0a8", 245))
        using (var pen = P("#2c2718", 2f, 230))
        {
            float mx = sx + sw * 0.07f;
            g.FillEllipse(marker, mx - 14, sy - 9, 28, 28);
            g.DrawEllipse(pen, mx - 14, sy - 9, 28, 28);
        }
        CenterText(g, "☀", sx + sw * 0.07f - 14, sy - 9, 28, 28, 16, "#31280f", FontStyle.Bold);
    }

    public static void Generate(string outPath)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(outPath));
        using (var bitmap = new Bitmap(W, H, PixelFormat.Format32bppArgb))
        using (var g = Graphics.FromImage(bitmap))
        {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.TextRenderingHint = System.Drawing.Text.TextRenderingHint.ClearTypeGridFit;
            g.Clear(C("#09100f"));

            using (var brush = new LinearGradientBrush(new Rectangle(0, 0, W, H), C("#111c1a"), C("#050807"), 90f))
                g.FillRectangle(brush, 0, 0, W, H);

            Text(g, "Lost In Island - 구조 와이어프레임", 34, 18, 520, 30, 22, "#f2e5c5", FontStyle.Bold);
            Text(g, "맵 중심 생활형 생존 UI / 갱신 2026-05-29", 34, 48, 520, 24, 14, "#b9b39f");

            DrawTimeBar(g, 470, 20, 660, 86);
            Panel(g, 1164, 28, 370, 64, "#111916", "#3e4a43", 8, 238);
            Text(g, "상단 우측: 시스템 메뉴 압축", 1182, 48, 330, 22, 14, "#ded5bc");

            DrawCharacterPanel(g, 30, 128, 238, 708, "플레이어", true);
            DrawMap(g, 292, 128, 1016, 520);
            DrawCharacterPanel(g, 1332, 128, 238, 708, "동행자", false);
            DrawBottom(g, 292, 672, 1016, 164);

            Panel(g, 30, 850, 1540, 30, "#111916", "#2e3a34", 6, 235);
            Text(g, "핵심 상태: 이미지 헥스 타일 100장, 생성 지역/컷씬/타이틀 자산, 시간/날씨/안개, 카드 인벤토리, 무게/필드 보관, 거점, 컷씬 이벤트 구현. 남은 과제: main.gd 분리와 밸런스 검증.", 48, 856, 1500, 18, 13, "#cfc7ad");

            bitmap.Save(outPath, ImageFormat.Png);
        }
    }
}
"@

Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing

$scriptRoot = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($scriptRoot)) {
    $scriptRoot = Join-Path (Get-Location) 'scripts\tools'
}
$projectRoot = Resolve-Path (Join-Path $scriptRoot '..\..')
$outPath = Join-Path $projectRoot 'docs\wireframes\current_game_state_wireframe.png'
[CurrentStateWireframe]::Generate($outPath)
Write-Output "wireframe=$outPath"

