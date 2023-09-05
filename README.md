# Kali Linux with Nessus Docker image creator

Welcome to the Kali Linux with Nessus Docker image creator.

This repository allows you to create a Docker image with a lot of Kali Linux tools and Nessus preinstalled and activated.  This image (based on [kali-rolling](https://hub.docker.com/r/kalilinux/kali-rolling)) will contain tools mostly suitable for network pentests. Other Kali packages can be included by editing the script variables at the beginning of the [install.sh](https://github.com/valenbg1/kali-nessus-docker-image/blob/master/install.sh) file. The Docker containers created from this image will not need any further public Internet access.

The instructions are:
1. Clone this repository.
2. Revise and edit the script variables at the beginning of the [install.sh](https://github.com/valenbg1/kali-nessus-docker-image/blob/master/install.sh) file accordingly.
3. Write the Nessus activation code in [nessus_activation_code.txt](https://github.com/valenbg1/kali-nessus-docker-image/blob/master/nessus_activation_code.txt) file.
4. Build the Docker image with `docker build -t "kali-nessus-docker-image:v1.0" .` inside the repository folder. This will take a long time since a lot of Kali Linux packages need to be downloaded and installed.

## Docker image exportation

The built image can be exported to a TAR file with `docker save -o "kali-nessus-docker-image-v1.0.tar" "kali-nessus-docker-image:v1.0"`. The image size is ~16GB and ~3.5GB compressed.

The exported image can later be imported with `docker load -i "kali-nessus-docker-image-v1.0.tar"`.

## Docker container creation

A Docker container from the built image can be created with `docker run --name "kali" -p "8834:8834" -it "kali-nessus-docker-image:v1.0" "/bin/bash"`.

Nessus can be launch in the background inside the container with `/opt/nessus/sbin/nessus-service -q -D`. The first time Nessus is started it will compile the plugins, which will take a long time.

The container size is ~3.5GB (with Nessus plugins compiled).

If the Docker container is stopped it can be run again with: `docker container start -ai "kali"`.
