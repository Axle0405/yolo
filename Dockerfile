FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y git build-essential wget ca-certificates pkg-config && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN git clone https://github.com/pjreddie/darknet.git

WORKDIR /opt/darknet

# Makefile 직접 수정 (GPU/CUDNN 비활성, OPENCV 활성)
RUN sed -i 's/^GPU=.*/GPU=0/' Makefile && \
    sed -i 's/^CUDNN=.*/CUDNN=0/' Makefile && \
    sed -i 's/^OPENCV=.*/OPENCV=0/' Makefile && \
    make

RUN make

RUN wget https://pjreddie.com/media/files/yolov3.weights -O yolov3.weights

COPY run_yolo.sh /usr/local/bin/run_yolo.sh
RUN chmod +x /usr/local/bin/run_yolo.sh

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/run_yolo.sh"]
