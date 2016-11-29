FROM maven
MAINTAINER <oliv>

RUN mkdir /home/app

COPY click-count /home/app

# Define working directory.
WORKDIR /home/app
