# git-config
My personal git configuration

To use, create symlinks for `.gitconfig` and `.gitignore_global` in your home directory:

    # Assuming path to git-config is `~/Git/git-config`
    ln -s Git/git-config/.gitconfig ~/.gitconfig
    ln -s Git/git-config/.gitignore_global ~/.gitignore_global

There is also a script for setting the command line prompt:

    # Assuming your bash profile loads everything in `~/.bash_profile.d/`
    ln -s Git/git-config/git-prompt ~/.bash_profile.d/git-prompt

## Diff and merge tools

IntelliJ (`idea`) is the default difftool and mergetool. For repos that are worked on in VS Code
instead (for example, ones with no Java files), switch that repo to git's built-in `vscode` tool, which
requires the `code` command on your `PATH` (VS Code: "Shell Command: Install 'code' command in PATH").
Run this once inside the repo:

    git config --local diff.tool vscode
    git config --local merge.tool vscode

To use VS Code for a single invocation without changing the repo's config:

    git difftool -t vscode
    git mergetool -t vscode
