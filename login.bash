set -o vi
shopt -s globstar

# Very complex and unmaintainable PS1. I should have used a separate script to generate it indeed.
SIMPLE_PS1='\[\033]0;$TITLEPREFIX:${PWD//[^[:ascii:]]/?}\007\]\n\[\033[0m\]\[\033[31m\]$(echo $__M2_SYS_COMMAND_LAST_DURATION )ms | \[\033[0m\]\[\033[34m\]\[\033[32m\]\[\033[35m\]\[\033[91m\]\H @ \[\033[32m\]\w\[\033[36m\]$(__git_ps1)\[\033[0m\]\n$ '
NO_BEEP_PS1='\[\033]0;$TITLEPREFIX:${PWD//[^[:ascii:]]/?}\007\]\n\[\033[0m\]\[\033[31m\]$(echo $__M2_SYS_COMMAND_LAST_DURATION )ms | \[\033[0m\]\[\033[34m\]\[\033[32m\]\[\033[35m\]$(LAST_EXIT_CODE=$? && test $LAST_EXIT_CODE -gt 0 && echo \[\033[33m\]"Exit code: $LAST_EXIT_CODE | ")\[\033[91m\]\H @ \[\033[32m\]\w\[\033[36m\]$(__git_ps1)\[\033[0m\]\n$ '
BEEP_PS1='\[\033]0;$TITLEPREFIX:${PWD//[^[:ascii:]]/?}\007\]\n\[\033[0m\]\[\033[31m\]$(echo $__M2_SYS_COMMAND_LAST_DURATION )ms | \[\033[0m\]\[\033[34m\]\[\033[32m\]\[\033[35m\]$(LAST_EXIT_CODE=$? && test $LAST_EXIT_CODE -gt 0 && echo \[\033[33m\]"Exit code: $LAST_EXIT_CODE | " && $(play -q -n synth 0.3 sin 60000 vol 0.06 2>/dev/null) || $(play -q -n synth 0.08 triangle 5000 vol 0.015 2>/dev/null))\[\033[91m\]\H @ \[\033[32m\]\w\[\033[36m\] ($(cat /sys/class/power_supply/BAT*/capacity)%)$(__git_ps1)\[\033[0m\]\n$ '

# In fact I don't use shell on Windows anymore.
if [[ $OS == "Windows_NT" ]]; then
	PS1="$SIMPLE_PS1"
else
	PS1="$BEEP_PS1"
fi
alias unbeep='PS1="$NO_BEEP_PS1"'

export TS_NODE_CACHE_DIRECTORY=${HOME}/.ts-node-cache
# I don't even remember all these paths I set for myself.
export PATH="$PATH":~/path:/k/team/sofe_secret_conn/path:/k/private/sofe/path:~/.local/bin:~/.cargo/bin:~/.cabal/bin:~/.config/composer/vendor/bin:~/.local/go/bin
# export DOCKER_HOST=tcp://127.0.0.1:2376
# some programs have unreadable colors when I use xterm-256color.
export TERM=xterm
export GPG_TTY=$(tty)
export VISUAL=vim
export EDITOR=vim
# export RUSTFLAGS='-Clink-args=-fuse-ld=gold'
# export RUST_BACKTRACE=full

# I have autosave in my vimrc,
# and swapfiles tend to cause issues on mounted filesystems like kbfs and dropbox.
alias vi='vim -n'
# I use symlinks everywhere, and I don't like the inconsistency.
alias cd='cd -P'
alias mv='mv -i'
alias cp='cp -i'
# I only know PCRE.
alias grep='env grep --color=auto -P'
alias grepf='env grep --color=auto -F'
alias ls='ls -F --color=auto --show-control-chars -A'
# Once upon a time I used a server that had the `tailf` alias,
# and I got to this habit for some reason.
alias tailf='tail -f'
# I previously called this `ffpull`,
# but it doesn't autocomplete because of `ffmpeg`.
# Yet I use it far too often.
alias ffp='git pull --ff-only'
# Usually I just use vim instead.
alias ccat='pygmentize'
# Later on I found out that `git-extras` had a command called `git-root`.
alias gitroot='git rev-parse --show-toplevel'
alias local-ignore='vim -n $(git rev-parse --show-toplevel)/.git/info/exclude'
# Guess what this means.
alias haymow='RUST_BACKTRACE=0 haymow'
alias pmcps='pmphp $(which composer)'

# Usage freuqency is too high in M2.
alias blue='bluetoothctl'
alias ta='tmux a -t'

alias shrced='vim /kbp/sys/login.bash && source /kbp/sys/login.bash'
# tbh I haven't used hkuvpn for ages.
alias hkuvpn='/opt/cisco/anyconnect/bin/vpn connect vpn2fa.hku.hk'

# These days I just use `m2cd`.
alias roscd='cd ~/m2/ros/src/ && cd'
# Failured attempt of enforcing code style in M2.
alias m2lint='python3 -m pylint --rcfile=~/m2/ros/pylintrc src'

