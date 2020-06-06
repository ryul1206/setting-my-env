# setting-my-env
This repository is a shell script collection for a rapid personal setting.

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/ryul1206/setting-my-env.svg)
![GitHub](https://img.shields.io/github/license/ryul1206/setting-my-env.svg)


## Installation All

#### via curl

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/install.sh)"
```

#### via wget

```sh
bash -c "$(wget -q -o /dev/null -O- https://raw.githubusercontent.com/ryul1206/setting-my-env/master/install.sh)"
```

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
