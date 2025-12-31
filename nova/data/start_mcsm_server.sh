#!/bin/sh

# CleanroomLoader 内存优化启动配置 (Java 21)
# openjdk21="/usr/bin/jdk/jdk-21.0.2/bin/java"
openjdk21="java"

# 内存配置 (降低最小内存)
MIN_MEM="2G"
MAX_MEM="10G"

# Java 21 优化参数 (兼容dash语法)
JAVA_OPTS="-Xms$MIN_MEM"
JAVA_OPTS="$JAVA_OPTS -Xmx$MAX_MEM"
JAVA_OPTS="$JAVA_OPTS -XX:+UseZGC"
JAVA_OPTS="$JAVA_OPTS -XX:+ZGenerational"
JAVA_OPTS="$JAVA_OPTS -XX:+ZUncommit"
JAVA_OPTS="$JAVA_OPTS -XX:ZUncommitDelay=300"
JAVA_OPTS="$JAVA_OPTS -XX:+AlwaysPreTouch"
JAVA_OPTS="$JAVA_OPTS -Dio.netty.allocator.type=pooled"
JAVA_OPTS="$JAVA_OPTS -Xlog:gc*:file=gc.log:time,uptime,tags:filecount=3,filesize=50M"
JAVA_OPTS="$JAVA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
JAVA_OPTS="$JAVA_OPTS -XX:HeapDumpPath=./memory_dump.hprof"

# 设置终端标题
printf "\033]0;CatRoom - Java21优化版\007"

# 显示关键配置
echo "JVM内存: $MIN_MEM -> $MAX_MEM (ZGC优化)"
echo "启动时间: $(date)"

# 启动服务器
start_time=$(date +%s)
$openjdk21 $JAVA_OPTS -jar cleanroom-15.24.0.3029.jar -nogui

# 计算运行时间
end_time=$(date +%s)
echo "服务器运行时长: $((end_time - start_time))秒"
echo "已停止于 $(date)"
echo "内存分析: gc.log & memory_dump.hprof"