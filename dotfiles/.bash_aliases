alias ss='clear && neofetch'
alias sbc='source ~/.zshrc'
alias vbc='nvim ~/.zshrc'
alias sba='source ~/.bash_aliases'
alias vba='nvim ~/.bash_aliases'
alias vbase='nvim ~/.zsh_aliases'
alias als='cat ~/.bash_aliases | grep alias'
alias alconf='nvim ~/.config/alacritty/alacritty.yml'
alias tmconf='nvim ~/.tmux.conf'
alias olv='~/.scripts/lv.sh'
alias olvf='~/.scripts/lvf.sh'

alias ll='ls -al --block-size=K'
alias ldu='du -h --max-depth=1 | sort -h'

alias vnn='source ~/Workspace/.nn/bin/activate'
alias vse='source ~/Workspace/.se/bin/activate'
alias vdl='source ~/Workspace/.dl/bin/activate'
alias vfa='source ~/Workspace/.fapi/bin/activate'

# smart-eye specific
alias cwtc='cd $HOME/Workspace/gitlab/trackercore'
alias cbtc='cd $HOME/Workspace/builds/tc'
alias sedo='/home/yanuar/Workspace/gitlab/trackercore/sedo'
alias seshow='cat ~/.config/sedo/sedo.yml'
alias sekpi='/home/yanuar/Workspace/gitlab/trackercore/convert-analyze/utils/drowsiness/analyze_kpi_run.py'
alias sema='sudo mount -a'

# git
alias gg='git status'
alias ga='git add'
alias gl='git log --graph --oneline'
alias gl5='git log --graph --oneline -5'
alias gl10='git log --graph --oneline -10'
alias gls="git log --graph --all --topo-order --pretty='format:%h %ai %s%d (%an)'"
alias glc='git log --graph'
alias gc='git commit'
alias gco='git checkout'
alias gr='git remote'
alias gb='git branch'
alias gf='cat ~/Workspace/gitlab/onboarding/git_flow.txt'
alias gst='git stash'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gsa='git stash apply'
alias gdt='git difftool'

# tools
alias score='sensors | grep Core'

# python
alias pipl='pip list'
alias pipc='pip config list -v'

# smarteye
alias stc='cd /home/yanuar/Workspace/gitlab/trackercore'

# others
alias godot='/home/yanuar/Applications/Godot/Godot_v4.0.2-stable_linux.x86_x64'
