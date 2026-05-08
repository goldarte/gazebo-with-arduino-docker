FROM gazebo:libgazebo11

RUN apt-get update && apt-get install -y \ 
    build-essential \
    libsdl2-dev \
    curl

ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # add sudo support
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN groupadd input
RUN usermod -a -G input $USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# install arduino-cli
RUN mkdir -p ~/.local/bin && curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=~/.local/bin sh
ENV PATH="/home/$USERNAME/.local/bin:${PATH}"

RUN mkdir -p /home/${USERNAME}/Arduino
RUN mkdir -p /home/${USERNAME}/.config/arduino
RUN mkdir -p /home/${USERNAME}/.arduino15