# Git Bash has issues using some programs without `winpty` command.
if [[ $OS == "Windows_NT" ]]; then
	WINPTY="winpty "
	alias open=start
else
	WINPTY=""
	alias clip='xclip -selection clipboard'
	alias fork='gnome-terminal --tab --'
	alias forkn='gnome-terminal --'
	alias open=unix-only-open
	alias start=unix-only-start
fi

function unix-only-open {
	xdg-open "$1" 2>/dev/null >/dev/null
}

function unix-only-start {
	xdg-open "$1" 2>/dev/null >/dev/null
}

# Workaround for a GNOME bug that started in late 2020.
alias fs='gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false && gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true; gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true && gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false'

# I don't want to have a copy of each dep in every package and waste my disk spae.
# This also makes things easier to clean up.
alias cargo="$WINPTY cargo"
alias carf="cargo fmt --all -- --check || cargo fmt --all"
alias carfdm="rustfmt --edition 2018 **/*.rs"
alias carc="$WINPTY cargo check --target-dir=$HOME/rust-target"
alias carl="$WINPTY cargo clippy --target-dir=$HOME/rust-target"
alias carlr='eval RUSTFLAGS="-Z macro-backtrace" carl --release'
alias carb="$WINPTY cargo build --target-dir=$HOME/rust-target"
alias carr="$WINPTY cargo run --target-dir=$HOME/rust-target"
alias cart="$WINPTY cargo test --target-dir=$HOME/rust-target"
alias card="$WINPTY cargo doc --target-dir=$HOME/rust-target"
alias carx="$WINPTY cargo expand --target-dir=$HOME/rust-target"
alias carfx="$WINPTY cargo fix --target-dir=$HOME/rust-target --allow-staged"
alias caru="$WINPTY cargo udeps --target-dir=$HOME/rust-target"
alias cari="$WINPTY cargo install --target-dir=$HOME/rust-target"
alias carmb="RUSTFLAGS=\"-Z macro-backtrace\" $WINPTY cargo +nightly check"
# I was crazy when I wrote this; I don't use this anymore.
function carmat {
	carf "$@"
	carc "$@"
	carb "$@"
	cart "$@"
	card "$@"
}
alias less-expand='cargo expand --color always | less -r'

# I have some OCD of making sure my clipboard is empty.
alias noc='true | xclip ; true | xclip -selection clipboard'
alias cls='clear && clear'

# Again, usage frequency is too high for me.
alias dcp='docker-compose'
alias dud='docker-compose up -d --build'

# Apparently I forgot what I made and reinvented my own wheels.
if [[ -f ~/.local_path ]]; then
	while read -r LINE; do
		export PATH="$PATH:$LINE"
	done < ~/.local_path
fi

# Yet another wheel reinvention.
function git-clone {
	repo=$1
	if [[ $2 ]]; then
		repo=$1/$2
	fi
	git clone git@github.com:$repo
}

# Moar wheel reinvention
function mod-commit {
	if [[ ! $1 ]]; then
		echo Usage: mo-commit \"commit message\"
		return
	fi
	git submodule foreach --recursive git add .
	git submodule foreach --recursive git commit -m "$1"
	git submodule foreach --recursive git push
	git add .
	git commit -m "$1"
	git push
}

# wtf is this?
function commit {
	if [[ ! "$2" ]] || [[ ! -d $1/.git ]]; then
		echo Usage: commit \<directory\> \<commit message\>
		return
	fi
	cd $1
	git commit -am "$2"
	git push
}

# This util is very useful in simple functions like `tex-watch`.
# I never manage to remember what ${x%.*} and ${x##*.} mean.
function get-name {
	filename="$(basename -- "$1")"
	simplename="${filename%.*}"
	echo $simplename
}
function get-ext {
	filename="$(basename -- "$1")"
	extension="${filename##*.}"
	echo $extension
}

# A variant of tex-watch that triggers bibtex.
function bib-watch {
	tex=$1

	if [[ -z $tex ]]; then
		echo "Usage: $0 Xxx.tex; view with SumatraPDF"
		return 1
	fi

	base_name="`basename -s .tex $tex`"

	if [[ $tex == $base_name ]]; then
		echo "Does not end with .tex"
		return 1
	fi

	while true; do
		this_mod=`stat -c%y "$tex"`
		if [[ $this_mod != $last_mod ]]; then
			echo Refreshing
			true | ( \
				(xelatex -halt-on-error -shell-escape "$base_name" ; \
				bibtex "$base_name" ; \
				xelatex -halt-on-error -shell-escape "$base_name" ; \
				xelatex -halt-on-error -shell-escape "$base_name") \
			) || (echo "Failed to compile" && beep 0.05)
			rm \
				"$base_name".aux \
				"$base_name".bbl \
				"$base_name".blg \
				"$base_name".dvi \
				"$base_name".glo \
				"$base_name".idx \
				"$base_name".ist \
				"$base_name".lo? \
				"$base_name".out \
				"$base_name".out.ps \
				"$base_name".te?~ \
				"$base_name".toc \
				texput.log 2>/dev/null
			last_mod="$this_mod"
		else
			echo "$(realpath "$tex") is unchanged"
			sleep 1
		fi
	done
}

