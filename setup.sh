#!/bin/bash

# These commands are used to install keybase so that this file exists.
if false; then
	sudo apt-get update
	sudo apt-get install -y dbus-x11
	wget https://prerelease.keybase.io/keybase_amd64.deb
	sudo dpkg -i keybase_amd64.deb
	sudo apt-get install -f
	rm keybase_amd64.deb
	run_keybase
fi

set -e

# This is for consistency with Windows `K:` drive on Git Bash.
sudo ln -s /keybase /k || true
sudo ln -s /keybase/private/sofe /kbp || true

# The real location of this repo at /kbp/sys.
echo >> ~/.bashrc
echo "source /kbp/sys/login.bash" >> ~/.bashrc

echo >> ~/.bash_completions
echo "source /kbp/sys/bash_completions" >> ~/.bash_completions

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
	sudo apt-get install -y vim git curl
	mkdir -p ~/.vim/bundle
	git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
	echo "so /kbp/sys/vimrc" >> ~/.vimrc
	vim +PluginInstall +qall
fi

# Don't ask me why I install all these... I don't remember.
# I just happened to have needed them at some point.
sudo apt-get install -y \
	acpi \
	apt-file \
	apt-transport-https \
	apt-utils \
	autoconf \
	bc \
	biber \
	bison \
	build-essential \
	ca-certificates \
	cabal-install $(: I do not know haskell. I only used it with pandoc once upon a time.) \
	clang \
	cmake \
	colordiff \
	default-jdk \
	dot2tex \
	doxygen \
	duplicity \
	fuse-zip $(: I used this to mount matlab because the useless docs are too space-consuming) \
	git-extras \
	gnupg \
	gnupg-agent \
	graphviz \
	gzip \
	htop \
	iotop \
	jq \
	libcanberra-dev \
	libdbus-glib-1-dev-bin \
	libfuse-dev \
	libluajit-5.1-2 \
	libluajit-5.1-common \
	libmysqlclient-dev \
	libpq-dev \
	libproxy-dev \
	libsqlite3-dev \
	libssl-dev \
	libtool-bin \
	libudev-dev \
	libxcb-shape0-dev $(: this is required to use the clipboard rust crate on ubuntu server installation) \
	libxcb-xfixes0-dev \
	libxml2-dev \
	linux-tools-common \
	linux-tools-generic \
	lm-sensors \
	mesa-utils \
	meson \
	net-tools \
	nettle-dev $(: needed for some crypto crates) \
	python3-ply \
	python3-pycparser \
	ntp \
	ocaml-interp $(: I forgot why I installed this, but no, I do not know ocaml) \
	openssh-server \
	p7zip-full \
	pandoc \
	pkg-config \
	pm-utils \
	python2.7 $(: I still install this because I might need it sometimes, but python is aliased to in most individual bashrcs I use) \
	python3.8 \
	python3-dev \
	r-base-core \
	re2c \
	ruby-full \
	socat \
	software-properties-common \
	sox $(: used for the play command) \
	sshfs \
	texlive-full $(: here comes the biggest package) \
	tree \
	wget \
	xdotool \
	xorg-dev \


# I use docker to deploy literally everything.
curl -sSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

sudo service docker start
sudo adduser `whoami` docker

curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
source ~/.nvm/nvm.sh
nvm install --lts
nvm use --lts

curl -sS https://sh.rustup.rs | bash
source ~/.cargo/env
rustup install nightly
rustup component add rustfmt --toolchain nightly
rustup component add rls --toolchain nightly
cargo install \
	cargo-edit \
	cargo-expand \
	cargo-generate \
	cargo-fix \
	just \
	mdbook \
	racer \
	sfz \
	wasm-pack \

# Unfortunately, I never ended up finishing anything that uses SQL in Rust.
# I guess NoSQL exists for a good reason.
# But I insist that RDBMS is good despite SQL is a nightmare.
# Why do people always equate RDBMS with SQL?
cargo install diesel_cli --no-default-features --features postgres

# I've wanted to learn elixir since several years ago,
# and I made sure it's installed on every system I use,
# but to date I still don't know elixir well enough.
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install -y esl-erlang elixir
rm erlang-solutions_1.0_all.deb

# Guess what haymow means :D
git clone keybase://team/sofe_secret_conn/haymow
pushd haymow
cargo build --release
ln -s `pwd`/target/release/haymow ~/.local/bin/haymow
popd

# pytimeparse is used in another command not in this repo.
# Most of the p[ython packages I use are installed from other methods like requirements.txt.
sudo pip install \
	pytimeparse

echo "Done! Manual setup: edit /usr/share/vim/vim80/syntax/tex.vim, add the following:"
echo "    call TexNewMathZone(\"E\", \"align\", 1)"
