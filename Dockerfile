FROM continuumio/miniconda3

RUN apt-get update -y && apt-get install -y --no-install-recommends \
        build-essential

WORKDIR /opt/biophi

COPY environment.yml .
COPY Makefile .

# Create a new environment instead of updating base
RUN conda env create -n biophi -f environment.yml

COPY . .

# Install the package in the new environment
RUN conda run -n biophi pip install -e . --no-deps

RUN useradd docker \
  && mkdir /home/docker \
  && chown docker:docker /home/docker \
  && usermod -a -G staff docker
USER docker

# Use the new environment for the command
CMD [ "conda", "run", "-n", "biophi", "biophi", "web", "--host", "0.0.0.0" ]
