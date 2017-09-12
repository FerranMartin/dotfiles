# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
CURRENT_FG='NONE'

LONG_LINE=true

##COLORS
ORANGE="166"
LIGHT_GREY="245"

##CHARS
GIT_CHAR=''
HAS_UNTRACKED_FILES_CHAR=''        #                ?    
HAS_MODIFICATIONS_CHAR=''
HAS_MODIFICATIONS_CACHED_CHAR=''
HAS_DELETIONS_CHAR=''
HAS_DELETIONS_CACHED_CHAR=''
HAS_ADDS_CHAR=''
HAS_DIVERGED_CHAR=''              #   
HAS_STASHES_CHAR=''
IS_READY_TO_COMMIT_CHAR=''         #   →
CAN_FAST_FORWARD_CHAR=''
SHOULD_PUSH_CHAR=''               #    
DETACHED_CHAR=''
NOT_TRACKED_BRANCH_CHAR=''
REBASE_TRACKING_BRANCH_CHAR=''    #   
MERGE_TRACKING_BRANCH_CHAR=''     #  

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  # Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
  SEGMENT_SEPARATOR=$'\ue0b0'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  CURRENT_FG=$2
  [[ -n $3 ]] && echo -n $3
}

# Depending on $1, print a symbol ($2) or a white space.
# You can change the current foreground color with optional $3 argument
prompt_char() {
    local flag=$1
    local symbol=$2
    local color=${3:-$CURRENT_FG}

    local no_symbol=' '
    local space_between_chars='  '
    if [[ $LONG_LINE == false ]] then 
      no_symbol=''; 
      space_between_chars=' ';
    fi

    if [[ $flag == false ]]; then symbol=$no_symbol; fi

    echo -n "%F{$color}${symbol}$space_between_chars%F{$CURRENT_FG}"
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
  CURRENT_FG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER@%m"
  fi
}

#Git status: stashed, added, modified or deleted files
promp_git_status() {
  prompt_segment $LIGHT_GREY black "$GIT_CHAR  "

  local git_status="$(git status --porcelain 2> /dev/null)"
  local number_of_untracked_files=$(\grep -c "^??" <<< "${git_status}")
  local number_of_stashes="$(git stash list -n1 2> /dev/null | wc -l)"

  if [[ $git_status =~ ($'\n'|^).M ]]; then local has_modifications=true; fi
  if [[ $git_status =~ ($'\n'|^)M ]]; then local has_modifications_cached=true; fi
  if [[ $git_status =~ ($'\n'|^).D ]]; then local has_deletions=true; fi
  if [[ $git_status =~ ($'\n'|^)D ]]; then local has_deletions_cached=true; fi
  if [[ $git_status =~ ($'\n'|^)A ]]; then local has_adds=true; fi
  if [[ $number_of_untracked_files -gt 0 ]]; then local has_untracked_files=true; fi
  if [[ $git_status =~ ($'\n'|^)[MAD] && ! $git_status =~ ($'\n'|^).[MAD\?] ]]; then local ready_to_commit=true; fi
  if [[ $number_of_stashes -gt 0 ]]; then local has_stashes=true; fi

  prompt_char ${has_stashes:-false} $HAS_STASHES_CHAR yellow

  prompt_char ${has_untracked_files:-false} $HAS_UNTRACKED_FILES_CHAR red
  prompt_char ${has_modifications:-false} $HAS_MODIFICATIONS_CHAR red
  prompt_char ${has_deletions:-false} $HAS_DELETIONS_CHAR red

  prompt_char ${has_adds:-false} $HAS_ADDS_CHAR
  prompt_char ${has_modifications_cached:-false} $HAS_MODIFICATIONS_CACHED_CHAR
  prompt_char ${has_deletions_cached:-false} $HAS_DELETIONS_CACHED_CHAR

  prompt_char ${ready_to_commit:-false} $IS_READY_TO_COMMIT_CHAR yellow
}

