# Reuse an inherited SSH agent, then a persistent local socket, otherwise start one.
ssh_agent_ok=0

if [[ -n "${SSH_AUTH_SOCK:-}" ]]; then
    ssh-add -l >/dev/null 2>&1
    (( $? != 2 )) && ssh_agent_ok=1
fi

if (( ssh_agent_ok == 0 )); then
    export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
    ssh-add -l >/dev/null 2>&1
    (( $? != 2 )) && ssh_agent_ok=1
fi

if (( ssh_agent_ok == 0 )); then
    rm -f "$SSH_AUTH_SOCK"
    eval "$(ssh-agent -s -a "$SSH_AUTH_SOCK")" >/dev/null
fi

ssh-stop() {
    ssh-add -D
    if [[ -n "${SSH_AGENT_PID:-}" ]]; then
        ssh-agent -k >/dev/null
    fi
    unset SSH_AUTH_SOCK SSH_AGENT_PID
    print 'SSH agent stopped.'
}
