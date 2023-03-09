# setting-my-env
This repository is a shell script collection for a rapid personal setting.

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/ryul1206/setting-my-env.svg)
![GitHub](https://img.shields.io/github/license/ryul1206/setting-my-env.svg)

1. [Importing `functions.sh`](#importing-functionssh)
2. [Installation Example](#installation-example)
   1. [Preset](#preset)
   2. [Single component](#single-component)

## Importing `functions.sh`

```sh
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)
```

This shell script contains the features below:

#### Beautiful Prints

- section-separator
- subsection
- emphasis
- already-installed

#### Evaluations

- duplicate-check-bashrc
- duplicate-check-zshrc
- is-not-exist
  - if not exist, return 0 # true
  - else, return 1 # false
- ask
  - Any number of options can be attached freely. (is not limited.)
   ```sh
   QUESTION=$(cat << EOM
   Do you want to set up your GIT?
   You can initialize your identity and default editor.
   EOM)
   echo "${QUESTION}"
   case $(ask "Yes" "No") in
   1)
      # Do something for "Yes"
      ;;
   2)
      # Do something for "No"
      ;;
   esac
   ```


#### Install, Download, Safe Git-commands

- apt-install
  - Batch-version of apt install
   ```sh
   ALL_PKGS=(
      "pkg-A"
      "pkg-B"
      "pkg-C"
   )
   apt-install "${ALL_PKGS[@]}"
   ```
- safe-git-clone
  - `git pull` if the repository exists, `git clone` if not.
   ```sh
   safe-git-clone $GIT_URL
   ```


## Installation Example

### Preset

via curl

```sh
REPO_URL="https://raw.githubusercontent.com/ryul1206/setting-my-env/master"
bash <(curl -fsSL ${REPO_URL}/usages/setting_my_wsl.sh)
```

via wget

```sh
REPO_URL="https://raw.githubusercontent.com/ryul1206/setting-my-env/master"
bash -c "$(wget -q -o /dev/null -O- ${REPO_URL}/usages/setting_my_wsl.sh)"
```

### Single component

```sh
# curl
REPO_URL="https://raw.githubusercontent.com/ryul1206/setting-my-env/master"
bash <(curl -fsSL ${REPO_URL}/components/git.sh)
```

<!--
<details><summary>Component List</summary>
<p>

1. basics
   - git
   - vim
   - npm
   - curl
   - wget
   - zsh
     - oh-my-zsh
     - zsh-autosuggestions
   - python
3. utilities
   - vscode
   - slack
   - google-chrome
   - [todoist](https://github.com/KryDos/todoist-linux) (will be installed in `~/Downloads`)
   - gnome-panel
   - [OBS](https://obsproject.com/)
4. others
   - ros1 (melodic)

</p>
</details>

If you can't find scripts you want here, find them [here](https://github.com/ohilho/initialize_script).
-->
