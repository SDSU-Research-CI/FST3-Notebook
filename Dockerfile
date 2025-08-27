ARG BASE_IMAGE=quay.io/jupyter/minimal-notebook:2025-07-07
FROM ${BASE_IMAGE}

USER root
RUN sudo apt-get update -y && sudo apt-get install build-essential -y
RUN conda install -y -c conda-forge nb_conda_kernels -n base
# RUN apt-get install gcc
# Make sure to run as notebook user for conda installs

WORKDIR /home/${NB_USER}

# Install fst3 environment
COPY fst3.yaml ./fst3.yaml
RUN conda env create -y -f fst3.yaml

# Fix any permissions issues caused by installing software via root
RUN fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

USER $NB_USER
RUN rm fst3.yaml \
 && source activate fst3