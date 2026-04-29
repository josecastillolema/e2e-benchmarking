#!/usr/bin/env bash
set -e

source ./env.sh
source ../../utils/common.sh

K8S_IO_BINARY=./k8s-io
K8S_IO_DIR=/tmp/k8s-io-build

download_binary() {
  echo "Downloading k8s-io binary from ${K8S_IO_URL}"
  curl --fail --retry 8 --retry-all-errors -sS -L "${K8S_IO_URL}" -o ${K8S_IO_BINARY}
  chmod +x ${K8S_IO_BINARY}
}

build_binary() {
  echo "Building k8s-io from source (${K8S_IO_REPO}@${K8S_IO_BRANCH})"
  if [ -d "${K8S_IO_DIR}" ]; then
    rm -rf "${K8S_IO_DIR}"
  fi
  git clone --depth 1 --branch "${K8S_IO_BRANCH}" "${K8S_IO_REPO}" "${K8S_IO_DIR}"
  pushd "${K8S_IO_DIR}"
  go build -o k8s-io .
  popd
  cp "${K8S_IO_DIR}/k8s-io" ${K8S_IO_BINARY}
  rm -rf "${K8S_IO_DIR}"
}

if [ -n "${K8S_IO_URL}" ]; then
  download_binary
else
  build_binary
fi

log "###############################################"
log "Workload: ${WORKLOAD}"
log "UUID: ${UUID}"
log "Config: ${CONFIG}"
log "###############################################"

set +e

JOB_START=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cmd="timeout ${TEST_TIMEOUT} ${K8S_IO_BINARY} -config ${CONFIG}"

if [ "${CLEANUP}" = "true" ]; then
  cmd+=" -cleanup"
fi

echo "Executing command: $cmd"
eval "$cmd"
run=$?

JOB_END=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

log "Finished workload ${WORKLOAD}, exit code ($run)"

if [ $run -eq 0 ]; then
  JOB_STATUS="success"
else
  JOB_STATUS="failure"
fi
env JOB_START="${JOB_START}" JOB_END="${JOB_END}" JOB_STATUS="${JOB_STATUS}" UUID="${UUID}" WORKLOAD="${WORKLOAD}" ES_SERVER="${ES_SERVER}" ../../utils/index.sh
exit $run
