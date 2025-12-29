FROM steamcmd/steamcmd:latest
USER root

# 1. 配置镜像源
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's@//.*security.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources


# 2. 安装依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates libatomic1 libpulse-dev libpulse0 \
    && rm -rf /var/lib/apt/lists/*

# 3. 创建steam用户
RUN id -u steam &>/dev/null || useradd -m steam

# 4. 创建工作目录
RUN mkdir -p /app/game && chown -R steam:steam /app/game

# 5. 拷贝入口脚本
COPY --chown=steam:steam entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

USER steam
ENV HOME=/home/steam
WORKDIR /app/game
ENTRYPOINT ["/app/entrypoint.sh"]
