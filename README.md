# setting-my-env
This repository is a shell script collection for a rapid personal setting.

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/ryul1206/setting-my-env.svg)
![GitHub](https://img.shields.io/github/license/ryul1206/setting-my-env.svg)

1. [Installation All](#installation-all)
      1. [via curl](#via-curl)
      2. [via wget](#via-wget)
2. [Importing `functions.sh`](#importing-functionssh)
      1. [Beautiful Prints](#beautiful-prints)
      2. [Detections](#detections)
      3. [Batch: apt install](#batch-apt-install)


## Installation All

#### via curl

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/install.sh)"
```

#### via wget

```sh
bash -c "$(wget -q -o /dev/null -O- https://raw.githubusercontent.com/ryul1206/setting-my-env/master/install.sh)"
```
<details><summary>Installation list</summary>
<p>

1. basics
   - git
   - vim 
   - npm
   - curl
   - wget
   - zsh
   - oh-my-zsh
1. utilities
   - google-chrome
   - todoist (will be installed in `~/Downloads`)
2. others
   - ros1 (melodic)

</p>
</details>


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

#### Detections

- is-not-exist
  - if not exist, return 0 # true
  - else, return 1 # false

#### Batch: apt install

- apt-install
    ```sh
    ALL_PKGS=(
        "pkg-A"
        "pkg-B"
        "pkg-C"
    )
    apt-install "${ALL_PKGS[@]}"
    ```


---

If you can't find scripts you want here, find them [here](https://github.com/ohilho/initialize_script).
