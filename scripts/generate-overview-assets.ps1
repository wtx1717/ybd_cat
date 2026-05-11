Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$ErrorActionPreference = "Stop"
$outDir = Join-Path $PSScriptRoot "..\assets\images\overview"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

function New-Canvas($width, $height) {
  $bitmap = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
  $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
  $graphics.Clear([System.Drawing.Color]::Transparent)
  return @{ Bitmap = $bitmap; Graphics = $graphics }
}

function Save-Canvas($canvas, $name) {
  $path = Join-Path $outDir $name
  $canvas.Bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $canvas.Graphics.Dispose()
  $canvas.Bitmap.Dispose()
}

function Solid($hex) {
  return New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($hex))
}

function Pen($hex, $width = 1) {
  return New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml($hex), $width)
}

function Fill-PixelNoise($g, $w, $h, $seed, $alpha = 24) {
  $rnd = New-Object System.Random($seed)
  for ($i = 0; $i -lt 420; $i++) {
    $x = $rnd.Next(8, [Math]::Max(9, $w - 8))
    $y = $rnd.Next(8, [Math]::Max(9, $h - 8))
    $c = if ($rnd.NextDouble() -gt 0.5) { [System.Drawing.Color]::FromArgb($alpha, 91, 58, 29) } else { [System.Drawing.Color]::FromArgb($alpha, 255, 248, 222) }
    $b = New-Object System.Drawing.SolidBrush($c)
    $g.FillRectangle($b, $x, $y, $rnd.Next(2, 6), $rnd.Next(1, 4))
    $b.Dispose()
  }
}

function Draw-PaperPanel($name, $w, $h, $edgeMode) {
  $c = New-Canvas $w $h
  $g = $c.Graphics
  $paper = Solid "#f3ddb8"
  $paper2 = Solid "#ead0a5"
  $line = Pen "#6e472b" 8
  $inner = Pen "#bc8750" 4
  $soft = Pen "#d9b783" 2
  $g.FillRectangle($paper, 8, 8, $w - 16, $h - 16)
  $g.FillRectangle($paper2, 18, $h - 34, $w - 36, 16)
  Fill-PixelNoise $g $w $h 42
  $g.DrawRectangle($line, 4, 4, $w - 8, $h - 8)
  $g.DrawRectangle($inner, 16, 16, $w - 32, $h - 32)
  $g.DrawLine($soft, 32, 78, $w - 32, 78)
  if ($edgeMode -eq "left") {
    $g.DrawLine((Pen "#9b6f3e" 6), $w - 8, 16, $w - 8, $h - 16)
  }
  if ($edgeMode -eq "right") {
    Draw-CornerOnGraphics $g ($w - 84) 4
    Draw-CornerOnGraphics $g ($w - 84) ($h - 84)
  }
  Save-Canvas $c $name
}

function Draw-CornerOnGraphics($g, $x, $y) {
  $gold = Solid "#d5a14b"
  $dark = Pen "#5d3a22" 5
  $hi = Pen "#ffe09a" 3
  $g.FillRectangle($gold, $x + 8, $y + 8, 54, 18)
  $g.FillRectangle($gold, $x + 8, $y + 8, 18, 54)
  $g.DrawRectangle($dark, $x + 6, $y + 6, 60, 24)
  $g.DrawRectangle($dark, $x + 6, $y + 6, 24, 60)
  $g.DrawLine($hi, $x + 15, $y + 14, $x + 55, $y + 14)
  $g.DrawLine($hi, $x + 15, $y + 14, $x + 15, $y + 55)
}

function New-Corner($name, $flipX, $flipY) {
  $c = New-Canvas 80 80
  $g = $c.Graphics
  if ($flipX -or $flipY) {
    $g.TranslateTransform($(if ($flipX) { 80 } else { 0 }), $(if ($flipY) { 80 } else { 0 }))
    $g.ScaleTransform($(if ($flipX) { -1 } else { 1 }), $(if ($flipY) { -1 } else { 1 }))
  }
  Draw-CornerOnGraphics $g 0 0
  Save-Canvas $c $name
}

