# docker-corplink
docker-corplink builds a docker image to run corplink in a container, which is based on [kasmtech/workspaces-images](https://github.com/kasmtech/workspaces-images).

## Usage

1. Run the container as a daemon.

```bash
docker run -d \
  --name=corplink \
  --hostname=ubuntu \
  --device=/dev/net/tun \
  --cap-add=NET_ADMIN \
  --shm-size=512m \
  -p 6901:6901 \
  -p 8888:8118 \
  -p 1088:1080 \
  -e VNC_PW=password \
  sleepymole/corplink:latest
```

2. Configure corplink via a browser: https://localhost:6901.

* User : kasm_user
* Password: password

3. Access corplink network via http proxy: localhost:8888 or socks5 proxy: localhost:1088. You can also route traffic to the container. The container will do SNAT for all traffic sent to it.

## Acknowledgments

* Thanks [kasmtech](https://github.com/kasmtech) for providing some great open source tools.
