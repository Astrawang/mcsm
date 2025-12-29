#!/bin/bash
echo "正在启动 valheim..."

export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH

./valheim_server.x86_64 -name "Teyvat 4.0" -port 2456 -world "teyvat4" -password "bydbyd" -crossplay -savedir "/app/game/save" -modifier deathpenalty casual -modifier resources most -modifier portals casual -public 0