function New-Book($name, $highlight) {
  $c = New-Canvas 520 560
  $g = $c.Graphics
  $g.TranslateTransform(260, 282)
  $g.RotateTransform(-9)
  $g.TranslateTransform(-260, -282)
  $cover = Solid $(if ($highlight) { "#8b5638" } else { "#724528" })
  $coverDark = Solid "#4a2a18"
  $gold = Pen "#d7a04a" 8
  $dark = Pen "#4f301c" 10
  $red = Solid "#bf2e24"
  $g.FillRectangle($coverDark, 124, 38, 300, 444)
  $g.FillRectangle($cover, 86, 52, 302, 440)
  $g.FillRectangle($red, 300, 34, 48, 480)
  $g.DrawRectangle($dark, 76, 42, 330, 460)
  $g.DrawRectangle($gold, 104, 78, 252, 380)
  $g.DrawLine((Pen "#f0c66d" 6), 334, 42, 380, 80)
  $g.DrawEllipse((Pen "#e5b35e" 7), 154, 198, 160, 160)
  $font = New-Object System.Drawing.Font("Microsoft YaHei", 82, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $fmt = New-Object System.Drawing.StringFormat
  $fmt.Alignment = [System.Drawing.StringAlignment]::Center
  $fmt.LineAlignment = [System.Drawing.StringAlignment]::Center
  $cloudText = [char]0x4e91
  $g.DrawString($cloudText, $font, (Solid "#f7d17b"), (New-Object System.Drawing.RectangleF(154, 198, 160, 160)), $fmt)
  Save-Canvas $c $name
}

function New-BookLabel() {
  $c = New-Canvas 360 92
  $g = $c.Graphics
  $g.FillRectangle((Solid "#f8e7c7"), 12, 12, 336, 62)
  $g.DrawRectangle((Pen "#6b4729" 6), 8, 8, 344, 70)
  $g.DrawRectangle((Pen "#d1a066" 3), 22, 22, 316, 42)
  Save-Canvas $c "overview-book-label.png"
}

function New-Shadow() {
  $c = New-Canvas 560 120
  $g = $c.Graphics
  for ($i = 0; $i -lt 8; $i++) {
    $a = 42 - ($i * 4)
    $b = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($a, 41, 23, 10))
    $g.FillEllipse($b, 50 + ($i * 10), 34 + ($i * 3), 460 - ($i * 20), 56 - ($i * 4))
    $b.Dispose()
  }
  Save-Canvas $c "overview-book-shadow.png"
}

function New-Spine() {
  $c = New-Canvas 96 390
  $g = $c.Graphics
  $g.FillRectangle((Solid "#235f43"), 16, 8, 64, 374)
  $g.FillRectangle((Solid "#2f8056"), 32, 20, 18, 340)
  $g.DrawRectangle((Pen "#5b3b22" 8), 12, 4, 72, 382)
  $g.DrawLine((Pen "#d5a14b" 4), 24, 18, 24, 366)
  $g.DrawLine((Pen "#d5a14b" 4), 72, 18, 72, 366)
  foreach ($y in 36, 188, 338) {
    $g.FillEllipse((Solid "#b9362c"), 38, $y, 20, 20)
    $g.DrawEllipse((Pen "#f0c66d" 3), 36, $y - 2, 24, 24)
  }
  Save-Canvas $c "overview-panel-spine-green.png"
}

function New-Divider() {
  $c = New-Canvas 42 360
  $g = $c.Graphics
  $g.FillRectangle((Solid "#8b5b32"), 10, 0, 22, 360)
  $g.DrawLine((Pen "#4d2f1b" 5), 8, 0, 8, 360)
  $g.DrawLine((Pen "#4d2f1b" 5), 34, 0, 34, 360)
  $g.DrawLine((Pen "#d8a452" 3), 18, 8, 18, 352)
  Save-Canvas $c "overview-panel-divider.png"
}

function New-Progress($name, $fill) {
  $c = New-Canvas 520 $(if ($fill) { 28 } else { 34 })
  $g = $c.Graphics
  if ($fill) {
    $g.FillRectangle((Solid "#2d7d44"), 0, 0, 520, 28)
    $g.FillRectangle((Solid "#46a45e"), 0, 3, 520, 8)
    $g.DrawRectangle((Pen "#1f5f36" 3), 1, 1, 517, 25)
  } else {
    $g.FillRectangle((Solid "#d8c09a"), 2, 4, 516, 24)
    $g.DrawRectangle((Pen "#8a714f" 5), 2, 2, 516, 28)
    $g.DrawRectangle((Pen "#f5dfb8" 2), 11, 10, 498, 12)
  }
  Save-Canvas $c $name
}

