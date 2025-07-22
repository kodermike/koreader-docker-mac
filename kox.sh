#!/usr/bin/env bash 

FAIL=0
for package in xauth socat xquartz; do
  if [ -n $(brew list ${package} | grep -ic "error:" ) ]; then 
    FAIL=1
    echo "MISSING: ${package}"
  fi
done
if [ ${FAIL} -gt 0 ]; then
  echo "Missing required packages. Review the list above and re-check the intallation guide."
  exit 
fi
# brew install -q socat xauth as well as xquartz --cask
#
CONTAINER=kodereaderapp:latest


NIC=en0

# Grab the ip address of this box
IPADDR=$(ifconfig $NIC | grep "inet " | awk '{print $2}')

DISP_NUM=$(jot -r 1 100 200) # random display number between 100 and 200

#sudo /opt/X11/bin/xhost +

PORT_NUM=$((6000 + DISP_NUM)) # so multiple instances of the container won't interfer with eachother

socat TCP-LISTEN:${PORT_NUM},reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" 2>&1 >/dev/null &

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth.$USER.$$
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

function build_koreader() {
git clone https://github.com/koreader/koreader.git

docker run \
  -it \
  --rm \
  --workdir="/Users/$USER" \
  -v "$(pwd)/koreader:/home/ko/koreader" \
  -v $XSOCK:$XSOCK:rw \
  -v $XAUTH:$XAUTH:rw \
  -e DISPLAY=$IPADDR:$DISP_NUM \
  -e XAUTHORITY=$XAUTH \
  $CONTAINER \
  bash "cd koreader && ./kodev fetch-thirdparty && ./kodev build"
#-c $COMMAND
}

function run_koreder() {
  docker run -v $(pwd)/koreader:/home/ko/koreader -it koreader/koappimage:latest bash
}

CMD="$1"
shift 
case "${CMD}" in 
  build)
    build_koreader()
    ;;
  *)
    run_koreader()
    ;;
esac
rm -f $XAUTH
kill %1 # kill the socat job launched above