# Recompile in a loop.
# This is better than `make` because `make` uses mtime,
# which could cause race conditions if source file is modified before pdflatex finishes writing.
function tex-watch {
	tex=$1

	if [[ -z $tex ]]; then
		echo "Usage: $0 Xxx.tex; view with SumatraPDF"
		return 1
	fi

	base_name="`basename -s .tex $tex`"

	if [[ $tex == $base_name ]]; then
		echo "Does not end with .tex"
		return 1
	fi

	while true; do
		this_mod=`stat -c%y "$tex"`
		if [[ $this_mod != $last_mod ]]; then
			echo Refreshing
			true | ( \
				(latex -halt-on-error -shell-escape "$base_name" ; \
				pdflatex -halt-on-error -shell-escape "$base_name") \
			) || (echo "Failed to compile" && beep 0.05)
			rm \
				"$base_name".aux \
				"$base_name".bbl \
				"$base_name".blg \
				"$base_name".dvi \
				"$base_name".idx \
				"$base_name".lo? \
				"$base_name".out \
				"$base_name".out.ps \
				"$base_name".te?~ \
				"$base_name".toc \
				texput.log 2>/dev/null
			last_mod="$this_mod"
		else
			echo "$(realpath "$tex") is unchanged"
			sleep 1
		fi
	done
}

# I don't remember actually using this alias anywhere.
function beep {
	duration=$1
	if [[ -z $duration ]]; then
		echo 'Usage: beep $duration'
		return 1
	fi
	play -q -n synth $duration sin 466.16 2>/dev/null
}

function bibbg {
	gnome-terminal --tab -- bash -ic "bib-watch $1"
}

function pdfbg {
	gnome-terminal --tab -- bash -ic "tex-watch $1"
}

function makebg {
	gnome-terminal --tab -- bash -ic "makel $@"
}

function makepdf {
	tex=$1

	if [[ -z $tex ]]; then
		echo "Usage: $0 Xxx.tex; view with SumatraPDF"
		return 1
	fi

	base_name="`basename -s .tex $tex`"

	if [[ $tex == $base_name ]]; then
		echo "Does not end with .tex"
		return 1
	fi

	echo "${base_name}.pdf: ${base_name}.tex" >> Makefile
	echo -e "\ttrue | pdflatex -halt-on-error -shell-escape '$base_name'" >> Makefile
	echo -e "\ttrue | pdflatex -halt-on-error -shell-escape '$base_name'" >> Makefile
}

# See :Prtsc in vimrc
function prtsc {
	file=${1:-$(date +screenshot%Y%m%d%H%M%S.png)}
	xdotool windowminimize $(xdotool getactivewindow) >&2
	sleep 0.5
	gnome-screenshot -a -f $file >&2
	echo $file
}

# Git Bash bug.
[[ `pwd` == "/" ]] && cd ~

# Codeforces rust compilation command.
function cf {
	rustfmt "$1" && \
		rustc --edition=2018 -g -O -C link-args=/STACK:268435456 "$1"
}

function md2pdf {
	FILE="$1"
	NAME="$(get-name "$FILE")"
	EXT="$(get-ext "$FILE")"
	if [[ $EXT != md ]]; then
		echo "Argument should be *.md"
		exit 2
	fi

	pandoc "$FILE" -o "${NAME}.pdf"
}

# Reinvent the wheel for the dozenth time.
function mkcd {
	mkdir -p "$1" && cd "$1"
}

# I no longer use this function after I have added `loop`.
function makel {
	while true; do make "$@"; sleep 1; done
}

# I found this really handy, especially for recompiling stuff.
function loop {
	if [[ $# -eq 0 ]]; then
		echo "Usage: loop [interval] <command> [args ...]"
		return 1
	fi
	REGEX='^[0-9]+([.][0-9]+)?$'
	if [[ $1 =~ $REGEX ]] ; then
		SKIP_FIRST=true
		SLEEP_DURATION=$1
	else
		SKIP_FIRST=false
		SLEEP_DURATION=1
	fi
	while true; do
		if $SKIP_FIRST; then
			eval "${@:2}"
		else
			eval "$@"
		fi
		sleep $SLEEP_DURATION
	done
}

# This is copied from m2_sys, used for tracking command execution time.
trap '{
	test "$__M2_SYS_COMMAND_START_TIME" == reset &&
	__M2_SYS_COMMAND_START_TIME=$((
		$(date +%s%N) / 1000000
	))
}' DEBUG
PROMPT_COMMAND='{
	__M2_SYS_COMMAND_LAST_DURATION=$((
		$((
			$(date +%s%N) / 1000000
		)) - __M2_SYS_COMMAND_START_TIME
	)) ;
	__M2_SYS_COMMAND_START_TIME=reset
}'

echo shrc complete >&2
