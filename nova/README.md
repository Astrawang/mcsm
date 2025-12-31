# Nova Engineering World Minecraft Server (Docker for MCSManager)

基于 Eclipse Temurin (Java 21) 的 Nova Engineering World 整合包专用 Docker 镜像方案。
本方案采用 **“全数据持久化”** 策略：服务端核心、世界存档、模组文件均存储在宿主机，容器仅提供 Java 运行环境。

## 目录结构说明

* `docker/`: 包含构建 Docker 镜像所需文件。
* `data/`: 包含启动脚本 `start_mcsm_server.sh` 及服务端压缩包。此目录将作为挂载点。

## 部署流程

### 1. 构建镜像

进入 docker 目录并构建镜像：

```bash
cd nova/docker
docker build -t mcsm-nova .

```

### 2. 准备数据目录

将仓库中的 `data` 目录内容复制到你的宿主机服务器位置（例如 `/opt/mcsm/nova`），并**放入服务端压缩包**：

```bash
# 假设你在宿主机创建了如下目录
mkdir -p /opt/mcsm/nova/data

# 1. 将启动脚本复制进去，并赋予执行权限
cp ./data/start_mcsm_server.sh /opt/mcsm/nova/data/

# 2. 【必须】将服务端压缩包上传到此目录
# 文件名必须包含 "NovaEng-CatRoom" (例如: [服务端]NovaEng-CatRoom-1.18.2.1.zip)

# 3. 设置权限 (确保容器内用户可读写)
sudo chown -R 1000:1000 /opt/mcsm/nova/data

```

**⚠️ 重要配置：**
请务必编辑 `start_mcsm_server.sh`，根据你的机器配置修改内存参数。**容器只会执行此脚本，未创建将导致启动失败。**

* `JAVA_XMS`: 最小内存 (推荐 2G)
* `JAVA_XMX`: 最大内存 (推荐 10G)

### 3. MCSManager 实例配置

在面板创建实例时，请严格按照以下配置：

| 配置项 | 填写内容 | 说明 |
| --- | --- | --- |
| **实例类型** | Docker |  |
| **镜像名称** | `mcsm-nova` | 刚才构建的镜像名 |
| **启动命令** | (留空) | 使用镜像内置 Entrypoint |
| **工作目录** | `/app/game` | **必须填此路径** |
| **挂载路径** | 宿主机路径: `/opt/mcsm/nova/data` 容器路径: `/app/game` | **核心步骤**：将宿主机的数据目录直接映射为容器的游戏根目录 |

## 启动与更新

1. **首次启动**：
容器启动后，`entrypoint.sh` 会自动检测挂载目录下的 Zip 压缩包，进行解压和部署。
*注意：如果没有上传符合名称要求的压缩包，容器会报错并停止。*
2. **日常运行**：
每次重启实例，容器将直接执行挂载目录下的 `start_mcsm_server.sh`。
3. **存档位置**：
存档位于宿主机目录下的 `world` 文件夹 (即 `/opt/mcsm/nova/data/world`)。