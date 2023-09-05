FROM kalilinux/kali-rolling

WORKDIR /root
COPY install.sh nessus_activation_code.txt ./
RUN ./install.sh
RUN rm install.sh nessus_activation_code.txt
