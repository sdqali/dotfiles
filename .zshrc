export ALTERNATE_EDITOR=""
export SVN_EDITOR="emacs -nw"
export EDITOR="emacs -nw"
export PATH=$PATH:/sbin/:~/bin/eclipse/
export JAVA_HOME=/usr/lib/jvm/java-6-sun
export JDK_HOME=/usr/lib/jvm/java-6-sun

# number of lines kept in history
export HISTSIZE=10000
# number of lines saved in the history after logout
export SAVEHIST=10000
# location of history
export HISTFILE=~/.zhistory
# history options
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_allow_clobber
setopt hist_reduce_blanks
setopt share_history

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
#setopt auto_list list_ambiguous

setopt list_types

# directory options
setopt auto_cd
setopt auto_pushd

#processes
setopt auto_continue

# console colors
autoload -U colors && colors

export CLICOLOR=1
export LS_COLORS="di=1;36:ln=4;37:so=1;32:pi=0;33:ex=0;37:bd=0;34:cd=0;34:su=0;37:sg=0;31:tw=0;37:ow=0;37:"



# completion
autoload -U compinit && compinit
# colorize completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
# ignore what's already selected on line
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
# hosts completion for some commands
#local knownhosts
#knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} ) 
#zstyle ':completion:*:(ssh|scp|sftp):*' hosts $knownhosts
compctl -k hosts ftp lftp ncftp ssh w3m lynx links elinks nc telnet rlogin host
compctl -k hosts -P '@' finger

# manpage comletion
man_glob () {
  local a
  read -cA a
  if [[ $a[2] = -s ]] then
  reply=( ${^manpath}/man$a[3]/$1*$2(N:t:r) )
  else
  reply=( ${^manpath}/man*/$1*$2(N:t:r) )
  fi
}

compctl -K man_glob -x 'C[-1,-P]' -m - 'R[-*l*,;]' -g '*.(man|[0-9nlpo](|[a-z]))' + -g '*(-/)' -- man
# fuzzy matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
# completion cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
# remove trailing slash in directory names, useful for ln
zstyle ':completion:*' squeeze-slashes true

# # named directories
# for i in $HOME/work/*; do
# 	project=`basename $i`;
# 	hash -d $project="$i"
# done


# global aliases
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias as="sudo aptitude search"
alias ai="sudo aptitude install"
alias au="sudo aptitude safe-upgrade"
alias cl="clear"
alias pull="git pull origin master"
alias push="git push origin master"
alias rebase="git rebase master"
alias master="git checkout master"
alias merge="git merge"
alias get="git checkout"
alias st="git status --ignore-submodule=dirty"
alias commit="git commit -a -m"
alias clip="xclip -selection clipboard"
alias e="emacsclient ."
alias o="xdg-open"


# ensures that deleting word on /path/to/file deletes only 'file', this removes the '/' from $WORDCHARS
export WORDCHARS="${WORDCHARS:s#/#}"
export WORDCHARS="${WORDCHARS:s#.#}"
export CUCUMBER_COLORS=pending_param=magenta:failed_param=magenta:passed_param=magenta:skipped_param=magenta
export RSPEC=true
parse_git_branch() {
 	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function reals () {
  ls -la "$(print `which $1`)"
}

function title () {
  unset PROMPT_COMMAND
  echo -ne "\e]0;$1\a"
}

function precmd {
	title `pwd`
PS1="$(print '%{\e[0;37m%}%n%{\e[0m%}')@%M %B %{$fg[cyan]%}%~%{$fg[green]%}$(parse_git_branch) %{$reset_color%}>"	
}

function capture {
		sudo tcpdump -A -s 0 -i lo0 "(src and dst localhost) and ( tcp port `echo $1` ) and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)"
}
# Usage:
# title 'my title'

typeset -U fpath
autoload -U _git
[[ -s "/home/sdqali/.rvm/scripts/rvm" ]] && source "/home/sdqali/.rvm/scripts/rvm"  # This loads RVM into a shell session.
