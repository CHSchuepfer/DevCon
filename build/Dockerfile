FROM ubuntu:latest

# Set environment variables from the .env file
ARG USER_NAME=default_username
ARG USER_PASSWORD=default_password
ENV USER_NAME=$USER_NAME
ENV USER_PASSWORD=$USER_PASSWORD
ENV LocalSetup=en_EN.UTF-8
RUN apt update && apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa
# install the tooks i wish to use
RUN DEBIAN_FRONTEND=noninteractive TZ=Europe/Berlin apt install -y tzdata
RUN apt update && \
  apt install -y sudo \
  curl \
  git-core \
  gnupg \
  locales \
  nodejs \
  zsh \
  wget \
  nano \
  npm \
  bat \
  tmux \
  htop \ 
  python3.10-full \
  python3-pip \
  python3.10-venv \
  flake8 \
  golang-go \
  xclip \ 
  ripgrep \
  fonts-powerline \
  libaio1 \ 
  # set up locale
  && locale-gen $LocalSetup \
  # add a user (--disabled-password: the user won't be able to use the account until the password is set)
  && adduser --quiet --disabled-password --shell /bin/zsh --home /home/$USER_NAME --gecos "User" $USER_NAME \
  # update the password
  && echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd && usermod -aG sudo $USER_NAME \
  && apt upgrade -y \
  && apt autoremove -y 
# Add Docker’s official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# Add the Docker repository
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" && \
   apt-get update && \
    apt-get install -y docker-ce-cli
RUN groupadd docker
RUN usermod -aG sudo,docker $USER_NAME
# Add an entrypoint script
COPY entrypoint.sh /run/entrypoint.sh
RUN chmod +x /run/entrypoint.sh

USER $USER_NAME
#  Install Rust using rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
# Add Cargo's bin directory to PATH
ENV PATH="/home/$USER_NAME/.cargo/bin:${PATH}"
# terminal colors with xterm
RUN go install golang.org/x/tools/gopls@latest
ENV TERM xterm
# set the zsh theme
ENV ZSH_THEME agnoster
RUN cargo install lsd && \
cargo install bob-nvim && \
bob install latest && \
bob use latest
# run the installation script  
ENV PATH="${PATH}:/home/$USER_NAME/.local/share/bob/nvim-bin"
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN go install github.com/jesseduffield/lazygit@latest
RUN export PATH=$PATH:/home/$USER_NAME/.local/share/bob/nvim-bin:/home/$USER_NAME/go/bin
#  Set the entrypoint script
ENTRYPOINT ["/run/entrypoint.sh"] 

CMD ["zsh"]
