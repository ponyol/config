# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -n "$CLAUDECODE" ]] || [[ "$TERM_PROGRAM" == "kiro" ]] || [[ -n "$GEMINI_CLI" ]]; then
    # Отключить историю
    unset HISTFILE
    SAVEHIST=0

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    [[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

    export PATH="/Users/ponyol/bin:/usr/local/sbin:/Users/ponyol/.local/bin:/Users/ponyol/go/bin:/Users/ponyol/development/flutter/bin:$PATH"
else
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
      source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

    # If you come from bash you might have to change your $PATH.
    # export PATH=$HOME/bin:/usr/local/bin:$PATH

    # Path to your oh-my-zsh installation.
    export ZSH="/Users/ponyol/.oh-my-zsh"
    #export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'cat {}'"

    # Set name of the theme to load --- if set to "random", it will
    # load a random theme each time oh-my-zsh is loaded, in which case,
    # to know which specific one was loaded, run: echo $RANDOM_THEME
    # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
    ZSH_THEME="agnoster"

    # Set list of themes to pick from when loading at random
    # Setting this variable when ZSH_THEME=random will cause zsh to load
    # a theme from this variable instead of looking in $ZSH/themes/
    # If set to an empty array, this variable will have no effect.
    # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
    ZSH_DISABLE_COMPFIX="true"
    # Uncomment the following line to use case-sensitive completion.
    # CASE_SENSITIVE="true"

    # Uncomment the following line to use hyphen-insensitive completion.
    # Case-sensitive completion must be off. _ and - will be interchangeable.
    # HYPHEN_INSENSITIVE="true"

    # Uncomment the following line to disable bi-weekly auto-update checks.
    # DISABLE_AUTO_UPDATE="true"

    # Uncomment the following line to automatically update without prompting.
    # DISABLE_UPDATE_PROMPT="true"

    # Uncomment the following line to change how often to auto-update (in days).
    # export UPDATE_ZSH_DAYS=13

    # Uncomment the following line if pasting URLs and other text is messed up.
    # DISABLE_MAGIC_FUNCTIONS=true

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
    # You can set one of the optional three formats:
    # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
    # or set a custom format using the strftime function format specifications,
    # see 'man strftime' for details.
    # HIST_STAMPS="mm/dd/yyyy"

    # Would you like to use another custom folder than $ZSH/custom?
    # ZSH_CUSTOM=/path/to/new-custom-folder

    # Which plugins would you like to load?
    # Standard plugins can be found in $ZSH/plugins/
    # Custom plugins may be added to $ZSH_CUSTOM/plugins/
    # Example format: plugins=(rails git textmate ruby lighthouse)
    # Add wisely, as too many plugins slow down shell startup.
    plugins=(
            git
            zsh-syntax-highlighting
            zsh-autosuggestions
            zsh-completions
            nomad
            emacs
            fzf-tab
            extract
            universalarchive
            kubectl-autocomplete
    )

    eval "$(starship init zsh)"

    source $ZSH/oh-my-zsh.sh

    # User configuration

    # export MANPATH="/usr/local/man:$MANPATH"

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

    # Set personal aliases, overriding those provided by oh-my-zsh libs,
    # plugins, and themes. Aliases can be placed here, though oh-my-zsh
    # users are encouraged to define aliases within the ZSH_CUSTOM folder.
    # For a full list of active aliases, run `alias`.
    #
    # Example aliases
    # alias zshconfig="mate ~/.zshrc"
    # alias ohmyzsh="mate ~/.oh-my-zsh"
    alias ec='~/bin/ec'
    alias nj='nomad job plan $(find ./* -type f -name "*hcl" | sed -e "s/^\.\///" | fzf --height 60% --layout=reverse --border --preview "cat {}" --color="hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008" --prompt=">> " --pointer="▶" --marker="✓")'
    #alias nj='nomad job plan $(find ./* -type f -name "*hcl" | sed -e "s/^\.\///" | fzf --height 60% --layout=reverse --border --preview "cat {}")'

    alias tfold='tfswitch 0.14.2 && terraform -v'
    alias tfnew='tfswitch 1.5.5 && terraform -v'
    alias tgpl='rm -rf ./.terragrunt-cache && terragrunt plan -lock=false'
    alias tgap='rm -rf ./.terragrunt-cache && terragrunt apply -lock=false'
    alias start='python3 ~/kyrrex/DevOps/PY/start-stop.py -e start'
    alias stop='python3 ~/kyrrex/DevOps/PY/start-stop.py -e stop'
    alias kk='kubectl'
    alias kx='kubectx'
    alias kn='kubens'
    alias kps='eks-node-viewer -resources memory'
    alias kpsc='eks-node-viewer -resources cpu,memory'
    alias hl="rm -rf ./charts; rm -f Chart.lock; helm dependency update; helm template `pwd | awk -F / '{print $NF}'` ."
    alias hld="rm -rf ./charts; rm -f Chart.lock; helm dependency update; helm template `pwd | awk -F / '{print $NF}'` .; rm -rf ./charts; rm -f Chart.lock;"
    alias py='python'
    export EDITOR='~/bin/ec'
    export VIRTUAL_ENV=/Users/ponyol/.venv
    export PATH=$PATH:/Users/ponyol/bin:/usr/local/sbin:$HOME/development/flutter/bin

    source ~/.config/fzf-command-bookmarks/fzf-command-bookmarks.sh
    source ~/.config/fzf-command-ansible/fzf-command-ansible.sh
    source ~/powerlevel10k/powerlevel10k.zsh-theme

    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C /opt/homebrew/bin/nomad nomad

    complete -o nospace -C /opt/homebrew/bin/consul consul

    load-tfswitch() {
      local tfswitchrc_path=".tfswitchrc"

      if [ -f "$tfswitchrc_path" ]; then
        tfswitch
      fi
    }
    add-zsh-hook chpwd load-tfswitch
    load-tfswitch

    complete -o nospace -C /opt/homebrew/bin/terragrunt terragrunt
    [[ "$PATH" == *"$HOME/bin:"* ]] || export PATH="$HOME/bin:$PATH"

    # Added by LM Studio CLI (lms)
    export PATH="$PATH:/Users/ponyol/.lmstudio/bin"

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    # Added by Windsurf
    export PATH="/Users/ponyol/.codeium/windsurf/bin:$PATH"

    #. "$HOME/.local/bin/env"
    function k() {
      if [[ -z "$KUBECONFIG_CONTENT" ]]; then
        echo "⚠️  KUBECONFIG_CONTENT не установлен. Запусти M-x my/load-eks-kubeconfig в Emacs"
        return 1
      fi
      echo "$KUBECONFIG_CONTENT" | KUBECONFIG=/dev/stdin kubectl "$@"
    }

    # Алиас для удобства
    alias kb=k

    [[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
    export PATH="/opt/homebrew/bin:/Users/ponyol/.local/bin:/Users/ponyol/go/bin:/Users/ponyol/development/flutter/bin:$PATH"

fi

# pyenv initialization
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init --path)"
#eval "$(pyenv init -)"

# Added by Antigravity
#export PATH="/Users/ponyol/.antigravity/antigravity/bin:$PATH"
#export PATH="/opt/homebrew/anaconda3/bin:$PATH"

# bun completions
[ -s "/Users/ponyol/.bun/_bun" ] && source "/Users/ponyol/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Entire CLI shell completion
rm -f ~/.zcompdump; autoload -Uz compinit && compinit
export PATH="/opt/homebrew/opt/pcsc-lite/bin:$PATH"
export PATH="/opt/homebrew/opt/pcsc-lite/sbin:$PATH"


# Added by Antigravity CLI installer
export PATH="/Users/ponyol/.local/bin:$PATH"

# strix
export PATH=/Users/ponyol/.strix/bin:$PATH
