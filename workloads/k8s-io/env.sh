# Common
export UUID=${UUID:-$(uuidgen)}
export CLEANUP=${CLEANUP:-true}

# k8s-io build/download
export K8S_IO_REPO=${K8S_IO_REPO:-https://github.com/jtaleric/k8s-io.git}
export K8S_IO_BRANCH=${K8S_IO_BRANCH:-main}
export K8S_IO_URL=${K8S_IO_URL:-}

# Elasticsearch
export ES_SERVER=${ES_SERVER:-}
export ES_INDEX=${ES_INDEX:-ripsaw-fio}

# Workload
export CONFIG=${CONFIG:-smoke.yaml}
export WORKLOAD=${WORKLOAD:-k8s-io}
export TEST_TIMEOUT=${TEST_TIMEOUT:-14400}
