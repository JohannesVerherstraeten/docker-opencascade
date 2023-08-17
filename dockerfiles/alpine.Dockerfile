FROM alpine:3.18.3

# OpenCascade build tools and dependencies
RUN apk add --no-cache build-base cmake wget tcl-dev tk-dev libxmu-dev libxi-dev mesa-gl mesa-dev

# OpenCascade
# Modify some lines in the opencascade source code
# -> based on https://tracker.dev.opencascade.org/view.php?id=33250
# - Add the missing limits header file
# -> based on https://stackoverflow.com/questions/58554433/opencascade-compilation-failure-on-alpine-linux-with-musl-libc-mallinfo-has-in
# - Comment out references of mallinfo (not available in glibc on musl/alpine)
# - Comment out references of feenableexcept, fedisableexcept and fegetexcept (not available in glibc on musl/alpine)
# - Comment out references of backtrace and backtrace_symbols (libexecinfo not available anymore on alpine>3.17)
RUN mkdir /opencascade && \
    cd /opencascade && \
    wget https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V7_7_0.tar.gz && \
    tar zxvf V7_7_0.tar.gz && \
    rm V7_7_0.tar.gz && \
    awk 'NR == 22 {print "#include <limits>"} {print}' OCCT-7_7_0/src/ViewerTest/ViewerTest_CmdParser.cxx >ViewerTest_CmdParser_tmp.cxx && \
    mv ViewerTest_CmdParser_tmp.cxx OCCT-7_7_0/src/ViewerTest/ViewerTest_CmdParser.cxx && \
    awk 'NR == 187 { $0 = "//" $0 };  \
         NR == 188 { $0 = "//" $0 };  \
         NR == 189 { $0 = "//" $0 };  \
         NR == 190 { $0 = "//" $0 };  \
         NR == 191 { $0 = "//" $0 };  \
         NR == 192 { $0 = "//" $0 };  \
         1' OCCT-7_7_0/src/OSD/OSD_MemInfo.cxx >OSD_MemInfo_tmp.cxx &&  \
    mv OSD_MemInfo_tmp.cxx OCCT-7_7_0/src/OSD/OSD_MemInfo.cxx && \
    awk 'NR == 979 { $0 = "//" $0 };  \
         NR == 980 { $0 = "//" $0 };  \
         NR == 981 { $0 = "//" $0 };  \
         NR == 982 { $0 = "//" $0 };  \
         NR == 983 { $0 = "//" $0 };  \
         NR == 984 { $0 = "//" $0 };  \
         NR == 985 { $0 = "//" $0 };  \
         NR == 986 { $0 = "//" $0 };  \
         NR == 1010 { $0 = "//" $0 };  \
         NR == 1011 { $0 = "//" $0 };  \
         NR == 1012 { $0 = "//" $0 };  \
         NR == 1014 { $0 = "//" $0 };  \
         1' OCCT-7_7_0/src/OSD/OSD_signal.cxx >OSD_signal_tmp.cxx &&  \
    mv OSD_signal_tmp.cxx OCCT-7_7_0/src/OSD/OSD_signal.cxx && \
    awk 'NR == 32 { $0 = "//" $0 };  \
         NR == 33 { $0 = "//" $0 };  \
         NR == 319 { $0 = "//" $0 };  \
         NR == 320 { $0 = "//" $0 };  \
         NR == 321 { $0 = "//" $0 };  \
         NR == 323 { $0 = "//" $0 };  \
         NR == 325 { $0 = "//" $0 };  \
         NR == 332 { $0 = "  char** aStrings;" }; \
         1' OCCT-7_7_0/src/Standard/Standard_StackTrace.cxx >Standard_StackTrace_tmp.cxx &&  \
    mv Standard_StackTrace_tmp.cxx OCCT-7_7_0/src/Standard/Standard_StackTrace.cxx && \
    mkdir OCCT-7_7_0/build && \
    cd OCCT-7_7_0/build && \
    cmake .. \
    -D CMAKE_BUILD_TYPE=release \
    -D CMAKE_INSTALL_PREFIX=/usr && \
    make -j4 && \
    make install