# Git where: info about local branch, remote, etc
promp_git_where() {
  dirty=$(parse_git_dirty)
  ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
  if [[ -n $dirty ]]; then
    prompt_segment red black
  else
    prompt_segment green black
  fi

  local current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  local current_commit_hash=$(git rev-parse HEAD 2> /dev/null)
  local upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
  local will_rebase=$(git config --get branch.${current_branch}.rebase 2> /dev/null)

  if [[ $current_branch == 'HEAD' ]]; then local detached=true; fi
  if [[ -n "${upstream}" && "${upstream}" != "@{upstream}" ]]; then local has_upstream=true; fi
  if [[ $has_upstream == true ]]; then
    local commits_diff="$(git log --pretty=oneline --topo-order --left-right ${current_commit_hash}...${upstream} 2> /dev/null)"
    local commits_ahead=$(\grep -c "^<" <<< "$commits_diff")
    local commits_behind=$(\grep -c "^>" <<< "$commits_diff")
  fi
  if [[ $commits_ahead -gt 0 && $commits_behind -gt 0 ]]; then local has_diverged=true; fi
  if [[ $has_diverged == false && $commits_ahead -gt 0 ]]; then local should_push=true; fi

  if [[ $detached == true ]]; then
    prompt_char true $DETACHED_CHAR white
    prompt_char true "(${current_commit_hash:0:7})"
  else
    if [[ $has_upstream == false ]]; then
      prompt_char true "-- ${NOT_TRACKED_BRANCH_CHAR}  --  (${current_branch})"
    else
      if [[ $will_rebase == true ]]; then
        local type_of_upstream=$REBASE_TRACKING_BRANCH_CHAR
      else
        local type_of_upstream=$MERGE_TRACKING_BRANCH_CHAR
      fi

      if [[ $has_diverged == true ]]; then
        prompt_char true "-${commits_behind} ${HAS_DIVERGED_CHAR} +${commits_ahead}" white
      else
        if [[ $commits_behind -gt 0 ]]; then
          prompt_char true "-${commits_behind} %F{white}${CAN_FAST_FORWARD_CHAR}%F{$CURRENT_FG} --"
        fi
        if [[ $commits_ahead -gt 0 ]]; then
          prompt_char true "-- %F{white}${SHOULD_PUSH_CHAR}%F{$CURRENT_FG}  +${commits_ahead}"
        fi
        if [[ $commits_ahead == 0 && $commits_behind == 0 ]]; then
          prompt_char true " --   -- "
        fi

      fi
      prompt_char true "(${current_branch} ${type_of_upstream} ${upstream//\/$current_branch/})"
    fi
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    promp_git_status
    promp_git_where
  fi

  # (( $+commands[git] )) || return
  # local PL_BRANCH_CHAR
  # () {
  #   local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  #   PL_BRANCH_CHAR=$'\ue0a0'         # 
  # }
  # local ref dirty mode repo_path
  # repo_path=$(git rev-parse --git-dir 2>/dev/null)

  # if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
  #   dirty=$(parse_git_dirty)
  #   ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
  #   if [[ -n $dirty ]]; then
  #     prompt_segment red black
  #   else
  #     prompt_segment green black
  #   fi

  #   if [[ -e "${repo_path}/BISECT_LOG" ]]; then
  #     mode=" <B>"
  #   elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
  #     mode=" >M<"
  #   elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
  #     mode=" >R>"
  #   fi

  #   setopt promptsubst
  #   autoload -Uz vcs_info

  #   zstyle ':vcs_info:*' enable git
  #   zstyle ':vcs_info:*' get-revision true
  #   zstyle ':vcs_info:*' check-for-changes true
  #   zstyle ':vcs_info:*' stagedstr '✚'
  #   zstyle ':vcs_info:*' unstagedstr '●'
  #   zstyle ':vcs_info:*' formats ' %u%c'
  #   zstyle ':vcs_info:*' actionformats ' %u%c'
  #   vcs_info
  #   echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  # fi
}

prompt_bzr() {
    (( $+commands[bzr] )) || return
    if (bzr status >/dev/null 2>&1); then
        status_mod=`bzr status | head -n1 | grep "modified" | wc -m`
        status_all=`bzr status | head -n1 | wc -m`
        revision=`bzr log | head -n2 | tail -n1 | sed 's/^revno: //'`
        if [[ $status_mod -gt 0 ]] ; then
            prompt_segment yellow black
            echo -n "bzr@"$revision "✚ "
        else
            if [[ $status_all -gt 0 ]] ; then
                prompt_segment yellow black
                echo -n "bzr@"$revision

            else
                prompt_segment green black
                echo -n "bzr@"$revision
            fi
        fi
    fi
}

prompt_hg() {
  (( $+commands[hg] )) || return
  local rev status
  if $(hg id >/dev/null 2>&1); then
    if $(hg prompt >/dev/null 2>&1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
        # if any modification
        prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        prompt_segment green black
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if `hg st | grep -q "^\?"`; then
        prompt_segment red black
        st='±'
      elif `hg st | grep -q "^[MA]"`; then
        prompt_segment yellow black
        st='±'
      else
        prompt_segment green black
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment white black '%~'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "(`basename $virtualenv_path`)"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_git
  prompt_bzr
  prompt_hg
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '

