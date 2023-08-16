FROM alpine:3.18.3

# OpenCascade build tools and dependencies
RUN apk update &&  \
    apk add build-base cmake wget tcl-dev tk-dev libxmu-dev libxi-dev mesa-gl mesa-dev &&  \
    rm -rf /var/lib/apt/lists/*

# OpenCascade
# Comment out some lines in the opencascade source code
# -> based on https://stackoverflow.com/questions/58554433/opencascade-compilation-failure-on-alpine-linux-with-musl-libc-mallinfo-has-in
# - Comment out references of mallinfo (not available in glibc on musl/alpine)
# - Comment out references of feenableexcept, fedisableexcept and fegetexcept (not available in glibc on musl/alpine)
# - Comment out references of backtrace and backtrace_symbols (libexecinfo not available anymore on alpine>3.17)
RUN mkdir /opencascade && \
    cd /opencascade && \
    wget https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V7_6_2.tar.gz && \
    tar zxvf V7_6_2.tar.gz && \
    rm V7_6_2.tar.gz && \
    awk 'NR == 191 { $0 = "//" $0 };  \
         NR == 192 { $0 = "//" $0 };  \
         NR == 193 { $0 = "//" $0 };  \
         NR == 194 { $0 = "//" $0 };  \
         NR == 195 { $0 = "//" $0 };  \
         NR == 196 { $0 = "//" $0 };  \
         1' OCCT-7_6_2/src/OSD/OSD_MemInfo.cxx >OSD_MemInfo_tmp.cxx &&  \
    mv OSD_MemInfo_tmp.cxx OCCT-7_6_2/src/OSD/OSD_MemInfo.cxx && \
    awk 'NR == 982 { $0 = "//" $0 };  \
         NR == 983 { $0 = "//" $0 };  \
         NR == 984 { $0 = "//" $0 };  \
         NR == 985 { $0 = "//" $0 };  \
         NR == 986 { $0 = "//" $0 };  \
         NR == 987 { $0 = "//" $0 };  \
         NR == 988 { $0 = "//" $0 };  \
         NR == 989 { $0 = "//" $0 };  \
         NR == 1013 { $0 = "//" $0 };  \
         NR == 1014 { $0 = "//" $0 };  \
         NR == 1015 { $0 = "//" $0 };  \
         NR == 1017 { $0 = "//" $0 };  \
         1' OCCT-7_6_2/src/OSD/OSD_signal.cxx >OSD_signal_tmp.cxx &&  \
    mv OSD_signal_tmp.cxx OCCT-7_6_2/src/OSD/OSD_signal.cxx && \
    awk 'NR == 32 { $0 = "//" $0 };  \
         NR == 33 { $0 = "//" $0 };  \
         NR == 319 { $0 = "//" $0 };  \
         NR == 320 { $0 = "//" $0 };  \
         NR == 321 { $0 = "//" $0 };  \
         NR == 323 { $0 = "//" $0 };  \
         NR == 325 { $0 = "//" $0 };  \
         NR == 332 { $0 = "  char** aStrings;" }; \
         1' OCCT-7_6_2/src/Standard/Standard_StackTrace.cxx >Standard_StackTrace_tmp.cxx &&  \
    mv Standard_StackTrace_tmp.cxx OCCT-7_6_2/src/Standard/Standard_StackTrace.cxx && \
    mkdir OCCT-7_6_2/build && \
    cd OCCT-7_6_2/build && \
    cmake .. \
    -D CMAKE_BUILD_TYPE=release \
    -D CMAKE_INSTALL_PREFIX=/usr && \
    make -j4 && \
    make install \