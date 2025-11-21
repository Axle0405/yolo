FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git build-essential wget ca-certificates pkg-config \
        libopencv-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone https://github.com/pjreddie/darknet.git

WORKDIR /opt/darknet

RUN sed -i 's/GPU=1/GPU=0/' Makefile && \
    sed -i 's/CUDNN=1/CUDNN=0/' Makefile && \
    sed -i 's/OPENCV=0/OPENCV=1/' Makefile && \
    make

#    (PDF에 나온 wget yolov3.weights 명령을 컨테이너 빌드 과정으로 이동)
RUN wget https://pjreddie.com/media/files/yolov3.weights -O yolov3.weights

COPY run_yolo.sh /usr/local/bin/run_yolo.sh
RUN chmod +x /usr/local/bin/run_yolo.sh

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/run_yolo.sh"]
