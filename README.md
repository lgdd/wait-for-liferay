# wait-for-liferay

`wait-for-liferay.sh` is a script that will wait on the availability of a Liferay instance based on its host and TCP port. It is designed to synchronize services like docker containers. It was inspired by [vishnubob/wait-for-it](https://github.com/vishnubob/wait-for-it) and [eficode/wait-for](https://github.com/eficode/wait-for).

## Usage

```
Usage:
  wait-for-liferay.sh host:port [-- command args]
  -q | --quiet                        Don't output any status messages
  -- COMMAND ARGS                     Execute command with args after the test finishes
```

## Example
With [Docker Compose](https://docs.docker.com/compose/startup-order/), you want to start a Liferay cluster and therefore the second node must start just after the first node is available:

- `Dockerfile`:
```
FROM liferay/portal:7.2.0-ga1

ADD --chown=liferay:liferay https://raw.githubusercontent.com/lgdd/wait-for-liferay/master/wait-for-liferay.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/wait-for-liferay.sh
```

- `docker-compose.yml`:
```
version: '3.3'
services:
  liferay-node-1:
    build: .
  liferay-node-2:
    build: .
    entrypoint: /usr/local/bin/wait-for-liferay.sh liferay-node-1:8080 -- /usr/local/bin/liferay_entrypoint.sh
```

- Docker Compose logs output:
```
liferay-node-2_1  | Liferay is unavailable on liferay-node-1:8080 - sleeping
liferay-node-1_1  | INFO [main] org.apache.catalina.startup.Catalina.load Server initialization in [x] milliseconds
...               |  ...
liferay-node-1_1  | INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [x] milliseconds
liferay-node-2_1  | Liferay is up on liferay-node-1:8080 - executing command
liferay-node-2_1  | [LIFERAY] To SSH into this container, run: "docker exec -it liferay-node-2.local /bin/bash".
...               |  ...
```

## License
[MIT](LICENSE)
