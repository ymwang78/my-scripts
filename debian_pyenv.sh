#!/bin/sh
sudo apt update
sudo apt install -y build-essential libssl-dev zlib1g-dev libncurses5-dev \
    libncursesw5-dev libreadline-dev libsqlite3-dev libgdbm-dev libdb5.3-dev \
    libbz2-dev libexpat1-dev liblzma-dev tk-dev libffi-dev libgmp-dev \
    libmpfr-dev uuid-dev libmpc-dev

wget https://www.python.org/ftp/python/3.12.3/Python-3.12.3.tgz
tar -xvf Python-3.12.3.tgz
cd Python-3.12.3
./configure --enable-optimizations
make -j $(nproc)
sudo make altinstall
sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.12 1
python3 -m venv /zdata/venv

#curl https://pyenv.run | bash
#echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
#echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
#echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
#source ~/.bashrc
