NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [ "$USER" = root ]; then
        PS1="$RED\h [$NORMAL\w$RED]# $NORMAL"
else
        PS1="$GREEN\h [$NORMAL\w$GREEN]\$ $NORMAL"
fi

alias t='terraform'
alias ll='ls -la'
alias la='ls -ltr'

eval $(ssh-agent -s) > /dev/null 2>&1
ssh-add /root/.ssh/id_rsa > /dev/null 2>&1
