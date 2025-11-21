FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 기본 패키지 설치
RUN apt-get update && \
    apt-get install -y git build-essential wget ca-certificates pkg-config \
                       libopencv-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Darknet 원본 다운로드
RUN git clone https://github.com/pjreddie/darknet.git

WORKDIR /opt/darknet

# Makefile 직접 수정 (GPU/CUDNN 비활성, OPENCV 활성)
RUN sed -i 's/^GPU=.*/GPU=0/' Makefile && \
    sed -i 's/^CUDNN=.*/CUDNN=0/' Makefile && \
    sed -i 's/^OPENCV=.*/OPENCV=1/' Makefile

# 빌드 실행
RUN make

# YOLOv3 weights 다운로드
RUN wget https://pjreddie.com/media/files/yolov3.weights -O yolov3.weights

# 실행 스크립트 복사
COPY run_yolo.sh /usr/local/bin/run_yolo.sh
RUN chmod +x /usr/local/bin/run_yolo.sh

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/run_yolo.sh"]
