# pgmodeler-docker

Based on work by:
- https://github.com/apazga/docker-pgmodeler
- https://github.com/ksylvan/docker-pgmodeler

Build with:
```sh
git clone https://github.com/masavini/pgmodeler-docker
cd pgmodeler-docker
docker build -t pgmodeler:latest .
```

Then you can start it with:
```sh
docker run \
    -e HOME \
    -e DISPLAY \
    -u 1000:1000 `# replacethis with your UID and GID` \
    -v /etc/passwd:/etc/passwd:ro \
    -v /etc/group:/etc/group:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro
    -v /pgmodeler/config/dir:/home/$USER/.config/pgmodeler
    -v /pgmodeler/data/dir:/data
    masavini/pgmodeler:latest
```