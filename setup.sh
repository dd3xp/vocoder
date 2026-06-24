#!/usr/bin/env bash
# 一键安装编译依赖 (tectonic)。 fandol 字体由 tectonic 首次编译时按需拉取, 不需要单独装。
set -e

if command -v tectonic >/dev/null 2>&1; then
  echo "[skip] tectonic 已安装: $(tectonic -V 2>&1 | head -1)"
  exit 0
fi

OS="$(uname -s)"
case "$OS" in
  Darwin)
    if command -v brew >/dev/null 2>&1; then
      echo "[install] brew install tectonic"
      brew install tectonic
    else
      echo "[install] 通过官方脚本安装 tectonic (macOS, 无 brew)"
      curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net | sh
      sudo mv tectonic /usr/local/bin/
    fi
    ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1 && apt-cache show tectonic >/dev/null 2>&1; then
      echo "[install] apt-get install tectonic"
      sudo apt-get update && sudo apt-get install -y tectonic
    elif command -v conda >/dev/null 2>&1; then
      echo "[install] conda install -c conda-forge tectonic"
      conda install -y -c conda-forge tectonic
    elif command -v cargo >/dev/null 2>&1; then
      echo "[install] cargo install tectonic"
      cargo install tectonic
    else
      echo "[install] 通过官方脚本安装 tectonic (Linux)"
      curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net | sh
      mkdir -p "$HOME/.local/bin"
      mv tectonic "$HOME/.local/bin/"
      echo "[note] 请确保 \$HOME/.local/bin 在 PATH 中"
    fi
    ;;
  *)
    echo "[error] 不支持的系统: $OS。 请到 https://tectonic-typesetting.github.io 手动安装"
    exit 1
    ;;
esac

echo "[ok] 安装完成: $(tectonic -V 2>&1 | head -1)"
echo "[next] ./build.sh 编译 main.pdf"
