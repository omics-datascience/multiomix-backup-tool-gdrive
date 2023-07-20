FROM debian:12.0-slim
ENV BACKUP_DIR /backup
COPY . /

RUN bash /bash-scripts/setup_image.sh