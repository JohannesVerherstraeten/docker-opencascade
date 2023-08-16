# alpine-opencascade
Unofficial Docker images with OpenCascade on Alpine/Ubuntu Linux. 

Alpine version: 3.18.3

OpenCascade version: 7.6.2

## Changes
To be able to build Opencascade on Alpine, some lines in the Opencascade source code had to be
commented out. See [this stackoverflow issue](https://stackoverflow.com/questions/58554433/opencascade-compilation-failure-on-alpine-linux-with-musl-libc-mallinfo-has-in). 
- Commented out `mallinfo` function calls (not available in glibc on musl/alpine)
- Commented out `feenableexcept`, `fedisableexcept` and `fegetexcept` function calls (not available in glibc on musl/alpine)
- Commented out `backtrace` and `backtrace_symbols` function calls (libexecinfo not available anymore on alpine>3.17)

## Visual rendering
If you need visual rendering, add Qt5: 
```dockerfile
# On Alpine: 
RUN apk update && apk add qt5-qtbase-x11v

# On Ubuntu: 
RUN apt-get update && apt-get install libqt5gui5
```

If you need visual rendering but your docker container has no display (ex: on server), you can additionally install 
`xvfb` for a virtual display and use it as follows: 
```dockerfile
CMD xvfb-run <your command that needs a (virtual) display>
```

## License
This container image contains `opencascade` which is under the GNU Lesser General
Public License (LGPL) version 2.1 with additional exception. See the licensing
information on [the website of Opencascade](https://www.opencascade.com/content/licensing).

Like other container images, this image contains some other software (ex: build dependencies) 
that may be under different licenses.
