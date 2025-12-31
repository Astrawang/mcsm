#!/bin/bash
set -e

GAME_DIR="/app/game"
ZIP_PASSWORD="NovaEng"
ZIP_PATTERN="*NovaEng-CatRoom*.zip"
LOCK_FILE=".install_lock"

echo "--- [1/3] 初始化 Java 环境 ---"
java -version

echo "--- [2/3] 检查并部署整合包资源 ---"
mkdir -p "$GAME_DIR"
cd "$GAME_DIR"

if [ -f "$LOCK_FILE" ]; then
  echo "检测到安装锁文件，跳过解压流程。"
else
  # 查找符合模式的压缩包
  TARGET_ZIP=$(find . -maxdepth 1 -iname "$ZIP_PATTERN" | head -n 1)

  if [ -n "$TARGET_ZIP" ]; then
    echo "发现整合包: $TARGET_ZIP，正在解压..."
    
    # 1. 解压 (安静模式, 覆盖, 指定密码)
    7z x "$TARGET_ZIP" -p"$ZIP_PASSWORD" -y -otemp_extract
    
    # 2. 处理双层嵌套目录结构
    cd temp_extract
    DIR_L1=$(ls -d */ | head -n 1)
    if [ -n "$DIR_L1" ]; then
      cd "$DIR_L1"
      DIR_L2=$(ls -d */ | head -n 1)
      if [ -n "$DIR_L2" ]; then
        cd "$DIR_L2"
        echo "定位到游戏根目录，正在移动文件..."
        shopt -s dotglob && mv * "$GAME_DIR/" && shopt -u dotglob
      else
        echo "警告: 未发现第二层目录，尝试移动当前层级..."
        shopt -s dotglob && mv * "$GAME_DIR/" && shopt -u dotglob
      fi
    fi
    
    # 3. 清理与标记
    cd "$GAME_DIR"
    rm -rf temp_extract
    
    touch "$LOCK_FILE"
    echo "部署完成。"
  else
    echo "--------------------------------------------------------"
    echo "❌ 错误: 初始化失败，未找到服务端整合包！"
    echo "请上传符合模式 '$ZIP_PATTERN' 的压缩包"
    echo "到宿主机的数据挂载目录，然后重启实例。"
    echo "--------------------------------------------------------"
    exit 1
  fi
fi

echo "--- [3/3] 准备启动服务器 ---"
cd "$GAME_DIR"

if [ -z "$1" ]; then
  if [ -f "./start_mcsm_server.sh" ]; then
    echo "执行本地启动脚本: ./start_mcsm_server.sh"
    chmod +x ./start_mcsm_server.sh
    exec ./start_mcsm_server.sh
  else
    echo "--------------------------------------------------------"
    echo "❌ 错误: 未找到 start_mcsm_server.sh 文件！"
    echo "请在数据目录中创建。"
    echo "--------------------------------------------------------"
    exit 1
  fi
else
  echo "执行传入的启动命令: $@"
  exec "$@"
fi
