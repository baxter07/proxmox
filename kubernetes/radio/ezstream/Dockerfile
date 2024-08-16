FROM ubuntu:noble

RUN apt update && apt install -y ezstream ffmpeg madplay

VOLUME ["/ezstream", "/music"]

ENTRYPOINT ["/usr/bin/ezstream", "-c", "/ezstream/ezstream.xml"]
