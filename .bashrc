case $TERM in
    xterm*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
#        PS1='bash[\!]\$ '
        PS1='\$ '
        ;;
    *)
        unset PROMPT_COMMAND
        PS1="[\u@\h \W]\\$ "
        ;;
esac

HISTIGNORE='&'

shopt -s no_empty_cmd_completion
