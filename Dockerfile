# This vLLM Dockerfile is used to construct image that can build and run vLLM on x86 CPU platform.
# Based on https://github.com/PZD-CHINA/vllm/commit/55e1b7b54e916a3a930fc92fadca8a61adf9ace7
FROM ubuntu:22.04

RUN apt-get update  -y \
    && apt-get install -y git wget vim numactl gcc-12 g++-12 python3 python3-pip \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 10 --slave /usr/bin/g++ g++ /usr/bin/g++-12

RUN pip install --upgrade pip 
RUN pip install --proxy http://child-prc.intel.com:913 wheel packaging ninja setuptools>=49.4.0 numpy 
RUN pip install --proxy http://child-prc.intel.com:913 torch==2.1.2+cpu --index-url https://download.pytorch.org/whl/cpu

RUN pip install langchain --proxy http://child-prc.intel.com:913

# TODO: link to selected url
COPY ./ /workspace/vllm

WORKDIR /workspace/vllm

RUN VLLM_BUILD_CPU_ONLY=1 MAX_JOBS=8 pip install --proxy=http://child-prc.intel.com:913 --no-build-isolation  -v -e .

CMD ["/bin/bash"]
