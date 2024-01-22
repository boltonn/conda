#! /bin/bash
set -ef

verlte() {
    [  "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]
}

if [ ! -x /bin/nvidia-smi ]; then
    echo "No Nvidia driver detected...continuing"
else
    NVIDIA_DRIVER_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader,nounits | head -n 1)
    echo "Host Nvidia driver version: $NVIDIA_DRIVER_VERSION"

    CUDA_COMPST_MAX_DRIVER_VERSION=$(cat /usr/local/cuda/version.txt | grep "CUDA Version" | awk '{print $3}')
    echo -n "CUDA Compat required driver version: $CUDA_COMPST_MAX_DRIVER_VERSION"

    if verlte $NVIDIA_DRIVER_VERSION $CUDA_COMPST_MAX_DRIVER_VERSION; then
        echo "Host Nvidia driver version is compatible with CUDA"
        export LD_LIBRARY_PATH=/usr/local/cuda/compat:$LD_LIBRARY_PATH
    else
        echo "Host Nvidia driver version is not compatible with CUDA"
        exit 1
    fi
fi

set +ef