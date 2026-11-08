#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/../android/app/src/main/res"
for pair in "mdpi:48" "hdpi:72" "xhdpi:96" "xxhdpi:144" "xxxhdpi:192"; do
  dens="${pair%%:*}"
  sz="${pair##*:}"
  mkdir -p "mipmap-${dens}"
  convert -size "${sz}x${sz}" xc:'#2E7D6B' \
    -fill white -draw "circle $((sz/2)),$((sz/2)) $((sz/2)),$((sz/3))" \
    "mipmap-${dens}/ic_launcher.png"
  cp "mipmap-${dens}/ic_launcher.png" "mipmap-${dens}/ic_launcher_round.png"
done
echo "✅ Icons generated."