function New-Icon($name, $kind, $w = 40, $h = 40) {
  $c = New-Canvas $w $h
  $g = $c.Graphics
  $cx = [int]($w / 2)
  $cy = [int]($h / 2)
  switch ($kind) {
    "person" {
      $g.FillEllipse((Solid "#6c4d2f"), $cx - 5, 5, 10, 10)
      $g.FillRectangle((Solid "#6c4d2f"), $cx - 4, 17, 8, 14)
      $g.DrawLine((Pen "#6c4d2f" 3), $cx - 8, 34, $cx, 28)
      $g.DrawLine((Pen "#6c4d2f" 3), $cx + 8, 34, $cx, 28)
    }
    "activity" {
      $g.FillRectangle((Solid "#2f8056"), 9, 14, 22, 15)
      $g.FillRectangle((Solid "#d9b783"), 13, 9, 14, 6)
      $g.DrawRectangle((Pen "#5d3a22" 3), 8, 13, 24, 17)
    }
    "paw" {
      $g.FillEllipse((Solid "#9b5d32"), $cx - 7, $cy - 1, 14, 13)
      foreach ($p in @(@(-11,-10),@(-4,-14),@(4,-14),@(11,-10))) {
        $g.FillEllipse((Solid "#9b5d32"), $cx + $p[0] - 4, $cy + $p[1] - 4, 8, 8)
      }
    }
    "link" {
      $g.DrawArc((Pen "#7d5634" 5), 5, 10, 18, 18, 70, 250)
      $g.DrawArc((Pen "#7d5634" 5), 17, 10, 18, 18, -110, 250)
    }
    "fire" {
      $g.FillEllipse((Solid "#c9462c"), 11, 10, 18, 24)
      $g.FillEllipse((Solid "#f2a43d"), 15, 17, 10, 16)
      $g.DrawLine((Pen "#5d3a22" 3), 9, 28, 31, 28)
    }
    "blue" {
      $g.FillEllipse((Solid "#2f80b8"), 9, 9, 22, 22)
      $g.DrawLine((Pen "#d5f0ff" 4), 15, 24, 25, 14)
      $g.DrawRectangle((Pen "#1f5279" 3), 8, 8, 24, 24)
    }
    "clover" {
      foreach ($p in @(@(12,10),@(20,10),@(12,18),@(20,18))) {
        $g.FillEllipse((Solid "#3f8a45"), $p[0], $p[1], 10, 10)
      }
      $g.DrawLine((Pen "#2e6534" 4), 21, 24, 27, 34)
    }
    "lightning" {
      $poly = [System.Drawing.Point[]]@(
        [System.Drawing.Point]::new(22, 4),
        [System.Drawing.Point]::new(10, 22),
        [System.Drawing.Point]::new(20, 22),
        [System.Drawing.Point]::new(15, 36),
        [System.Drawing.Point]::new(32, 16),
        [System.Drawing.Point]::new(22, 16)
      )
      $g.FillPolygon((Solid "#f0b93e"), $poly)
      $g.DrawPolygon((Pen "#6b4729" 3), $poly)
    }
    "weather" {
      $g.FillEllipse((Solid "#f2b43f"), 18, 10, 58, 58)
      for ($i = 0; $i -lt 8; $i++) {
        $ang = $i * [Math]::PI / 4
        $x1 = 47 + [int]([Math]::Cos($ang) * 40)
        $y1 = 39 + [int]([Math]::Sin($ang) * 40)
        $x2 = 47 + [int]([Math]::Cos($ang) * 55)
        $y2 = 39 + [int]([Math]::Sin($ang) * 55)
        $g.DrawLine((Pen "#d18b2d" 6), $x1, $y1, $x2, $y2)
      }
      $g.FillEllipse((Solid "#f7f0d6"), 54, 54, 42, 30)
      $g.FillEllipse((Solid "#f7f0d6"), 84, 46, 44, 40)
      $g.FillRectangle((Solid "#f7f0d6"), 58, 68, 72, 24)
      $g.DrawRectangle((Pen "#6b8aa0" 4), 56, 66, 76, 26)
    }
  }
  Save-Canvas $c $name
}

Draw-PaperPanel "overview-panel-bg-left.png" 760 360 "left"
Draw-PaperPanel "overview-panel-bg-middle.png" 760 360 "middle"
Draw-PaperPanel "overview-panel-bg-right.png" 900 360 "right"
New-Book "overview-book-closed.png" $false
New-Book "overview-book-open-hint.png" $true
New-BookLabel
New-Shadow
New-Spine
New-Divider
New-Corner "overview-panel-corner-tl.png" $false $false
New-Corner "overview-panel-corner-tr.png" $true $false
New-Corner "overview-panel-corner-bl.png" $false $true
New-Corner "overview-panel-corner-br.png" $true $true
New-Icon "overview-icon-person.png" "person" 32 32
New-Icon "overview-icon-activity.png" "activity" 40 40
New-Icon "overview-icon-paw.png" "paw" 32 32
New-Icon "overview-icon-link.png" "link" 32 32
New-Icon "overview-icon-run-fire.png" "fire" 40 40
New-Icon "overview-icon-run-blue.png" "blue" 40 40
New-Icon "overview-icon-clover.png" "clover" 40 40
New-Icon "overview-icon-lightning.png" "lightning" 40 40
New-Progress "overview-progress-track.png" $false
New-Progress "overview-progress-fill.png" $true
New-Icon "overview-weather-partly-cloudy.png" "weather" 150 110

Get-ChildItem $outDir -Filter *.png | Sort-Object Name | Select-Object Name, Length
