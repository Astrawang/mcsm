#!/bin/bash
set -e

APP_ID=896660
GAME_DIR="/app/game"

echo "--- [1/3] 初始化 SteamCMD ---"
steamcmd +login anonymous +quit || true

echo "--- [2/3] 开始下载/更新游戏 (AppID: $APP_ID) ---"
mkdir -p "$GAME_DIR"
steamcmd +force_install_dir "$GAME_DIR" +login anonymous +app_update $APP_ID validate +quit

echo "--- [3/3] 准备启动服务器 ---"
cd "$GAME_DIR"

if [ -z "$1" ]; then
  if [ -f "./start_mcsm_server.sh" ]; then
    echo "执行本地启动脚本: ./start_mcsm_server.sh"
    chmod +x ./start_mcsm_server.sh
    exec ./start_mcsm_server.sh
  else
    echo "错误: 未找到 start_mcsm_server.sh 文件！请在数据目录中创建。"
    exit 1
  fi
else
  echo "执行传入的启动命令: $@"
  exec "$@"
fi
