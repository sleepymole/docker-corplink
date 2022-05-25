# docker-corplink
docker-corplink builds a docker image to run corplink in a container, which is based on [kasmtech/workspaces-images](https://github.com/kasmtech/workspaces-images).

## Usage

1. Run the container as a daemon.

```bash
docker run -d \
  --name=corplink \
  --device=/dev/net/tun \
  --cap-add=NET_ADMIN \
  --shm-size=512m \
  -p 6901:6901 \
  -p 8888:8118 \
  -e VNC_PW=password \
  gozssky/corplink:latest
```

2. Configure corplink via a browser: https://localhost:6901.

* User : kasm_user
* Password: password

3. Access corplink network via http proxy: http://localhost:8888.

## Acknowledgments

* Thanks [kasmtech](https://github.com/kasmtech) for providing some great open source tools.
