COLOR_NONE="\[\e[0m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
WHITE="\[\033[0;37m\]"

function parse_git_branch
{
    git rev-parse --git-dir &> /dev/null
    git_status="$(git status 2> /dev/null)"
    branch_pattern="^On branch ([^${IFS}]*)"
    bisect_pattern="You are currently bisecting"
    remote_pattern="Your branch is ([^']*) '"
    diverge_pattern="Your branch and ([^${IFS}]*) have diverged"
    detached_pattern="^HEAD detached at ([^${IFS}]*)"
    if [[ ! -z $git_status ]]
    then
        state=""
        remote=""

        if [[ ${git_status} =~ "Untracked files" ]]
        then
            state="${RED}⚡ "
        fi

        if [[ ${git_status} =~ "Changes not staged for commit" ]]
        then
            state+="${YELLOW}∆"
        fi

        if [[ ${git_status} =~ "Changes to be committed" ]]
        then
            state+="${GREEN}∆"
        fi

        if [[ ${git_status} =~ ${bisect_pattern} ]]
        then
            state+="${PURPLE}(Bisect in progress)"
        fi

        if [[ ${git_status} =~ ${remote_pattern} ]]
        then
            if [[ ${BASH_REMATCH[1]} == "ahead of" ]]
            then
                remote="${RED}↑"
            elif [[ ${BASH_REMATCH[1]} == "behind" ]]
            then
                remote="${YELLOW}↓"
            fi
        fi

        if [[ ${git_status} =~ ${diverge_pattern} ]]
        then
            remote="${YELLOW}↕"
        fi

        if [[ ${git_status} =~ ${branch_pattern} ]]
        then
            branch="${COLOR_NONE}[${GREEN}${BASH_REMATCH[1]}${COLOR_NONE}]"
        elif [[ ${git_status} =~ ${detached_pattern} ]]
        then
            branch="${COLOR_NONE}[${RED}${BASH_REMATCH[1]}${COLOR_NONE}]"
        fi

        echo "${branch} ${remote}${state}"
        export GIT_BRANCH="${branch}"
    fi
}

function parse_virtualenv()
{
    if [[ ! -z "$VIRTUAL_ENV" ]]
    then
        echo "${COLOR_NONE}(${WHITE}$(basename $VIRTUAL_ENV)${COLOR_NONE})"
    fi
}

function prompt_func()
{
    previous_return_value=$?;

    author=$(git config user.name)
    #prompt="${CYAN}\u@\h${COLOR_NONE}:\W (${YELLOW}${author}${COLOR_NONE})\n$(parse_git_branch)$(parse_virtualenv)"
    prompt="${CYAN}\u@\h${COLOR_NONE}:\W\n$(parse_git_branch)$(parse_virtualenv)"

    if test $previous_return_value -eq 0
    then
        PS1="${prompt}${WHITE}\$${COLOR_NONE} "
    else
        PS1="${prompt}${RED}\$${COLOR_NONE} "
    fi
}

PROMPT_COMMAND=prompt_func
