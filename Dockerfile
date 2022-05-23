FROM kalilinux/kali-last-release

WORKDIR /root
COPY install.sh .
RUN ./install.sh
RUN rm install.sh