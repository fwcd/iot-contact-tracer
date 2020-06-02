@echo off
set CNG_PATH=%~dp0%contiki-ng
set SRC_PATH=%~dp0%src
set DISPLAY=host.docker.internal:0.0
docker run --privileged --sysctl net.ipv6.conf.all.disable_ipv6=0 --mount type=bind,source=%CNG_PATH%,destination=/home/user/contiki-ng --mount type=bind,source=%SRC_PATH%,destination=/home/user/src -e DISPLAY=%DISPLAY% -ti --rm contiker/contiki-ng %*
