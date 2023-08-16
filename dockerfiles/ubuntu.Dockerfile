FROM ubuntu:20.04

# OpenCascade build tools and dependencies
# For ubuntu 18.04, see https://realglitch.com/2020/04/how-to-install-opencascade-7-4-on-ubuntu-18-04-lts/
RUN apt-get update &&  \
    apt-get install -y build-essential cmake wget tcl-dev tk-dev libxmu-dev libxi-dev libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev &&  \
    rm -rf /var/lib/apt/lists/*


# OpenCascade
RUN mkdir /opencascade && \
    cd /opencascade && \
    wget https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V7_6_2.tar.gz && \
    tar zxvf V7_6_2.tar.gz && \
    rm V7_6_2.tar.gz && \
    mkdir OCCT-7_6_2/build && \
    cd OCCT-7_6_2/build && \
    cmake .. \
    -D CMAKE_BUILD_TYPE=release \
    -D CMAKE_INSTALL_PREFIX=/usr && \
    make -j4 && \
    make install \
