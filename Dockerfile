# Ubuntu-based development environment.
# Override the base at build time, e.g. --build-arg BASE_IMAGE=ros:jazzy-ros-base
ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=Etc/UTC

# Common tools for a usable Linux shell environment
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash-completion \
        build-essential \
        ca-certificates \
        curl \
        git \
        htop \
        iputils-ping \
        less \
        locales \
        nano \
        python3 \
        python3-pip \
        python3-venv \
        sudo \
        tzdata \
        unzip \
        vim \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user with passwordless sudo.
# Ubuntu 24.04 images ship a default "ubuntu" user at UID 1000; remove it so our UID is free.
RUN if id -u ubuntu >/dev/null 2>&1; then userdel -r ubuntu; fi \
    && groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}/workspace

CMD ["/bin/bash"]
