# Valheim Dedicated Server (Docker for MCSManager)

基于 SteamCMD 的英灵神殿 (Valheim) 专用 Docker 镜像方案。
本方案采用 **“全数据持久化”** 策略：游戏本体、存档、配置文件、启动脚本均存储在宿主机，容器仅提供运行环境。

## 目录结构说明

- `docker/`: 包含构建 Docker 镜像所需文件。
- `data/`: 包含启动脚本 `start_mcsm_server.sh`。此目录将作为挂载点。

## 部署流程

### 1. 构建镜像

进入 docker 目录并构建镜像：

```bash
cd valheim/docker
docker build -t mcsm-valheim .

```

### 2. 准备数据目录

将仓库中的 `data` 目录内容复制到你的宿主机服务器位置（例如 `/opt/mcsm/valheim`）：

```bash
# 假设你在宿主机创建了如下目录
mkdir -p /opt/mcsm/valheim/data

# 将启动脚本复制进去，并赋予执行权限
cp ./data/start_mcsm_server.sh /opt/mcsm/valheim/data/
sudo chown -R 1000:1000 /opt/mcsm/valheim/data
```

**⚠️ 重要配置：**
请务必编辑 `start_mcsm_server.sh`，修改以下参数：

* `-name`: 服务器名称
* `-password`: 服务器密码
* `-world`: 存档文件名

### 3. MCSManager 实例配置

在面板创建实例时，请严格按照以下配置：

| 配置项 | 填写内容 | 说明 |
| --- | --- | --- |
| **实例类型** | Docker |  |
| **镜像名称** | `mcsm-valheim` | 刚才构建的镜像名 |
| **启动命令** | (留空) | 使用镜像内置 Entrypoint |
| **工作目录** | `/app/game` | **必须填此路径** |
| **挂载路径** | 宿主机路径: `/opt/mcsm/valheim/data` 容器路径: `/app/game` | **核心步骤**：将宿主机的数据目录直接映射为容器的游戏根目录 |

## 启动与更新

1. **首次启动**：
容器启动后，`entrypoint.sh` 会检测到挂载目录，并自动通过 SteamCMD 将 Valheim 游戏文件下载到你的宿主机 `data` 目录下。
*注意：首次下载可能需要较长时间，请查看控制台日志。*
2. **日常运行**：
每次重启实例，脚本都会尝试校验/更新游戏文件，然后直接执行目录下的 `start_mcsm_server.sh`。
3. **存档位置**：
根据启动脚本配置，存档通常位于 `data/save` (即宿主机的 `/opt/mcsm/valheim/data/save`)。

