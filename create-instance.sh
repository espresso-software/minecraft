#!/bin/bash

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -n|--name)
      DEPLOYMENT_NAME="$2"
      shift
      shift
      ;;
    -t|--tag)
      TAG="$2"
      shift
      shift
      ;;
    -T|--type)
      TYPE="$2"
      shift
      shift
      ;;
    -v|--version)
      VERSION="$2"
      shift
      shift
      ;;
    -c|--min-cpu)
      MIN_CPU="$2"
      shift
      shift
      ;;
    -C|--max-cpu)
      MAX_CPU="$2"
      shift
      shift
      ;;
    -r|--min-memory)
      MIN_RAM="$2"
      shift
      shift
      ;;
    -R|--max-memory)
      MAX_RAM="$2"
      shift
      shift
      ;;
    -p|--port)
      PORT="$2"
      shift
      shift
      ;;
    -S|--seed)
      SEED="$2"
      shift
      shift
      ;;
    -s|--slug)
      ITZG_SLUG="$2"
      shift
      shift
      ;;
    -f|--file-id)
      ITZG_FILE_ID="$2"
      shift
      shift
      ;;
    -F|--file)
      ITZG_FILE="$2"
      shift
      shift
      ;;
    -W|--world-size)
      WORLD_SIZE="$2"
      shift
      shift
      ;;
    -b|--backup-size)
      BKP_SIZE="$2"
      shift
      shift
      ;;
    -B|--save-size)
      SAVE_SIZE="$2"
      shift
      shift
      ;;
    -E|--etc-size)
      ETC_SIZE="$2"
      shift
      shift
      ;;
    -D|--mods-size)
      MODS_SIZE="$2"
      shift
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

print_help() {
  echo "Usage: create-instance.sh -n NAME -v VERSION [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -n, --name          The NAME (required)"
  echo "  -v, --version       The VERSION (required)"
  echo "  -t, --tag           The TAG (default: java21)"
  echo "  -T, --type          The TYPE (default: VANILLA)"
  echo "  -A, --server-stats  The SERVER_STATS (default: forge)"
  echo "  -c, --min-cpu       The MIN_CPU (default: 1)"
  echo "  -C, --max-cpu       The MAX_CPU (default: 4)"
  echo "  -r, --min-memory   The MIN_RAM (default: 1G)"
  echo "  -R, --max-memory   The MAX_RAM (default: 4G)"
  echo "  -S, --seed          The SEED (optional)"
  echo "  -s, --slug          The ITZG_SLUG (optional)"
  echo "  -f, --file-id       The ITZG_FILE_ID (optional)"
  echo "  -F, --file          The ITZG_FILE (optional)"
  echo "  -W, --world-size    The WORLD_SIZE (default: 20Gi)"
  echo "  -b, --backup-size   The BKP_SIZE (optional, default: 10Gi)"
  echo "  -B, --save-size     The SAVE_SIZE (default: 5Gi)"
  echo "  -E, --etc-size      The ETC_SIZE (default: 5Gi)"
  echo "  -D, --mods-size     The MODS_SIZE (default: 5Gi)"
}

# Validate required inputs
if [ -z "$DEPLOYMENT_NAME" ]; then
  echo "NAME is required"
  exit 1
fi
if [ -z "$VERSION" ]; then
  echo "VERSION is required"
  exit 1
fi

# force version to lowercase
VERSION=$(echo $VERSION | tr '[:upper:]' '[:lower:]')

# Set defaults
TAG="${TAG:-java21}"
TYPE="${TYPE:-VANILLA}"
SERVER_STATS="${SERVER_STATS:-forge}"
MIN_CPU="${MIN_CPU:-1}"
MAX_CPU="${MAX_CPU:-4}"
MIN_RAM="${MIN_RAM:-1G}"
MAX_RAM="${MAX_RAM:-4G}"
PORT="${PORT:-25565}"
WORLD_SIZE="${WORLD_SIZE:-20Gi}"
SAVE_SIZE="${SAVE_SIZE:-5Gi}"
ETC_SIZE="${ETC_SIZE:-5Gi}"
BKP_SIZE="${BKP_SIZE:-10Gi}"
MODS_SIZE="${MODS_SIZE:-5Gi}"
GC_ARGS="-XX:+UseZGC"

if [ "$TAG" == "java8" ]; then
  GC_ARGS="-XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:InitiatingHeapOccupancyPercent=45 -XX:G1ReservePercent=15"
fi

cp deploy.yml.template $DEPLOYMENT_NAME.yml
sed -i "s%<NAME>%$DEPLOYMENT_NAME%g" $DEPLOYMENT_NAME.yml
sed -i "s%<TAG>%$TAG%g" $DEPLOYMENT_NAME.yml
sed -i "s%<TYPE>%$TYPE%g" $DEPLOYMENT_NAME.yml
sed -i "s%<SERVER_STATS>%$SERVER_STATS%g" $DEPLOYMENT_NAME.yml
sed -i "s%<VERSION>%$VERSION%g" $DEPLOYMENT_NAME.yml
sed -i "s%<MIN_CPU>%$MIN_CPU%g" $DEPLOYMENT_NAME.yml
sed -i "s%<MAX_CPU>%$MAX_CPU%g" $DEPLOYMENT_NAME.yml
sed -i "s%<MIN_RAM>%$MIN_RAM%g" $DEPLOYMENT_NAME.yml
sed -i "s%<MAX_RAM>%$MAX_RAM%g" $DEPLOYMENT_NAME.yml
sed -i "s%<PORT>%$PORT%g" $DEPLOYMENT_NAME.yml
sed -i "s%<SEED>%$SEED%g" $DEPLOYMENT_NAME.yml
sed -i "s%<ITZG_SLUG>%$ITZG_SLUG%g" $DEPLOYMENT_NAME.yml
sed -i "s%<ITZG_FILE_ID>%$ITZG_FILE_ID%g" $DEPLOYMENT_NAME.yml
sed -i "s%<ITZG_FILE>%$ITZG_FILE%g" $DEPLOYMENT_NAME.yml
sed -i "s%<WORLD_SIZE>%$WORLD_SIZE%g" $DEPLOYMENT_NAME.yml
sed -i "s%<SAVE_SIZE>%$SAVE_SIZE%g" $DEPLOYMENT_NAME.yml
sed -i "s%<ETC_SIZE>%$ETC_SIZE%g" $DEPLOYMENT_NAME.yml
sed -i "s%<BKP_SIZE>%$BKP_SIZE%g" $DEPLOYMENT_NAME.yml
sed -i "s%<MODS_SIZE>%$MODS_SIZE%g" $DEPLOYMENT_NAME.yml
sed -i "s%<GC_ARGS>%$GC_ARGS%g" $DEPLOYMENT_NAME.yml