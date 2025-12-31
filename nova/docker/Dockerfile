FROM eclipse-temurin:21-jre-noble

# 1. 配置镜像源
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's@//.*security.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources

# 2. 安装依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl fontconfig libfreetype6 7zip \
    && rm -rf /var/lib/apt/lists/*

# 3. 创建 minecraft 用户
RUN (getent passwd 1000 > /dev/null && userdel -f $(getent passwd 1000 | cut -d: -f1)) || true && \
    (getent group 1000 > /dev/null && groupdel $(getent group 1000 | cut -d: -f1)) || true && \
    groupadd -g 1000 minecraft && \
    useradd -m -u 1000 -g minecraft minecraft

# 4. 创建工作目录
RUN mkdir -p /app/game && chown -R minecraft:minecraft /app/game

# 5. 拷贝入口脚本
COPY --chown=minecraft:minecraft entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

USER minecraft
ENV HOME=/home/minecraft
ENV LANG=C.UTF-8 

WORKDIR /app/game
ENTRYPOINT ["/app/entrypoint.sh"]
