# docker-opencascade
Unofficial Docker images with OpenCascade on Alpine/Ubuntu Linux. 

Alpine version: 3.18.3 / Ubuntu version: 20.04

OpenCascade version: 7.7.0

See [Docker Hub](https://hub.docker.com/repository/docker/johannesvhs/opencascade) for all available images.

## Modifications on Alpine
To be able to build Opencascade on Alpine, some lines in the Opencascade source code had to be
modified. 

Based on [this stackoverflow issue](https://stackoverflow.com/questions/58554433/opencascade-compilation-failure-on-alpine-linux-with-musl-libc-mallinfo-has-in): 
- Commented out `mallinfo` function calls (not available in glibc on musl/alpine)
- Commented out `feenableexcept`, `fedisableexcept` and `fegetexcept` function calls (not available in glibc on musl/alpine)
- Commented out `backtrace` and `backtrace_symbols` function calls (libexecinfo not available anymore on alpine>3.17)

Based on [this bug tracker](https://tracker.dev.opencascade.org/view.php?id=33250):
 - Add a missing `#include <limits>`


## Visual rendering
If you need visual rendering, add Qt5: 
```dockerfile
# On Alpine: 
RUN apk update && apk add qt5-qtbase-x11

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
