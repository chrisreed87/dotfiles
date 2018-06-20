# Path to your oh-my-zsh installation.
export ZSH=/Users/chris/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(aws docker git brew vagrant)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export PATH="/usr/local/sbin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

function vs {
    if [[ $# = 0 ]]
    then
        open -a "Visual Studio Code"
    else
        local argPath="$1"
        [[ $1 = /* ]] && argPath="$1" || argPath="$PWD/${1#./}"
        open -a "Visual Studio Code" "$argPath"
    fi
}

 con() {
     prod='lax1 sjc1 dal1 ord1 lga1 iad1 mia1 lon1 fra1 ams1'
     staging='phx1 ams2'
     lab='phx2 ams3'
     site=`echo $1 | sed 's/-.*//'`
     if [[ " $prod " =~ .*\ $site\ .* ]]; then
         env='dlvr1.net'
     elif [[ " $staging " =~ .*\ $site\ .* ]]; then
         env='dlvr0.net'
     elif [[ " $lab " =~ .*\ $site\ .* ]]; then
         env='dlvrtest.com'
     fi
     ssh $1.$site.$env
 }

function vpn-connect {
/usr/bin/env osascript <<-EOF
tell application "System Events"
        tell current location of network preferences
                set VPN to service "DLVR VPN"
                if exists VPN then connect VPN
                repeat while (current configuration of VPN is not connected)
                    delay 1
                end repeat
        end tell
end tell
EOF
route get 172.102.232.0/21 | grep -q ppp0 || sudo route add -net 172.102.232.0/21 -interface ppp0
route get 185.161.106.0/24 | grep -q ppp0 || sudo route add -net 185.161.106.0/24 -interface ppp0
route get 10.1.0.0 | grep -q ppp0 || sudo route add -net 10.1.0.0 -interface ppp0
route get 10.10.0.0 | grep -q ppp0 || sudo route add -net 10.10.0.0 -interface ppp0
route get 10.10.10.0 | grep -q ppp0 || sudo route add -net 10.10.10.0 -interface ppp0
route get 10.0.0.0 | grep -q ppp0 || sudo route add -net 10.0.0.0 -interface ppp0
route get 54.0.0.0/8 | grep -q ppp0 || sudo route add -net 54.0.0.0/8 -interface ppp0
ssh-add
}

function cleanup-vpn {
sudo route delete -net 172.102.232.0/21 -interface ppp0
sudo route delete -net 185.161.106.0/24 -interface ppp0
sudo route delete -net 10.1.0.0 -interface ppp0
sudo route delete -net 10.10.0.0 -interface ppp0
sudo route delete -net 10.10.10.0 -interface ppp0
sudo route delete -net 10.0.0.0 -interface ppp0
sudo route delete -net 54.0.0.0/8 -interface ppp0
}

function docker-stop-all {
    docker stop $(docker ps -q)
}
function docker-rm-all {
    docker rm $(docker ps -a -q)
}
function docker-rmi-all {
    docker rmi $(docker images -q -f dangling=true)
}
