" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.github/FUNDING.yml	[[[1
1
github: junegunn
./.github/ISSUE_TEMPLATE.md	[[[1
22
<!-- ISSUES NOT FOLLOWING THIS TEMPLATE WILL BE CLOSED AND DELETED -->

<!-- Check all that apply [x] -->

- [ ] I have read through the manual page (`man fzf`)
- [ ] I have the latest version of fzf
- [ ] I have searched through the existing issues

## Info

- OS
    - [ ] Linux
    - [ ] Mac OS X
    - [ ] Windows
    - [ ] Etc.
- Shell
    - [ ] bash
    - [ ] zsh
    - [ ] fish

## Problem / Steps to reproduce

./.github/dependabot.yml	[[[1
10
version: 2
updates:
  - package-ecosystem: "gomod"
    directory: "/"
    schedule:
      interval: "weekly"
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
        interval: "weekly"
./.github/workflows/codeql-analysis.yml	[[[1
44
# https://docs.github.com/en/free-pro-team@latest/github/finding-security-vulnerabilities-and-errors-in-your-code/configuring-code-scanning
name: CodeQL

on:
  push:
    branches: [ master, devel ]
  pull_request:
    branches: [ master ]
  workflow_dispatch:

permissions:
  contents: read

jobs:
  analyze:
    permissions:
      actions: read  # for github/codeql-action/init to get workflow details
      contents: read  # for actions/checkout to fetch code
      security-events: write  # for github/codeql-action/autobuild to send a status report
    name: Analyze
    runs-on: ubuntu-latest

    strategy:
      fail-fast: false
      matrix:
        language: ['go']

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3
      with:
        fetch-depth: 0

    # Initializes the CodeQL tools for scanning.
    - name: Initialize CodeQL
      uses: github/codeql-action/init@v2
      with:
        languages: ${{ matrix.language }}

    - name: Autobuild
      uses: github/codeql-action/autobuild@v2

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v2
./.github/workflows/depsreview.yaml	[[[1
14
name: 'Dependency Review'
on: [pull_request]

permissions:
  contents: read

jobs:
  dependency-review:
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout Repository'
        uses: actions/checkout@v3
      - name: 'Dependency Review'
        uses: actions/dependency-review-action@v3
./.github/workflows/linux.yml	[[[1
45
---
name: Test fzf on Linux

on:
  push:
    branches: [ master, devel ]
  pull_request:
    branches: [ master ]
  workflow_dispatch:

permissions:
  contents: read

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
      with:
        fetch-depth: 0

    - name: Set up Go
      uses: actions/setup-go@v4
      with:
        go-version: 1.19

    - name: Setup Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.1.0

    - name: Install packages
      run: sudo apt-get install --yes zsh fish tmux

    - name: Install Ruby gems
      run: sudo gem install --no-document minitest:5.17.0 rubocop:1.43.0 rubocop-minitest:0.25.1 rubocop-performance:1.15.2

    - name: Rubocop
      run: rubocop --require rubocop-minitest --require rubocop-performance

    - name: Unit test
      run: make test

    - name: Integration test
      run: make install && ./install --all && LC_ALL=C tmux new-session -d && ruby test/test_go.rb --verbose
./.github/workflows/macos.yml	[[[1
45
---
name: Test fzf on macOS

on:
  push:
    branches: [ master, devel ]
  pull_request:
    branches: [ master ]
  workflow_dispatch:

permissions:
  contents: read

jobs:
  build:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v3
      with:
        fetch-depth: 0

    - name: Set up Go
      uses: actions/setup-go@v4
      with:
        go-version: 1.18

    - name: Setup Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.0.0

    - name: Install packages
      run: HOMEBREW_NO_INSTALL_CLEANUP=1 brew install fish zsh tmux

    - name: Install Ruby gems
      run: gem install --no-document minitest:5.14.2 rubocop:1.0.0 rubocop-minitest:0.10.1 rubocop-performance:1.8.1

    - name: Rubocop
      run: rubocop --require rubocop-minitest --require rubocop-performance

    - name: Unit test
      run: make test

    - name: Integration test
      run: make install && ./install --all && LC_ALL=C tmux new-session -d && ruby test/test_go.rb --verbose
./.github/workflows/typos.yml	[[[1
10
name: "Spell Check"
on: [pull_request]

jobs:
  typos:
    name: Spell Check with Typos
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: crate-ci/typos@v1.15.0
./.github/workflows/winget.yml	[[[1
15
name: Publish to Winget
on:
  release:
    types: [released]

jobs:
  publish:
    runs-on: windows-latest # Action can only run on Windows
    steps:
      - uses: vedantmgoyal2009/winget-releaser@v2
        with:
          identifier: junegunn.fzf
          version: ${{ github.event.release.tag_name }}
          installers-regex: '-windows_(armv7|arm64|amd64)\.zip$'
          token: ${{ secrets.WINGET_TOKEN }}
./.gitignore	[[[1
14
bin/fzf
bin/fzf.exe
dist
target
pkg
Gemfile.lock
.DS_Store
doc/tags
vendor
gopath
*.zwc
fzf
tmp
*.patch
./.goreleaser.yml	[[[1
126
---
project_name: fzf

before:
  hooks:
    - go mod download

builds:
  - id: fzf-macos
    binary: fzf
    goos:
      - darwin
    goarch:
      - amd64
    ldflags:
      - "-s -w -X main.version={{ .Version }} -X main.revision={{ .ShortCommit }}"
    hooks:
      post: |
        sh -c '
        cat > /tmp/fzf-gon-amd64.hcl << EOF
        source = ["./dist/fzf-macos_darwin_amd64_v1/fzf"]
        bundle_id = "kr.junegunn.fzf"
        apple_id {
          username = "junegunn.c@gmail.com"
          password = "@env:AC_PASSWORD"
        }
        sign {
          application_identity = "Developer ID Application: Junegunn Choi (Y254DRW44Z)"
        }
        zip {
          output_path = "./dist/fzf-{{ .Version }}-darwin_amd64.zip"
        }
        EOF
        gon /tmp/fzf-gon-amd64.hcl
        '

  - id: fzf-macos-arm
    binary: fzf
    goos:
      - darwin
    goarch:
      - arm64
    ldflags:
      - "-s -w -X main.version={{ .Version }} -X main.revision={{ .ShortCommit }}"
    hooks:
      post: |
        sh -c '
        cat > /tmp/fzf-gon-arm64.hcl << EOF
        source = ["./dist/fzf-macos-arm_darwin_arm64/fzf"]
        bundle_id = "kr.junegunn.fzf"
        apple_id {
          username = "junegunn.c@gmail.com"
          password = "@env:AC_PASSWORD"
        }
        sign {
          application_identity = "Developer ID Application: Junegunn Choi (Y254DRW44Z)"
        }
        zip {
          output_path = "./dist/fzf-{{ .Version }}-darwin_arm64.zip"
        }
        EOF
        gon /tmp/fzf-gon-arm64.hcl
        '

  - id: fzf
    goos:
      - linux
      - windows
      - freebsd
      - openbsd
    goarch:
      - amd64
      - arm
      - arm64
      - loong64
      - ppc64le
      - s390x
    goarm:
      - 5
      - 6
      - 7
    ldflags:
      - "-s -w -X main.version={{ .Version }} -X main.revision={{ .ShortCommit }}"
    ignore:
      - goos: freebsd
        goarch: arm
      - goos: openbsd
        goarch: arm
      - goos: freebsd
        goarch: arm64
      - goos: openbsd
        goarch: arm64

archives:
  - name_template: "{{ .ProjectName }}-{{ .Version }}-{{ .Os }}_{{ .Arch }}{{ if .Arm }}v{{ .Arm }}{{ end }}"
    builds:
      - fzf
    format: tar.gz
    format_overrides:
      - goos: windows
        format: zip
    files:
      - non-existent*

checksum:
  extra_files:
    - glob: ./dist/fzf-*darwin*.zip

release:
  github:
    owner: junegunn
    name: fzf
  prerelease: auto
  name_template: '{{ .Tag }}'
  extra_files:
    - glob: ./dist/fzf-*darwin*.zip

snapshot:
  name_template: "{{ .Tag }}-devel"

changelog:
  sort: asc
  filters:
    exclude:
      - README
      - test
./.rubocop.yml	[[[1
32
Layout/LineLength:
  Enabled: false
Metrics:
  Enabled: false
Lint/ShadowingOuterLocalVariable:
  Enabled: false
Style/MethodCallWithArgsParentheses:
  Enabled: true
  IgnoredMethods:
    - assert
    - exit
    - paste
    - puts
    - raise
    - refute
    - require
    - send_keys
  IgnoredPatterns:
    - ^assert_
    - ^refute_
Style/NumericPredicate:
  Enabled: false
Style/StringConcatenation:
  Enabled: false
Style/OptionalBooleanParameter:
  Enabled: false
Style/WordArray:
  MinSize: 1
Minitest/AssertEqual:
  Enabled: false
Naming/VariableNumber:
  Enabled: false
./.tool-versions	[[[1
1
golang 1.20.4
./ADVANCED.md	[[[1
612
Advanced fzf examples
======================

* *Last update: 2023/05/26*
* *Requires fzf 0.41.0 or above*

---

<!-- vim-markdown-toc GFM -->

* [Introduction](#introduction)
* [Screen Layout](#screen-layout)
    * [`--height`](#--height)
    * [`fzf-tmux`](#fzf-tmux)
        * [Popup window support](#popup-window-support)
* [Dynamic reloading of the list](#dynamic-reloading-of-the-list)
    * [Updating the list of processes by pressing CTRL-R](#updating-the-list-of-processes-by-pressing-ctrl-r)
    * [Toggling between data sources](#toggling-between-data-sources)
* [Ripgrep integration](#ripgrep-integration)
    * [Using fzf as the secondary filter](#using-fzf-as-the-secondary-filter)
    * [Using fzf as interactive Ripgrep launcher](#using-fzf-as-interactive-ripgrep-launcher)
    * [Switching to fzf-only search mode](#switching-to-fzf-only-search-mode)
    * [Switching between Ripgrep mode and fzf mode](#switching-between-ripgrep-mode-and-fzf-mode)
* [Log tailing](#log-tailing)
* [Key bindings for git objects](#key-bindings-for-git-objects)
    * [Files listed in `git status`](#files-listed-in-git-status)
    * [Branches](#branches)
    * [Commit hashes](#commit-hashes)
* [Color themes](#color-themes)
    * [Generating fzf color theme from Vim color schemes](#generating-fzf-color-theme-from-vim-color-schemes)

<!-- vim-markdown-toc -->

Introduction
------------

fzf is an interactive [Unix filter][filter] program that is designed to be
used with other Unix tools. It reads a list of items from the standard input,
allows you to select a subset of the items, and prints the selected ones to
the standard output. You can think of it as an interactive version of *grep*,
and it's already useful even if you don't know any of its options.

```sh
# 1. ps:   Feed the list of processes to fzf
# 2. fzf:  Interactively select a process using fuzzy matching algorithm
# 3. awk:  Take the PID from the selected line
# 3. kill: Kill the process with the PID
ps -ef | fzf | awk '{print $2}' | xargs kill -9
```

[filter]: https://en.wikipedia.org/wiki/Filter_(software)

While the above example succinctly summarizes the fundamental concept of fzf,
you can build much more sophisticated interactive workflows using fzf once you
learn its wide variety of features.

- To see the full list of options and features, see `man fzf`
- To see the latest additions, see [CHANGELOG.md](CHANGELOG.md)

This document will guide you through some examples that will familiarize you
with the advanced features of fzf.

Screen Layout
-------------

### `--height`

fzf by default opens in fullscreen mode, but it's not always desirable.
Oftentimes, you want to see the current context of the terminal while using
fzf. `--height` is an option for opening fzf below the cursor in
non-fullscreen mode so you can still see the previous commands and their
results above it.

```sh
fzf --height=40%
```

![image](https://user-images.githubusercontent.com/700826/113379893-c184c680-93b5-11eb-9676-c7c0a2f01748.png)

You might also want to experiment with other layout options such as
`--layout=reverse`, `--info=inline`, `--border`, `--margin`, etc.

```sh
fzf --height=40% --layout=reverse
fzf --height=40% --layout=reverse --info=inline
fzf --height=40% --layout=reverse --info=inline --border
fzf --height=40% --layout=reverse --info=inline --border --margin=1
fzf --height=40% --layout=reverse --info=inline --border --margin=1 --padding=1
```

![image](https://user-images.githubusercontent.com/700826/113379932-dfeac200-93b5-11eb-9e28-df1a2ee71f90.png)

*(See `Layout` section of the man page to see the full list of options)*

But you definitely don't want to repeat `--height=40% --layout=reverse
--info=inline --border --margin=1 --padding=1` every time you use fzf. You
could write a wrapper script or shell alias, but there is an easier option.
Define `$FZF_DEFAULT_OPTS` like so:

```sh
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --info=inline --border --margin=1 --padding=1"
```

### `fzf-tmux`

Before fzf had `--height` option, we would open fzf in a tmux split pane not
to take up the whole screen. This is done using `fzf-tmux` script.

```sh
# Open fzf on a tmux split pane below the current pane.
# Takes the same set of options.
fzf-tmux --layout=reverse
```

![image](https://user-images.githubusercontent.com/700826/113379973-f1cc6500-93b5-11eb-8860-c9bc4498aadf.png)

The limitation of `fzf-tmux` is that it only works when you're on tmux unlike
`--height` option. But the advantage of it is that it's more flexible.
(See `man fzf-tmux` for available options.)

```sh
# On the right (50%)
fzf-tmux -r

# On the left (30%)
fzf-tmux -l30%

# Above the cursor
fzf-tmux -u30%
```

![image](https://user-images.githubusercontent.com/700826/113379983-fa24a000-93b5-11eb-93eb-8a3d39b2f163.png)

![image](https://user-images.githubusercontent.com/700826/113380001-0577cb80-93b6-11eb-95d0-2ba453866882.png)

![image](https://user-images.githubusercontent.com/700826/113380040-1d4f4f80-93b6-11eb-9bef-737fb120aafe.png)

#### Popup window support

But here's the really cool part; tmux 3.2 added support for popup windows. So
you can open fzf in a popup window, which is quite useful if you frequently
use split panes.

```sh
# Open tmux in a tmux popup window (default size: 50% of the screen)
fzf-tmux -p

# 80% width, 60% height
fzf-tmux -p 80%,60%
```

![image](https://user-images.githubusercontent.com/700826/113380106-4a9bfd80-93b6-11eb-8cee-aeb1c4ce1a1f.png)

> You might also want to check out my tmux plugins which support this popup
> window layout.
>
> - https://github.com/junegunn/tmux-fzf-url
> - https://github.com/junegunn/tmux-fzf-maccy

Dynamic reloading of the list
-----------------------------

fzf can dynamically update the candidate list using an arbitrary program with
`reload` bindings (The design document for `reload` can be found
[here][reload]).

[reload]: https://github.com/junegunn/fzf/issues/1750

### Updating the list of processes by pressing CTRL-R

This example shows how you can set up a binding for dynamically updating the
list without restarting fzf.

```sh
(date; ps -ef) |
  fzf --bind='ctrl-r:reload(date; ps -ef)' \
      --header=$'Press CTRL-R to reload\n\n' --header-lines=2 \
      --preview='echo {}' --preview-window=down,3,wrap \
      --layout=reverse --height=80% | awk '{print $2}' | xargs kill -9
```

![image](https://user-images.githubusercontent.com/700826/113465047-200c7c00-946c-11eb-918c-268f37a900c8.png)

- The initial command is `(date; ps -ef)`. It prints the current date and
  time, and the list of the processes.
- With `--header` option, you can show any message as the fixed header.
- To disallow selecting the first two lines (`date` and `ps` header), we use
  `--header-lines=2` option.
- `--bind='ctrl-r:reload(date; ps -ef)'` binds CTRL-R to `reload` action that
  runs `date; ps -ef`, so we can update the list of the processes by pressing
  CTRL-R.
- We use simple `echo {}` preview option, so we can see the entire line on the
  preview window below even if it's too long

### Toggling between data sources

You're not limited to just one reload binding. Set up multiple bindings so
you can switch between data sources.

```sh
find * | fzf --prompt 'All> ' \
             --header 'CTRL-D: Directories / CTRL-F: Files' \
             --bind 'ctrl-d:change-prompt(Directories> )+reload(find * -type d)' \
             --bind 'ctrl-f:change-prompt(Files> )+reload(find * -type f)'
```

![image](https://user-images.githubusercontent.com/700826/113465073-4af6d000-946c-11eb-858f-2372c0955f67.png)

![image](https://user-images.githubusercontent.com/700826/113465072-46321c00-946c-11eb-9b6f-cda3951df579.png)

Ripgrep integration
-------------------

### Using fzf as the secondary filter

* Requires [bat][bat]
* Requires [Ripgrep][rg]

[bat]: https://github.com/sharkdp/bat
[rg]: https://github.com/BurntSushi/ripgrep

fzf is pretty fast for filtering a list that you will rarely have to think
about its performance. But it is not the right tool for searching for text
inside many large files, and in that case you should definitely use something
like [Ripgrep][rg].

In the next example, Ripgrep is the primary filter that searches for the given
text in files, and fzf is used as the secondary fuzzy filter that adds
interactivity to the workflow. And we use [bat][bat] to show the matching line in
the preview window.

This is a bash script and it will not run as expected on other non-compliant
shells. To avoid the compatibility issue, let's save this snippet as a script
file called `rfv`.

```bash
#!/usr/bin/env bash

# 1. Search for text in files using Ripgrep
# 2. Interactively narrow down the list using fzf
# 3. Open the file in Vim
rg --color=always --line-number --no-heading --smart-case "${*:-}" |
  fzf --ansi \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
      --bind 'enter:become(vim {1} +{2})'
```

And run it with an initial query string.

```sh
# Make the script executable
chmod +x rfv

# Run it with the initial query "algo"
./rfv algo
```

> Ripgrep will perform the initial search and list all the lines that contain
`algo`. Then we further narrow down the list on fzf.

![image](https://user-images.githubusercontent.com/700826/113683873-a42a6200-96ff-11eb-9666-26ce4091b0e4.png)

I know it's a lot to digest, let's try to break down the code.

- Ripgrep prints the matching lines in the following format
  ```
  man/man1/fzf.1:54:.BI "--algo=" TYPE
  man/man1/fzf.1:55:Fuzzy matching algorithm (default: v2)
  man/man1/fzf.1:58:.BR v2 "     Optimal scoring algorithm (quality)"
  src/pattern_test.go:7:  "github.com/junegunn/fzf/src/algo"
  ```
  The first token delimited by `:` is the file path, and the second token is
  the line number of the matching line. They respectively correspond to `{1}`
  and `{2}` in the preview command.
    - `--preview 'bat --color=always {1} --highlight-line {2}'`
- As we run `rg` with `--color=always` option, we should tell fzf to parse
  ANSI color codes in the input by setting `--ansi`.
- We customize how fzf colors various text elements using `--color` option.
  `-1` tells fzf to keep the original color from the input. See `man fzf` for
  available color options.
- The value of `--preview-window` option consists of 5 components delimited
  by `,`
    1. `up` — Position of the preview window
    1. `60%` — Size of the preview window
    1. `border-bottom` — Preview window border only on the bottom side
    1. `+{2}+3/3` — Scroll offset of the preview contents
    1. `~3` — Fixed header
- Let's break down the latter two. We want to display the bat output in the
  preview window with a certain scroll offset so that the matching line is
  positioned near the center of the preview window.
    - `+{2}` — The base offset is extracted from the second token
    - `+3` — We add 3 lines to the base offset to compensate for the header
      part of `bat` output
        - ```
          ───────┬──────────────────────────────────────────────────────────
                 │ File: CHANGELOG.md
          ───────┼──────────────────────────────────────────────────────────
             1   │ CHANGELOG
             2   │ =========
             3   │
             4   │ 0.26.0
             5   │ ------
          ```
    - `/3` adjusts the offset so that the matching line is shown at a third
      position in the window
    - `~3` makes the top three lines fixed header so that they are always
      visible regardless of the scroll offset
- Instead of using shell script to process the final output of fzf, we use
  `become(...)` action which was added in [fzf 0.38.0][0.38.0] to turn fzf
  into a new process that opens the file with `vim` (`vim {1}`) and move the
  cursor to the line (`+{2}`).

[0.38.0]: https://github.com/junegunn/fzf/blob/master/CHANGELOG.md#0380

### Using fzf as interactive Ripgrep launcher

We have learned that we can bind `reload` action to a key (e.g.
`--bind=ctrl-r:execute(ps -ef)`). In the next example, we are going to **bind
`reload` action to `change` event** so that whenever the user *changes* the
query string on fzf, `reload` action is triggered.

Here is a variation of the above `rfv` script. fzf will restart Ripgrep every
time the user updates the query string on fzf. Searching and filtering is
completely done by Ripgrep, and fzf merely provides the interactive interface.
So we lose the "fuzziness", but the performance will be better on larger
projects, and it will free up memory as you narrow down the results.

```bash
#!/usr/bin/env bash

# 1. Search for text in files using Ripgrep
# 2. Interactively restart Ripgrep with reload action
# 3. Open the file in Vim
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="${*:-}"
: | fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(vim {1} +{2})'
```

![image](https://user-images.githubusercontent.com/700826/113684212-f9ff0a00-96ff-11eb-8737-7bb571d320cc.png)

- Instead of starting fzf in the usual `rg ... | fzf` form, we start fzf with
  an empty input (`: | fzf`), then we make it start the initial Ripgrep
  process immediately via `start:reload` binding. This way, fzf owns the
  initial Ripgrep process so it can kill it on the next `reload`. Otherwise,
  the process will keep running in the background.
- Filtering is no longer a responsibility of fzf; hence `--disabled`
- `{q}` in the reload command evaluates to the query string on fzf prompt.
- `sleep 0.1` in the reload command is for "debouncing". This small delay will
  reduce the number of intermediate Ripgrep processes while we're typing in
  a query.

### Switching to fzf-only search mode

In the previous example, we lost fuzzy matching capability as we completely
delegated search functionality to Ripgrep. But we can dynamically switch to
fzf-only search mode by *"unbinding"* `reload` action from `change` event.

```sh
#!/usr/bin/env bash

# Two-phase filtering with Ripgrep and fzf
#
# 1. Search for text in files using Ripgrep
# 2. Interactively restart Ripgrep with reload action
#    * Press alt-enter to switch to fzf-only filtering
# 3. Open the file in Vim
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="${*:-}"
: | fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --bind "alt-enter:unbind(change,alt-enter)+change-prompt(2. fzf> )+enable-search+clear-query" \
    --color "hl:-1:underline,hl+:-1:underline:reverse" \
    --prompt '1. ripgrep> ' \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(vim {1} +{2})'
```

* Phase 1. Filtering with Ripgrep
![image](https://user-images.githubusercontent.com/700826/119213880-735e8a80-bafd-11eb-8493-123e4be24fbc.png)
* Phase 2. Filtering with fzf
![image](https://user-images.githubusercontent.com/700826/119213887-7e191f80-bafd-11eb-98c9-71a1af9d7aab.png)

- We added `--prompt` option to show that fzf is initially running in "Ripgrep
  launcher mode".
- We added `alt-enter` binding that
    1. unbinds `change` event, so Ripgrep is no longer restarted on key press
    2. changes the prompt to `2. fzf>`
    3. enables search functionality of fzf
    4. clears the current query string that was used to start Ripgrep process
    5. and unbinds `alt-enter` itself as this is a one-off event
- We reverted `--color` option for customizing how the matching chunks are
  displayed in the second phase

### Switching between Ripgrep mode and fzf mode

[fzf 0.30.0][0.30.0] added `rebind` action so we can "rebind" the bindings
that were previously "unbound" via `unbind`.

This is an improved version of the previous example that allows us to switch
between Ripgrep launcher mode and fzf-only filtering mode via CTRL-R and
CTRL-F.

```sh
#!/usr/bin/env bash

# Switch between Ripgrep launcher mode (CTRL-R) and fzf filtering mode (CTRL-F)
rm -f /tmp/rg-fzf-{r,f}
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="${*:-}"
: | fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload($RG_PREFIX {q})+unbind(ctrl-r)" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
    --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
    --color "hl:-1:underline,hl+:-1:underline:reverse" \
    --prompt '1. ripgrep> ' \
    --delimiter : \
    --header '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱' \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(vim {1} +{2})'
```

- To restore the query string when switching between modes, we store the
  current query in `/tmp/rg-fzf-{r,f}` files and restore the query using
  `transform-query` action which was added in [fzf 0.36.0][0.36.0].
- Also note that we unbind `ctrl-r` binding on `start` event which is
  triggered once when fzf starts.

[0.30.0]: https://github.com/junegunn/fzf/blob/master/CHANGELOG.md#0300
[0.36.0]: https://github.com/junegunn/fzf/blob/master/CHANGELOG.md#0360

Log tailing
-----------

fzf can run long-running preview commands and render partial results before
completion. And when you specify `follow` flag in `--preview-window` option,
fzf will "`tail -f`" the result, automatically scrolling to the bottom.

```bash
# With "follow", preview window will automatically scroll to the bottom.
# "\033[2J" is an ANSI escape sequence for clearing the screen.
# When fzf reads this code it clears the previous preview contents.
fzf --preview-window follow --preview 'for i in $(seq 100000); do
  echo "$i"
  sleep 0.01
  (( i % 300 == 0 )) && printf "\033[2J"
done'
```

![image](https://user-images.githubusercontent.com/700826/113473303-dd669600-94a3-11eb-88a9-1f61b996bb0e.png)

Admittedly, that was a silly example. Here's a practical one for browsing
Kubernetes pods.

```bash
pods() {
  : | command='kubectl get pods --all-namespaces' fzf \
    --info=inline --layout=reverse --header-lines=1 \
    --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
    --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
    --bind 'start:reload:$command' \
    --bind 'ctrl-r:reload:$command' \
    --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
    --bind 'enter:execute:kubectl exec -it --namespace {1} {2} -- bash > /dev/tty' \
    --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers --namespace {1} {2}) > /dev/tty' \
    --preview-window up:follow \
    --preview 'kubectl logs --follow --all-containers --tail=10000 --namespace {1} {2}' "$@"
}
```

![image](https://user-images.githubusercontent.com/700826/113473547-1d7a4880-94a5-11eb-98ef-9aa6f0ed215a.png)

- The preview window will *"log tail"* the pod
    - Holding on to a large amount of log will consume a lot of memory. So we
      limited the initial log amount with `--tail=10000`.
- `execute` bindings allow you to run any command without leaving fzf
    - Press enter key on a pod to `kubectl exec` into it
    - Press CTRL-O to open the log in your editor
- Press CTRL-R to reload the pod list
- Press CTRL-/ repeatedly to to rotate through a different sets of preview
  window options
    1. `80%,border-bottom`
    1. `hidden`
    1. Empty string after `|` translates to the default options from `--preview-window`

Key bindings for git objects
----------------------------

Oftentimes, you want to put the identifiers of various Git object to the
command-line. For example, it is common to write commands like these:

```sh
git checkout [SOME_COMMIT_HASH or BRANCH or TAG]
git diff [SOME_COMMIT_HASH or BRANCH or TAG] [SOME_COMMIT_HASH or BRANCH or TAG]
```

[fzf-git.sh](https://github.com/junegunn/fzf-git.sh) project defines a set of
fzf-based key bindings for Git objects. I strongly recommend that you check
them out because they are seriously useful.

### Files listed in `git status`

<kbd>CTRL-G</kbd><kbd>CTRL-F</kbd>

![image](https://user-images.githubusercontent.com/700826/113473779-a9d93b00-94a6-11eb-87b5-f62a8d0a0efc.png)

### Branches

<kbd>CTRL-G</kbd><kbd>CTRL-B</kbd>

![image](https://user-images.githubusercontent.com/700826/113473758-87dfb880-94a6-11eb-82f4-9218103f10bd.png)

### Commit hashes

<kbd>CTRL-G</kbd><kbd>CTRL-H</kbd>

![image](https://user-images.githubusercontent.com/700826/113473765-91692080-94a6-11eb-8d38-ed4d41f27ac1.png)

Color themes
------------

You can customize how fzf colors the text elements with `--color` option. Here
are a few color themes. Note that you need a terminal emulator that can
display 24-bit colors.

```sh
# junegunn/seoul256.vim (dark)
export FZF_DEFAULT_OPTS='--color=bg+:#3F3F3F,bg:#4B4B4B,border:#6B6B6B,spinner:#98BC99,hl:#719872,fg:#D9D9D9,header:#719872,info:#BDBB72,pointer:#E12672,marker:#E17899,fg+:#D9D9D9,preview-bg:#3F3F3F,prompt:#98BEDE,hl+:#98BC99'
```

![seoul256](https://user-images.githubusercontent.com/700826/113475011-2c192d80-94ae-11eb-9d17-1e5867bae01f.png)

```sh
# junegunn/seoul256.vim (light)
export FZF_DEFAULT_OPTS='--color=bg+:#D9D9D9,bg:#E1E1E1,border:#C8C8C8,spinner:#719899,hl:#719872,fg:#616161,header:#719872,info:#727100,pointer:#E12672,marker:#E17899,fg+:#616161,preview-bg:#D9D9D9,prompt:#0099BD,hl+:#719899'
```

![seoul256-light](https://user-images.githubusercontent.com/700826/113475022-389d8600-94ae-11eb-905f-0939dd535837.png)

```sh
# morhetz/gruvbox
export FZF_DEFAULT_OPTS='--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'
```

![gruvbox](https://user-images.githubusercontent.com/700826/113475042-494dfc00-94ae-11eb-9322-cd03a027305a.png)

```sh
# arcticicestudio/nord-vim
export FZF_DEFAULT_OPTS='--color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1'
```

![nord](https://user-images.githubusercontent.com/700826/113475063-67b3f780-94ae-11eb-9b24-5f0d22b63399.png)

```sh
# tomasr/molokai
export FZF_DEFAULT_OPTS='--color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672'
```

![molokai](https://user-images.githubusercontent.com/700826/113475085-8619f300-94ae-11eb-85e4-2766fc3246bf.png)

### Generating fzf color theme from Vim color schemes

The Vim plugin of fzf can generate `--color` option from the current color
scheme according to `g:fzf_colors` variable. You can find the detailed
explanation [here](https://github.com/junegunn/fzf/blob/master/README-VIM.md#explanation-of-gfzf_colors).

Here is an example. Add this to your Vim configuration file.

```vim
let g:fzf_colors =
\ { 'fg':         ['fg', 'Normal'],
  \ 'bg':         ['bg', 'Normal'],
  \ 'preview-bg': ['bg', 'NormalFloat'],
  \ 'hl':         ['fg', 'Comment'],
  \ 'fg+':        ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':        ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':        ['fg', 'Statement'],
  \ 'info':       ['fg', 'PreProc'],
  \ 'border':     ['fg', 'Ignore'],
  \ 'prompt':     ['fg', 'Conditional'],
  \ 'pointer':    ['fg', 'Exception'],
  \ 'marker':     ['fg', 'Keyword'],
  \ 'spinner':    ['fg', 'Label'],
  \ 'header':     ['fg', 'Comment'] }
```

Then you can see how the `--color` option is generated by printing the result
of `fzf#wrap()`.

```vim
:echo fzf#wrap()
```

Use this command to append `export FZF_DEFAULT_OPTS="..."` line to the end of
the current file.

```vim
:call append('$', printf('export FZF_DEFAULT_OPTS="%s"', matchstr(fzf#wrap().options, "--color[^']*")))
```
./BUILD.md	[[[1
49
Building fzf
============

Build instructions
------------------

### Prerequisites

- Go 1.17 or above

### Using Makefile

```sh
# Build fzf binary for your platform in target
make

# Build fzf binary and copy it to bin directory
make install

# Build fzf binaries and archives for all platforms using goreleaser
make build

# Publish GitHub release
make release
```

> :warning: Makefile uses git commands to determine the version and the
> revision information for `fzf --version`. So if you're building fzf from an
> environment where its git information is not available, you have to manually
> set `$FZF_VERSION` and `$FZF_REVISION`.
>
> e.g. `FZF_VERSION=0.24.0 FZF_REVISION=tarball make`

Third-party libraries used
--------------------------

- [mattn/go-runewidth](https://github.com/mattn/go-runewidth)
    - Licensed under [MIT](http://mattn.mit-license.org)
- [mattn/go-shellwords](https://github.com/mattn/go-shellwords)
    - Licensed under [MIT](http://mattn.mit-license.org)
- [mattn/go-isatty](https://github.com/mattn/go-isatty)
    - Licensed under [MIT](http://mattn.mit-license.org)
- [tcell](https://github.com/gdamore/tcell)
    - Licensed under [Apache License 2.0](https://github.com/gdamore/tcell/blob/master/LICENSE)

License
-------

[MIT](LICENSE)
./CHANGELOG.md	[[[1
1668
CHANGELOG
=========

0.42.0
------
- Added new info style: `--info=right`
- Added new info style: `--info=inline-right`
- Added new border style `thinblock` which uses symbols for legacy computing
  [one eighth block elements](https://en.wikipedia.org/wiki/Symbols_for_Legacy_Computing)
    - Similarly to `block`, this style is suitable when using a different
      background color because the window is completely contained within the border.
      ```sh
      BAT_THEME=GitHub fzf --info=right --border=thinblock --preview-window=border-thinblock \
          --margin=3 --scrollbar=▏▕ --preview='bat --color=always --style=numbers {}' \
          --color=light,query:238,fg:238,bg:251,bg+:249,gutter:251,border:248,preview-bg:253
      ```
    - This style may not render correctly depending on the font and the
      terminal emulator.

0.41.1
------
- Fixed a bug where preview window is not updated when `--disabled` is set and
  a reload is triggered by `change:reload` binding

0.41.0
------
- Added color name `preview-border` and `preview-scrollbar`
- Added new border style `block` which uses [block elements](https://en.wikipedia.org/wiki/Block_Elements)
- `--scrollbar` can take two characters, one for the main window, the other
  for the preview window
- Putting it altogether:
  ```sh
  fzf-tmux -p 80% --padding 1,2 --preview 'bat --style=plain --color=always {}' \
      --color 'bg:237,bg+:235,gutter:237,border:238,scrollbar:236' \
      --color 'preview-bg:235,preview-border:236,preview-scrollbar:234' \
      --preview-window 'border-block' --border block --scrollbar '▌▐'
  ```
- Bug fixes and improvements

0.40.0
------
- Added `zero` event that is triggered when there's no match
  ```sh
  # Reload the candidate list when there's no match
  echo $RANDOM | fzf --bind 'zero:reload(echo $RANDOM)+clear-query' --height 3
  ```
- New actions
    - Added `track` action which makes fzf track the current item when the
      search result is updated. If the user manually moves the cursor, or the
      item is not in the updated search result, tracking is automatically
      disabled. Tracking is useful when you want to see the surrounding items
      by deleting the query string.
      ```sh
      # Narrow down the list with a query, point to a command,
      # and hit CTRL-T to see its surrounding commands.
      export FZF_CTRL_R_OPTS="
        --preview 'echo {}' --preview-window up:3:hidden:wrap
        --bind 'ctrl-/:toggle-preview'
        --bind 'ctrl-t:track+clear-query'
        --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
        --color header:italic
        --header 'Press CTRL-Y to copy command into clipboard'"
      ```
    - Added `change-header(...)`
    - Added `transform-header(...)`
    - Added `toggle-track` action
- Fixed `--track` behavior when used with `--tac`
    - However, using `--track` with `--tac` is not recommended. The resulting
      behavior can be very confusing.
- Bug fixes and improvements

0.39.0
------
- Added `one` event that is triggered when there's only one match
  ```sh
  # Automatically select the only match
  seq 10 | fzf --bind one:accept
  ```
- Added `--track` option that makes fzf track the current selection when the
  result list is updated. This can be useful when browsing logs using fzf with
  sorting disabled.
  ```sh
  git log --oneline --graph --color=always | nl |
      fzf --ansi --track --no-sort --layout=reverse-list
  ```
- If you use `--listen` option without a port number fzf will automatically
  allocate an available port and export it as `$FZF_PORT` environment
  variable.
  ```sh
  # Automatic port assignment
  fzf --listen --bind 'start:execute-silent:echo $FZF_PORT > /tmp/fzf-port'

  # Say hello
  curl "localhost:$(cat /tmp/fzf-port)" -d 'preview:echo Hello, fzf is listening on $FZF_PORT.'
  ```
- A carriage return and a line feed character will be rendered as dim ␍ and
  ␊ respectively.
  ```sh
  printf "foo\rbar\nbaz" | fzf --read0 --preview 'echo {}'
  ```
- fzf will stop rendering a non-displayable characters as a space. This will
  likely cause less glitches in the preview window.
  ```sh
  fzf --preview 'head -1000 /dev/random'
  ```
- Bug fixes and improvements

0.38.0
------
- New actions
    - `become(...)` - Replace the current fzf process with the specified
      command using `execve(2)` system call.
      See https://github.com/junegunn/fzf#turning-into-a-different-process for
      more information.
      ```sh
      # Open selected files in Vim
      fzf --multi --bind 'enter:become(vim {+})'

      # Open the file in Vim and go to the line
      git grep --line-number . |
          fzf --delimiter : --nth 3.. --bind 'enter:become(vim {1} +{2})'
      ```
        - This action is not supported on Windows
    - `show-preview`
    - `hide-preview`
- Bug fixes
    - `--preview-window 0,hidden` should not execute the preview command until
      `toggle-preview` action is triggered

0.37.0
------
- Added a way to customize the separator of inline info
  ```sh
  fzf --info 'inline: ╱ ' --prompt '╱ ' --color prompt:bright-yellow
  ```
- New event
    - `focus` - Triggered when the focus changes due to a vertical cursor
      movement or a search result update
      ```sh
      fzf --bind 'focus:transform-preview-label:echo [ {} ]' --preview 'cat {}'

      # Any action bound to the event runs synchronously and thus can make the interface sluggish
      # e.g. lolcat isn't one of the fastest programs, and every cursor movement in
      #      fzf will be noticeably affected by its execution time
      fzf --bind 'focus:transform-preview-label:echo [ {} ] | lolcat -f' --preview 'cat {}'

      # Beware not to introduce an infinite loop
      seq 10 | fzf --bind 'focus:up' --cycle
      ```
- New actions
    - `change-border-label`
    - `change-preview-label`
    - `transform-border-label`
    - `transform-preview-label`
- Bug fixes and improvements

0.36.0
------
- Added `--listen=HTTP_PORT` option to start HTTP server. It allows external
  processes to send actions to perform via POST method.
  ```sh
  # Start HTTP server on port 6266
  fzf --listen 6266

  # Send actions to the server
  curl -XPOST localhost:6266 -d 'reload(seq 100)+change-prompt(hundred> )'
  ```
- Added draggable scrollbar to the main search window and the preview window
  ```sh
  # Hide scrollbar
  fzf --no-scrollbar

  # Customize scrollbar
  fzf --scrollbar ┆ --color scrollbar:blue
  ```
- New event
    - Added `load` event that is triggered when the input stream is complete
      and the initial processing of the list is complete.
      ```sh
      # Change the prompt to "loaded" when the input stream is complete
      (seq 10; sleep 1; seq 11 20) | fzf --prompt 'Loading> ' --bind 'load:change-prompt:Loaded> '

      # You can use it instead of 'start' event without `--sync` if asynchronous
      # trigger is not an issue.
      (seq 10; sleep 1; seq 11 20) | fzf --bind 'load:last'
      ```
- New actions
    - Added `pos(...)` action to move the cursor to the numeric position
        - `first` and `last` are equivalent to `pos(1)` and `pos(-1)` respectively
      ```sh
      # Put the cursor on the 10th item
      seq 100 | fzf --sync --bind 'start:pos(10)'

      # Put the cursor on the 10th to last item
      seq 100 | fzf --sync --bind 'start:pos(-10)'
      ```
    - Added `reload-sync(...)` action which replaces the current list only after
      the reload process is complete. This is useful when the command takes
      a while to produce the initial output and you don't want fzf to run against
      an empty list while the command is running.
      ```sh
      # You can still filter and select entries from the initial list for 3 seconds
      seq 100 | fzf --bind 'load:reload-sync(sleep 3; seq 1000)+unbind(load)'
      ```
    - Added `next-selected` and `prev-selected` actions to move between selected
      items
      ```sh
      # `next-selected` will move the pointer to the next selected item below the current line
      # `prev-selected` will move the pointer to the previous selected item above the current line
      seq 10 | fzf --multi --bind ctrl-n:next-selected,ctrl-p:prev-selected

      # Both actions respect --layout option
      seq 10 | fzf --multi --bind ctrl-n:next-selected,ctrl-p:prev-selected --layout reverse
      ```
    - Added `change-query(...)` action that simply changes the query string to the
      given static string. This can be useful when used with `--listen`.
      ```sh
      curl localhost:6266 -d "change-query:$(date)"
      ```
    - Added `transform-prompt(...)` action for transforming the prompt string
      using an external command
      ```sh
      # Press space to change the prompt string using an external command
      # (only the first line of the output is taken)
      fzf --bind 'space:reload(ls),load:transform-prompt(printf "%s> " "$(date)")'
      ```
    - Added `transform-query(...)` action for transforming the query string using
      an external command
      ```sh
      # Press space to convert the query to uppercase letters
      fzf --bind 'space:transform-query(tr "[:lower:]" "[:upper:]" <<< {q})'

      # Bind it to 'change' event for automatic conversion
      fzf --bind 'change:transform-query(tr "[:lower:]" "[:upper:]" <<< {q})'

      # Can only type numbers
      fzf --bind 'change:transform-query(sed "s/[^0-9]//g" <<< {q})'
      ```
    - `put` action can optionally take an argument string
      ```sh
      # a will put 'alpha' on the prompt, ctrl-b will put 'bravo'
      fzf --bind 'a:put+put(lpha),ctrl-b:put(bravo)'
      ```
- Added color name `preview-label` for `--preview-label` (defaults to `label`
  for `--border-label`)
- Better support for (Windows) terminals where each box-drawing character
  takes 2 columns. Set `RUNEWIDTH_EASTASIAN` environment variable to `0` or `1`.
    - On Vim, the variable will be automatically set if `&ambiwidth` is `double`
- Behavior changes
    - fzf will always execute the preview command if the command template
      contains `{q}` even when it's empty. If you prefer the old behavior,
      you'll have to check if `{q}` is empty in your command.
      ```sh
      # This will show // even when the query is empty
      : | fzf --preview 'echo /{q}/'

      # But if you don't want it,
      : | fzf --preview '[ -n {q} ] || exit; echo /{q}/'
      ```
    - `double-click` will behave the same as `enter` unless otherwise specified,
      so you don't have to repeat the same action twice in `--bind` in most cases.
      ```sh
      # No need to bind 'double-click' to the same action
      fzf --bind 'enter:execute:less {}' # --bind 'double-click:execute:less {}'
      ```
    - If the color for `separator` is not specified, it will default to the
      color for `border`. Same holds true for `scrollbar`. This is to reduce
      the number of configuration items required to achieve a consistent color
      scheme.
    - If `follow` flag is specified in `--preview-window` option, fzf will
      automatically scroll to the bottom of the streaming preview output. But
      when the user manually scrolls the window, the following stops. With
      this version, fzf will resume following if the user scrolls the window
      to the bottom.
    - Default border style on Windows is changed to `sharp` because some
      Windows terminals are not capable of displaying `rounded` border
      characters correctly.
- Minor bug fixes and improvements

0.35.1
------
- Fixed a bug where fzf with `--tiebreak=chunk` crashes on inverse match query
- Fixed a bug where clicking above fzf would paste escape sequences

0.35.0
------
- Added `start` event that is triggered only once when fzf finder starts.
  Since fzf consumes the input stream asynchronously, the input list is not
  available unless you use `--sync`.
  ```sh
  seq 100 | fzf --multi --sync --bind 'start:last+select-all+preview(echo welcome)'
  ```
- Added `--border-label` and `--border-label-pos` for putting label on the border
  ```sh
  # ANSI color codes are supported
  # (with https://github.com/busyloop/lolcat)
  label=$(curl -s http://metaphorpsum.com/sentences/1 | lolcat -f)

  # Border label at the center
  fzf --height=10 --border --border-label="╢ $label ╟" --color=label:italic:black

  # Left-aligned (positive integer)
  fzf --height=10 --border --border-label="╢ $label ╟" --border-label-pos=3 --color=label:italic:black

  # Right-aligned (negative integer) on the bottom line (:bottom)
  fzf --height=10 --border --border-label="╢ $label ╟" --border-label-pos=-3:bottom --color=label:italic:black
  ```
- Also added `--preview-label` and `--preview-label-pos` for the border of the
  preview window
  ```sh
  fzf --preview 'cat {}' --border --preview-label=' Preview ' --preview-label-pos=2
  ```
- Info panel (match counter) will be followed by a horizontal separator by
  default
    - Use `--no-separator` or `--separator=''` to hide the separator
    - You can specify an arbitrary string that is repeated to form the
      horizontal separator. e.g. `--separator=╸`
    - The color of the separator can be customized via `--color=separator:...`
    - ANSI color codes are also supported
  ```sh
  fzf --separator=╸ --color=separator:green
  fzf --separator=$(lolcat -f -F 1.4 <<< ▁▁▂▃▄▅▆▆▅▄▃▂▁▁) --info=inline
  ```
- Added `--border=bold` and `--border=double` along with
  `--preview-window=border-bold` and `--preview-window=border-double`

0.34.0
------
- Added support for adaptive `--height`. If the `--height` value is prefixed
  with `~`, fzf will automatically determine the height in the range according
  to the input size.
  ```sh
  seq 1 | fzf --height ~70% --border --padding 1 --margin 1
  seq 10 | fzf --height ~70% --border --padding 1 --margin 1
  seq 100 | fzf --height ~70% --border --padding 1 --margin 1
  ```
    - There are a few limitations
        - Not compatible with percent top/bottom margin/padding
          ```sh
          # This is not allowed (top/bottom margin in percent value)
          fzf --height ~50% --border --margin 5%,10%

          # This is allowed (top/bottom margin in fixed value)
          fzf --height ~50% --border --margin 2,10%
          ```
        - fzf will not start until it can determine the right height for the input
          ```sh
          # fzf will open immediately
          (sleep 2; seq 10) | fzf --height 50%

          # fzf will open after 2 seconds
          (sleep 2; seq 10) | fzf --height ~50%
          (sleep 2; seq 1000) | fzf --height ~50%
          ```
- Fixed tcell renderer used to render full-screen fzf on Windows
- `--no-clear` is deprecated. Use `reload` action instead.

0.33.0
------
- Added `--scheme=[default|path|history]` option to choose scoring scheme
    - (Experimental)
    - We updated the scoring algorithm in 0.32.0, however we have learned that
      this new scheme (`default`) is not always giving the optimal result
    - `path`: Additional bonus point is only given to the characters after
      path separator. You might want to choose this scheme if you have many
      files with spaces in their paths.
    - `history`: No additional bonus points are given so that we give more
      weight to the chronological ordering. This is equivalent to the scoring
      scheme before 0.32.0. This also sets `--tiebreak=index`.
- ANSI color sequences with colon delimiters are now supported.
  ```sh
  printf "\e[38;5;208mOption 1\e[m\nOption 2" | fzf --ansi
  printf "\e[38:5:208mOption 1\e[m\nOption 2" | fzf --ansi
  ```
- Support `border-{up,down}` as the synonyms for `border-{top,bottom}` in
  `--preview-window`
- Added support for ANSI `strikethrough`
  ```sh
  printf "\e[9mdeleted" | fzf --ansi
  fzf --color fg+:strikethrough
  ```

0.32.1
------
- Fixed incorrect ordering of `--tiebreak=chunk`
- fzf-tmux will show fzf border instead of tmux popup border (requires tmux 3.3)
  ```sh
  fzf-tmux -p70%
  fzf-tmux -p70% --color=border:bright-red
  fzf-tmux -p100%,60% --color=border:bright-yellow --border=horizontal --padding 1,5 --margin 1,0
  fzf-tmux -p70%,100% --color=border:bright-green --border=vertical

  # Key bindings (CTRL-T, CTRL-R, ALT-C) will use these options
  export FZF_TMUX_OPTS='-p100%,60% --color=border:green --border=horizontal --padding 1,5 --margin 1,0'
  ```

0.32.0
------
- Updated the scoring algorithm
    - Different bonus points to different categories of word boundaries
      (listed higher to lower bonus point)
        - Word after whitespace characters or beginning of the string
        - Word after common delimiter characters (`/,:;|`)
        - Word after other non-word characters
      ```sh
      # foo/bar.sh` is preferred over `foo-bar.sh` on `bar`
      fzf --query=bar --height=4 << EOF
      foo-bar.sh
      foo/bar.sh
      EOF
      ```
- Added a new tiebreak `chunk`
    - Favors the line with shorter matched chunk. A chunk is a set of
      consecutive non-whitespace characters.
    - Unlike the default `length`, this scheme works well with tabular input
      ```sh
      # length prefers item #1, because the whole line is shorter,
      # chunk prefers item #2, because the matched chunk ("foo") is shorter
      fzf --height=6 --header-lines=2 --tiebreak=chunk --reverse --query=fo << "EOF"
      N | Field1 | Field2 | Field3
      - | ------ | ------ | ------
      1 | hello  | foobar | baz
      2 | world  | foo    | bazbaz
      EOF
      ```
    - If the input does not contain any spaces, `chunk` is equivalent to
      `length`. But we're not going to set it as the default because it is
      computationally more expensive.
- Bug fixes and improvements

0.31.0
------
- Added support for an alternative preview window layout that is activated
  when the size of the preview window is smaller than a certain threshold.
  ```sh
  # If the width of the preview window is smaller than 50 columns,
  # it will be displayed above the search window.
  fzf --preview 'cat {}' --preview-window 'right,50%,border-left,<50(up,30%,border-bottom)'

  # Or you can just hide it like so
  fzf --preview 'cat {}' --preview-window '<50(hidden)'
  ```
- fzf now uses SGR mouse mode to properly support mouse on larger terminals
- You can now use characters that do not satisfy `unicode.IsGraphic` constraint
  for `--marker`, `--pointer`, and `--ellipsis`. Allows Nerd Fonts and stuff.
  Use at your own risk.
- Bug fixes and improvements
- Shell extension
    - `kill` completion now requires trigger sequence (`**`) for consistency

0.30.0
------
- Fixed cursor flickering over the screen by hiding it during rendering
- Added `--ellipsis` option. You can take advantage of it to make fzf
  effectively search non-visible parts of the item.
  ```sh
  # Search against hidden line numbers on the far right
  nl /usr/share/dict/words                  |
    awk '{printf "%s%1000s\n", $2, $1}'     |
    fzf --nth=-1 --no-hscroll --ellipsis='' |
    awk '{print $2}'
  ```
- Added `rebind` action for restoring bindings after `unbind`
- Bug fixes and improvements

0.29.0
------
- Added `change-preview(...)` action to change the `--preview` command
    - cf. `preview(...)` is a one-off action that doesn't change the default
      preview command
- Added `change-preview-window(...)` action
    - You can rotate through the different options separated by `|`
      ```sh
      fzf --preview 'cat {}' --preview-window right:40% \
          --bind 'ctrl-/:change-preview-window(right,70%|down,40%,border-top|hidden|)'
      ```
- Fixed rendering of the prompt line when overflow occurs with `--info=inline`

0.28.0
------
- Added `--header-first` option to print header before the prompt line
  ```sh
  fzf --header $'Welcome to fzf\n▔▔▔▔▔▔▔▔▔▔▔▔▔▔' --reverse --height 30% --border --header-first
  ```
- Added `--scroll-off=LINES` option (similar to `scrolloff` option of Vim)
    - You can set it to a very large number so that the cursor stays in the
      middle of the screen while scrolling
      ```sh
      fzf --scroll-off=5
      fzf --scroll-off=999
      ```
- Fixed bug where preview window is not updated on `reload` (#2644)
- fzf on Windows will also use `$SHELL` to execute external programs
    - See #2638 and #2647
    - Thanks to @rashil2000, @vovcacik, and @janlazo

0.27.3
------
- Preview window is `hidden` by default when there are `preview` bindings but
  `--preview` command is not given
- Fixed bug where `{n}` is not properly reset on `reload`
- Fixed bug where spinner is not displayed on `reload`
- Enhancements in tcell renderer for Windows (#2616)
- Vim plugin
    - `sinklist` is added as a synonym to `sink*` so that it's easier to add
      a function to a spec dictionary
      ```vim
      let spec = { 'source': 'ls', 'options': ['--multi', '--preview', 'cat {}'] }
      function spec.sinklist(matches)
        echom string(a:matches)
      endfunction

      call fzf#run(fzf#wrap(spec))
      ```
    - Vim 7 compatibility

0.27.2
------
- 16 base ANSI colors can be specified by their names
  ```sh
  fzf --color fg:3,fg+:11
  fzf --color fg:yellow,fg+:bright-yellow
  ```
- Fix bug where `--read0` not properly displaying long lines

0.27.1
------
- Added `unbind` action. In the following Ripgrep launcher example, you can
  use `unbind(reload)` to switch to fzf-only filtering mode.
    - See https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-to-fzf-only-search-mode
- Vim plugin
    - Vim plugin will stop immediately even when the source command hasn't finished
      ```vim
      " fzf will read the stream file while allowing other processes to append to it
      call fzf#run({'source': 'cat /dev/null > /tmp/stream; tail -f /tmp/stream'})
      ```
    - It is now possible to open popup window relative to the current window
      ```vim
      let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }
      ```

0.27.0
------
- More border options for `--preview-window`
  ```sh
  fzf --preview 'cat {}' --preview-window border-left
  fzf --preview 'cat {}' --preview-window border-left --border horizontal
  fzf --preview 'cat {}' --preview-window top:border-bottom
  fzf --preview 'cat {}' --preview-window top:border-horizontal
  ```
- Automatically set `/dev/tty` as STDIN on execute action
  ```sh
  # Redirect /dev/tty to suppress "Vim: Warning: Input is not from a terminal"
  # ls | fzf --bind "enter:execute(vim {} < /dev/tty)"

  # "< /dev/tty" part is no longer needed
  ls | fzf --bind "enter:execute(vim {})"
  ```
- Bug fixes and improvements
- Signed and notarized macOS binaries
  (Huge thanks to [BACKERS.md](https://github.com/junegunn/junegunn/blob/main/BACKERS.md)!)

0.26.0
------
- Added support for fixed header in preview window
  ```sh
  # Display top 3 lines as the fixed header
  fzf --preview 'bat --style=header,grid --color=always {}' --preview-window '~3'
  ```
- More advanced preview offset expression to better support the fixed header
  ```sh
  # Preview with bat, matching line in the middle of the window below
  # the fixed header of the top 3 lines
  #
  #   ~3    Top 3 lines as the fixed header
  #   +{2}  Base scroll offset extracted from the second field
  #   +3    Extra offset to compensate for the 3-line header
  #   /2    Put in the middle of the preview area
  #
  git grep --line-number '' |
    fzf --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~3:+{2}+3/2'
  ```
- Added `select` and `deselect` action for unconditionally selecting or
  deselecting a single item in `--multi` mode. Complements `toggle` action.
- Significant performance improvement in ANSI code processing
- Bug fixes and improvements
- Built with Go 1.16

0.25.1
------
- Added `close` action
    - Close preview window if open, abort fzf otherwise
- Bug fixes and improvements

0.25.0
------
- Text attributes set in `--color` are not reset when fzf sees another
  `--color` option for the same element. This allows you to put custom text
  attributes in your `$FZF_DEFAULT_OPTS` and still have those attributes
  even when you override the colors.

  ```sh
  # Default colors and attributes
  fzf

  # Apply custom text attributes
  export FZF_DEFAULT_OPTS='--color fg+:italic,hl:-1:underline,hl+:-1:reverse:underline'

  fzf

  # Different colors but you still have the attributes
  fzf --color hl:176,hl+:177

  # Write "regular" if you want to clear the attributes
  fzf --color hl:176:regular,hl+:177:regular
  ```
- Renamed `--phony` to `--disabled`
- You can dynamically enable and disable the search functionality using the
  new `enable-search`, `disable-search`, and `toggle-search` actions
- You can assign a different color to the query string for when search is disabled
  ```sh
  fzf --color query:#ffffff,disabled:#999999 --bind space:toggle-search
  ```
- Added `last` action to move the cursor to the last match
    - The opposite action `top` is renamed to `first`, but `top` is still
      recognized as a synonym for backward compatibility
- Added `preview-top` and `preview-bottom` actions
- Extended support for alt key chords: alt with any case-sensitive single character
  ```sh
  fzf --bind alt-,:first,alt-.:last
  ```

0.24.4
------
- Added `--preview-window` option `follow`
  ```sh
  # Preview window will automatically scroll to the bottom
  fzf --preview-window follow --preview 'for i in $(seq 100000); do
    echo "$i"
    sleep 0.01
    (( i % 300 == 0 )) && printf "\033[2J"
  done'
  ```
- Added `change-prompt` action
  ```sh
  fzf --prompt 'foo> ' --bind $'a:change-prompt:\x1b[31mbar> '
  ```
- Bug fixes and improvements

0.24.3
------
- Added `--padding` option
  ```sh
  fzf --margin 5% --padding 5% --border --preview 'cat {}' \
      --color bg:#222222,preview-bg:#333333
  ```

0.24.2
------
- Bug fixes and improvements

0.24.1
------
- Fixed broken `--color=[bw|no]` option

0.24.0
------
- Real-time rendering of preview window
  ```sh
  # fzf can render preview window before the command completes
  fzf --preview 'sleep 1; for i in $(seq 100); do echo $i; sleep 0.01; done'

  # Preview window can process ANSI escape sequence (CSI 2 J) for clearing the display
  fzf --preview 'for i in $(seq 100000); do
    (( i % 200 == 0 )) && printf "\033[2J"
    echo "$i"
    sleep 0.01
  done'
  ```
- Updated `--color` option to support text styles
  - `regular` / `bold` / `dim` / `underline` / `italic` / `reverse` / `blink`
    ```sh
    # * Set -1 to keep the original color
    # * Multiple style attributes can be combined
    # * Italic style may not be supported by some terminals
    rg --line-number --no-heading --color=always "" |
      fzf --ansi --prompt "Rg: " \
          --color fg+:italic,hl:underline:-1,hl+:italic:underline:reverse:-1 \
          --color pointer:reverse,prompt:reverse,input:159 \
          --pointer '  '
    ```
- More `--border` options
  - `vertical`, `top`, `bottom`, `left`, `right`
  - Updated Vim plugin to use these new `--border` options
    ```vim
    " Floating popup window in the center of the screen
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

    " Popup with 100% width
    let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 0.5, 'border': 'horizontal' } }

    " Popup with 100% height
    let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 1.0, 'border': 'vertical' } }

    " Similar to 'down' layout, but it uses a popup window and doesn't affect the window layout
    let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 0.5, 'yoffset': 1.0, 'border': 'top' } }

    " Opens on the right;
    "   'highlight' option is still supported but it will only take the foreground color of the group
    let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 1.0, 'xoffset': 1.0, 'border': 'left', 'highlight': 'Comment' } }
    ```
- To indicate if `--multi` mode is enabled, fzf will print the number of
  selected items even when no item is selected
  ```sh
  seq 100 | fzf
    # 100/100
  seq 100 | fzf --multi
    # 100/100 (0)
  seq 100 | fzf --multi 5
    # 100/100 (0/5)
  ```
- Since 0.24.0, release binaries will be uploaded to https://github.com/junegunn/fzf/releases

0.23.1
------
- Added `--preview-window` options for disabling flags
    - `nocycle`
    - `nohidden`
    - `nowrap`
    - `default`
- Built with Go 1.14.9 due to performance regression
    - https://github.com/golang/go/issues/40727

0.23.0
------
- Support preview scroll offset relative to window height
  ```sh
  git grep --line-number '' |
    fzf --delimiter : \
        --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
        --preview-window +{2}-/2
  ```
- Added `--preview-window` option for sharp edges (`--preview-window sharp`)
- Added `--preview-window` option for cyclic scrolling (`--preview-window cycle`)
- Reduced vertical padding around the preview window when `--preview-window
  noborder` is used
- Added actions for preview window
    - `preview-half-page-up`
    - `preview-half-page-down`
- Vim
    - Popup width and height can be given in absolute integer values
    - Added `fzf#exec()` function for getting the path of fzf executable
        - It also downloads the latest binary if it's not available by running
          `./install --bin`
- Built with Go 1.15.2
    - We no longer provide 32-bit binaries

0.22.0
------
- Added more options for `--bind`
    - `backward-eof` event
      ```sh
      # Aborts when you delete backward when the query prompt is already empty
      fzf --bind backward-eof:abort
      ```
    - `refresh-preview` action
      ```sh
      # Rerun preview command when you hit '?'
      fzf --preview 'echo $RANDOM' --bind '?:refresh-preview'
      ```
    - `preview` action
      ```sh
      # Default preview command with an extra preview binding
      fzf --preview 'file {}' --bind '?:preview:cat {}'

      # A preview binding with no default preview command
      # (Preview window is initially empty)
      fzf --bind '?:preview:cat {}'

      # Preview window hidden by default, it appears when you first hit '?'
      fzf --bind '?:preview:cat {}' --preview-window hidden
      ```
- Added preview window option for setting the initial scroll offset
  ```sh
  # Initial scroll offset is set to the line number of each line of
  # git grep output *minus* 5 lines
  git grep --line-number '' |
    fzf --delimiter : --preview 'nl {1}' --preview-window +{2}-5
  ```
- Added support for ANSI colors in `--prompt` string
- Smart match of accented characters
    - An unaccented character in the query string will match both accented and
      unaccented characters, while an accented character will only match
      accented characters. This is similar to how "smart-case" match works.
- Vim plugin
    - `tmux` layout option for using fzf-tmux
      ```vim
      let g:fzf_layout = { 'tmux': '-p90%,60%' }
      ```

0.21.1
------
- Shell extension
    - CTRL-R will remove duplicate commands
- fzf-tmux
    - Supports tmux popup window (require tmux 3.2 or above)
        - ```sh
          # 50% width and height
          fzf-tmux -p

          # 80% width and height
          fzf-tmux -p 80%

          # 80% width and 40% height
          fzf-tmux -p 80%,40%
          fzf-tmux -w 80% -h 40%

          # Window position
          fzf-tmux -w 80% -h 40% -x 0 -y 0
          fzf-tmux -w 80% -h 40% -y 1000

          # Write ordinary fzf options after --
          fzf-tmux -p -- --reverse --info=inline --margin 2,4 --border
          ```
        - On macOS, you can build the latest tmux from the source with
          `brew install tmux --HEAD`
- Bug fixes
    - Fixed Windows file traversal not to include directories
    - Fixed ANSI colors with `--keep-right`
    - Fixed _fzf_complete for zsh
- Built with Go 1.14.1

0.21.0
------
- `--height` option is now available on Windows as well (@kelleyma49)
- Added `--pointer` and `--marker` options
- Added `--keep-right` option that keeps the right end of the line visible
  when it's too long
- Style changes
    - `--border` will now print border with rounded corners around the
      finder instead of printing horizontal lines above and below it.
      The previous style is available via `--border=horizontal`
    - Unicode spinner
- More keys and actions for `--bind`
- Added PowerShell script for downloading Windows binary
- Vim plugin: Built-in floating windows support
  ```vim
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
  ```
- bash: Various improvements in key bindings (CTRL-T, CTRL-R, ALT-C)
    - CTRL-R will start with the current command-line as the initial query
    - CTRL-R properly supports multi-line commands
- Fuzzy completion API changed
  ```sh
  # Previous: fzf arguments given as a single string argument
  # - This style is still supported, but it's deprecated
  _fzf_complete "--multi --reverse --prompt=\"doge> \"" "$@" < <(
    echo foo
  )

  # New API: multiple fzf arguments before "--"
  # - Easier to write multiple options
  _fzf_complete --multi --reverse --prompt="doge> " -- "$@" < <(
    echo foo
  )
  ```
- Bug fixes and improvements

0.20.0
------
- Customizable preview window color (`preview-fg` and `preview-bg` for `--color`)
  ```sh
  fzf --preview 'cat {}' \
      --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899' \
      --border --height 20 --layout reverse --info inline
  ```
- Removed the immediate flicking of the screen on `reload` action.
  ```sh
  : | fzf --bind 'change:reload:seq {q}' --phony
  ```
- Added `clear-query` and `clear-selection` actions for `--bind`
- It is now possible to split a composite bind action over multiple `--bind`
  expressions by prefixing the later ones with `+`.
  ```sh
  fzf --bind 'ctrl-a:up+up'

  # Can be now written as
  fzf --bind 'ctrl-a:up' --bind 'ctrl-a:+up'

  # This is useful when you need to write special execute/reload form (i.e. `execute:...`)
  # to avoid parse errors and add more actions to the same key
  fzf --multi --bind 'ctrl-l:select-all+execute:less {+f}' --bind 'ctrl-l:+deselect-all'
  ```
- Fixed parse error of `--bind` expression where concatenated execute/reload
  action contains `+` character.
  ```sh
  fzf --multi --bind 'ctrl-l:select-all+execute(less {+f})+deselect-all'
  ```
- Fixed bugs of reload action
    - Not triggered when there's no match even when the command doesn't have
      any placeholder expressions
    - Screen not properly cleared when `--header-lines` not filled on reload

0.19.0
------

- Added `--phony` option which completely disables search functionality.
  Useful when you want to use fzf only as a selector interface. See below.
- Added "reload" action for dynamically updating the input list without
  restarting fzf. See https://github.com/junegunn/fzf/issues/1750 to learn
  more about it.
  ```sh
  # Using fzf as the selector interface for ripgrep
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  INITIAL_QUERY="foo"
  FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY' || true" \
    fzf --bind "change:reload:$RG_PREFIX {q} || true" \
        --ansi --phony --query "$INITIAL_QUERY"
  ```
- `--multi` now takes an optional integer argument which indicates the maximum
  number of items that can be selected
  ```sh
  seq 100 | fzf --multi 3 --reverse --height 50%
  ```
- If a placeholder expression for `--preview` and `execute` action (and the
  new `reload` action) contains `f` flag, it is replaced to the
  path of a temporary file that holds the evaluated list. This is useful
  when you multi-select a large number of items and the length of the
  evaluated string may exceed [`ARG_MAX`][argmax].
  ```sh
  # Press CTRL-A to select 100K items and see the sum of all the numbers
  seq 100000 | fzf --multi --bind ctrl-a:select-all \
                   --preview "awk '{sum+=\$1} END {print sum}' {+f}"
  ```
- `deselect-all` no longer deselects unmatched items. It is now consistent
  with `select-all` and `toggle-all` in that it only affects matched items.
- Due to the limitation of bash, fuzzy completion is enabled by default for
  a fixed set of commands. A helper function for easily setting up fuzzy
  completion for any command is now provided.
  ```sh
  # usage: _fzf_setup_completion path|dir COMMANDS...
  _fzf_setup_completion path git kubectl
  ```
- Info line style can be changed by `--info=STYLE`
    - `--info=default`
    - `--info=inline` (same as old `--inline-info`)
    - `--info=hidden`
- Preview window border can be disabled by adding `noborder` to
  `--preview-window`.
- When you transform the input with `--with-nth`, the trailing white spaces
  are removed.
- `ctrl-\`, `ctrl-]`, `ctrl-^`, and `ctrl-/` can now be used with `--bind`
- See https://github.com/junegunn/fzf/milestone/15?closed=1 for more details

[argmax]: https://unix.stackexchange.com/questions/120642/what-defines-the-maximum-size-for-a-command-single-argument

0.18.0
------

- Added placeholder expression for zero-based item index: `{n}` and `{+n}`
    - `fzf --preview 'echo {n}: {}'`
- Added color option for the gutter: `--color gutter:-1`
- Added `--no-unicode` option for drawing borders in non-Unicode, ASCII
  characters
- `FZF_PREVIEW_LINES` and `FZF_PREVIEW_COLUMNS` are exported to preview process
    - fzf still overrides `LINES` and `COLUMNS` as before, but they may be
      reset by the default shell.
- Bug fixes and improvements
    - See https://github.com/junegunn/fzf/milestone/14?closed=1
- Built with Go 1.12.1

0.17.5
------

- Bug fixes and improvements
    - See https://github.com/junegunn/fzf/milestone/13?closed=1
- Search query longer than the screen width is allowed (up to 300 chars)
- Built with Go 1.11.1

0.17.4
------

- Added `--layout` option with a new layout called `reverse-list`.
    - `--layout=reverse` is a synonym for `--reverse`
    - `--layout=default` is a synonym for `--no-reverse`
- Preview window will be updated even when there is no match for the query
  if any of the placeholder expressions (e.g. `{q}`, `{+}`) evaluates to
  a non-empty string.
- More keys for binding: `shift-{up,down}`, `alt-{up,down,left,right}`
- fzf can now start even when `/dev/tty` is not available by making an
  educated guess.
- Updated the default command for Windows.
- Fixes and improvements on bash/zsh completion
- install and uninstall scripts now supports generating files under
  `XDG_CONFIG_HOME` on `--xdg` flag.

See https://github.com/junegunn/fzf/milestone/12?closed=1 for the full list of
changes.

0.17.3
------
- `$LINES` and `$COLUMNS` are exported to preview command so that the command
  knows the exact size of the preview window.
- Better error messages when the default command or `$FZF_DEFAULT_COMMAND`
  fails.
- Reverted #1061 to avoid having duplicate entries in the list when find
  command detected a file system loop (#1120). The default command now
  requires that find supports `-fstype` option.
- fzf now distinguishes mouse left click and right click (#1130)
    - Right click is now bound to `toggle` action by default
    - `--bind` understands `left-click` and `right-click`
- Added `replace-query` action (#1137)
    - Replaces query string with the current selection
- Added `accept-non-empty` action (#1162)
    - Same as accept, except that it prevents fzf from exiting without any
      selection

0.17.1
------

- Fixed custom background color of preview window (#1046)
- Fixed background color issues of Windows binary
- Fixed Windows binary to execute command using cmd.exe with no parsing and
  escaping (#1072)
- Added support for `window` layout on Vim 8 using Vim 8 terminal (#1055)

0.17.0-2
--------

A maintenance release for auxiliary scripts. fzf binaries are not updated.

- Experimental support for the builtin terminal of Vim 8
    - fzf can now run inside GVim
- Updated Vim plugin to better handle `&shell` issue on fish
- Fixed a bug of fzf-tmux where invalid output is generated
- Fixed fzf-tmux to work even when `tput` does not work

0.17.0
------
- Performance optimization
- One can match literal spaces in extended-search mode with a space prepended
  by a backslash.
- `--expect` is now additive and can be specified multiple times.

0.16.11
-------
- Performance optimization
- Fixed missing preview update

0.16.10
-------
- Fixed invalid handling of ANSI colors in preview window
- Further improved `--ansi` performance

0.16.9
------
- Memory and performance optimization
    - Around 20% performance improvement for general use cases
    - Up to 5x faster processing of `--ansi`
    - Up to 50% reduction of memory usage
- Bug fixes and usability improvements
    - Fixed handling of bracketed paste mode
    - [ERROR] on info line when the default command failed
    - More efficient rendering of preview window
    - `--no-clear` updated for repetitive relaunching scenarios

0.16.8
------
- New `change` event and `top` action for `--bind`
    - `fzf --bind change:top`
        - Move cursor to the top result whenever the query string is changed
    - `fzf --bind 'ctrl-w:unix-word-rubout+top,ctrl-u:unix-line-discard+top'`
        - `top` combined with `unix-word-rubout` and `unix-line-discard`
- Fixed inconsistent tiebreak scores when `--nth` is used
- Proper display of tab characters in `--prompt`
- Fixed not to `--cycle` on page-up/page-down to prevent overshoot
- Git revision in `--version` output
- Basic support for Cygwin environment
- Many fixes in Vim plugin on Windows/Cygwin (thanks to @janlazo)

0.16.7
------
- Added support for `ctrl-alt-[a-z]` key chords
- CTRL-Z (SIGSTOP) now works with fzf
- fzf will export `$FZF_PREVIEW_WINDOW` so that the scripts can use it
- Bug fixes and improvements in Vim plugin and shell extensions

0.16.6
------
- Minor bug fixes and improvements
- Added `--no-clear` option for scripting purposes

0.16.5
------
- Minor bug fixes
- Added `toggle-preview-wrap` action
- Built with Go 1.8

0.16.4
------
- Added `--border` option to draw border above and below the finder
- Bug fixes and improvements

0.16.3
------
- Fixed a bug where fzf incorrectly display the lines when straddling tab
  characters are trimmed
- Placeholder expression used in `--preview` and `execute` action can
  optionally take `+` flag to be used with multiple selections
    - e.g. `git log --oneline | fzf --multi --preview 'git show {+1}'`
- Added `execute-silent` action for executing a command silently without
  switching to the alternate screen. This is useful when the process is
  short-lived and you're not interested in its output.
    - e.g. `fzf --bind 'ctrl-y:execute!(echo -n {} | pbcopy)'`
- `ctrl-space` is allowed in `--bind`

0.16.2
------
- Dropped ncurses dependency
- Binaries for freebsd, openbsd, arm5, arm6, arm7, and arm8
- Official 24-bit color support
- Added support for composite actions in `--bind`. Multiple actions can be
  chained using `+` separator.
    - e.g. `fzf --bind 'ctrl-y:execute(echo -n {} | pbcopy)+abort'`
- `--preview-window` with size 0 is allowed. This is used to make fzf execute
  preview command in the background without displaying the result.
- Minor bug fixes and improvements

0.16.1
------
- Fixed `--height` option to properly fill the window with the background
  color
- Added `half-page-up` and `half-page-down` actions
- Added `-L` flag to the default find command

0.16.0
------
- *Added `--height HEIGHT[%]` option*
    - fzf can now display finder without occupying the full screen
- Preview window will truncate long lines by default. Line wrap can be enabled
  by `:wrap` flag in `--preview-window`.
- Latin script letters will be normalized before matching so that it's easier
  to match against accented letters. e.g. `sodanco` can match `Só Danço Samba`.
    - Normalization can be disabled via `--literal`
- Added `--filepath-word` to make word-wise movements/actions (`alt-b`,
  `alt-f`, `alt-bs`, `alt-d`) respect path separators

0.15.9
------
- Fixed rendering glitches introduced in 0.15.8
- The default escape delay is reduced to 50ms and is configurable via
  `$ESCDELAY`
- Scroll indicator at the top-right corner of the preview window is always
  displayed when there's overflow
- Can now be built with ncurses 6 or tcell to support extra features
    - *ncurses 6*
        - Supports more than 256 color pairs
        - Supports italics
    - *tcell*
        - 24-bit color support
    - See https://github.com/junegunn/fzf/blob/master/BUILD.md

0.15.8
------
- Updated ANSI processor to handle more VT-100 escape sequences
- Added `--no-bold` (and `--bold`) option
- Improved escape sequence processing for WSL
- Added support for `alt-[0-9]`, `f11`, and `f12` for `--bind` and `--expect`

0.15.7
------
- Fixed panic when color is disabled and header lines contain ANSI colors

0.15.6
------
- Windows binaries! (@kelleyma49)
- Fixed the bug where header lines are cleared when preview window is toggled
- Fixed not to display ^N and ^O on screen
- Fixed cursor keys (or any key sequence that starts with ESC) on WSL by
  making fzf wait for additional keystrokes after ESC for up to 100ms

0.15.5
------
- Setting foreground color will no longer set background color to black
    - e.g. `fzf --color fg:153`
- `--tiebreak=end` will consider relative position instead of absolute distance
- Updated `fzf#wrap` function to respect `g:fzf_colors`

0.15.4
------
- Added support for range expression in preview and execute action
    - e.g. `ls -l | fzf --preview="echo user={3} when={-4..-2}; cat {-1}" --header-lines=1`
    - `{q}` will be replaced to the single-quoted string of the current query
- Fixed to properly handle unicode whitespace characters
- Display scroll indicator in preview window
- Inverse search term will use exact matcher by default
    - This is a breaking change, but I believe it makes much more sense. It is
      almost impossible to predict which entries will be filtered out due to
      a fuzzy inverse term. You can still perform inverse-fuzzy-match by
      prepending `!'` to the term.

0.15.3
------
- Added support for more ANSI attributes: dim, underline, blink, and reverse
- Fixed race condition in `toggle-preview`

0.15.2
------
- Preview window is now scrollable
    - With mouse scroll or with bindable actions
        - `preview-up`
        - `preview-down`
        - `preview-page-up`
        - `preview-page-down`
- Updated ANSI processor to support high intensity colors and ignore
  some VT100-related escape sequences

0.15.1
------
- Fixed panic when the pattern occurs after 2^15-th column
- Fixed rendering delay when displaying extremely long lines

0.15.0
------
- Improved fuzzy search algorithm
    - Added `--algo=[v1|v2]` option so one can still choose the old algorithm
      which values the search performance over the quality of the result
- Advanced scoring criteria
- `--read0` to read input delimited by ASCII NUL character
- `--print0` to print output delimited by ASCII NUL character

0.13.5
------
- Memory and performance optimization
    - Up to 2x performance with half the amount of memory

0.13.4
------
- Performance optimization
    - Memory footprint for ascii string is reduced by 60%
    - 15 to 20% improvement of query performance
    - Up to 45% better performance of `--nth` with non-regex delimiters
- Fixed invalid handling of `hidden` property of `--preview-window`

0.13.3
------
- Fixed duplicate rendering of the last line in preview window

0.13.2
------
- Fixed race condition where preview window is not properly cleared

0.13.1
------
- Fixed UI issue with large `--preview` output with many ANSI codes

0.13.0
------
- Added preview feature
    - `--preview CMD`
    - `--preview-window POS[:SIZE][:hidden]`
- `{}` in execute action is now replaced to the single-quoted (instead of
  double-quoted) string of the current line
- Fixed to ignore control characters for bracketed paste mode

0.12.2
------

- 256-color capability detection does not require `256` in `$TERM`
- Added `print-query` action
- More named keys for binding; <kbd>F1</kbd> ~ <kbd>F10</kbd>,
  <kbd>ALT-/</kbd>, <kbd>ALT-space</kbd>, and <kbd>ALT-enter</kbd>
- Added `jump` and `jump-accept` actions that implement [EasyMotion][em]-like
  movement
  ![][jump]

[em]: https://github.com/easymotion/vim-easymotion
[jump]: https://cloud.githubusercontent.com/assets/700826/15367574/b3999dc4-1d64-11e6-85da-28ceeb1a9bc2.png

0.12.1
------

- Ranking algorithm introduced in 0.12.0 is now universally applied
- Fixed invalid cache reference in exact mode
- Fixes and improvements in Vim plugin and shell extensions

0.12.0
------

- Enhanced ranking algorithm
- Minor bug fixes

0.11.4
------

- Added `--hscroll-off=COL` option (default: 10) (#513)
- Some fixes in Vim plugin and shell extensions

0.11.3
------

- Graceful exit on SIGTERM (#482)
- `$SHELL` instead of `sh` for `execute` action and `$FZF_DEFAULT_COMMAND` (#481)
- Changes in fuzzy completion API
    - [`_fzf_compgen_{path,dir}`](https://github.com/junegunn/fzf/commit/9617647)
    - [`_fzf_complete_COMMAND_post`](https://github.com/junegunn/fzf/commit/8206746)
      for post-processing

0.11.2
------

- `--tiebreak` now accepts comma-separated list of sort criteria
    - Each criterion should appear only once in the list
    - `index` is only allowed at the end of the list
    - `index` is implicitly appended to the list when not specified
    - Default is `length` (or equivalently `length,index`)
- `begin` criterion will ignore leading whitespaces when calculating the index
- Added `toggle-in` and `toggle-out` actions
    - Switch direction depending on `--reverse`-ness
    - `export FZF_DEFAULT_OPTS="--bind tab:toggle-out,shift-tab:toggle-in"`
- Reduced the initial delay when `--tac` is not given
    - fzf defers the initial rendering of the screen up to 100ms if the input
      stream is ongoing to prevent unnecessary redraw during the initial
      phase. However, 100ms delay is quite noticeable and might give the
      impression that fzf is not snappy enough. This commit reduces the
      maximum delay down to 20ms when `--tac` is not specified, in which case
      the input list quickly fills the entire screen.

0.11.1
------

- Added `--tabstop=SPACES` option

0.11.0
------

- Added OR operator for extended-search mode
- Added `--execute-multi` action
- Fixed incorrect cursor position when unicode wide characters are used in
  `--prompt`
- Fixes and improvements in shell extensions

0.10.9
------

- Extended-search mode is now enabled by default
    - `--extended-exact` is deprecated and instead we have `--exact` for
      orthogonally controlling "exactness" of search
- Fixed not to display non-printable characters
- Added `double-click` for `--bind` option
- More robust handling of SIGWINCH

0.10.8
------

- Fixed panic when trying to set colors after colors are disabled (#370)

0.10.7
------

- Fixed unserialized interrupt handling during execute action which often
  caused invalid memory access and crash
- Changed `--tiebreak=length` (default) to use trimmed length when `--nth` is
  used

0.10.6
------

- Replaced `--header-file` with `--header` option
- `--header` and `--header-lines` can be used together
- Changed exit status
    - 0: Okay
    - 1: No match
    - 2: Error
    - 130: Interrupted
- 64-bit linux binary is statically-linked with ncurses to avoid
  compatibility issues.

0.10.5
------

- `'`-prefix to unquote the term in `--extended-exact` mode
- Backward scan when `--tiebreak=end` is set

0.10.4
------

- Fixed to remove ANSI code from output when `--with-nth` is set

0.10.3
------

- Fixed slow performance of `--with-nth` when used with `--delimiter`
    - Regular expression engine of Golang as of now is very slow, so the fixed
      version will treat the given delimiter pattern as a plain string instead
      of a regular expression unless it contains special characters and is
      a valid regular expression.
    - Simpler regular expression for delimiter for better performance

0.10.2
------

### Fixes and improvements

- Improvement in perceived response time of queries
    - Eager, efficient rune array conversion
- Graceful exit when failed to initialize ncurses (invalid $TERM)
- Improved ranking algorithm when `--nth` option is set
- Changed the default command not to fail when there are files whose names
  start with dash

0.10.1
------

### New features

- Added `--margin` option
- Added options for sticky header
    - `--header-file`
    - `--header-lines`
- Added `cancel` action which clears the input or closes the finder when the
  input is already empty
    - e.g. `export FZF_DEFAULT_OPTS="--bind esc:cancel"`
- Added `delete-char/eof` action to differentiate `CTRL-D` and `DEL`

### Minor improvements/fixes

- Fixed to allow binding colon and comma keys
- Fixed ANSI processor to handle color regions spanning multiple lines

0.10.0
------

### New features

- More actions for `--bind`
    - `select-all`
    - `deselect-all`
    - `toggle-all`
    - `ignore`
- `execute(...)` action for running arbitrary command without leaving fzf
    - `fzf --bind "ctrl-m:execute(less {})"`
    - `fzf --bind "ctrl-t:execute(tmux new-window -d 'vim {}')"`
    - If the command contains parentheses, use any of the follows alternative
      notations to avoid parse errors
        - `execute[...]`
        - `execute~...~`
        - `execute!...!`
        - `execute@...@`
        - `execute#...#`
        - `execute$...$`
        - `execute%...%`
        - `execute^...^`
        - `execute&...&`
        - `execute*...*`
        - `execute;...;`
        - `execute/.../`
        - `execute|...|`
        - `execute:...`
            - This is the special form that frees you from parse errors as it
              does not expect the closing character
            - The catch is that it should be the last one in the
              comma-separated list
- Added support for optional search history
    - `--history HISTORY_FILE`
        - When used, `CTRL-N` and `CTRL-P` are automatically remapped to
          `next-history` and `previous-history`
    - `--history-size MAX_ENTRIES` (default: 1000)
- Cyclic scrolling can be enabled with `--cycle`
- Fixed the bug where the spinner was not spinning on idle input stream
    - e.g. `sleep 100 | fzf`

### Minor improvements/fixes

- Added synonyms for key names that can be specified for `--bind`,
  `--toggle-sort`, and `--expect`
- Fixed the color of multi-select marker on the current line
- Fixed to allow `^pattern$` in extended-search mode


0.9.13
------

### New features

- Color customization with the extended `--color` option

### Bug fixes

- Fixed premature termination of Reader in the presence of a long line which
  is longer than 64KB

0.9.12
------

### New features

- Added `--bind` option for custom key bindings

### Bug fixes

- Fixed to update "inline-info" immediately after terminal resize
- Fixed ANSI code offset calculation

0.9.11
------

### New features

- Added `--inline-info` option for saving screen estate (#202)
     - Useful inside Neovim
     - e.g. `let $FZF_DEFAULT_OPTS = $FZF_DEFAULT_OPTS.' --inline-info'`

### Bug fixes

- Invalid mutation of input on case conversion (#209)
- Smart-case for each term in extended-search mode (#208)
- Fixed double-click result when scroll offset is positive

0.9.10
------

### Improvements

- Performance optimization
- Less aggressive memoization to limit memory usage

### New features

- Added color scheme for light background: `--color=light`

0.9.9
-----

### New features

- Added `--tiebreak` option (#191)
- Added `--no-hscroll` option (#193)
- Visual indication of `--toggle-sort` (#194)

0.9.8
-----

### Bug fixes

- Fixed Unicode case handling (#186)
- Fixed to terminate on RuneError (#185)

0.9.7
-----

### New features

- Added `--toggle-sort` option (#173)
    - `--toggle-sort=ctrl-r` is applied to `CTRL-R` shell extension

### Bug fixes

- Fixed to print empty line if `--expect` is set and fzf is completed by
  `--select-1` or `--exit-0` (#172)
- Fixed to allow comma character as an argument to `--expect` option

0.9.6
-----

### New features

#### Added `--expect` option (#163)

If you provide a comma-separated list of keys with `--expect` option, fzf will
allow you to select the match and complete the finder when any of the keys is
pressed. Additionally, fzf will print the name of the key pressed as the first
line of the output so that your script can decide what to do next based on the
information.

```sh
fzf --expect=ctrl-v,ctrl-t,alt-s,f1,f2,~,@
```

The updated vim plugin uses this option to implement
[ctrlp](https://github.com/kien/ctrlp.vim)-compatible key bindings.

### Bug fixes

- Fixed to ignore ANSI escape code `\e[K` (#162)

0.9.5
-----

### New features

#### Added `--ansi` option (#150)

If you give `--ansi` option to fzf, fzf will interpret ANSI color codes from
the input, display the item with the ANSI colors (true colors are not
supported), and strips the codes from the output. This option is off by
default as it entails some overhead.

### Improvements

#### Reduced initial memory footprint (#151)

By removing unnecessary copy of pointers, fzf will use significantly smaller
amount of memory when it's started. The difference is hugely noticeable when
the input is extremely large. (e.g. `locate / | fzf`)

### Bug fixes

- Fixed panic on `--no-sort --filter ''` (#149)

0.9.4
-----

### New features

#### Added `--tac` option to reverse the order of the input.

One might argue that this option is unnecessary since we can already put `tac`
or `tail -r` in the command pipeline to achieve the same result. However, the
advantage of `--tac` is that it does not block until the input is complete.

### *Backward incompatible changes*

#### Changed behavior on `--no-sort`

`--no-sort` option will no longer reverse the display order within finder. You
may want to use the new `--tac` option with `--no-sort`.

```
history | fzf +s --tac
```

### Improvements

#### `--filter` will not block when sort is disabled

When fzf works in filtering mode (`--filter`) and sort is disabled
(`--no-sort`), there's no need to block until input is complete. The new
version of fzf will print the matches on-the-fly when the following condition
is met:

    --filter TERM --no-sort [--no-tac --no-sync]

or simply:

    -f TERM +s

This change removes unnecessary delay in the use cases like the following:

    fzf -f xxx +s | head -5

However, in this case, fzf processes the lines sequentially, so it cannot
utilize multiple cores, and fzf will run slightly slower than the previous
mode of execution where filtering is done in parallel after the entire input
is loaded. If the user is concerned about this performance problem, one can
add `--sync` option to re-enable buffering.

0.9.3
-----

### New features
- Added `--sync` option for multi-staged filtering

### Improvements
- `--select-1` and `--exit-0` will start finder immediately when the condition
  cannot be met
./Dockerfile	[[[1
11
FROM --platform=linux/amd64 archlinux
RUN pacman -Sy && pacman --noconfirm -S awk git tmux zsh fish ruby procps go make gcc
RUN gem install --no-document -v 5.14.2 minitest
RUN echo '. /usr/share/bash-completion/completions/git' >> ~/.bashrc
RUN echo '. ~/.bashrc' >> ~/.bash_profile

# Do not set default PS1
RUN rm -f /etc/bash.bashrc
COPY . /fzf
RUN cd /fzf && make install && ./install --all
CMD tmux new 'set -o pipefail; ruby /fzf/test/test_go.rb | tee out && touch ok' && cat out && [ -e ok ]
./LICENSE	[[[1
21
The MIT License (MIT)

Copyright (c) 2013-2023 Junegunn Choi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
./Makefile	[[[1
178
SHELL          := bash
GO             ?= go
GOOS           ?= $(word 1, $(subst /, " ", $(word 4, $(shell go version))))

MAKEFILE       := $(realpath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR       := $(shell dirname $(MAKEFILE))
SOURCES        := $(wildcard *.go src/*.go src/*/*.go) $(MAKEFILE)

ifdef FZF_VERSION
VERSION        := $(FZF_VERSION)
else
VERSION        := $(shell git describe --abbrev=0 2> /dev/null)
endif
ifeq ($(VERSION),)
$(error Not on git repository; cannot determine $$FZF_VERSION)
endif
VERSION_TRIM   := $(shell sed "s/-.*//" <<< $(VERSION))
VERSION_REGEX  := $(subst .,\.,$(VERSION_TRIM))

ifdef FZF_REVISION
REVISION       := $(FZF_REVISION)
else
REVISION       := $(shell git log -n 1 --pretty=format:%h --abbrev=8 -- $(SOURCES) 2> /dev/null)
endif
ifeq ($(REVISION),)
$(error Not on git repository; cannot determine $$FZF_REVISION)
endif
BUILD_FLAGS    := -a -ldflags "-s -w -X main.version=$(VERSION) -X main.revision=$(REVISION)" -tags "$(TAGS)"

BINARY32       := fzf-$(GOOS)_386
BINARY64       := fzf-$(GOOS)_amd64
BINARYS390     := fzf-$(GOOS)_s390x
BINARYARM5     := fzf-$(GOOS)_arm5
BINARYARM6     := fzf-$(GOOS)_arm6
BINARYARM7     := fzf-$(GOOS)_arm7
BINARYARM8     := fzf-$(GOOS)_arm8
BINARYPPC64LE  := fzf-$(GOOS)_ppc64le
BINARYRISCV64  := fzf-$(GOOS)_riscv64
BINARYLOONG64  := fzf-$(GOOS)_loong64

# https://en.wikipedia.org/wiki/Uname
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_M),x86_64)
	BINARY := $(BINARY64)
else ifeq ($(UNAME_M),amd64)
	BINARY := $(BINARY64)
else ifeq ($(UNAME_M),s390x)
	BINARY := $(BINARYS390)
else ifeq ($(UNAME_M),i686)
	BINARY := $(BINARY32)
else ifeq ($(UNAME_M),i386)
	BINARY := $(BINARY32)
else ifeq ($(UNAME_M),armv5l)
	BINARY := $(BINARYARM5)
else ifeq ($(UNAME_M),armv6l)
	BINARY := $(BINARYARM6)
else ifeq ($(UNAME_M),armv7l)
	BINARY := $(BINARYARM7)
else ifeq ($(UNAME_M),armv8l)
	BINARY := $(BINARYARM8)
else ifeq ($(UNAME_M),arm64)
	BINARY := $(BINARYARM8)
else ifeq ($(UNAME_M),aarch64)
	BINARY := $(BINARYARM8)
else ifeq ($(UNAME_M),ppc64le)
	BINARY := $(BINARYPPC64LE)
else ifeq ($(UNAME_M),riscv64)
	BINARY := $(BINARYRISCV64)
else ifeq ($(UNAME_M),loongarch64)
	BINARY := $(BINARYLOONG64)
else
$(error Build on $(UNAME_M) is not supported, yet.)
endif

all: target/$(BINARY)

test: $(SOURCES)
	[ -z "$$(gofmt -s -d src)" ] || (gofmt -s -d src; exit 1)
	SHELL=/bin/sh GOOS= $(GO) test -v -tags "$(TAGS)" \
				github.com/junegunn/fzf/src \
				github.com/junegunn/fzf/src/algo \
				github.com/junegunn/fzf/src/tui \
				github.com/junegunn/fzf/src/util

bench:
	cd src && SHELL=/bin/sh GOOS= $(GO) test -v -tags "$(TAGS)" -run=Bench -bench=. -benchmem

install: bin/fzf

build:
	goreleaser build --rm-dist --snapshot --skip-post-hooks

release:
ifndef GITHUB_TOKEN
	$(error GITHUB_TOKEN is not defined)
endif

	# Check if we are on master branch
ifneq ($(shell git symbolic-ref --short HEAD),master)
	$(error Not on master branch)
endif

	# Check if version numbers are properly updated
	grep -q ^$(VERSION_REGEX)$$ CHANGELOG.md
	grep -qF '"fzf $(VERSION_TRIM)"' man/man1/fzf.1
	grep -qF '"fzf $(VERSION_TRIM)"' man/man1/fzf-tmux.1
	grep -qF $(VERSION) install
	grep -qF $(VERSION) install.ps1

	# Make release note out of CHANGELOG.md
	mkdir -p tmp
	sed -n '/^$(VERSION_REGEX)$$/,/^[0-9]/p' CHANGELOG.md | tail -r | \
		sed '1,/^ *$$/d' | tail -r | sed 1,2d | tee tmp/release-note

	# Push to temp branch first so that install scripts always works on master branch
	git checkout -B temp master
	git push origin temp --follow-tags --force

	# Make a GitHub release
	goreleaser --rm-dist --release-notes tmp/release-note

	# Push to master
	git checkout master
	git push origin master

	# Delete temp branch
	git push origin --delete temp

clean:
	$(RM) -r dist target

target/$(BINARY32): $(SOURCES)
	GOARCH=386 $(GO) build $(BUILD_FLAGS) -o $@

target/$(BINARY64): $(SOURCES)
	GOARCH=amd64 $(GO) build $(BUILD_FLAGS) -o $@

target/$(BINARYS390): $(SOURCES)
	GOARCH=s390x $(GO) build $(BUILD_FLAGS) -o $@
# https://github.com/golang/go/wiki/GoArm
target/$(BINARYARM5): $(SOURCES)
	GOARCH=arm GOARM=5 $(GO) build $(BUILD_FLAGS) -o $@

target/$(BINARYARM6): $(SOURCES)
	GOARCH=arm GOARM=6 $(GO) build $(BUILD_FLAGS) -o $@

target/$(BINARYARM7): $(SOURCES)
	GOARCH=arm GOARM=7 $(GO) build $(BUILD_FLAGS) -o $@

target/$(BINARYARM8): $(SOURCES)
	GOARCH=arm64 $(GO) build $(BUILD_FLAGS) -o $@

target/$(BINARYPPC64LE): $(SOURCES)
	GOARCH=ppc64le $(GO) build $(BUILD_FLAGS) -o $@

target/$(BINARYRISCV64): $(SOURCES)
	GOARCH=riscv64 $(GO) build $(BUILD_FLAGS) -o $@

target/$(BINARYLOONG64): $(SOURCES)
	GOARCH=loong64 $(GO) build $(BUILD_FLAGS) -o $@

bin/fzf: target/$(BINARY) | bin
	-rm -f bin/fzf
	cp -f target/$(BINARY) bin/fzf

docker:
	docker build -t fzf-arch .
	docker run -it fzf-arch tmux

docker-test:
	docker build -t fzf-arch .
	docker run -it fzf-arch

update:
	$(GO) get -u
	$(GO) mod tidy

.PHONY: all build release test bench install clean docker docker-test update
./README-VIM.md	[[[1
489
FZF Vim integration
===================

Installation
------------

Once you have fzf installed, you can enable it inside Vim simply by adding the
directory to `&runtimepath` in your Vim configuration file. The path may
differ depending on the package manager.

```vim
" If installed using Homebrew
set rtp+=/usr/local/opt/fzf

" If installed using Homebrew on Apple Silicon
set rtp+=/opt/homebrew/opt/fzf

" If you have cloned fzf on ~/.fzf directory
set rtp+=~/.fzf
```

If you use [vim-plug](https://github.com/junegunn/vim-plug), the same can be
written as:

```vim
" If installed using Homebrew
Plug '/usr/local/opt/fzf'

" If you have cloned fzf on ~/.fzf directory
Plug '~/.fzf'
```

But if you want the latest Vim plugin file from GitHub rather than the one
included in the package, write:

```vim
Plug 'junegunn/fzf'
```

The Vim plugin will pick up fzf binary available on the system. If fzf is not
found on `$PATH`, it will ask you if it should download the latest binary for
you.

To make sure that you have the latest version of the binary, set up
post-update hook like so:

```vim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
```

Summary
-------

The Vim plugin of fzf provides two core functions, and `:FZF` command which is
the basic file selector command built on top of them.

1. **`fzf#run([spec dict])`**
    - Starts fzf inside Vim with the given spec
    - `:call fzf#run({'source': 'ls'})`
2. **`fzf#wrap([spec dict]) -> (dict)`**
    - Takes a spec for `fzf#run` and returns an extended version of it with
      additional options for addressing global preferences (`g:fzf_xxx`)
        - `:echo fzf#wrap({'source': 'ls'})`
    - We usually *wrap* a spec with `fzf#wrap` before passing it to `fzf#run`
        - `:call fzf#run(fzf#wrap({'source': 'ls'}))`
3. **`:FZF [fzf_options string] [path string]`**
    - Basic fuzzy file selector
    - A reference implementation for those who don't want to write VimScript
      to implement custom commands
    - If you're looking for more such commands, check out [fzf.vim](https://github.com/junegunn/fzf.vim) project.

The most important of all is `fzf#run`, but it would be easier to understand
the whole if we start off with `:FZF` command.

`:FZF[!]`
---------

```vim
" Look for files under current directory
:FZF

" Look for files under your home directory
:FZF ~

" With fzf command-line options
:FZF --reverse --info=inline /tmp

" Bang version starts fzf in fullscreen mode
:FZF!
```

Similarly to [ctrlp.vim](https://github.com/kien/ctrlp.vim), use enter key,
`CTRL-T`, `CTRL-X` or `CTRL-V` to open selected files in the current window,
in new tabs, in horizontal splits, or in vertical splits respectively.

Note that the environment variables `FZF_DEFAULT_COMMAND` and
`FZF_DEFAULT_OPTS` also apply here.

### Configuration

- `g:fzf_action`
    - Customizable extra key bindings for opening selected files in different ways
- `g:fzf_layout`
    - Determines the size and position of fzf window
- `g:fzf_colors`
    - Customizes fzf colors to match the current color scheme
- `g:fzf_history_dir`
    - Enables history feature

#### Examples

```vim
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - Popup window (center of the screen)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" - Popup window (center of the current window)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true } }

" - Popup window (anchored to the bottom of the current window)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }

" - down / up / left / right
let g:fzf_layout = { 'down': '40%' }

" - Window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history
" - History files will be stored in the specified directory
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.local/share/fzf-history'
```

##### Explanation of `g:fzf_colors`

`g:fzf_colors` is a dictionary mapping fzf elements to a color specification
list:

    element: [ component, group1 [, group2, ...] ]

- `element` is an fzf element to apply a color to:

  | Element                     | Description                                           |
  | ---                         | ---                                                   |
  | `fg`  / `bg`  / `hl`        | Item (foreground / background / highlight)            |
  | `fg+` / `bg+` / `hl+`       | Current item (foreground / background / highlight)    |
  | `preview-fg` / `preview-bg` | Preview window text and background                    |
  | `hl`  / `hl+`               | Highlighted substrings (normal / current)             |
  | `gutter`                    | Background of the gutter on the left                  |
  | `pointer`                   | Pointer to the current line (`>`)                     |
  | `marker`                    | Multi-select marker (`>`)                             |
  | `border`                    | Border around the window (`--border` and `--preview`) |
  | `header`                    | Header (`--header` or `--header-lines`)               |
  | `info`                      | Info line (match counters)                            |
  | `spinner`                   | Streaming input indicator                             |
  | `query`                     | Query string                                          |
  | `disabled`                  | Query string when search is disabled                  |
  | `prompt`                    | Prompt before query (`> `)                            |
  | `pointer`                   | Pointer to the current line (`>`)                     |

- `component` specifies the component (`fg` / `bg`) from which to extract the
  color when considering each of the following highlight groups

- `group1 [, group2, ...]` is a list of highlight groups that are searched (in
  order) for a matching color definition

For example, consider the following specification:

```vim
  'prompt':  ['fg', 'Conditional', 'Comment'],
```

This means we color the **prompt**
- using the `fg` attribute of the `Conditional` if it exists,
- otherwise use the `fg` attribute of the `Comment` highlight group if it exists,
- otherwise fall back to the default color settings for the **prompt**.

You can examine the color option generated according the setting by printing
the result of `fzf#wrap()` function like so:

```vim
:echo fzf#wrap()
```

`fzf#run`
---------

`fzf#run()` function is the core of Vim integration. It takes a single
dictionary argument, *a spec*, and starts fzf process accordingly. At the very
least, specify `sink` option to tell what it should do with the selected
entry.

```vim
call fzf#run({'sink': 'e'})
```

We haven't specified the `source`, so this is equivalent to starting fzf on
command line without standard input pipe; fzf will use find command (or
`$FZF_DEFAULT_COMMAND` if defined) to list the files under the current
directory. When you select one, it will open it with the sink, `:e` command.
If you want to open it in a new tab, you can pass `:tabedit` command instead
as the sink.

```vim
call fzf#run({'sink': 'tabedit'})
```

Instead of using the default find command, you can use any shell command as
the source. The following example will list the files managed by git. It's
equivalent to running `git ls-files | fzf` on shell.

```vim
call fzf#run({'source': 'git ls-files', 'sink': 'e'})
```

fzf options can be specified as `options` entry in spec dictionary.

```vim
call fzf#run({'sink': 'tabedit', 'options': '--multi --reverse'})
```

You can also pass a layout option if you don't want fzf window to take up the
entire screen.

```vim
" up / down / left / right / window are allowed
call fzf#run({'source': 'git ls-files', 'sink': 'e', 'left': '40%'})
call fzf#run({'source': 'git ls-files', 'sink': 'e', 'window': '30vnew'})
```

`source` doesn't have to be an external shell command, you can pass a Vim
array as the source. In the next example, we pass the names of color
schemes as the source to implement a color scheme selector.

```vim
call fzf#run({'source': map(split(globpath(&rtp, 'colors/*.vim')),
            \               'fnamemodify(v:val, ":t:r")'),
            \ 'sink': 'colo', 'left': '25%'})
```

The following table summarizes the available options.

| Option name                | Type          | Description                                                           |
| -------------------------- | ------------- | ----------------------------------------------------------------      |
| `source`                   | string        | External command to generate input to fzf (e.g. `find .`)             |
| `source`                   | list          | Vim list as input to fzf                                              |
| `sink`                     | string        | Vim command to handle the selected item (e.g. `e`, `tabe`)            |
| `sink`                     | funcref       | Reference to function to process each selected item                   |
| `sinklist` (or `sink*`)    | funcref       | Similar to `sink`, but takes the list of output lines at once         |
| `options`                  | string/list   | Options to fzf                                                        |
| `dir`                      | string        | Working directory                                                     |
| `up`/`down`/`left`/`right` | number/string | (Layout) Window position and size (e.g. `20`, `50%`)                  |
| `tmux`                     | string        | (Layout) fzf-tmux options (e.g. `-p90%,60%`)                          |
| `window` (Vim 8 / Neovim)  | string        | (Layout) Command to open fzf window (e.g. `vertical aboveleft 30new`) |
| `window` (Vim 8 / Neovim)  | dict          | (Layout) Popup window settings (e.g. `{'width': 0.9, 'height': 0.6}`) |

`options` entry can be either a string or a list. For simple cases, string
should suffice, but prefer to use list type to avoid escaping issues.

```vim
call fzf#run({'options': '--reverse --prompt "C:\\Program Files\\"'})
call fzf#run({'options': ['--reverse', '--prompt', 'C:\Program Files\']})
```

When `window` entry is a dictionary, fzf will start in a popup window. The
following options are allowed:

- Required:
    - `width` [float range [0 ~ 1]] or [integer range [8 ~ ]]
    - `height` [float range [0 ~ 1]] or [integer range [4 ~ ]]
- Optional:
    - `yoffset` [float default 0.5 range [0 ~ 1]]
    - `xoffset` [float default 0.5 range [0 ~ 1]]
    - `relative` [boolean default v:false]
    - `border` [string default `rounded` (`sharp` on Windows)]: Border style
        - `rounded` / `sharp` / `horizontal` / `vertical` / `top` / `bottom` / `left` / `right` / `no[ne]`

`fzf#wrap`
----------

We have seen that several aspects of `:FZF` command can be configured with
a set of global option variables; different ways to open files
(`g:fzf_action`), window position and size (`g:fzf_layout`), color palette
(`g:fzf_colors`), etc.

So how can we make our custom `fzf#run` calls also respect those variables?
Simply by *"wrapping"* the spec dictionary with `fzf#wrap` before passing it
to `fzf#run`.

- **`fzf#wrap([name string], [spec dict], [fullscreen bool]) -> (dict)`**
    - All arguments are optional. Usually we only need to pass a spec dictionary.
    - `name` is for managing history files. It is ignored if
      `g:fzf_history_dir` is not defined.
    - `fullscreen` can be either `0` or `1` (default: 0).

`fzf#wrap` takes a spec and returns an extended version of it (also
a dictionary) with additional options for addressing global preferences. You
can examine the return value of it like so:

```vim
echo fzf#wrap({'source': 'ls'})
```

After we *"wrap"* our spec, we pass it to `fzf#run`.

```vim
call fzf#run(fzf#wrap({'source': 'ls'}))
```

Now it supports `CTRL-T`, `CTRL-V`, and `CTRL-X` key bindings (configurable
via `g:fzf_action`) and it opens fzf window according to `g:fzf_layout`
setting.

To make it easier to use, let's define `LS` command.

```vim
command! LS call fzf#run(fzf#wrap({'source': 'ls'}))
```

Type `:LS` and see how it works.

We would like to make `:LS!` (bang version) open fzf in fullscreen, just like
`:FZF!`. Add `-bang` to command definition, and use `<bang>` value to set
the last `fullscreen` argument of `fzf#wrap` (see `:help <bang>`).

```vim
" On :LS!, <bang> evaluates to '!', and '!0' becomes 1
command! -bang LS call fzf#run(fzf#wrap({'source': 'ls'}, <bang>0))
```

Our `:LS` command will be much more useful if we can pass a directory argument
to it, so that something like `:LS /tmp` is possible.

```vim
command! -bang -complete=dir -nargs=? LS
    \ call fzf#run(fzf#wrap({'source': 'ls', 'dir': <q-args>}, <bang>0))
```

Lastly, if you have enabled `g:fzf_history_dir`, you might want to assign
a unique name to our command and pass it as the first argument to `fzf#wrap`.

```vim
" The query history for this command will be stored as 'ls' inside g:fzf_history_dir.
" The name is ignored if g:fzf_history_dir is not defined.
command! -bang -complete=dir -nargs=? LS
    \ call fzf#run(fzf#wrap('ls', {'source': 'ls', 'dir': <q-args>}, <bang>0))
```

### Global options supported by `fzf#wrap`

- `g:fzf_layout`
- `g:fzf_action`
    - **Works only when no custom `sink` (or `sinklist`) is provided**
        - Having custom sink usually means that each entry is not an ordinary
          file path (e.g. name of color scheme), so we can't blindly apply the
          same strategy (i.e. `tabedit some-color-scheme` doesn't make sense)
- `g:fzf_colors`
- `g:fzf_history_dir`

Tips
----

### fzf inside terminal buffer

On the latest versions of Vim and Neovim, fzf will start in a terminal buffer.
If you find the default ANSI colors to be different, consider configuring the
colors using `g:terminal_ansi_colors` in regular Vim or `g:terminal_color_x`
in Neovim.

```vim
" Terminal colors for seoul256 color scheme
if has('nvim')
  let g:terminal_color_0 = '#4e4e4e'
  let g:terminal_color_1 = '#d68787'
  let g:terminal_color_2 = '#5f865f'
  let g:terminal_color_3 = '#d8af5f'
  let g:terminal_color_4 = '#85add4'
  let g:terminal_color_5 = '#d7afaf'
  let g:terminal_color_6 = '#87afaf'
  let g:terminal_color_7 = '#d0d0d0'
  let g:terminal_color_8 = '#626262'
  let g:terminal_color_9 = '#d75f87'
  let g:terminal_color_10 = '#87af87'
  let g:terminal_color_11 = '#ffd787'
  let g:terminal_color_12 = '#add4fb'
  let g:terminal_color_13 = '#ffafaf'
  let g:terminal_color_14 = '#87d7d7'
  let g:terminal_color_15 = '#e4e4e4'
else
  let g:terminal_ansi_colors = [
    \ '#4e4e4e', '#d68787', '#5f865f', '#d8af5f',
    \ '#85add4', '#d7afaf', '#87afaf', '#d0d0d0',
    \ '#626262', '#d75f87', '#87af87', '#ffd787',
    \ '#add4fb', '#ffafaf', '#87d7d7', '#e4e4e4'
  \ ]
endif
```

### Starting fzf in a popup window

```vim
" Required:
" - width [float range [0 ~ 1]] or [integer range [8 ~ ]]
" - height [float range [0 ~ 1]] or [integer range [4 ~ ]]
"
" Optional:
" - xoffset [float default 0.5 range [0 ~ 1]]
" - yoffset [float default 0.5 range [0 ~ 1]]
" - relative [boolean default v:false]
" - border [string default 'rounded']: Border style
"   - 'rounded' / 'sharp' / 'horizontal' / 'vertical' / 'top' / 'bottom' / 'left' / 'right'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
```

Alternatively, you can make fzf open in a tmux popup window (requires tmux 3.2
or above) by putting fzf-tmux options in `tmux` key.

```vim
" See `man fzf-tmux` for available options
if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '-p90%,60%' }
else
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif
```

### Hide statusline

When fzf starts in a terminal buffer, the file type of the buffer is set to
`fzf`. So you can set up `FileType fzf` autocmd to customize the settings of
the window.

For example, if you open fzf on the bottom on the screen (e.g. `{'down':
'40%'}`), you might want to temporarily disable the statusline for a cleaner
look.

```vim
let g:fzf_layout = { 'down': '30%' }
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
```

[License](LICENSE)
------------------

The MIT License (MIT)

Copyright (c) 2013-2023 Junegunn Choi
./README.md	[[[1
786
<img src="https://raw.githubusercontent.com/junegunn/i/master/fzf.png" height="170" alt="fzf - a command-line fuzzy finder"> [![github-actions](https://github.com/junegunn/fzf/workflows/Test%20fzf%20on%20Linux/badge.svg)](https://github.com/junegunn/fzf/actions)
===

fzf is a general-purpose command-line fuzzy finder.

<img src="https://raw.githubusercontent.com/junegunn/i/master/fzf-preview.png" width=640>

It's an interactive Unix filter for command-line that can be used with any
list; files, command history, processes, hostnames, bookmarks, git commits,
etc.

Pros
----

- Portable, no dependencies
- Blazingly fast
- The most comprehensive feature set
- Flexible layout
- Batteries included
    - Vim/Neovim plugin, key bindings, and fuzzy auto-completion

Table of Contents
-----------------

<!-- vim-markdown-toc GFM -->

* [Installation](#installation)
    * [Using Homebrew](#using-homebrew)
    * [Using git](#using-git)
    * [Using Linux package managers](#using-linux-package-managers)
    * [Windows](#windows)
    * [As Vim plugin](#as-vim-plugin)
* [Upgrading fzf](#upgrading-fzf)
* [Building fzf](#building-fzf)
* [Usage](#usage)
    * [Using the finder](#using-the-finder)
    * [Layout](#layout)
    * [Search syntax](#search-syntax)
    * [Environment variables](#environment-variables)
    * [Options](#options)
    * [Demo](#demo)
* [Examples](#examples)
* [`fzf-tmux` script](#fzf-tmux-script)
* [Key bindings for command-line](#key-bindings-for-command-line)
* [Fuzzy completion for bash and zsh](#fuzzy-completion-for-bash-and-zsh)
    * [Files and directories](#files-and-directories)
    * [Process IDs](#process-ids)
    * [Host names](#host-names)
    * [Environment variables / Aliases](#environment-variables--aliases)
    * [Settings](#settings)
    * [Supported commands](#supported-commands)
    * [Custom fuzzy completion](#custom-fuzzy-completion)
* [Vim plugin](#vim-plugin)
* [Advanced topics](#advanced-topics)
    * [Performance](#performance)
    * [Executing external programs](#executing-external-programs)
    * [Turning into a different process](#turning-into-a-different-process)
    * [Reloading the candidate list](#reloading-the-candidate-list)
        * [1. Update the list of processes by pressing CTRL-R](#1-update-the-list-of-processes-by-pressing-ctrl-r)
        * [2. Switch between sources by pressing CTRL-D or CTRL-F](#2-switch-between-sources-by-pressing-ctrl-d-or-ctrl-f)
        * [3. Interactive ripgrep integration](#3-interactive-ripgrep-integration)
    * [Preview window](#preview-window)
* [Tips](#tips)
    * [Respecting `.gitignore`](#respecting-gitignore)
    * [Fish shell](#fish-shell)
* [Related projects](#related-projects)
* [License](#license)

<!-- vim-markdown-toc -->

Installation
------------

fzf project consists of the following components:

- `fzf` executable
- `fzf-tmux` script for launching fzf in a tmux pane
- Shell extensions
    - Key bindings (`CTRL-T`, `CTRL-R`, and `ALT-C`) (bash, zsh, fish)
    - Fuzzy auto-completion (bash, zsh)
- Vim/Neovim plugin

You can [download fzf executable][bin] alone if you don't need the extra
stuff.

[bin]: https://github.com/junegunn/fzf/releases

### Using Homebrew

You can use [Homebrew](https://brew.sh/) (on macOS or Linux)
to install fzf.

```sh
brew install fzf

# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install
```

fzf is also available [via MacPorts][portfile]: `sudo port install fzf`

[portfile]: https://github.com/macports/macports-ports/blob/master/sysutils/fzf/Portfile

### Using git

Alternatively, you can "git clone" this repository to any directory and run
[install](https://github.com/junegunn/fzf/blob/master/install) script.

```sh
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Using Linux package managers

| Package Manager | Linux Distribution      | Command                            |
| ---             | ---                     | ---                                |
| APK             | Alpine Linux            | `sudo apk add fzf`                 |
| APT             | Debian 9+/Ubuntu 19.10+ | `sudo apt install fzf`             |
| Conda           |                         | `conda install -c conda-forge fzf` |
| DNF             | Fedora                  | `sudo dnf install fzf`             |
| Nix             | NixOS, etc.             | `nix-env -iA nixpkgs.fzf`          |
| Pacman          | Arch Linux              | `sudo pacman -S fzf`               |
| pkg             | FreeBSD                 | `pkg install fzf`                  |
| pkgin           | NetBSD                  | `pkgin install fzf`                |
| pkg_add         | OpenBSD                 | `pkg_add fzf`                      |
| Portage         | Gentoo                  | `emerge --ask app-shells/fzf`      |
| XBPS            | Void Linux              | `sudo xbps-install -S fzf`         |
| Zypper          | openSUSE                | `sudo zypper install fzf`          |

> :warning: **Key bindings (CTRL-T / CTRL-R / ALT-C) and fuzzy auto-completion
> may not be enabled by default.**
>
> Refer to the package documentation for more information. (e.g. `apt show fzf`)

[![Packaging status](https://repology.org/badge/vertical-allrepos/fzf.svg)](https://repology.org/project/fzf/versions)

### Windows

Pre-built binaries for Windows can be downloaded [here][bin]. fzf is also
available via [Chocolatey][choco], [Scoop][scoop], and [Winget][winget]:

| Package manager | Command              |
| ---             | ---                  |
| Chocolatey      | `choco install fzf`  |
| Scoop           | `scoop install fzf`  |
| Winget          | `winget install fzf` |

[choco]: https://chocolatey.org/packages/fzf
[scoop]: https://github.com/ScoopInstaller/Main/blob/master/bucket/fzf.json
[winget]: https://github.com/microsoft/winget-pkgs/tree/master/manifests/j/junegunn/fzf

Known issues and limitations on Windows can be found on [the wiki
page][windows-wiki].

[windows-wiki]: https://github.com/junegunn/fzf/wiki/Windows

### As Vim plugin

If you use
[vim-plug](https://github.com/junegunn/vim-plug), add this line to your Vim
configuration file:

```vim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
```

`fzf#install()` makes sure that you have the latest binary, but it's optional,
so you can omit it if you use a plugin manager that doesn't support hooks.

For more installation options, see [README-VIM.md](README-VIM.md).

Upgrading fzf
-------------

fzf is being actively developed, and you might want to upgrade it once in a
while. Please follow the instruction below depending on the installation
method used.

- git: `cd ~/.fzf && git pull && ./install`
- brew: `brew update; brew upgrade fzf`
- macports: `sudo port upgrade fzf`
- chocolatey: `choco upgrade fzf`
- vim-plug: `:PlugUpdate fzf`

Building fzf
------------

See [BUILD.md](BUILD.md).

Usage
-----

fzf will launch interactive finder, read the list from STDIN, and write the
selected item to STDOUT.

```sh
find * -type f | fzf > selected
```

Without STDIN pipe, fzf will use find command to fetch the list of
files excluding hidden ones. (You can override the default command with
`FZF_DEFAULT_COMMAND`)

```sh
vim $(fzf)
```

> *:bulb: A more robust solution would be to use `xargs` but we've presented
> the above as it's easier to grasp*
> ```sh
> fzf --print0 | xargs -0 -o vim
> ```

>
> *:bulb: fzf also has the ability to turn itself into a different process.*
>
> ```sh
> fzf --bind 'enter:become(vim {})'
> ```
>
> *See [Turning into a different process](#turning-into-a-different-process)
> for more information.*

### Using the finder

- `CTRL-K` / `CTRL-J` (or `CTRL-P` / `CTRL-N`) to move cursor up and down
- `Enter` key to select the item, `CTRL-C` / `CTRL-G` / `ESC` to exit
- On multi-select mode (`-m`), `TAB` and `Shift-TAB` to mark multiple items
- Emacs style key bindings
- Mouse: scroll, click, double-click; shift-click and shift-scroll on
  multi-select mode

### Layout

fzf by default starts in fullscreen mode, but you can make it start below the
cursor with `--height` option.

```sh
vim $(fzf --height 40%)
```

Also, check out `--reverse` and `--layout` options if you prefer
"top-down" layout instead of the default "bottom-up" layout.

```sh
vim $(fzf --height 40% --reverse)
```

You can add these options to `$FZF_DEFAULT_OPTS` so that they're applied by
default. For example,

```sh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
```

### Search syntax

Unless otherwise specified, fzf starts in "extended-search mode" where you can
type in multiple search terms delimited by spaces. e.g. `^music .mp3$ sbtrkt
!fire`

| Token     | Match type                 | Description                          |
| --------- | -------------------------- | ------------------------------------ |
| `sbtrkt`  | fuzzy-match                | Items that match `sbtrkt`            |
| `'wild`   | exact-match (quoted)       | Items that include `wild`            |
| `^music`  | prefix-exact-match         | Items that start with `music`        |
| `.mp3$`   | suffix-exact-match         | Items that end with `.mp3`           |
| `!fire`   | inverse-exact-match        | Items that do not include `fire`     |
| `!^music` | inverse-prefix-exact-match | Items that do not start with `music` |
| `!.mp3$`  | inverse-suffix-exact-match | Items that do not end with `.mp3`    |

If you don't prefer fuzzy matching and do not wish to "quote" every word,
start fzf with `-e` or `--exact` option. Note that when  `--exact` is set,
`'`-prefix "unquotes" the term.

A single bar character term acts as an OR operator. For example, the following
query matches entries that start with `core` and end with either `go`, `rb`,
or `py`.

```
^core go$ | rb$ | py$
```

### Environment variables

- `FZF_DEFAULT_COMMAND`
    - Default command to use when input is tty
    - e.g. `export FZF_DEFAULT_COMMAND='fd --type f'`
    - > :warning: This variable is not used by shell extensions due to the
      > slight difference in requirements.
      >
      > (e.g. `CTRL-T` runs `$FZF_CTRL_T_COMMAND` instead, `vim **<tab>` runs
      > `_fzf_compgen_path()`, and `cd **<tab>` runs `_fzf_compgen_dir()`)
      >
      > The available options are described later in this document.
- `FZF_DEFAULT_OPTS`
    - Default options
    - e.g. `export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"`

### Options

See the man page (`man fzf`) for the full list of options.

### Demo
If you learn by watching videos, check out this screencast by [@samoshkin](https://github.com/samoshkin) to explore `fzf` features.

<a title="fzf - command-line fuzzy finder" href="https://www.youtube.com/watch?v=qgG5Jhi_Els">
  <img src="https://i.imgur.com/vtG8olE.png" width="640">
</a>

Examples
--------

* [Wiki page of examples](https://github.com/junegunn/fzf/wiki/examples)
    * *Disclaimer: The examples on this page are maintained by the community
      and are not thoroughly tested*
* [Advanced fzf examples](https://github.com/junegunn/fzf/blob/master/ADVANCED.md)

`fzf-tmux` script
-----------------

[fzf-tmux](bin/fzf-tmux) is a bash script that opens fzf in a tmux pane.

```sh
# usage: fzf-tmux [LAYOUT OPTIONS] [--] [FZF OPTIONS]

# See available options
fzf-tmux --help

# select git branches in horizontal split below (15 lines)
git branch | fzf-tmux -d 15

# select multiple words in vertical split on the left (20% of screen width)
cat /usr/share/dict/words | fzf-tmux -l 20% --multi --reverse
```

It will still work even when you're not on tmux, silently ignoring `-[pudlr]`
options, so you can invariably use `fzf-tmux` in your scripts.

Alternatively, you can use `--height HEIGHT[%]` option not to start fzf in
fullscreen mode.

```sh
fzf --height 40%
```

Key bindings for command-line
-----------------------------

The install script will setup the following key bindings for bash, zsh, and
fish.

- `CTRL-T` - Paste the selected files and directories onto the command-line
    - Set `FZF_CTRL_T_COMMAND` to override the default command
    - Set `FZF_CTRL_T_OPTS` to pass additional options to fzf
      ```sh
      # Preview file content using bat (https://github.com/sharkdp/bat)
      export FZF_CTRL_T_OPTS="
        --preview 'bat -n --color=always {}'
        --bind 'ctrl-/:change-preview-window(down|hidden|)'"
      ```
- `CTRL-R` - Paste the selected command from history onto the command-line
    - If you want to see the commands in chronological order, press `CTRL-R`
      again which toggles sorting by relevance
    - Set `FZF_CTRL_R_OPTS` to pass additional options to fzf
      ```sh
      # CTRL-/ to toggle small preview window to see the full command
      # CTRL-Y to copy the command into clipboard using pbcopy
      export FZF_CTRL_R_OPTS="
        --preview 'echo {}' --preview-window up:3:hidden:wrap
        --bind 'ctrl-/:toggle-preview'
        --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
        --color header:italic
        --header 'Press CTRL-Y to copy command into clipboard'"
      ```
- `ALT-C` - cd into the selected directory
    - Set `FZF_ALT_C_COMMAND` to override the default command
    - Set `FZF_ALT_C_OPTS` to pass additional options to fzf
      ```sh
      # Print tree structure in the preview window
      export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
      ```

If you're on a tmux session, you can start fzf in a tmux split-pane or in
a tmux popup window by setting `FZF_TMUX_OPTS` (e.g. `export FZF_TMUX_OPTS='-p80%,60%'`).
See `fzf-tmux --help` for available options.

More tips can be found on [the wiki page](https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings).

Fuzzy completion for bash and zsh
---------------------------------

### Files and directories

Fuzzy completion for files and directories can be triggered if the word before
the cursor ends with the trigger sequence, which is by default `**`.

- `COMMAND [DIRECTORY/][FUZZY_PATTERN]**<TAB>`

```sh
# Files under the current directory
# - You can select multiple items with TAB key
vim **<TAB>

# Files under parent directory
vim ../**<TAB>

# Files under parent directory that match `fzf`
vim ../fzf**<TAB>

# Files under your home directory
vim ~/**<TAB>


# Directories under current directory (single-selection)
cd **<TAB>

# Directories under ~/github that match `fzf`
cd ~/github/fzf**<TAB>
```

### Process IDs

Fuzzy completion for PIDs is provided for kill command.

```sh
# Can select multiple processes with <TAB> or <Shift-TAB> keys
kill -9 **<TAB>
```

### Host names

For ssh and telnet commands, fuzzy completion for hostnames is provided. The
names are extracted from /etc/hosts and ~/.ssh/config.

```sh
ssh **<TAB>
telnet **<TAB>
```

### Environment variables / Aliases

```sh
unset **<TAB>
export **<TAB>
unalias **<TAB>
```

### Settings

```sh
# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}
```

### Supported commands

On bash, fuzzy completion is enabled only for a predefined set of commands
(`complete | grep _fzf` to see the list). But you can enable it for other
commands as well by using `_fzf_setup_completion` helper function.

```sh
# usage: _fzf_setup_completion path|dir|var|alias|host COMMANDS...
_fzf_setup_completion path ag git kubectl
_fzf_setup_completion dir tree
```

### Custom fuzzy completion

_**(Custom completion API is experimental and subject to change)**_

For a command named _"COMMAND"_, define `_fzf_complete_COMMAND` function using
`_fzf_complete` helper.

```sh
# Custom fuzzy completion for "doge" command
#   e.g. doge **<TAB>
_fzf_complete_doge() {
  _fzf_complete --multi --reverse --prompt="doge> " -- "$@" < <(
    echo very
    echo wow
    echo such
    echo doge
  )
}
```

- The arguments before `--` are the options to fzf.
- After `--`, simply pass the original completion arguments unchanged (`"$@"`).
- Then, write a set of commands that generates the completion candidates and
  feed its output to the function using process substitution (`< <(...)`).

zsh will automatically pick up the function using the naming convention but in
bash you have to manually associate the function with the command using the
`complete` command.

```sh
[ -n "$BASH" ] && complete -F _fzf_complete_doge -o default -o bashdefault doge
```

If you need to post-process the output from fzf, define
`_fzf_complete_COMMAND_post` as follows.

```sh
_fzf_complete_foo() {
  _fzf_complete --multi --reverse --header-lines=3 -- "$@" < <(
    ls -al
  )
}

_fzf_complete_foo_post() {
  awk '{print $NF}'
}

[ -n "$BASH" ] && complete -F _fzf_complete_foo -o default -o bashdefault foo
```

Vim plugin
----------

See [README-VIM.md](README-VIM.md).

Advanced topics
---------------

### Performance

fzf is fast. Performance should not be a problem in most use cases. However,
you might want to be aware of the options that can affect performance.

- `--ansi` tells fzf to extract and parse ANSI color codes in the input, and it
  makes the initial scanning slower. So it's not recommended that you add it
  to your `$FZF_DEFAULT_OPTS`.
- `--nth` makes fzf slower because it has to tokenize each line.
- `--with-nth` makes fzf slower as fzf has to tokenize and reassemble each
  line.

### Executing external programs

You can set up key bindings for starting external processes without leaving
fzf (`execute`, `execute-silent`).

```bash
# Press F1 to open the file with less without leaving fzf
# Press CTRL-Y to copy the line to clipboard and aborts fzf (requires pbcopy)
fzf --bind 'f1:execute(less -f {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'
```

See *KEY BINDINGS* section of the man page for details.

### Turning into a different process

`become(...)` is similar to `execute(...)`/`execute-silent(...)` described
above, but instead of executing the command and coming back to fzf on
complete, it turns fzf into a new process for the command.

```sh
fzf --bind 'enter:become(vim {})'
```

Compared to the seemingly equivalent command substitution `vim "$(fzf)"`, this
approach has several advantages:

* Vim will not open an empty file when you terminate fzf with
  <kbd>CTRL-C</kbd>
* Vim will not open an empty file when you press <kbd>ENTER</kbd> on an empty
  result
* Can handle multiple selections even when they have whitespaces
  ```sh
  fzf --multi --bind 'enter:become(vim {+})'
  ```

To be fair, running `fzf --print0 | xargs -0 -o vim` instead of `vim "$(fzf)"`
resolves all of the issues mentioned. Nonetheless, `become(...)` still offers
additional benefits in different scenarios.

* You can set up multiple bindings to handle the result in different ways
  without any wrapping script
  ```sh
  fzf --bind 'enter:become(vim {}),ctrl-e:become(emacs {})'
  ```
  * Previously, you would have to use `--expect=ctrl-e` and check the first
    line of the output of fzf
* You can easily build the subsequent command using the field index
  expressions of fzf
  ```sh
  # Open the file in Vim and go to the line
  git grep --line-number . |
      fzf --delimiter : --nth 3.. --bind 'enter:become(vim {1} +{2})'
  ```

### Reloading the candidate list

By binding `reload` action to a key or an event, you can make fzf dynamically
reload the candidate list. See https://github.com/junegunn/fzf/issues/1750 for
more details.

#### 1. Update the list of processes by pressing CTRL-R

```sh
ps -ef |
  fzf --bind 'ctrl-r:reload(ps -ef)' \
      --header 'Press CTRL-R to reload' --header-lines=1 \
      --height=50% --layout=reverse
```

#### 2. Switch between sources by pressing CTRL-D or CTRL-F

```sh
FZF_DEFAULT_COMMAND='find . -type f' \
  fzf --bind 'ctrl-d:reload(find . -type d),ctrl-f:reload(eval "$FZF_DEFAULT_COMMAND")' \
      --height=50% --layout=reverse
```

#### 3. Interactive ripgrep integration

The following example uses fzf as the selector interface for ripgrep. We bound
`reload` action to `change` event, so every time you type on fzf, the ripgrep
process will restart with the updated query string denoted by the placeholder
expression `{q}`. Also, note that we used `--disabled` option so that fzf
doesn't perform any secondary filtering.

```sh
: | rg_prefix='rg --column --line-number --no-heading --color=always --smart-case' \
    fzf --bind 'start:reload:$rg_prefix ""' \
        --bind 'change:reload:$rg_prefix {q} || true' \
        --bind 'enter:become(vim {1} +{2})' \
        --ansi --disabled \
        --height=50% --layout=reverse
```

If ripgrep doesn't find any matches, it will exit with a non-zero exit status,
and fzf will warn you about it. To suppress the warning message, we added
`|| true` to the command, so that it always exits with 0.

See ["Using fzf as interactive Ripgrep launcher"](https://github.com/junegunn/fzf/blob/master/ADVANCED.md#using-fzf-as-interactive-ripgrep-launcher)
for more sophisticated examples.

### Preview window

When the `--preview` option is set, fzf automatically starts an external process
with the current line as the argument and shows the result in the split window.
Your `$SHELL` is used to execute the command with `$SHELL -c COMMAND`.
The window can be scrolled using the mouse or custom key bindings.

```bash
# {} is replaced with the single-quoted string of the focused line
fzf --preview 'cat {}'
```

Preview window supports ANSI colors, so you can use any program that
syntax-highlights the content of a file, such as
[Bat](https://github.com/sharkdp/bat) or
[Highlight](http://www.andre-simon.de/doku/highlight/en/highlight.php):

```bash
fzf --preview 'bat --color=always {}' --preview-window '~3'
```

You can customize the size, position, and border of the preview window using
`--preview-window` option, and the foreground and background color of it with
`--color` option. For example,

```bash
fzf --height 40% --layout reverse --info inline --border \
    --preview 'file {}' --preview-window up,1,border-horizontal \
    --bind 'ctrl-/:change-preview-window(50%|hidden|)' \
    --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'
```

See the man page (`man fzf`) for the full list of options.

More advanced examples can be found [here](https://github.com/junegunn/fzf/blob/master/ADVANCED.md).

----

Since fzf is a general-purpose text filter rather than a file finder, **it is
not a good idea to add `--preview` option to your `$FZF_DEFAULT_OPTS`**.

```sh
# *********************
# ** DO NOT DO THIS! **
# *********************
export FZF_DEFAULT_OPTS='--preview "bat --style=numbers --color=always --line-range :500 {}"'

# bat doesn't work with any input other than the list of files
ps -ef | fzf
seq 100 | fzf
history | fzf
```

Tips
----

### Respecting `.gitignore`

You can use [fd](https://github.com/sharkdp/fd),
[ripgrep](https://github.com/BurntSushi/ripgrep), or [the silver
searcher](https://github.com/ggreer/the_silver_searcher) instead of the
default find command to traverse the file system while respecting
`.gitignore`.

```sh
# Feed the output of fd into fzf
fd --type f --strip-cwd-prefix | fzf

# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

# Now fzf (w/o pipe) will use fd instead of find
fzf

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
```

If you want the command to follow symbolic links and don't want it to exclude
hidden files, use the following command:

```sh
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
```

### Fish shell

`CTRL-T` key binding of fish, unlike those of bash and zsh, will use the last
token on the command-line as the root directory for the recursive search. For
instance, hitting `CTRL-T` at the end of the following command-line

```sh
ls /var/
```

will list all files and directories under `/var/`.

When using a custom `FZF_CTRL_T_COMMAND`, use the unexpanded `$dir` variable to
make use of this feature. `$dir` defaults to `.` when the last token is not a
valid directory. Example:

```sh
set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"
```

Related projects
----------------

https://github.com/junegunn/fzf/wiki/Related-projects

[License](LICENSE)
------------------

The MIT License (MIT)

Copyright (c) 2013-2023 Junegunn Choi
./bin/fzf-tmux	[[[1
234
#!/usr/bin/env bash
# fzf-tmux: starts fzf in a tmux pane
# usage: fzf-tmux [LAYOUT OPTIONS] [--] [FZF OPTIONS]

fail() {
  >&2 echo "$1"
  exit 2
}

fzf="$(command -v fzf 2> /dev/null)" || fzf="$(dirname "$0")/fzf"
[[ -x "$fzf" ]] || fail 'fzf executable not found'

args=()
opt=""
skip=""
swap=""
close=""
term=""
[[ -n "$LINES" ]] && lines=$LINES || lines=$(tput lines) || lines=$(tmux display-message -p "#{pane_height}")
[[ -n "$COLUMNS" ]] && columns=$COLUMNS || columns=$(tput cols) || columns=$(tmux display-message -p "#{pane_width}")

help() {
  >&2 echo 'usage: fzf-tmux [LAYOUT OPTIONS] [--] [FZF OPTIONS]

  LAYOUT OPTIONS:
    (default layout: -d 50%)

    Popup window (requires tmux 3.2 or above):
      -p [WIDTH[%][,HEIGHT[%]]]  (default: 50%)
      -w WIDTH[%]
      -h HEIGHT[%]
      -x COL
      -y ROW

    Split pane:
      -u [HEIGHT[%]]             Split above (up)
      -d [HEIGHT[%]]             Split below (down)
      -l [WIDTH[%]]              Split left
      -r [WIDTH[%]]              Split right
'
  exit
}

while [[ $# -gt 0 ]]; do
  arg="$1"
  shift
  [[ -z "$skip" ]] && case "$arg" in
    -)
      term=1
      ;;
    --help)
      help
      ;;
    --version)
      echo "fzf-tmux (with fzf $("$fzf" --version))"
      exit
      ;;
    -p*|-w*|-h*|-x*|-y*|-d*|-u*|-r*|-l*)
      if [[ "$arg" =~ ^-[pwhxy] ]]; then
        [[ "$opt" =~ "-E" ]] || opt="-E"
      elif [[ "$arg" =~ ^.[lr] ]]; then
        opt="-h"
        if [[ "$arg" =~ ^.l ]]; then
          opt="$opt -d"
          swap="; swap-pane -D ; select-pane -L"
          close="; tmux swap-pane -D"
        fi
      else
        opt=""
        if [[ "$arg" =~ ^.u ]]; then
          opt="$opt -d"
          swap="; swap-pane -D ; select-pane -U"
          close="; tmux swap-pane -D"
        fi
      fi
      if [[ ${#arg} -gt 2 ]]; then
        size="${arg:2}"
      else
        if [[ "$1" =~ ^[0-9%,]+$ ]] || [[ "$1" =~ ^[A-Z]$ ]]; then
          size="$1"
          shift
        else
          continue
        fi
      fi

      if [[ "$arg" =~ ^-p ]]; then
        if [[ -n "$size" ]]; then
          w=${size%%,*}
          h=${size##*,}
          opt="$opt -w$w -h$h"
        fi
      elif [[ "$arg" =~ ^-[whxy] ]]; then
        opt="$opt ${arg:0:2}$size"
      elif [[ "$size" =~ %$ ]]; then
        size=${size:0:((${#size}-1))}
        if [[ -n "$swap" ]]; then
          opt="$opt -p $(( 100 - size ))"
        else
          opt="$opt -p $size"
        fi
      else
        if [[ -n "$swap" ]]; then
          if [[ "$arg" =~ ^.l ]]; then
            max=$columns
          else
            max=$lines
          fi
          size=$(( max - size ))
          [[ $size -lt 0 ]] && size=0
          opt="$opt -l $size"
        else
          opt="$opt -l $size"
        fi
      fi
      ;;
    --)
      # "--" can be used to separate fzf-tmux options from fzf options to
      # avoid conflicts
      skip=1
      continue
      ;;
    *)
      args+=("$arg")
      ;;
  esac
  [[ -n "$skip" ]] && args+=("$arg")
done

if [[ -z "$TMUX" ]]; then
  "$fzf" "${args[@]}"
  exit $?
fi

# --height option is not allowed. CTRL-Z is also disabled.
args=("${args[@]}" "--no-height" "--bind=ctrl-z:ignore")

# Handle zoomed tmux pane without popup options by moving it to a temp window
if [[ ! "$opt" =~ "-E" ]] && tmux list-panes -F '#F' | grep -q Z; then
  zoomed_without_popup=1
  original_window=$(tmux display-message -p "#{window_id}")
  tmp_window=$(tmux new-window -d -P -F "#{window_id}" "bash -c 'while :; do for c in \\| / - '\\;' do sleep 0.2; printf \"\\r\$c fzf-tmux is running\\r\"; done; done'")
  tmux swap-pane -t $tmp_window \; select-window -t $tmp_window
fi

set -e

# Clean up named pipes on exit
id=$RANDOM
argsf="${TMPDIR:-/tmp}/fzf-args-$id"
fifo1="${TMPDIR:-/tmp}/fzf-fifo1-$id"
fifo2="${TMPDIR:-/tmp}/fzf-fifo2-$id"
fifo3="${TMPDIR:-/tmp}/fzf-fifo3-$id"
tmux_win_opts=( $(tmux show-window-options remain-on-exit \; show-window-options synchronize-panes | sed '/ off/d; s/^/set-window-option /; s/$/ \\;/') )
cleanup() {
  \rm -f $argsf $fifo1 $fifo2 $fifo3

  # Restore tmux window options
  if [[ "${#tmux_win_opts[@]}" -gt 0 ]]; then
    eval "tmux ${tmux_win_opts[*]}"
  fi

  # Remove temp window if we were zoomed without popup options
  if [[ -n "$zoomed_without_popup" ]]; then
    tmux display-message -p "#{window_id}" > /dev/null
    tmux swap-pane -t $original_window \; \
      select-window -t $original_window \; \
      kill-window -t $tmp_window \; \
      resize-pane -Z
  fi

  if [[ $# -gt 0 ]]; then
    trap - EXIT
    exit 130
  fi
}
trap 'cleanup 1' SIGUSR1
trap 'cleanup' EXIT

envs="export TERM=$TERM "
if [[ "$opt" =~ "-E" ]]; then
  tmux_version=$(tmux -V | sed 's/[^0-9.]//g')
  if [[ $(awk '{print ($1 > 3.2)}' <<< "$tmux_version" 2> /dev/null || bc -l <<< "$tmux_version > 3.2") = 1 ]]; then
    FZF_DEFAULT_OPTS="--border $FZF_DEFAULT_OPTS"
    opt="-B $opt"
  elif [[ $tmux_version = 3.2 ]]; then
    FZF_DEFAULT_OPTS="--margin 0,1 $FZF_DEFAULT_OPTS"
  else
    echo "fzf-tmux: tmux 3.2 or above is required for popup mode" >&2
    exit 2
  fi
fi
[[ -n "$FZF_DEFAULT_OPTS"    ]] && envs="$envs FZF_DEFAULT_OPTS=$(printf %q "$FZF_DEFAULT_OPTS")"
[[ -n "$FZF_DEFAULT_COMMAND" ]] && envs="$envs FZF_DEFAULT_COMMAND=$(printf %q "$FZF_DEFAULT_COMMAND")"
[[ -n "$BAT_THEME" ]] && envs="$envs BAT_THEME=$(printf %q "$BAT_THEME")"
echo "$envs;" > "$argsf"

# Build arguments to fzf
opts=$(printf "%q " "${args[@]}")

pppid=$$
echo -n "trap 'kill -SIGUSR1 -$pppid' EXIT SIGINT SIGTERM;" >> $argsf
close="; trap - EXIT SIGINT SIGTERM $close"

export TMUX=$(cut -d , -f 1,2 <<< "$TMUX")
mkfifo -m o+w $fifo2
if [[ "$opt" =~ "-E" ]]; then
  cat $fifo2 &
  if [[ -n "$term" ]] || [[ -t 0 ]]; then
    cat <<< "\"$fzf\" $opts > $fifo2; out=\$? $close; exit \$out" >> $argsf
  else
    mkfifo $fifo1
    cat <<< "\"$fzf\" $opts < $fifo1 > $fifo2; out=\$? $close; exit \$out" >> $argsf
    cat <&0 > $fifo1 &
  fi

  tmux popup -d "$PWD" $opt "bash $argsf" > /dev/null 2>&1
  exit $?
fi

mkfifo -m o+w $fifo3
if [[ -n "$term" ]] || [[ -t 0 ]]; then
  cat <<< "\"$fzf\" $opts > $fifo2; echo \$? > $fifo3 $close" >> $argsf
else
  mkfifo $fifo1
  cat <<< "\"$fzf\" $opts < $fifo1 > $fifo2; echo \$? > $fifo3 $close" >> $argsf
  cat <&0 > $fifo1 &
fi
tmux set-window-option synchronize-panes off \;\
  set-window-option remain-on-exit off \;\
  split-window -c "$PWD" $opt "bash -c 'exec -a fzf bash $argsf'" $swap \
  > /dev/null 2>&1 || { "$fzf" "${args[@]}"; exit $?; }
cat $fifo2
exit "$(cat $fifo3)"
./doc/fzf.txt	[[[1
512
fzf.txt	fzf	Last change: Mar 20 2023
FZF - TABLE OF CONTENTS                                            *fzf* *fzf-toc*
==============================================================================

  FZF Vim integration                       |fzf-vim-integration|
    Installation                            |fzf-installation|
    Summary                                 |fzf-summary|
    :FZF[!]                                 |:FZF|
      Configuration                         |fzf-configuration|
        Examples                            |fzf-examples|
          Explanation of g:fzf_colors       |fzf-explanation-of-gfzfcolors|
    fzf#run                                 |fzf#run|
    fzf#wrap                                |fzf#wrap|
      Global options supported by fzf#wrap  |fzf-global-options-supported-by-fzf#wrap|
    Tips                                    |fzf-tips|
      fzf inside terminal buffer            |fzf-inside-terminal-buffer|
      Starting fzf in a popup window        |fzf-starting-fzf-in-a-popup-window|
      Hide statusline                       |fzf-hide-statusline|
    License                                 |fzf-license|

FZF VIM INTEGRATION                                        *fzf-vim-integration*
==============================================================================


INSTALLATION                                                  *fzf-installation*
==============================================================================

Once you have fzf installed, you can enable it inside Vim simply by adding the
directory to 'runtimepath' in your Vim configuration file. The path may differ
depending on the package manager.
>
    " If installed using Homebrew
    set rtp+=/usr/local/opt/fzf

    " If you have cloned fzf on ~/.fzf directory
    set rtp+=~/.fzf
<
If you use {vim-plug}{1}, the same can be written as:
>
    " If installed using Homebrew
    Plug '/usr/local/opt/fzf'

    " If you have cloned fzf on ~/.fzf directory
    Plug '~/.fzf'
<
But if you want the latest Vim plugin file from GitHub rather than the one
included in the package, write:
>
    Plug 'junegunn/fzf'
<
The Vim plugin will pick up fzf binary available on the system. If fzf is not
found on `$PATH`, it will ask you if it should download the latest binary for
you.

To make sure that you have the latest version of the binary, set up
post-update hook like so:

                                                                   *fzf#install*
>
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
<
                                      {1} https://github.com/junegunn/vim-plug


SUMMARY                                                            *fzf-summary*
==============================================================================

The Vim plugin of fzf provides two core functions, and `:FZF` command which is
the basic file selector command built on top of them.

 1. `fzf#run([spec dict])`
   - Starts fzf inside Vim with the given spec
   - `:call fzf#run({'source': 'ls'})`
 2. `fzf#wrap([spec dict]) -> (dict)`
   - Takes a spec for `fzf#run` and returns an extended version of it with
     additional options for addressing global preferences (`g:fzf_xxx`)
     - `:echo fzf#wrap({'source': 'ls'})`
   - We usually wrap a spec with `fzf#wrap` before passing it to `fzf#run`
     - `:call fzf#run(fzf#wrap({'source': 'ls'}))`
 3. `:FZF [fzf_options string] [path string]`
   - Basic fuzzy file selector
   - A reference implementation for those who don't want to write VimScript to
     implement custom commands
   - If you're looking for more such commands, check out {fzf.vim}{2} project.

The most important of all is `fzf#run`, but it would be easier to understand
the whole if we start off with `:FZF` command.

                                       {2} https://github.com/junegunn/fzf.vim


:FZF[!]
==============================================================================

                                                                          *:FZF*
>
    " Look for files under current directory
    :FZF

    " Look for files under your home directory
    :FZF ~

    " With fzf command-line options
    :FZF --reverse --info=inline /tmp

    " Bang version starts fzf in fullscreen mode
    :FZF!
<
Similarly to {ctrlp.vim}{3}, use enter key, CTRL-T, CTRL-X or CTRL-V to open
selected files in the current window, in new tabs, in horizontal splits, or in
vertical splits respectively.

Note that the environment variables `FZF_DEFAULT_COMMAND` and
`FZF_DEFAULT_OPTS` also apply here.

                                         {3} https://github.com/kien/ctrlp.vim


< Configuration >_____________________________________________________________~
                                                             *fzf-configuration*

                      *g:fzf_action* *g:fzf_layout* *g:fzf_colors* *g:fzf_history_dir*

 - `g:fzf_action`
   - Customizable extra key bindings for opening selected files in different
     ways
 - `g:fzf_layout`
   - Determines the size and position of fzf window
 - `g:fzf_colors`
   - Customizes fzf colors to match the current color scheme
 - `g:fzf_history_dir`
   - Enables history feature


Examples~
                                                                  *fzf-examples*
>
    " This is the default extra key bindings
    let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

    " An action can be a reference to a function that processes selected lines
    function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
      copen
      cc
    endfunction

    let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

    " Default fzf layout
    " - Popup window (center of the screen)
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

    " - Popup window (center of the current window)
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true } }

    " - Popup window (anchored to the bottom of the current window)
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }

    " - down / up / left / right
    let g:fzf_layout = { 'down': '40%' }

    " - Window using a Vim command
    let g:fzf_layout = { 'window': 'enew' }
    let g:fzf_layout = { 'window': '-tabnew' }
    let g:fzf_layout = { 'window': '10new' }

    " Customize fzf colors to match your color scheme
    " - fzf#wrap translates this to a set of `--color` options
    let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

    " Enable per-command history
    " - History files will be stored in the specified directory
    " - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
    "   'previous-history' instead of 'down' and 'up'.
    let g:fzf_history_dir = '~/.local/share/fzf-history'
<

Explanation of g:fzf_colors~
                                                 *fzf-explanation-of-gfzfcolors*

`g:fzf_colors` is a dictionary mapping fzf elements to a color specification
list:
>
    element: [ component, group1 [, group2, ...] ]
<
 - `element` is an fzf element to apply a color to:

 ----------------------------+------------------------------------------------------
 Element                     | Description                                          ~
 ----------------------------+------------------------------------------------------
  `fg`   /  `bg`   /  `hl`         | Item (foreground / background / highlight)
  `fg+`  /  `bg+`  /  `hl+`        | Current item (foreground / background / highlight)
  `preview-fg`  /  `preview-bg`  | Preview window text and background
  `hl`   /  `hl+`                | Highlighted substrings (normal / current)
  `gutter`                     | Background of the gutter on the left
  `pointer`                    | Pointer to the current line ( `>` )
  `marker`                     | Multi-select marker ( `>` )
  `border`                     | Border around the window ( `--border`  and  `--preview` )
  `header`                     | Header ( `--header`  or  `--header-lines` )
  `info`                       | Info line (match counters)
  `spinner`                    | Streaming input indicator
  `query`                      | Query string
  `disabled`                   | Query string when search is disabled
  `prompt`                     | Prompt before query ( `> ` )
  `pointer`                    | Pointer to the current line ( `>` )
 ----------------------------+------------------------------------------------------
 - `component` specifies the component (`fg` / `bg`) from which to extract the
   color when considering each of the following highlight groups
 - `group1 [, group2, ...]` is a list of highlight groups that are searched (in
   order) for a matching color definition

For example, consider the following specification:
>
      'prompt':  ['fg', 'Conditional', 'Comment'],
<
This means we color the prompt - using the `fg` attribute of the `Conditional`
if it exists, - otherwise use the `fg` attribute of the `Comment` highlight
group if it exists, - otherwise fall back to the default color settings for
the prompt.

You can examine the color option generated according the setting by printing
the result of `fzf#wrap()` function like so:
>
    :echo fzf#wrap()
<

FZF#RUN
==============================================================================

                                                                       *fzf#run*

`fzf#run()` function is the core of Vim integration. It takes a single
dictionary argument, a spec, and starts fzf process accordingly. At the very
least, specify `sink` option to tell what it should do with the selected
entry.
>
    call fzf#run({'sink': 'e'})
<
We haven't specified the `source`, so this is equivalent to starting fzf on
command line without standard input pipe; fzf will use find command (or
`$FZF_DEFAULT_COMMAND` if defined) to list the files under the current
directory. When you select one, it will open it with the sink, `:e` command.
If you want to open it in a new tab, you can pass `:tabedit` command instead
as the sink.
>
    call fzf#run({'sink': 'tabedit'})
<
Instead of using the default find command, you can use any shell command as
the source. The following example will list the files managed by git. It's
equivalent to running `git ls-files | fzf` on shell.
>
    call fzf#run({'source': 'git ls-files', 'sink': 'e'})
<
fzf options can be specified as `options` entry in spec dictionary.
>
    call fzf#run({'sink': 'tabedit', 'options': '--multi --reverse'})
<
You can also pass a layout option if you don't want fzf window to take up the
entire screen.
>
    " up / down / left / right / window are allowed
    call fzf#run({'source': 'git ls-files', 'sink': 'e', 'left': '40%'})
    call fzf#run({'source': 'git ls-files', 'sink': 'e', 'window': '30vnew'})
<
`source` doesn't have to be an external shell command, you can pass a Vim
array as the source. In the next example, we pass the names of color schemes
as the source to implement a color scheme selector.
>
    call fzf#run({'source': map(split(globpath(&rtp, 'colors/*.vim')),
                \               'fnamemodify(v:val, ":t:r")'),
                \ 'sink': 'colo', 'left': '25%'})
<
The following table summarizes the available options.

 ---------------------------+---------------+----------------------------------------------------------------------
 Option name                | Type          | Description                                                          ~
 ---------------------------+---------------+----------------------------------------------------------------------
  `source`                    | string        | External command to generate input to fzf (e.g.  `find .` )
  `source`                    | list          | Vim list as input to fzf
  `sink`                      | string        | Vim command to handle the selected item (e.g.  `e` ,  `tabe` )
  `sink`                      | funcref       | Reference to function to process each selected item
  `sinklist`  (or  `sink*` )    | funcref       | Similar to  `sink` , but takes the list of output lines at once
  `options`                   | string/list   | Options to fzf
  `dir`                       | string        | Working directory
  `up` / `down` / `left` / `right`  | number/string | (Layout) Window position and size (e.g.  `20` ,  `50%` )
  `tmux`                      | string        | (Layout) fzf-tmux options (e.g.  `-p90%,60%` )
  `window`  (Vim 8 / Neovim)  | string        | (Layout) Command to open fzf window (e.g.  `vertical aboveleft 30new` )
  `window`  (Vim 8 / Neovim)  | dict          | (Layout) Popup window settings (e.g.  `{'width': 0.9, 'height': 0.6}` )
 ---------------------------+---------------+----------------------------------------------------------------------

`options` entry can be either a string or a list. For simple cases, string
should suffice, but prefer to use list type to avoid escaping issues.
>
    call fzf#run({'options': '--reverse --prompt "C:\\Program Files\\"'})
    call fzf#run({'options': ['--reverse', '--prompt', 'C:\Program Files\']})
<
When `window` entry is a dictionary, fzf will start in a popup window. The
following options are allowed:

 - Required:
   - `width` [float range [0 ~ 1]] or [integer range [8 ~ ]]
   - `height` [float range [0 ~ 1]] or [integer range [4 ~ ]]
 - Optional:
   - `yoffset` [float default 0.5 range [0 ~ 1]]
   - `xoffset` [float default 0.5 range [0 ~ 1]]
   - `relative` [boolean default v:false]
   - `border` [string default `rounded` (`sharp` on Windows)]: Border style
     - `rounded` / `sharp` / `horizontal` / `vertical` / `top` / `bottom` / `left` / `right` / `no[ne]`


FZF#WRAP
==============================================================================

                                                                      *fzf#wrap*

We have seen that several aspects of `:FZF` command can be configured with a
set of global option variables; different ways to open files (`g:fzf_action`),
window position and size (`g:fzf_layout`), color palette (`g:fzf_colors`),
etc.

So how can we make our custom `fzf#run` calls also respect those variables?
Simply by "wrapping" the spec dictionary with `fzf#wrap` before passing it to
`fzf#run`.

 - `fzf#wrap([name string], [spec dict], [fullscreen bool]) -> (dict)`
   - All arguments are optional. Usually we only need to pass a spec
     dictionary.
   - `name` is for managing history files. It is ignored if `g:fzf_history_dir`
     is not defined.
   - `fullscreen` can be either `0` or `1` (default: 0).

`fzf#wrap` takes a spec and returns an extended version of it (also a
dictionary) with additional options for addressing global preferences. You can
examine the return value of it like so:
>
    echo fzf#wrap({'source': 'ls'})
<
After we "wrap" our spec, we pass it to `fzf#run`.
>
    call fzf#run(fzf#wrap({'source': 'ls'}))
<
Now it supports CTRL-T, CTRL-V, and CTRL-X key bindings (configurable via
`g:fzf_action`) and it opens fzf window according to `g:fzf_layout` setting.

To make it easier to use, let's define `LS` command.
>
    command! LS call fzf#run(fzf#wrap({'source': 'ls'}))
<
Type `:LS` and see how it works.

We would like to make `:LS!` (bang version) open fzf in fullscreen, just like
`:FZF!`. Add `-bang` to command definition, and use <bang> value to set the
last `fullscreen` argument of `fzf#wrap` (see :help <bang>).
>
    " On :LS!, <bang> evaluates to '!', and '!0' becomes 1
    command! -bang LS call fzf#run(fzf#wrap({'source': 'ls'}, <bang>0))
<
Our `:LS` command will be much more useful if we can pass a directory argument
to it, so that something like `:LS /tmp` is possible.
>
    command! -bang -complete=dir -nargs=? LS
        \ call fzf#run(fzf#wrap({'source': 'ls', 'dir': <q-args>}, <bang>0))
<
Lastly, if you have enabled `g:fzf_history_dir`, you might want to assign a
unique name to our command and pass it as the first argument to `fzf#wrap`.
>
    " The query history for this command will be stored as 'ls' inside g:fzf_history_dir.
    " The name is ignored if g:fzf_history_dir is not defined.
    command! -bang -complete=dir -nargs=? LS
        \ call fzf#run(fzf#wrap('ls', {'source': 'ls', 'dir': <q-args>}, <bang>0))
<

< Global options supported by fzf#wrap >______________________________________~
                                      *fzf-global-options-supported-by-fzf#wrap*

 - `g:fzf_layout`
 - `g:fzf_action`
   - Works only when no custom `sink` (or `sink*`) is provided
     - Having custom sink usually means that each entry is not an ordinary
       file path (e.g. name of color scheme), so we can't blindly apply the
       same strategy (i.e. `tabedit some-color-scheme` doesn't make sense)
 - `g:fzf_colors`
 - `g:fzf_history_dir`


TIPS                                                                  *fzf-tips*
==============================================================================


< fzf inside terminal buffer >________________________________________________~
                                                    *fzf-inside-terminal-buffer*

The latest versions of Vim and Neovim include builtin terminal emulator
(`:terminal`) and fzf will start in a terminal buffer in the following cases:

 - On Neovim
 - On GVim
 - On Terminal Vim with a non-default layout
   - `call fzf#run({'left': '30%'})` or `let g:fzf_layout = {'left': '30%'}`

On the latest versions of Vim and Neovim, fzf will start in a terminal buffer.
If you find the default ANSI colors to be different, consider configuring the
colors using `g:terminal_ansi_colors` in regular Vim or `g:terminal_color_x`
in Neovim.

                   *g:terminal_color_15* *g:terminal_color_14* *g:terminal_color_13*
*g:terminal_color_12* *g:terminal_color_11* *g:terminal_color_10* *g:terminal_color_9*
   *g:terminal_color_8* *g:terminal_color_7* *g:terminal_color_6* *g:terminal_color_5*
   *g:terminal_color_4* *g:terminal_color_3* *g:terminal_color_2* *g:terminal_color_1*
                                                            *g:terminal_color_0*
>
    " Terminal colors for seoul256 color scheme
    if has('nvim')
      let g:terminal_color_0 = '#4e4e4e'
      let g:terminal_color_1 = '#d68787'
      let g:terminal_color_2 = '#5f865f'
      let g:terminal_color_3 = '#d8af5f'
      let g:terminal_color_4 = '#85add4'
      let g:terminal_color_5 = '#d7afaf'
      let g:terminal_color_6 = '#87afaf'
      let g:terminal_color_7 = '#d0d0d0'
      let g:terminal_color_8 = '#626262'
      let g:terminal_color_9 = '#d75f87'
      let g:terminal_color_10 = '#87af87'
      let g:terminal_color_11 = '#ffd787'
      let g:terminal_color_12 = '#add4fb'
      let g:terminal_color_13 = '#ffafaf'
      let g:terminal_color_14 = '#87d7d7'
      let g:terminal_color_15 = '#e4e4e4'
    else
      let g:terminal_ansi_colors = [
        \ '#4e4e4e', '#d68787', '#5f865f', '#d8af5f',
        \ '#85add4', '#d7afaf', '#87afaf', '#d0d0d0',
        \ '#626262', '#d75f87', '#87af87', '#ffd787',
        \ '#add4fb', '#ffafaf', '#87d7d7', '#e4e4e4'
      \ ]
    endif
<

< Starting fzf in a popup window >____________________________________________~
                                            *fzf-starting-fzf-in-a-popup-window*
>
    " Required:
    " - width [float range [0 ~ 1]] or [integer range [8 ~ ]]
    " - height [float range [0 ~ 1]] or [integer range [4 ~ ]]
    "
    " Optional:
    " - xoffset [float default 0.5 range [0 ~ 1]]
    " - yoffset [float default 0.5 range [0 ~ 1]]
    " - relative [boolean default v:false]
    " - border [string default 'rounded']: Border style
    "   - 'rounded' / 'sharp' / 'horizontal' / 'vertical' / 'top' / 'bottom' / 'left' / 'right'
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
<
Alternatively, you can make fzf open in a tmux popup window (requires tmux 3.2
or above) by putting fzf-tmux options in `tmux` key.
>
    " See `man fzf-tmux` for available options
    if exists('$TMUX')
      let g:fzf_layout = { 'tmux': '-p90%,60%' }
    else
      let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
    endif
<

< Hide statusline >___________________________________________________________~
                                                           *fzf-hide-statusline*

When fzf starts in a terminal buffer, the file type of the buffer is set to
`fzf`. So you can set up `FileType fzf` autocmd to customize the settings of
the window.

For example, if you open fzf on the bottom on the screen (e.g. `{'down':
'40%'}`), you might want to temporarily disable the statusline for a cleaner
look.
>
    let g:fzf_layout = { 'down': '30%' }
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
<

LICENSE                                                            *fzf-license*
==============================================================================

The MIT License (MIT)

Copyright (c) 2013-2023 Junegunn Choi

==============================================================================
vim:tw=78:sw=2:ts=2:ft=help:norl:nowrap:
./go.mod	[[[1
21
module github.com/junegunn/fzf

require (
	github.com/gdamore/tcell/v2 v2.5.4
	github.com/mattn/go-isatty v0.0.17
	github.com/mattn/go-runewidth v0.0.14
	github.com/mattn/go-shellwords v1.0.12
	github.com/rivo/uniseg v0.4.4
	github.com/saracen/walker v0.1.3
	golang.org/x/sys v0.9.0
	golang.org/x/term v0.9.0
)

require (
	github.com/gdamore/encoding v1.0.0 // indirect
	github.com/lucasb-eyer/go-colorful v1.2.0 // indirect
	golang.org/x/sync v0.0.0-20220722155255-886fb9371eb4 // indirect
	golang.org/x/text v0.5.0 // indirect
)

go 1.17
./go.sum	[[[1
49
github.com/gdamore/encoding v1.0.0 h1:+7OoQ1Bc6eTm5niUzBa0Ctsh6JbMW6Ra+YNuAtDBdko=
github.com/gdamore/encoding v1.0.0/go.mod h1:alR0ol34c49FCSBLjhosxzcPHQbf2trDkoo5dl+VrEg=
github.com/gdamore/tcell/v2 v2.5.4 h1:TGU4tSjD3sCL788vFNeJnTdzpNKIw1H5dgLnJRQVv/k=
github.com/gdamore/tcell/v2 v2.5.4/go.mod h1:dZgRy5v4iMobMEcWNYBtREnDZAT9DYmfqIkrgEMxLyw=
github.com/lucasb-eyer/go-colorful v1.2.0 h1:1nnpGOrhyZZuNyfu1QjKiUICQ74+3FNCN69Aj6K7nkY=
github.com/lucasb-eyer/go-colorful v1.2.0/go.mod h1:R4dSotOR9KMtayYi1e77YzuveK+i7ruzyGqttikkLy0=
github.com/mattn/go-isatty v0.0.17 h1:BTarxUcIeDqL27Mc+vyvdWYSL28zpIhv3RoTdsLMPng=
github.com/mattn/go-isatty v0.0.17/go.mod h1:kYGgaQfpe5nmfYZH+SKPsOc2e4SrIfOl2e/yFXSvRLM=
github.com/mattn/go-runewidth v0.0.14 h1:+xnbZSEeDbOIg5/mE6JF0w6n9duR1l3/WmbinWVwUuU=
github.com/mattn/go-runewidth v0.0.14/go.mod h1:Jdepj2loyihRzMpdS35Xk/zdY8IAYHsh153qUoGf23w=
github.com/mattn/go-shellwords v1.0.12 h1:M2zGm7EW6UQJvDeQxo4T51eKPurbeFbe8WtebGE2xrk=
github.com/mattn/go-shellwords v1.0.12/go.mod h1:EZzvwXDESEeg03EKmM+RmDnNOPKG4lLtQsUlTZDWQ8Y=
github.com/rivo/uniseg v0.2.0/go.mod h1:J6wj4VEh+S6ZtnVlnTBMWIodfgj8LQOQFoIToxlJtxc=
github.com/rivo/uniseg v0.4.4 h1:8TfxU8dW6PdqD27gjM8MVNuicgxIjxpm4K7x4jp8sis=
github.com/rivo/uniseg v0.4.4/go.mod h1:FN3SvrM+Zdj16jyLfmOkMNblXMcoc8DfTHruCPUcx88=
github.com/saracen/walker v0.1.3 h1:YtcKKmpRPy6XJTHJ75J2QYXXZYWnZNQxPCVqZSHVV/g=
github.com/saracen/walker v0.1.3/go.mod h1:FU+7qU8DeQQgSZDmmThMJi93kPkLFgy0oVAcLxurjIk=
github.com/yuin/goldmark v1.4.13/go.mod h1:6yULJ656Px+3vBD8DxQVa3kxgyrAnzto9xy5taEt/CY=
golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod h1:djNgcEr1/C05ACkg1iLfiJU5Ep61QUkGW8qpdssI0+w=
golang.org/x/crypto v0.0.0-20210921155107-089bfa567519/go.mod h1:GvvjBRRGRdwPK5ydBHafDWAxML/pGHZbMvKqRZ5+Abc=
golang.org/x/mod v0.6.0-dev.0.20220419223038-86c51ed26bb4/go.mod h1:jJ57K6gSWd91VN4djpZkiMVwK6gcyfeH4XE8wZrZaV4=
golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod h1:z5CRVTTTmAJ677TzLLGU+0bjPO0LkuOLi4/5GtJWs/s=
golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod h1:m0MpNAwzfU5UDzcl9v0D8zg8gWTRqZa9RBIspLL5mdg=
golang.org/x/net v0.0.0-20220722155237-a158d28d115b/go.mod h1:XRhObCWvk6IyKnWLug+ECip1KBveYUHfp+8e9klMJ9c=
golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM=
golang.org/x/sync v0.0.0-20220601150217-0de741cfad7f/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM=
golang.org/x/sync v0.0.0-20220722155255-886fb9371eb4 h1:uVc8UZUe6tr40fFVnUP5Oj+veunVezqYl9z7DYw9xzw=
golang.org/x/sync v0.0.0-20220722155255-886fb9371eb4/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM=
golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod h1:STP8DvDyc/dI5b8T5hshtkjS+E42TnysNCUPdjciGhY=
golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
golang.org/x/sys v0.0.0-20220722155257-8c9f86f7a55f/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
golang.org/x/sys v0.0.0-20220811171246-fbc7d0a398ab/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
golang.org/x/sys v0.9.0 h1:KS/R3tvhPqvJvwcKfnBHJwwthS11LRhmM5D59eEXa0s=
golang.org/x/sys v0.9.0/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod h1:bj7SfCRtBDWHUb9snDiAeCFNEtKQo2Wmx5Cou7ajbmo=
golang.org/x/term v0.0.0-20210927222741-03fcf44c2211/go.mod h1:jbD1KX2456YbFQfuXm/mYQcufACuNUgVhRMnK/tPxf8=
golang.org/x/term v0.9.0 h1:GRRCnKYhdQrD8kfRAdQ6Zcw1P0OcELxGLKJvtjVMZ28=
golang.org/x/term v0.9.0/go.mod h1:M6DEAAIenWoTxdKrOltXcmDY3rSplQUkrvaDU5FcQyo=
golang.org/x/text v0.3.0/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
golang.org/x/text v0.3.3/go.mod h1:5Zoc/QRtKVWzQhOtBMvqHzDpF6irO9z98xDceosuGiQ=
golang.org/x/text v0.3.7/go.mod h1:u+2+/6zg+i71rQMx5EYifcz6MCKuco9NR6JIITiCfzQ=
golang.org/x/text v0.5.0 h1:OLmvp0KP+FVG99Ct/qFiL/Fhk4zp4QQnZ7b2U+5piUM=
golang.org/x/text v0.5.0/go.mod h1:mrYo+phRRbMaCq/xk9113O4dZlRixOauAjOtrjsXDZ8=
golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod h1:n7NCudcB/nEzxVGmLbDWY5pfWTLqBcC2KZ6jyYvM4mQ=
golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod h1:b+2E5dAYhXwXZwtnZ6UAqBI28+e2cm9otk0dWdXHAEo=
golang.org/x/tools v0.1.12/go.mod h1:hNGJHUnrk76NpqgfD5Aqm5Crs+Hm0VOH/i9J2+nxYbc=
golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0=
./install	[[[1
380
#!/usr/bin/env bash

set -u

version=0.42.0
auto_completion=
key_bindings=
update_config=2
shells="bash zsh fish"
prefix='~/.fzf'
prefix_expand=~/.fzf
fish_dir=${XDG_CONFIG_HOME:-$HOME/.config}/fish

help() {
  cat << EOF
usage: $0 [OPTIONS]

    --help               Show this message
    --bin                Download fzf binary only; Do not generate ~/.fzf.{bash,zsh}
    --all                Download fzf binary and update configuration files
                         to enable key bindings and fuzzy completion
    --xdg                Generate files under \$XDG_CONFIG_HOME/fzf
    --[no-]key-bindings  Enable/disable key bindings (CTRL-T, CTRL-R, ALT-C)
    --[no-]completion    Enable/disable fuzzy completion (bash & zsh)
    --[no-]update-rc     Whether or not to update shell configuration files

    --no-bash            Do not set up bash configuration
    --no-zsh             Do not set up zsh configuration
    --no-fish            Do not set up fish configuration
EOF
}

for opt in "$@"; do
  case $opt in
    --help)
      help
      exit 0
      ;;
    --all)
      auto_completion=1
      key_bindings=1
      update_config=1
      ;;
    --xdg)
      prefix='"${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf'
      prefix_expand=${XDG_CONFIG_HOME:-$HOME/.config}/fzf/fzf
      mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/fzf"
      ;;
    --key-bindings)    key_bindings=1    ;;
    --no-key-bindings) key_bindings=0    ;;
    --completion)      auto_completion=1 ;;
    --no-completion)   auto_completion=0 ;;
    --update-rc)       update_config=1   ;;
    --no-update-rc)    update_config=0   ;;
    --bin)             ;;
    --no-bash)         shells=${shells/bash/} ;;
    --no-zsh)          shells=${shells/zsh/} ;;
    --no-fish)         shells=${shells/fish/} ;;
    *)
      echo "unknown option: $opt"
      help
      exit 1
      ;;
  esac
done

cd "$(dirname "${BASH_SOURCE[0]}")"
fzf_base=$(pwd)
fzf_base_esc=$(printf %q "$fzf_base")

ask() {
  while true; do
    read -p "$1 ([y]/n) " -r
    REPLY=${REPLY:-"y"}
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      return 1
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      return 0
    fi
  done
}

check_binary() {
  echo -n "  - Checking fzf executable ... "
  local output
  output=$("$fzf_base"/bin/fzf --version 2>&1)
  if [ $? -ne 0 ]; then
    echo "Error: $output"
    binary_error="Invalid binary"
  else
    output=${output/ */}
    if [ "$version" != "$output" ]; then
      echo "$output != $version"
      binary_error="Invalid version"
    else
      echo "$output"
      binary_error=""
      return 0
    fi
  fi
  rm -f "$fzf_base"/bin/fzf
  return 1
}

link_fzf_in_path() {
  if which_fzf="$(command -v fzf)"; then
    echo "  - Found in \$PATH"
    echo "  - Creating symlink: bin/fzf -> $which_fzf"
    (cd "$fzf_base"/bin && rm -f fzf && ln -sf "$which_fzf" fzf)
    check_binary && return
  fi
  return 1
}

try_curl() {
  command -v curl > /dev/null &&
  if [[ $1 =~ tar.gz$ ]]; then
    curl -fL $1 | tar -xzf -
  else
    local temp=${TMPDIR:-/tmp}/fzf.zip
    curl -fLo "$temp" $1 && unzip -o "$temp" && rm -f "$temp"
  fi
}

try_wget() {
  command -v wget > /dev/null &&
  if [[ $1 =~ tar.gz$ ]]; then
    wget -O - $1 | tar -xzf -
  else
    local temp=${TMPDIR:-/tmp}/fzf.zip
    wget -O "$temp" $1 && unzip -o "$temp" && rm -f "$temp"
  fi
}

download() {
  echo "Downloading bin/fzf ..."
  if [ -x "$fzf_base"/bin/fzf ]; then
    echo "  - Already exists"
    check_binary && return
  fi
  link_fzf_in_path && return
  mkdir -p "$fzf_base"/bin && cd "$fzf_base"/bin
  if [ $? -ne 0 ]; then
    binary_error="Failed to create bin directory"
    return
  fi

  local url
  url=https://github.com/junegunn/fzf/releases/download/$version/${1}
  set -o pipefail
  if ! (try_curl $url || try_wget $url); then
    set +o pipefail
    binary_error="Failed to download with curl and wget"
    return
  fi
  set +o pipefail

  if [ ! -f fzf ]; then
    binary_error="Failed to download ${1}"
    return
  fi

  chmod +x fzf && check_binary
}

# Try to download binary executable
archi=$(uname -sm)
binary_available=1
binary_error=""
case "$archi" in
  Darwin\ arm64)      download fzf-$version-darwin_arm64.zip     ;;
  Darwin\ x86_64)     download fzf-$version-darwin_amd64.zip     ;;
  Linux\ armv5*)      download fzf-$version-linux_armv5.tar.gz   ;;
  Linux\ armv6*)      download fzf-$version-linux_armv6.tar.gz   ;;
  Linux\ armv7*)      download fzf-$version-linux_armv7.tar.gz   ;;
  Linux\ armv8*)      download fzf-$version-linux_arm64.tar.gz   ;;
  Linux\ aarch64*)    download fzf-$version-linux_arm64.tar.gz   ;;
  Linux\ loongarch64) download fzf-$version-linux_loong64.tar.gz ;;
  Linux\ ppc64le)     download fzf-$version-linux_ppc64le.tar.gz ;;
  Linux\ *64)         download fzf-$version-linux_amd64.tar.gz   ;;
  Linux\ s390x)       download fzf-$version-linux_s390x.tar.gz   ;;
  FreeBSD\ *64)       download fzf-$version-freebsd_amd64.tar.gz ;;
  OpenBSD\ *64)       download fzf-$version-openbsd_amd64.tar.gz ;;
  CYGWIN*\ *64)       download fzf-$version-windows_amd64.zip    ;;
  MINGW*\ *64)        download fzf-$version-windows_amd64.zip    ;;
  MSYS*\ *64)         download fzf-$version-windows_amd64.zip    ;;
  Windows*\ *64)      download fzf-$version-windows_amd64.zip    ;;
  *)                  binary_available=0 binary_error=1          ;;
esac

cd "$fzf_base"
if [ -n "$binary_error" ]; then
  if [ $binary_available -eq 0 ]; then
    echo "No prebuilt binary for $archi ..."
  else
    echo "  - $binary_error !!!"
  fi
  if command -v go > /dev/null; then
    echo -n "Building binary (go get -u github.com/junegunn/fzf) ... "
    if [ -z "${GOPATH-}" ]; then
      export GOPATH="${TMPDIR:-/tmp}/fzf-gopath"
      mkdir -p "$GOPATH"
    fi
    if go get -ldflags "-s -w -X main.version=$version -X main.revision=go-get" github.com/junegunn/fzf; then
      echo "OK"
      cp "$GOPATH/bin/fzf" "$fzf_base/bin/"
    else
      echo "Failed to build binary. Installation failed."
      exit 1
    fi
  else
    echo "go executable not found. Installation failed."
    exit 1
  fi
fi

[[ "$*" =~ "--bin" ]] && exit 0

for s in $shells; do
  if ! command -v "$s" > /dev/null; then
    shells=${shells/$s/}
  fi
done

if [[ ${#shells} -lt 3 ]]; then
  echo "No shell configuration to be updated."
  exit 0
fi

# Auto-completion
if [ -z "$auto_completion" ]; then
  ask "Do you want to enable fuzzy auto-completion?"
  auto_completion=$?
fi

# Key-bindings
if [ -z "$key_bindings" ]; then
  ask "Do you want to enable key bindings?"
  key_bindings=$?
fi

echo
for shell in $shells; do
  [[ "$shell" = fish ]] && continue
  src=${prefix_expand}.${shell}
  echo -n "Generate $src ... "

  fzf_completion="[[ \$- == *i* ]] && source \"$fzf_base/shell/completion.${shell}\" 2> /dev/null"
  if [ $auto_completion -eq 0 ]; then
    fzf_completion="# $fzf_completion"
  fi

  fzf_key_bindings="source \"$fzf_base/shell/key-bindings.${shell}\""
  if [ $key_bindings -eq 0 ]; then
    fzf_key_bindings="# $fzf_key_bindings"
  fi

  cat > "$src" << EOF
# Setup fzf
# ---------
if [[ ! "\$PATH" == *$fzf_base_esc/bin* ]]; then
  PATH="\${PATH:+\${PATH}:}$fzf_base/bin"
fi

# Auto-completion
# ---------------
$fzf_completion

# Key bindings
# ------------
$fzf_key_bindings
EOF
  echo "OK"
done

# fish
if [[ "$shells" =~ fish ]]; then
  echo -n "Update fish_user_paths ... "
  fish << EOF
  echo \$fish_user_paths | \grep "$fzf_base"/bin > /dev/null
  or set --universal fish_user_paths \$fish_user_paths "$fzf_base"/bin
EOF
  [ $? -eq 0 ] && echo "OK" || echo "Failed"

  mkdir -p "${fish_dir}/functions"
  fish_binding="${fish_dir}/functions/fzf_key_bindings.fish"
  if [ $key_bindings -ne 0 ]; then
    echo -n "Symlink $fish_binding ... "
    ln -sf "$fzf_base/shell/key-bindings.fish" \
           "$fish_binding" && echo "OK" || echo "Failed"
  else
    echo -n "Removing $fish_binding ... "
    rm -f "$fish_binding"
    echo "OK"
  fi
fi

append_line() {
  set -e

  local update line file pat lno
  update="$1"
  line="$2"
  file="$3"
  pat="${4:-}"
  lno=""

  echo "Update $file:"
  echo "  - $line"
  if [ -f "$file" ]; then
    if [ $# -lt 4 ]; then
      lno=$(\grep -nF "$line" "$file" | sed 's/:.*//' | tr '\n' ' ')
    else
      lno=$(\grep -nF "$pat" "$file" | sed 's/:.*//' | tr '\n' ' ')
    fi
  fi
  if [ -n "$lno" ]; then
    echo "    - Already exists: line #$lno"
  else
    if [ $update -eq 1 ]; then
      [ -f "$file" ] && echo >> "$file"
      echo "$line" >> "$file"
      echo "    + Added"
    else
      echo "    ~ Skipped"
    fi
  fi
  echo
  set +e
}

create_file() {
  local file="$1"
  shift
  echo "Create $file:"
  for line in "$@"; do
    echo "    $line"
    echo "$line" >> "$file"
  done
  echo
}

if [ $update_config -eq 2 ]; then
  echo
  ask "Do you want to update your shell configuration files?"
  update_config=$?
fi
echo
for shell in $shells; do
  [[ "$shell" = fish ]] && continue
  [ $shell = zsh ] && dest=${ZDOTDIR:-~}/.zshrc || dest=~/.bashrc
  append_line $update_config "[ -f ${prefix}.${shell} ] && source ${prefix}.${shell}" "$dest" "${prefix}.${shell}"
done

if [ $key_bindings -eq 1 ] && [[ "$shells" =~ fish ]]; then
  bind_file="${fish_dir}/functions/fish_user_key_bindings.fish"
  if [ ! -e "$bind_file" ]; then
    create_file "$bind_file" \
      'function fish_user_key_bindings' \
      '  fzf_key_bindings' \
      'end'
  else
    append_line $update_config "fzf_key_bindings" "$bind_file"
  fi
fi

if [ $update_config -eq 1 ]; then
  echo 'Finished. Restart your shell or reload config file.'
  if [[ "$shells" =~ bash ]]; then
    echo -n '   source ~/.bashrc  # bash'
    [[ "$archi" =~ Darwin ]] && echo -n '  (.bashrc should be loaded from .bash_profile)'
    echo
  fi
  [[ "$shells" =~ zsh ]]  && echo "   source ${ZDOTDIR:-~}/.zshrc   # zsh"
  [[ "$shells" =~ fish ]] && [ $key_bindings -eq 1 ] && echo '   fzf_key_bindings  # fish'
  echo
  echo 'Use uninstall script to remove fzf.'
  echo
fi
echo 'For more information, see: https://github.com/junegunn/fzf'
./install.ps1	[[[1
65
$version="0.42.0"

$fzf_base=Split-Path -Parent $MyInvocation.MyCommand.Definition

function check_binary () {
  Write-Host "  - Checking fzf executable ... " -NoNewline
  $output=cmd /c $fzf_base\bin\fzf.exe --version 2>&1
  if (-not $?) {
    Write-Host "Error: $output"
    $binary_error="Invalid binary"
  } else {
    $output=(-Split $output)[0]
    if ($version -ne $output) {
      Write-Host "$output != $version"
      $binary_error="Invalid version"
    } else {
      Write-Host "$output"
      $binary_error=""
      return 1
    }
  }
  Remove-Item "$fzf_base\bin\fzf.exe"
  return 0
}

function download {
  param($file)
  Write-Host "Downloading bin/fzf ..."
  if (Test-Path "$fzf_base\bin\fzf.exe") {
    Write-Host "  - Already exists"
    if (check_binary) {
      return
    }
  }
  if (-not (Test-Path "$fzf_base\bin")) {
    md "$fzf_base\bin"
  }
  if (-not $?) {
    $binary_error="Failed to create bin directory"
    return
  }
  cd "$fzf_base\bin"
  $url="https://github.com/junegunn/fzf/releases/download/$version/$file"
  $temp=$env:TMP + "\fzf.zip"
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  if ($PSVersionTable.PSVersion.Major -ge 3) {
    Invoke-WebRequest -Uri $url -OutFile $temp
  } else {
    (New-Object Net.WebClient).DownloadFile($url, $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$temp"))
  }
  if ($?) {
    (Microsoft.PowerShell.Archive\Expand-Archive -Path $temp -DestinationPath .); (Remove-Item $temp)
  } else {
    $binary_error="Failed to download with powershell"
  }
  if (-not (Test-Path fzf.exe)) {
    $binary_error="Failed to download $file"
    return
  }
  echo y | icacls $fzf_base\bin\fzf.exe /grant Administrator:F ; check_binary >$null
}

download "fzf-$version-windows_amd64.zip"

Write-Host 'For more information, see: https://github.com/junegunn/fzf'
./main.go	[[[1
14
package main

import (
	fzf "github.com/junegunn/fzf/src"
	"github.com/junegunn/fzf/src/protector"
)

var version string = "0.42"
var revision string = "devel"

func main() {
	protector.Protect()
	fzf.Run(fzf.ParseOptions(), version, revision)
}
./man/man1/fzf-tmux.1	[[[1
68
.ig
The MIT License (MIT)

Copyright (c) 2013-2023 Junegunn Choi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
..
.TH fzf-tmux 1 "Jun 2023" "fzf 0.42.0" "fzf-tmux - open fzf in tmux split pane"

.SH NAME
fzf-tmux - open fzf in tmux split pane

.SH SYNOPSIS
.B fzf-tmux [LAYOUT OPTIONS] [--] [FZF OPTIONS]

.SH DESCRIPTION
fzf-tmux is a wrapper script for fzf that opens fzf in a tmux split pane or in
a tmux popup window. It is designed to work just like fzf except that it does
not take up the whole screen. You can safely use fzf-tmux instead of fzf in
your scripts as the extra options will be silently ignored if you're not on
tmux.

.SH LAYOUT OPTIONS

(default layout: \fB-d 50%\fR)

.SS Popup window
(requires tmux 3.2 or above)
.TP
.B "-p [WIDTH[%][,HEIGHT[%]]]"
.TP
.B "-w WIDTH[%]"
.TP
.B "-h WIDTH[%]"
.TP
.B "-x COL"
.TP
.B "-y ROW"

.SS Split pane
.TP
.B "-u [height[%]]"
Split above (up)
.TP
.B "-d [height[%]]"
Split below (down)
.TP
.B "-l [width[%]]"
Split left
.TP
.B "-r [width[%]]"
Split right
./man/man1/fzf.1	[[[1
1300
.ig
The MIT License (MIT)

Copyright (c) 2013-2023 Junegunn Choi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
..
.TH fzf 1 "Jun 2023" "fzf 0.42.0" "fzf - a command-line fuzzy finder"

.SH NAME
fzf - a command-line fuzzy finder

.SH SYNOPSIS
fzf [options]

.SH DESCRIPTION
fzf is a general-purpose command-line fuzzy finder.

.SH OPTIONS
.SS Search mode
.TP
.B "-x, --extended"
Extended-search mode. Since 0.10.9, this is enabled by default. You can disable
it with \fB+x\fR or \fB--no-extended\fR.
.TP
.B "-e, --exact"
Enable exact-match
.TP
.B "-i"
Case-insensitive match (default: smart-case match)
.TP
.B "+i"
Case-sensitive match
.TP
.B "--literal"
Do not normalize latin script letters for matching.
.TP
.BI "--scheme=" SCHEME
Choose scoring scheme tailored for different types of input.

.br
.BR default "  Generic scoring scheme designed to work well with any type of input"
.br
.BR path "     Scoring scheme for paths (additional bonus point only after path separator)
.br
.BR history "  Scoring scheme for command history (no additional bonus points).
         Sets \fB--tiebreak=index\fR as well.
.br
.TP
.BI "--algo=" TYPE
Fuzzy matching algorithm (default: v2)

.br
.BR v2 "     Optimal scoring algorithm (quality)"
.br
.BR v1 "     Faster but not guaranteed to find the optimal result (performance)"
.br

.TP
.BI "-n, --nth=" "N[,..]"
Comma-separated list of field index expressions for limiting search scope.
See \fBFIELD INDEX EXPRESSION\fR for the details.
.TP
.BI "--with-nth=" "N[,..]"
Transform the presentation of each line using field index expressions
.TP
.BI "-d, --delimiter=" "STR"
Field delimiter regex for \fB--nth\fR and \fB--with-nth\fR (default: AWK-style)
.TP
.BI "--disabled"
Do not perform search. With this option, fzf becomes a simple selector
interface rather than a "fuzzy finder". You can later enable the search using
\fBenable-search\fR or \fBtoggle-search\fR action.
.SS Search result
.TP
.B "+s, --no-sort"
Do not sort the result
.TP
.B "--track"
Make fzf track the current selection when the result list is updated.
This can be useful when browsing logs using fzf with sorting disabled. It is
not recommended to use this option with \fB--tac\fR as the resulting behavior
can be confusing. Also, consider using \fBtrack\fR action instead of this
option.

.RS
e.g.
     \fBgit log --oneline --graph --color=always | nl |
         fzf --ansi --track --no-sort --layout=reverse-list\fR
.RE
.TP
.B "--tac"
Reverse the order of the input

.RS
e.g.
     \fBhistory | fzf --tac --no-sort\fR
.RE
.TP
.BI "--tiebreak=" "CRI[,..]"
Comma-separated list of sort criteria to apply when the scores are tied.
.br

.br
.BR length "  Prefers line with shorter length"
.br
.BR chunk "   Prefers line with shorter matched chunk (delimited by whitespaces)"
.br
.BR begin "   Prefers line with matched substring closer to the beginning"
.br
.BR end "     Prefers line with matched substring closer to the end"
.br
.BR index "   Prefers line that appeared earlier in the input stream"
.br

.br
- Each criterion should appear only once in the list
.br
- \fBindex\fR is only allowed at the end of the list
.br
- \fBindex\fR is implicitly appended to the list when not specified
.br
- Default is \fBlength\fR (or equivalently \fBlength\fR,index)
.br
- If \fBend\fR is found in the list, fzf will scan each line backwards
.SS Interface
.TP
.B "-m, --multi"
Enable multi-select with tab/shift-tab. It optionally takes an integer argument
which denotes the maximum number of items that can be selected.
.TP
.B "+m, --no-multi"
Disable multi-select
.TP
.B "--no-mouse"
Disable mouse
.TP
.BI "--bind=" "KEYBINDS"
Comma-separated list of custom key bindings. See \fBKEY/EVENT BINDINGS\fR for
the details.
.TP
.B "--cycle"
Enable cyclic scroll
.TP
.B "--keep-right"
Keep the right end of the line visible when it's too long. Effective only when
the query string is empty.
.TP
.BI "--scroll-off=" "LINES"
Number of screen lines to keep above or below when scrolling to the top or to
the bottom (default: 0).
.TP
.B "--no-hscroll"
Disable horizontal scroll
.TP
.BI "--hscroll-off=" "COLS"
Number of screen columns to keep to the right of the highlighted substring
(default: 10). Setting it to a large value will cause the text to be positioned
on the center of the screen.
.TP
.B "--filepath-word"
Make word-wise movements and actions respect path separators. The following
actions are affected:

\fBbackward-kill-word\fR
.br
\fBbackward-word\fR
.br
\fBforward-word\fR
.br
\fBkill-word\fR
.TP
.BI "--jump-labels=" "CHARS"
Label characters for \fBjump\fR and \fBjump-accept\fR
.SS Layout
.TP
.BI "--height=" "[~]HEIGHT[%]"
Display fzf window below the cursor with the given height instead of using
the full screen. When prefixed with \fB~\fR, fzf will automatically determine
the height in the range according to the input size. Note that adaptive height
is not compatible with top/bottom margin and padding given in percent size.
.TP
.BI "--min-height=" "HEIGHT"
Minimum height when \fB--height\fR is given in percent (default: 10).
Ignored when \fB--height\fR is not specified.
.TP
.BI "--layout=" "LAYOUT"
Choose the layout (default: default)

.br
.BR default "       Display from the bottom of the screen"
.br
.BR reverse "       Display from the top of the screen"
.br
.BR reverse-list "  Display from the top of the screen, prompt at the bottom"
.br

.TP
.B "--reverse"
A synonym for \fB--layout=reverse\fB

.TP
.BI "--border" [=BORDER_OPT]
Draw border around the finder

.br
.BR rounded "       Border with rounded corners (default)"
.br
.BR sharp "         Border with sharp corners"
.br
.BR bold "          Border with bold lines"
.br
.BR double "        Border with double lines"
.br
.BR block "         Border using block elements; suitable when using different background colors"
.br
.BR thinblock "     Border using legacy computing symbols; may not be displayed on some terminals"
.br
.BR horizontal "    Horizontal lines above and below the finder"
.br
.BR vertical "      Vertical lines on each side of the finder"
.br
.BR top " (up)"
.br
.BR bottom " (down)"
.br
.BR left
.br
.BR right
.br
.BR none
.br

If you use a terminal emulator where each box-drawing character takes
2 columns, try setting \fBRUNEWIDTH_EASTASIAN\fR environment variable to
\fB0\fR or \fB1\fR. If the border is still not properly rendered, set
\fB--no-unicode\fR.

.TP
.BI "--border-label" [=LABEL]
Label to print on the horizontal border line. Should be used with one of the
following \fB--border\fR options.

.br
.B * rounded
.br
.B * sharp
.br
.B * bold
.br
.B * double
.br
.B * horizontal
.br
.BR "* top" " (up)"
.br
.BR "* bottom" " (down)"
.br

.br
e.g.
  \fB# ANSI color codes are supported
  # (with https://github.com/busyloop/lolcat)
  label=$(curl -s http://metaphorpsum.com/sentences/1 | lolcat -f)

  # Border label at the center
  fzf --height=10 --border --border-label="╢ $label ╟" --color=label:italic:black

  # Left-aligned (positive integer)
  fzf --height=10 --border --border-label="╢ $label ╟" --border-label-pos=3 --color=label:italic:black

  # Right-aligned (negative integer) on the bottom line (:bottom)
  fzf --height=10 --border --border-label="╢ $label ╟" --border-label-pos=-3:bottom --color=label:italic:black\fR

.TP
.BI "--border-label-pos" [=N[:top|bottom]]
Position of the border label on the border line. Specify a positive integer as
the column position from the left. Specify a negative integer to right-align
the label. Label is printed on the top border line by default, add
\fB:bottom\fR to put it on the border line on the bottom. The default value
\fB0 (or \fBcenter\fR) will put the label at the center of the border line.

.TP
.B "--no-unicode"
Use ASCII characters instead of Unicode drawing characters to draw borders,
the spinner and the horizontal separator.

.TP
.BI "--margin=" MARGIN
Comma-separated expression for margins around the finder.
.br

.br
.RS
.BR TRBL "     Same margin for top, right, bottom, and left"
.br
.BR TB,RL "    Vertical, horizontal margin"
.br
.BR T,RL,B "   Top, horizontal, bottom margin"
.br
.BR T,R,B,L "  Top, right, bottom, left margin"
.br

.br
Each part can be given in absolute number or in percentage relative to the
terminal size with \fB%\fR suffix.
.br

.br
e.g.
     \fBfzf --margin 10%
     fzf --margin 1,5%\fR
.RE
.TP
.BI "--padding=" PADDING
Comma-separated expression for padding inside the border. Padding is
distinguishable from margin only when \fB--border\fR option is used.
.br

.br
e.g.
     \fBfzf --margin 5% --padding 5% --border --preview 'cat {}' \\
         --color bg:#222222,preview-bg:#333333\fR

.br
.RS
.BR TRBL "     Same padding for top, right, bottom, and left"
.br
.BR TB,RL "    Vertical, horizontal padding"
.br
.BR T,RL,B "   Top, horizontal, bottom padding"
.br
.BR T,R,B,L "  Top, right, bottom, left padding"
.br
.RE

.TP
.BI "--info=" "STYLE"
Determines the display style of finder info (match counters).

.br
.BR default "          Display on the next line to the prompt"
.br
.BR right "            Display on the right end of the next line to the prompt"
.br
.BR inline "           Display on the same line with the default separator ' < '"
.br
.BR inline:SEPARATOR " Display on the same line with a non-default separator"
.br
.BR inline-right "     Display on the right end of the same line
.br
.BR hidden "           Do not display finder info"
.br

.TP
.B "--no-info"
A synonym for \fB--info=hidden\fB

.TP
.BI "--separator=" "STR"
The given string will be repeated to form the horizontal separator on the info
line (default: '─' or '-' depending on \fB--no-unicode\fR).

ANSI color codes are supported.

.TP
.B "--no-separator"
Do not display horizontal separator on the info line. A synonym for
\fB--separator=''\fB

.TP
.BI "--scrollbar=" "CHAR1[CHAR2]"
Use the given character to render scrollbar. (default: '│' or ':' depending on
\fB--no-unicode\fR). The optional \fBCHAR2\fR is used to render scrollbar of
the preview window.

.TP
.B "--no-scrollbar"
Do not display scrollbar. A synonym for \fB--scrollbar=''\fB

.TP
.BI "--prompt=" "STR"
Input prompt (default: '> ')
.TP
.BI "--pointer=" "STR"
Pointer to the current line (default: '>')
.TP
.BI "--marker=" "STR"
Multi-select marker (default: '>')
.TP
.BI "--header=" "STR"
The given string will be printed as the sticky header. The lines are displayed
in the given order from top to bottom regardless of \fB--layout\fR option, and
are not affected by \fB--with-nth\fR. ANSI color codes are processed even when
\fB--ansi\fR is not set.
.TP
.BI "--header-lines=" "N"
The first N lines of the input are treated as the sticky header. When
\fB--with-nth\fR is set, the lines are transformed just like the other
lines that follow.
.TP
.B "--header-first"
Print header before the prompt line
.TP
.BI "--ellipsis=" "STR"
Ellipsis to show when line is truncated (default: '..')
.SS Display
.TP
.B "--ansi"
Enable processing of ANSI color codes
.TP
.BI "--tabstop=" SPACES
Number of spaces for a tab character (default: 8)
.TP
.BI "--color=" "[BASE_SCHEME][,COLOR_NAME[:ANSI_COLOR][:ANSI_ATTRIBUTES]]..."
Color configuration. The name of the base color scheme is followed by custom
color mappings.

.RS
.B BASE SCHEME:
    (default: dark on 256-color terminal, otherwise 16)

    \fBdark    \fRColor scheme for dark 256-color terminal
    \fBlight   \fRColor scheme for light 256-color terminal
    \fB16      \fRColor scheme for 16-color terminal
    \fBbw      \fRNo colors (equivalent to \fB--no-color\fR)

.B COLOR NAMES:
    \fBfg                  \fRText
      \fBpreview-fg        \fRPreview window text
    \fBbg                  \fRBackground
      \fBpreview-bg        \fRPreview window background
    \fBhl                  \fRHighlighted substrings
    \fBfg+                 \fRText (current line)
    \fBbg+                 \fRBackground (current line)
      \fBgutter            \fRGutter on the left
    \fBhl+                 \fRHighlighted substrings (current line)
    \fBquery               \fRQuery string
      \fBdisabled          \fRQuery string when search is disabled (\fB--disabled\fR)
    \fBinfo                \fRInfo line (match counters)
    \fBborder              \fRBorder around the window (\fB--border\fR and \fB--preview\fR)
      \fBscrollbar         \fRScrollbar
      \fBpreview-border    \fRBorder around the preview window (\fB--preview\fR)
      \fBpreview-scrollbar \fRScrollbar
      \fBseparator         \fRHorizontal separator on info line
    \fBlabel               \fRBorder label (\fB--border-label\fR and \fB--preview-label\fR)
      \fBpreview-label     \fRBorder label of the preview window (\fB--preview-label\fR)
    \fBprompt              \fRPrompt
    \fBpointer             \fRPointer to the current line
    \fBmarker              \fRMulti-select marker
    \fBspinner             \fRStreaming input indicator
    \fBheader              \fRHeader

.B ANSI COLORS:
    \fB-1         \fRDefault terminal foreground/background color
    \fB           \fR(or the original color of the text)
    \fB0 ~ 15     \fR16 base colors
      \fBblack\fR
      \fBred\fR
      \fBgreen\fR
      \fByellow\fR
      \fBblue\fR
      \fBmagenta\fR
      \fBcyan\fR
      \fBwhite\fR
      \fBbright-black\fR (gray | grey)
      \fBbright-red\fR
      \fBbright-green\fR
      \fBbright-yellow\fR
      \fBbright-blue\fR
      \fBbright-magenta\fR
      \fBbright-cyan\fR
      \fBbright-white\fR
    \fB16 ~ 255   \fRANSI 256 colors
    \fB#rrggbb    \fR24-bit colors

.B ANSI ATTRIBUTES: (Only applies to foreground colors)
    \fBregular    \fRClears previously set attributes; should precede the other ones
    \fBbold\fR
    \fBunderline\fR
    \fBreverse\fR
    \fBdim\fR
    \fBitalic\fR
    \fBstrikethrough\fR

.B EXAMPLES:

     \fB# Seoul256 theme with 8-bit colors
     # (https://github.com/junegunn/seoul256.vim)
     fzf --color='bg:237,bg+:236,info:143,border:240,spinner:108' \\
         --color='hl:65,fg:252,header:65,fg+:252' \\
         --color='pointer:161,marker:168,prompt:110,hl+:108'

     # Seoul256 theme with 24-bit colors
     fzf --color='bg:#4B4B4B,bg+:#3F3F3F,info:#BDBB72,border:#6B6B6B,spinner:#98BC99' \\
         --color='hl:#719872,fg:#D9D9D9,header:#719872,fg+:#D9D9D9' \\
         --color='pointer:#E12672,marker:#E17899,prompt:#98BEDE,hl+:#98BC99'\fR
.RE
.TP
.B "--no-bold"
Do not use bold text
.TP
.B "--black"
Use black background
.SS History
.TP
.BI "--history=" "HISTORY_FILE"
Load search history from the specified file and update the file on completion.
When enabled, \fBCTRL-N\fR and \fBCTRL-P\fR are automatically remapped to
\fBnext-history\fR and \fBprev-history\fR.
.TP
.BI "--history-size=" "N"
Maximum number of entries in the history file (default: 1000). The file is
automatically truncated when the number of the lines exceeds the value.
.SS Preview
.TP
.BI "--preview=" "COMMAND"
Execute the given command for the current line and display the result on the
preview window. \fB{}\fR in the command is the placeholder that is replaced to
the single-quoted string of the current line. To transform the replacement
string, specify field index expressions between the braces (See \fBFIELD INDEX
EXPRESSION\fR for the details).

.RS
e.g.
     \fBfzf --preview='head -$LINES {}'
     ls -l | fzf --preview="echo user={3} when={-4..-2}; cat {-1}" --header-lines=1\fR

fzf exports \fB$FZF_PREVIEW_LINES\fR and \fB$FZF_PREVIEW_COLUMNS\fR so that
they represent the exact size of the preview window. (It also overrides
\fB$LINES\fR and \fB$COLUMNS\fR with the same values but they can be reset
by the default shell, so prefer to refer to the ones with \fBFZF_PREVIEW_\fR
prefix.)

A placeholder expression starting with \fB+\fR flag will be replaced to the
space-separated list of the selected lines (or the current line if no selection
was made) individually quoted.

e.g.
     \fBfzf --multi --preview='head -10 {+}'
     git log --oneline | fzf --multi --preview 'git show {+1}'\fR

When using a field index expression, leading and trailing whitespace is stripped
from the replacement string. To preserve the whitespace, use the \fBs\fR flag.

Also, \fB{q}\fR is replaced to the current query string, and \fB{n}\fR is
replaced to zero-based ordinal index of the line. Use \fB{+n}\fR if you want
all index numbers when multiple lines are selected.

A placeholder expression with \fBf\fR flag is replaced to the path of
a temporary file that holds the evaluated list. This is useful when you
multi-select a large number of items and the length of the evaluated string may
exceed \fBARG_MAX\fR.

e.g.
     \fB# Press CTRL-A to select 100K items and see the sum of all the numbers.
     # This won't work properly without 'f' flag due to ARG_MAX limit.
     seq 100000 | fzf --multi --bind ctrl-a:select-all \\
                      --preview "awk '{sum+=\\$1} END {print sum}' {+f}"\fR

Note that you can escape a placeholder pattern by prepending a backslash.

Preview window will be updated even when there is no match for the current
query if any of the placeholder expressions evaluates to a non-empty string
or \fB{q}\fR is in the command template.

Since 0.24.0, fzf can render partial preview content before the preview command
completes. ANSI escape sequence for clearing the display (\fBCSI 2 J\fR) is
supported, so you can use it to implement preview window that is constantly
updating.

e.g.
      \fBfzf --preview 'for i in $(seq 100000); do
        (( i % 200 == 0 )) && printf "\\033[2J"
        echo "$i"
        sleep 0.01
      done'\fR
.RE

.TP
.BI "--preview-label" [=LABEL]
Label to print on the horizontal border line of the preview window.
Should be used with one of the following \fB--preview-window\fR options.

.br
.B * border-rounded (default on non-Windows platforms)
.br
.B * border-sharp (default on Windows)
.br
.B * border-bold
.br
.B * border-double
.br
.B * border-block
.br
.B * border-thinblock
.br
.B * border-horizontal
.br
.B * border-top
.br
.B * border-bottom
.br

.TP
.BI "--preview-label-pos" [=N[:top|bottom]]
Position of the border label on the border line of the preview window. Specify
a positive integer as the column position from the left. Specify a negative
integer to right-align the label. Label is printed on the top border line by
default, add \fB:bottom\fR to put it on the border line on the bottom. The
default value 0 (or \fBcenter\fR) will put the label at the center of the
border line.

.TP
.BI "--preview-window=" "[POSITION][,SIZE[%]][,border-BORDER_OPT][,[no]wrap][,[no]follow][,[no]cycle][,[no]hidden][,+SCROLL[OFFSETS][/DENOM]][,~HEADER_LINES][,default][,<SIZE_THRESHOLD(ALTERNATIVE_LAYOUT)]"

.RS
.B POSITION: (default: right)
    \fBup
    \fBdown
    \fBleft
    \fBright

\fRDetermines the layout of the preview window.

* If the argument contains \fB:hidden\fR, the preview window will be hidden by
default until \fBtoggle-preview\fR action is triggered.

* If size is given as 0, preview window will not be visible, but fzf will still
execute the command in the background.

* Long lines are truncated by default. Line wrap can be enabled with
\fBwrap\fR flag.

* Preview window will automatically scroll to the bottom when \fBfollow\fR
flag is set, similarly to how \fBtail -f\fR works.

.RS
e.g.
      \fBfzf --preview-window follow --preview 'for i in $(seq 100000); do
        echo "$i"
        sleep 0.01
        (( i % 300 == 0 )) && printf "\\033[2J"
      done'\fR
.RE

* Cyclic scrolling is enabled with \fBcycle\fR flag.

* To change the style of the border of the preview window, specify one of
the options for \fB--border\fR with \fBborder-\fR prefix.
e.g. \fBborder-rounded\fR (border with rounded edges, default),
\fBborder-sharp\fR (border with sharp edges), \fBborder-left\fR,
\fBborder-none\fR, etc.

* \fB[:+SCROLL[OFFSETS][/DENOM]]\fR determines the initial scroll offset of the
preview window.

  - \fBSCROLL\fR can be either a numeric integer or a single-field index expression that refers to a numeric integer.

  - The optional \fBOFFSETS\fR part is for adjusting the base offset. It should be given as a series of signed integers (\fB-INTEGER\fR or \fB+INTEGER\fR).

  - The final \fB/DENOM\fR part is for specifying a fraction of the preview window height.

* \fB~HEADER_LINES\fR keeps the top N lines as the fixed header so that they
are always visible.

* \fBdefault\fR resets all options previously set to the default.

.RS
e.g.
     \fB# Non-default scroll window positions and sizes
     fzf --preview="head {}" --preview-window=up,30%
     fzf --preview="file {}" --preview-window=down,1

     # Initial scroll offset is set to the line number of each line of
     # git grep output *minus* 5 lines (-5)
     git grep --line-number '' |
       fzf --delimiter : --preview 'nl {1}' --preview-window '+{2}-5'

     # Preview with bat, matching line in the middle of the window below
     # the fixed header of the top 3 lines
     #
     #   ~3    Top 3 lines as the fixed header
     #   +{2}  Base scroll offset extracted from the second field
     #   +3    Extra offset to compensate for the 3-line header
     #   /2    Put in the middle of the preview area
     #
     git grep --line-number '' |
       fzf --delimiter : \\
           --preview 'bat --style=full --color=always --highlight-line {2} {1}' \\
           --preview-window '~3,+{2}+3/2'

     # Display top 3 lines as the fixed header
     fzf --preview 'bat --style=full --color=always {}' --preview-window '~3'\fR
.RE

* You can specify an alternative set of options that are used only when the size
  of the preview window is below a certain threshold. Note that only one
  alternative layout is allowed.

.RS
e.g.
      \fBfzf --preview 'cat {}' --preview-window 'right,border-left,<30(up,30%,border-bottom)'\fR
.RE

.SS Scripting
.TP
.BI "-q, --query=" "STR"
Start the finder with the given query
.TP
.B "-1, --select-1"
If there is only one match for the initial query (\fB--query\fR), do not start
interactive finder and automatically select the only match
.TP
.B "-0, --exit-0"
If there is no match for the initial query (\fB--query\fR), do not start
interactive finder and exit immediately
.TP
.BI "-f, --filter=" "STR"
Filter mode. Do not start interactive finder. When used with \fB--no-sort\fR,
fzf becomes a fuzzy-version of grep.
.TP
.B "--print-query"
Print query as the first line
.TP
.BI "--expect=" "KEY[,..]"
Comma-separated list of keys that can be used to complete fzf in addition to
the default enter key. When this option is set, fzf will print the name of the
key pressed as the first line of its output (or as the second line if
\fB--print-query\fR is also used). The line will be empty if fzf is completed
with the default enter key. If \fB--expect\fR option is specified multiple
times, fzf will expect the union of the keys. \fB--no-expect\fR will clear the
list.

.RS
e.g.
     \fBfzf --expect=ctrl-v,ctrl-t,alt-s --expect=f1,f2,~,@\fR
.RE
.TP
.B "--read0"
Read input delimited by ASCII NUL characters instead of newline characters
.TP
.B "--print0"
Print output delimited by ASCII NUL characters instead of newline characters
.TP
.B "--sync"
Synchronous search for multi-staged filtering. If specified, fzf will launch
ncurses finder only after the input stream is complete.

.RS
e.g. \fBfzf --multi | fzf --sync\fR
.RE
.TP
.B "--listen[=HTTP_PORT]"
Start HTTP server on the given port. It allows external processes to send
actions to perform via POST method. If the port number is omitted or given as
0, fzf will choose the port automatically and export it as \fBFZF_PORT\fR
environment variable to the child processes started via \fBexecute\fR and
\fBexecute-silent\fR actions.

e.g.
     \fB# Start HTTP server on port 6266
     fzf --listen 6266

     # Send action to the server
     curl -XPOST localhost:6266 -d 'reload(seq 100)+change-prompt(hundred> )'

     # Choose port automatically and export it as $FZF_PORT to the child process
     fzf --listen --bind 'start:execute-silent:echo $FZF_PORT > /tmp/fzf-port'
     \fR
.TP
.B "--version"
Display version information and exit

.TP
Note that most options have the opposite versions with \fB--no-\fR prefix.

.SH ENVIRONMENT VARIABLES
.TP
.B FZF_DEFAULT_COMMAND
Default command to use when input is tty. On *nix systems, fzf runs the command
with \fB$SHELL -c\fR if \fBSHELL\fR is set, otherwise with \fBsh -c\fR, so in
this case make sure that the command is POSIX-compliant.
.TP
.B FZF_DEFAULT_OPTS
Default options. e.g. \fBexport FZF_DEFAULT_OPTS="--extended --cycle"\fR

.SH EXIT STATUS
.BR 0 "      Normal exit"
.br
.BR 1 "      No match"
.br
.BR 2 "      Error"
.br
.BR 130 "    Interrupted with \fBCTRL-C\fR or \fBESC\fR"

.SH FIELD INDEX EXPRESSION

A field index expression can be a non-zero integer or a range expression
([BEGIN]..[END]). \fB--nth\fR and \fB--with-nth\fR take a comma-separated list
of field index expressions.

.SS Examples
.BR 1 "      The 1st field"
.br
.BR 2 "      The 2nd field"
.br
.BR -1 "     The last field"
.br
.BR -2 "     The 2nd to last field"
.br
.BR 3..5 "   From the 3rd field to the 5th field"
.br
.BR 2.. "    From the 2nd field to the last field"
.br
.BR ..-3 "   From the 1st field to the 3rd to the last field"
.br
.BR .. "     All the fields"
.br

.SH EXTENDED SEARCH MODE

Unless specified otherwise, fzf will start in "extended-search mode". In this
mode, you can specify multiple patterns delimited by spaces, such as: \fB'wild
^music .mp3$ sbtrkt !rmx\fR

You can prepend a backslash to a space (\fB\\ \fR) to match a literal space
character.

.SS Exact-match (quoted)
A term that is prefixed by a single-quote character (\fB'\fR) is interpreted as
an "exact-match" (or "non-fuzzy") term. fzf will search for the exact
occurrences of the string.

.SS Anchored-match
A term can be prefixed by \fB^\fR, or suffixed by \fB$\fR to become an
anchored-match term. Then fzf will search for the lines that start with or end
with the given string. An anchored-match term is also an exact-match term.

.SS Negation
If a term is prefixed by \fB!\fR, fzf will exclude the lines that satisfy the
term from the result. In this case, fzf performs exact match by default.

.SS Exact-match by default
If you don't prefer fuzzy matching and do not wish to "quote" (prefixing with
\fB'\fR) every word, start fzf with \fB-e\fR or \fB--exact\fR option. Note that
when \fB--exact\fR is set, \fB'\fR-prefix "unquotes" the term.

.SS OR operator
A single bar character term acts as an OR operator. For example, the following
query matches entries that start with \fBcore\fR and end with either \fBgo\fR,
\fBrb\fR, or \fBpy\fR.

e.g. \fB^core go$ | rb$ | py$\fR

.SH KEY/EVENT BINDINGS
\fB--bind\fR option allows you to bind \fBa key\fR or \fBan event\fR to one or
more \fBactions\fR. You can use it to customize key bindings or implement
dynamic behaviors.

\fB--bind\fR takes a comma-separated list of binding expressions. Each binding
expression is \fBKEY:ACTION\fR or \fBEVENT:ACTION\fR.

e.g.
     \fBfzf --bind=ctrl-j:accept,ctrl-k:kill-line\fR

.SS AVAILABLE KEYS:    (SYNONYMS)
\fIctrl-[a-z]\fR
.br
\fIctrl-space\fR
.br
\fIctrl-delete\fR
.br
\fIctrl-\\\fR
.br
\fIctrl-]\fR
.br
\fIctrl-^\fR      (\fIctrl-6\fR)
.br
\fIctrl-/\fR      (\fIctrl-_\fR)
.br
\fIctrl-alt-[a-z]\fR
.br
\fIalt-[*]\fR     (Any case-sensitive single character is allowed)
.br
\fIf[1-12]\fR
.br
\fIenter\fR       (\fIreturn\fR \fIctrl-m\fR)
.br
\fIspace\fR
.br
\fIbspace\fR      (\fIbs\fR)
.br
\fIalt-up\fR
.br
\fIalt-down\fR
.br
\fIalt-left\fR
.br
\fIalt-right\fR
.br
\fIalt-enter\fR
.br
\fIalt-space\fR
.br
\fIalt-bspace\fR  (\fIalt-bs\fR)
.br
\fItab\fR
.br
\fIbtab\fR        (\fIshift-tab\fR)
.br
\fIesc\fR
.br
\fIdel\fR
.br
\fIup\fR
.br
\fIdown\fR
.br
\fIleft\fR
.br
\fIright\fR
.br
\fIhome\fR
.br
\fIend\fR
.br
\fIinsert\fR
.br
\fIpgup\fR        (\fIpage-up\fR)
.br
\fIpgdn\fR        (\fIpage-down\fR)
.br
\fIshift-up\fR
.br
\fIshift-down\fR
.br
\fIshift-left\fR
.br
\fIshift-right\fR
.br
\fIshift-delete\fR
.br
\fIalt-shift-up\fR
.br
\fIalt-shift-down\fR
.br
\fIalt-shift-left\fR
.br
\fIalt-shift-right\fR
.br
\fIleft-click\fR
.br
\fIright-click\fR
.br
\fIdouble-click\fR
.br
or any single character

.SS AVAILABLE EVENTS:
\fIstart\fR
.RS
Triggered only once when fzf finder starts. Since fzf consumes the input stream
asynchronously, the input list is not available unless you use \fI--sync\fR.

e.g.
     \fB# Move cursor to the last item and select all items
     seq 1000 | fzf --multi --sync --bind start:last+select-all\fR
.RE
\fIload\fR
.RS
Triggered when the input stream is complete and the initial processing of the
list is complete.

e.g.
     \fB# Change the prompt to "loaded" when the input stream is complete
     (seq 10; sleep 1; seq 11 20) | fzf --prompt 'Loading> ' --bind 'load:change-prompt:Loaded> '\fR
.RE
\fIchange\fR
.RS
Triggered whenever the query string is changed

e.g.
     \fB# Move cursor to the first entry whenever the query is changed
     fzf --bind change:first\fR
.RE
\fIfocus\fR
.RS
Triggered when the focus changes due to a vertical cursor movement or a search
result update.

e.g.
     \fBfzf --bind 'focus:transform-preview-label:echo [ {} ]' --preview 'cat {}'

     # Any action bound to the event runs synchronously and thus can make the interface sluggish
     # e.g. lolcat isn't one of the fastest programs, and every cursor movement in
     #      fzf will be noticeably affected by its execution time
     fzf --bind 'focus:transform-preview-label:echo [ {} ] | lolcat -f' --preview 'cat {}'

     # Beware not to introduce an infinite loop
     seq 10 | fzf --bind 'focus:up' --cycle\fR
.RE
\fIone\fR
.RS
Triggered when there's only one match. \fBone:accept\fR binding is comparable
to \fB--select-1\fR option, but the difference is that \fB--select-1\fR is only
effective before the interactive finder starts but \fBone\fR event is triggered
by the interactive finder.

e.g.
     \fB# Automatically select the only match
     seq 10 | fzf --bind one:accept\fR
.RE
\fIzero\fR
.RS
Triggered when there's no match. \fBzero:abort\fR binding is comparable to
\fB--exit-0\fR option, but the difference is that \fB--exit-0\fR is only
effective before the interactive finder starts but \fBzero\fR event is
triggered by the interactive finder.

e.g.
     \fB# Reload the candidate list when there's no match
     echo $RANDOM | fzf --bind 'zero:reload(echo $RANDOM)+clear-query' --height 3\fR
.RE

\fIbackward-eof\fR
.RS
Triggered when the query string is already empty and you try to delete it
backward.

e.g.
     \fBfzf --bind backward-eof:abort\fR
.RE

.SS AVAILABLE ACTIONS:
A key or an event can be bound to one or more of the following actions.

  \fBACTION:                      DEFAULT BINDINGS (NOTES):
    \fBabort\fR                        \fIctrl-c  ctrl-g  ctrl-q  esc\fR
    \fBaccept\fR                       \fIenter   double-click\fR
    \fBaccept-non-empty\fR             (same as \fBaccept\fR except that it prevents fzf from exiting without selection)
    \fBbackward-char\fR                \fIctrl-b  left\fR
    \fBbackward-delete-char\fR         \fIctrl-h  bspace\fR
    \fBbackward-delete-char/eof\fR     (same as \fBbackward-delete-char\fR except aborts fzf if query is empty)
    \fBbackward-kill-word\fR           \fIalt-bs\fR
    \fBbackward-word\fR                \fIalt-b   shift-left\fR
    \fBbecome(...)\fR                  (replace fzf process with the specified command; see below for the details)
    \fBbeginning-of-line\fR            \fIctrl-a  home\fR
    \fBcancel\fR                       (clear query string if not empty, abort fzf otherwise)
    \fBchange-border-label(...)\fR     (change \fB--border-label\fR to the given string)
    \fBchange-header(...)\fR           (change header to the given string; doesn't affect \fB--header-lines\fR)
    \fBchange-preview(...)\fR          (change \fB--preview\fR option)
    \fBchange-preview-label(...)\fR    (change \fB--preview-label\fR to the given string)
    \fBchange-preview-window(...)\fR   (change \fB--preview-window\fR option; rotate through the multiple option sets separated by '|')
    \fBchange-prompt(...)\fR           (change prompt to the given string)
    \fBchange-query(...)\fR            (change query string to the given string)
    \fBclear-screen\fR                 \fIctrl-l\fR
    \fBclear-selection\fR              (clear multi-selection)
    \fBclose\fR                        (close preview window if open, abort fzf otherwise)
    \fBclear-query\fR                  (clear query string)
    \fBdelete-char\fR                  \fIdel\fR
    \fBdelete-char/eof\fR              \fIctrl-d\fR (same as \fBdelete-char\fR except aborts fzf if query is empty)
    \fBdeselect\fR
    \fBdeselect-all\fR                 (deselect all matches)
    \fBdisable-search\fR               (disable search functionality)
    \fBdown\fR                         \fIctrl-j  ctrl-n  down\fR
    \fBenable-search\fR                (enable search functionality)
    \fBend-of-line\fR                  \fIctrl-e  end\fR
    \fBexecute(...)\fR                 (see below for the details)
    \fBexecute-silent(...)\fR          (see below for the details)
    \fBfirst\fR                        (move to the first match; same as \fBpos(1)\fR)
    \fBforward-char\fR                 \fIctrl-f  right\fR
    \fBforward-word\fR                 \fIalt-f   shift-right\fR
    \fBignore\fR
    \fBjump\fR                         (EasyMotion-like 2-keystroke movement)
    \fBjump-accept\fR                  (jump and accept)
    \fBkill-line\fR
    \fBkill-word\fR                    \fIalt-d\fR
    \fBlast\fR                         (move to the last match; same as \fBpos(-1)\fR)
    \fBnext-history\fR                 (\fIctrl-n\fR on \fB--history\fR)
    \fBnext-selected\fR                (move to the next selected item)
    \fBpage-down\fR                    \fIpgdn\fR
    \fBpage-up\fR                      \fIpgup\fR
    \fBhalf-page-down\fR
    \fBhalf-page-up\fR
    \fBhide-preview\fR
    \fBpos(...)\fR                     (move cursor to the numeric position; negative number to count from the end)
    \fBprev-history\fR                 (\fIctrl-p\fR on \fB--history\fR)
    \fBprev-selected\fR                (move to the previous selected item)
    \fBpreview(...)\fR                 (see below for the details)
    \fBpreview-down\fR                 \fIshift-down\fR
    \fBpreview-up\fR                   \fIshift-up\fR
    \fBpreview-page-down\fR
    \fBpreview-page-up\fR
    \fBpreview-half-page-down\fR
    \fBpreview-half-page-up\fR
    \fBpreview-bottom\fR
    \fBpreview-top\fR
    \fBprint-query\fR                  (print query and exit)
    \fBput\fR                          (put the character to the prompt)
    \fBput(...)\fR                     (put the given string to the prompt)
    \fBrefresh-preview\fR
    \fBrebind(...)\fR                  (rebind bindings after \fBunbind\fR)
    \fBreload(...)\fR                  (see below for the details)
    \fBreload-sync(...)\fR             (see below for the details)
    \fBreplace-query\fR                (replace query string with the current selection)
    \fBselect\fR
    \fBselect-all\fR                   (select all matches)
    \fBshow-preview\fR
    \fBtoggle\fR                       (\fIright-click\fR)
    \fBtoggle-all\fR                   (toggle all matches)
    \fBtoggle+down\fR                  \fIctrl-i  (tab)\fR
    \fBtoggle-in\fR                    (\fB--layout=reverse*\fR ? \fBtoggle+up\fR : \fBtoggle+down\fR)
    \fBtoggle-out\fR                   (\fB--layout=reverse*\fR ? \fBtoggle+down\fR : \fBtoggle+up\fR)
    \fBtoggle-preview\fR
    \fBtoggle-preview-wrap\fR
    \fBtoggle-search\fR                (toggle search functionality)
    \fBtoggle-sort\fR
    \fBtoggle-track\fR
    \fBtoggle+up\fR                    \fIbtab    (shift-tab)\fR
    \fBtrack\fR                        (track the current item; automatically disabled if focus changes)
    \fBtransform-border-label(...)\fR  (transform border label using an external command)
    \fBtransform-header(...)\fR        (transform header using an external command)
    \fBtransform-preview-label(...)\fR (transform preview label using an external command)
    \fBtransform-prompt(...)\fR        (transform prompt string using an external command)
    \fBtransform-query(...)\fR         (transform query string using an external command)
    \fBunbind(...)\fR                  (unbind bindings)
    \fBunix-line-discard\fR            \fIctrl-u\fR
    \fBunix-word-rubout\fR             \fIctrl-w\fR
    \fBup\fR                           \fIctrl-k  ctrl-p  up\fR
    \fByank\fR                         \fIctrl-y\fR

.SS ACTION COMPOSITION

Multiple actions can be chained using \fB+\fR separator.

e.g.
     \fBfzf --multi --bind 'ctrl-a:select-all+accept'\fR
     \fBfzf --multi --bind 'ctrl-a:select-all' --bind 'ctrl-a:+accept'\fR

.SS ACTION ARGUMENT

An action denoted with \fB(...)\fR suffix takes an argument.

e.g.
     \fBfzf --bind 'ctrl-a:change-prompt(NewPrompt> )'\fR
     \fBfzf --bind 'ctrl-v:preview(cat {})' --preview-window hidden\fR

If the argument contains parentheses, fzf may fail to parse the expression. In
that case, you can use any of the following alternative notations to avoid
parse errors.

    \fBaction-name[...]\fR
    \fBaction-name{...}\fR
    \fBaction-name<...>\fR
    \fBaction-name~...~\fR
    \fBaction-name!...!\fR
    \fBaction-name@...@\fR
    \fBaction-name#...#\fR
    \fBaction-name$...$\fR
    \fBaction-name%...%\fR
    \fBaction-name^...^\fR
    \fBaction-name&...&\fR
    \fBaction-name*...*\fR
    \fBaction-name;...;\fR
    \fBaction-name/.../\fR
    \fBaction-name|...|\fR
    \fBaction-name:...\fR
.RS
The last one is the special form that frees you from parse errors as it does
not expect the closing character. The catch is that it should be the last one
in the comma-separated list of key-action pairs.
.RE

.SS COMMAND EXECUTION

With \fBexecute(...)\fR action, you can execute arbitrary commands without
leaving fzf. For example, you can turn fzf into a simple file browser by
binding \fBenter\fR key to \fBless\fR command like follows.

    \fBfzf --bind "enter:execute(less {})"\fR

You can use the same placeholder expressions as in \fB--preview\fR.

fzf switches to the alternate screen when executing a command. However, if the
command is expected to complete quickly, and you are not interested in its
output, you might want to use \fBexecute-silent\fR instead, which silently
executes the command without the switching. Note that fzf will not be
responsive until the command is complete. For asynchronous execution, start
your command as a background process (i.e. appending \fB&\fR).

On *nix systems, fzf runs the command with \fB$SHELL -c\fR if \fBSHELL\fR is
set, otherwise with \fBsh -c\fR, so in this case make sure that the command is
POSIX-compliant.

\fBbecome(...)\fR action is similar to \fBexecute(...)\fR, but it replaces the
current fzf process with the specified command using \fBexecve(2)\fR system
call.

    \fBfzf --bind "enter:become(vim {})"\fR

\fBbecome(...)\fR is not supported on Windows.

.SS RELOAD INPUT

\fBreload(...)\fR action is used to dynamically update the input list
without restarting fzf. It takes the same command template with placeholder
expressions as \fBexecute(...)\fR.

See \fIhttps://github.com/junegunn/fzf/issues/1750\fR for more info.

e.g.
     \fB# Update the list of processes by pressing CTRL-R
     ps -ef | fzf --bind 'ctrl-r:reload(ps -ef)' --header 'Press CTRL-R to reload' \\
                  --header-lines=1 --layout=reverse

     # Integration with ripgrep
     RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
     INITIAL_QUERY="foobar"
     FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \\
       fzf --bind "change:reload:$RG_PREFIX {q} || true" \\
           --ansi --disabled --query "$INITIAL_QUERY"\fR

\fBreload-sync(...)\fR is a synchronous version of \fBreload\fR that replaces
the list only when the command is complete. This is useful when the command
takes a while to produce the initial output and you don't want fzf to run
against an empty list while the command is running.


e.g.
     \fB# You can still filter and select entries from the initial list for 3 seconds
     seq 100 | fzf --bind 'load:reload-sync(sleep 3; seq 1000)+unbind(load)'\fR

.SS PREVIEW BINDING

With \fBpreview(...)\fR action, you can specify multiple different preview
commands in addition to the default preview command given by \fB--preview\fR
option.

e.g.
     # Default preview command with an extra preview binding
     fzf --preview 'file {}' --bind '?:preview:cat {}'

     # A preview binding with no default preview command
     # (Preview window is initially empty)
     fzf --bind '?:preview:cat {}'

     # Preview window hidden by default, it appears when you first hit '?'
     fzf --bind '?:preview:cat {}' --preview-window hidden

.SS CHANGE PREVIEW WINDOW ATTRIBUTES

\fBchange-preview-window\fR action can be used to change the properties of the
preview window. Unlike the \fB--preview-window\fR option, you can specify
multiple sets of options separated by '|' characters.

e.g.
     # Rotate through the options using CTRL-/
     fzf --preview 'cat {}' --bind 'ctrl-/:change-preview-window(right,70%|down,40%,border-horizontal|hidden|right)'

     # The default properties given by `--preview-window` are inherited, so an empty string in the list is interpreted as the default
     fzf --preview 'cat {}' --preview-window 'right,40%,border-left' --bind 'ctrl-/:change-preview-window(70%|down,border-top|hidden|)'

     # This is equivalent to toggle-preview action
     fzf --preview 'cat {}' --bind 'ctrl-/:change-preview-window(hidden|)'

.SH AUTHOR
Junegunn Choi (\fIjunegunn.c@gmail.com\fR)

.SH SEE ALSO
.B Project homepage:
.RS
.I https://github.com/junegunn/fzf
.RE
.br

.br
.B Extra Vim plugin:
.RS
.I https://github.com/junegunn/fzf.vim
.RE

.SH LICENSE
MIT
./plugin/fzf.vim	[[[1
1098
" Copyright (c) 2013-2023 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if exists('g:loaded_fzf')
  finish
endif
let g:loaded_fzf = 1

let s:is_win = has('win32') || has('win64')
if s:is_win && &shellslash
  set noshellslash
  let s:base_dir = expand('<sfile>:h:h')
  set shellslash
else
  let s:base_dir = expand('<sfile>:h:h')
endif
if s:is_win
  let s:term_marker = '&::FZF'

  function! s:fzf_call(fn, ...)
    let shellslash = &shellslash
    try
      set noshellslash
      return call(a:fn, a:000)
    finally
      let &shellslash = shellslash
    endtry
  endfunction

  " Use utf-8 for fzf.vim commands
  " Return array of shell commands for cmd.exe
  function! s:enc_to_cp(str)
    if !has('iconv')
      return a:str
    endif
    if !exists('s:codepage')
      let s:codepage = libcallnr('kernel32.dll', 'GetACP', 0)
    endif
    return iconv(a:str, &encoding, 'cp'.s:codepage)
  endfunction
  function! s:wrap_cmds(cmds)
    return map([
      \ '@echo off',
      \ 'setlocal enabledelayedexpansion']
    \ + (has('gui_running') ? ['set TERM= > nul'] : [])
    \ + (type(a:cmds) == type([]) ? a:cmds : [a:cmds])
    \ + ['endlocal'],
    \ '<SID>enc_to_cp(v:val."\r")')
  endfunction
else
  let s:term_marker = ";#FZF"

  function! s:fzf_call(fn, ...)
    return call(a:fn, a:000)
  endfunction

  function! s:wrap_cmds(cmds)
    return a:cmds
  endfunction

  function! s:enc_to_cp(str)
    return a:str
  endfunction
endif

function! s:shellesc_cmd(arg)
  let escaped = substitute(a:arg, '[&|<>()@^]', '^&', 'g')
  let escaped = substitute(escaped, '%', '%%', 'g')
  let escaped = substitute(escaped, '"', '\\^&', 'g')
  let escaped = substitute(escaped, '\(\\\+\)\(\\^\)', '\1\1\2', 'g')
  return '^"'.substitute(escaped, '\(\\\+\)$', '\1\1', '').'^"'
endfunction

function! fzf#shellescape(arg, ...)
  let shell = get(a:000, 0, s:is_win ? 'cmd.exe' : 'sh')
  if shell =~# 'cmd.exe$'
    return s:shellesc_cmd(a:arg)
  endif
  try
    let [shell, &shell] = [&shell, shell]
    return s:fzf_call('shellescape', a:arg)
  finally
    let [shell, &shell] = [&shell, shell]
  endtry
endfunction

function! s:fzf_getcwd()
  return s:fzf_call('getcwd')
endfunction

function! s:fzf_fnamemodify(fname, mods)
  return s:fzf_call('fnamemodify', a:fname, a:mods)
endfunction

function! s:fzf_expand(fmt)
  return s:fzf_call('expand', a:fmt, 1)
endfunction

function! s:fzf_tempname()
  return s:fzf_call('tempname')
endfunction

let s:layout_keys = ['window', 'tmux', 'up', 'down', 'left', 'right']
let s:fzf_go = s:base_dir.'/bin/fzf'
let s:fzf_tmux = s:base_dir.'/bin/fzf-tmux'

let s:cpo_save = &cpo
set cpo&vim

function! s:popup_support()
  return has('nvim') ? has('nvim-0.4') : has('popupwin') && has('patch-8.2.191')
endfunction

function! s:default_layout()
  return s:popup_support()
        \ ? { 'window' : { 'width': 0.9, 'height': 0.6 } }
        \ : { 'down': '~40%' }
endfunction

function! fzf#install()
  if s:is_win && !has('win32unix')
    let script = s:base_dir.'/install.ps1'
    if !filereadable(script)
      throw script.' not found'
    endif
    let script = 'powershell -ExecutionPolicy Bypass -file ' . shellescape(script)
  else
    let script = s:base_dir.'/install'
    if !executable(script)
      throw script.' not found'
    endif
    let script .= ' --bin'
  endif

  call s:warn('Running fzf installer ...')
  call system(script)
  if v:shell_error
    throw 'Failed to download fzf: '.script
  endif
endfunction

let s:versions = {}
function s:get_version(bin)
  if has_key(s:versions, a:bin)
    return s:versions[a:bin]
  end
  let command = (&shell =~ 'powershell\|pwsh' ? '&' : '') . s:fzf_call('shellescape', a:bin) . ' --version --no-height'
  let output = systemlist(command)
  if v:shell_error || empty(output)
    return ''
  endif
  let ver = matchstr(output[-1], '[0-9.]\+')
  let s:versions[a:bin] = ver
  return ver
endfunction

function! s:compare_versions(a, b)
  let a = split(a:a, '\.')
  let b = split(a:b, '\.')
  for idx in range(0, max([len(a), len(b)]) - 1)
    let v1 = str2nr(get(a, idx, 0))
    let v2 = str2nr(get(b, idx, 0))
    if     v1 < v2 | return -1
    elseif v1 > v2 | return 1
    endif
  endfor
  return 0
endfunction

function! s:compare_binary_versions(a, b)
  return s:compare_versions(s:get_version(a:a), s:get_version(a:b))
endfunction

let s:checked = {}
function! fzf#exec(...)
  if !exists('s:exec')
    let binaries = []
    if executable('fzf')
      call add(binaries, 'fzf')
    endif
    if executable(s:fzf_go)
      call add(binaries, s:fzf_go)
    endif

    if empty(binaries)
      if input('fzf executable not found. Download binary? (y/n) ') =~? '^y'
        redraw
        call fzf#install()
        return fzf#exec()
      else
        redraw
        throw 'fzf executable not found'
      endif
    elseif len(binaries) > 1
      call sort(binaries, 's:compare_binary_versions')
    endif

    let s:exec = binaries[-1]
  endif

  if a:0 && !has_key(s:checked, a:1)
    let fzf_version = s:get_version(s:exec)
    if empty(fzf_version)
      let message = printf('Failed to run "%s --version"', s:exec)
      unlet s:exec
      throw message
    end

    if s:compare_versions(fzf_version, a:1) >= 0
      let s:checked[a:1] = 1
      return s:exec
    elseif a:0 < 2 && input(printf('You need fzf %s or above. Found: %s. Download binary? (y/n) ', a:1, fzf_version)) =~? '^y'
      let s:versions = {}
      unlet s:exec
      redraw
      call fzf#install()
      return fzf#exec(a:1, 1)
    else
      throw printf('You need to upgrade fzf (required: %s or above)', a:1)
    endif
  endif

  return s:exec
endfunction

function! s:tmux_enabled()
  if has('gui_running') || !exists('$TMUX')
    return 0
  endif

  if exists('s:tmux')
    return s:tmux
  endif

  let s:tmux = 0
  if !executable(s:fzf_tmux)
    if executable('fzf-tmux')
      let s:fzf_tmux = 'fzf-tmux'
    else
      return 0
    endif
  endif

  let output = system('tmux -V')
  let s:tmux = !v:shell_error && output >= 'tmux 1.7'
  return s:tmux
endfunction

function! s:escape(path)
  let path = fnameescape(a:path)
  return s:is_win ? escape(path, '$') : path
endfunction

function! s:error(msg)
  echohl ErrorMsg
  echom a:msg
  echohl None
endfunction

function! s:warn(msg)
  echohl WarningMsg
  echom a:msg
  echohl None
endfunction

function! s:has_any(dict, keys)
  for key in a:keys
    if has_key(a:dict, key)
      return 1
    endif
  endfor
  return 0
endfunction

function! s:open(cmd, target)
  if stridx('edit', a:cmd) == 0 && s:fzf_fnamemodify(a:target, ':p') ==# s:fzf_expand('%:p')
    return
  endif
  execute a:cmd s:escape(a:target)
endfunction

function! s:common_sink(action, lines) abort
  if len(a:lines) < 2
    return
  endif
  let key = remove(a:lines, 0)
  let Cmd = get(a:action, key, 'e')
  if type(Cmd) == type(function('call'))
    return Cmd(a:lines)
  endif
  if len(a:lines) > 1
    augroup fzf_swap
      autocmd SwapExists * let v:swapchoice='o'
            \| call s:warn('fzf: E325: swap file exists: '.s:fzf_expand('<afile>'))
    augroup END
  endif
  try
    let empty = empty(s:fzf_expand('%')) && line('$') == 1 && empty(getline(1)) && !&modified
    " Preserve the current working directory in case it's changed during
    " the execution (e.g. `set autochdir` or `autocmd BufEnter * lcd ...`)
    let cwd = exists('w:fzf_pushd') ? w:fzf_pushd.dir : expand('%:p:h')
    for item in a:lines
      if item[0] != '~' && item !~ (s:is_win ? '^[A-Z]:\' : '^/')
        let sep = s:is_win ? '\' : '/'
        let item = join([cwd, item], cwd[len(cwd)-1] == sep ? '' : sep)
      endif
      if empty
        execute 'e' s:escape(item)
        let empty = 0
      else
        call s:open(Cmd, item)
      endif
      if !has('patch-8.0.0177') && !has('nvim-0.2') && exists('#BufEnter')
            \ && isdirectory(item)
        doautocmd BufEnter
      endif
    endfor
  catch /^Vim:Interrupt$/
  finally
    silent! autocmd! fzf_swap
  endtry
endfunction

function! s:get_color(attr, ...)
  " Force 24 bit colors: g:fzf_force_termguicolors (temporary workaround for https://github.com/junegunn/fzf.vim/issues/1152)
  let gui = get(g:, 'fzf_force_termguicolors', 0) || (!s:is_win && !has('win32unix') && has('termguicolors') && &termguicolors)
  let fam = gui ? 'gui' : 'cterm'
  let pat = gui ? '^#[a-f0-9]\+' : '^[0-9]\+$'
  for group in a:000
    let code = synIDattr(synIDtrans(hlID(group)), a:attr, fam)
    if code =~? pat
      return code
    endif
  endfor
  return ''
endfunction

function! s:defaults()
  let rules = copy(get(g:, 'fzf_colors', {}))
  let colors = join(map(items(filter(map(rules, 'call("s:get_color", v:val)'), '!empty(v:val)')), 'join(v:val, ":")'), ',')
  return empty(colors) ? '' : fzf#shellescape('--color='.colors)
endfunction

function! s:validate_layout(layout)
  for key in keys(a:layout)
    if index(s:layout_keys, key) < 0
      throw printf('Invalid entry in g:fzf_layout: %s (allowed: %s)%s',
            \ key, join(s:layout_keys, ', '), key == 'options' ? '. Use $FZF_DEFAULT_OPTS.' : '')
    endif
  endfor
  return a:layout
endfunction

function! s:evaluate_opts(options)
  return type(a:options) == type([]) ?
        \ join(map(copy(a:options), 'fzf#shellescape(v:val)')) : a:options
endfunction

" [name string,] [opts dict,] [fullscreen boolean]
function! fzf#wrap(...)
  let args = ['', {}, 0]
  let expects = map(copy(args), 'type(v:val)')
  let tidx = 0
  for arg in copy(a:000)
    let tidx = index(expects, type(arg) == 6 ? type(0) : type(arg), tidx)
    if tidx < 0
      throw 'Invalid arguments (expected: [name string] [opts dict] [fullscreen boolean])'
    endif
    let args[tidx] = arg
    let tidx += 1
    unlet arg
  endfor
  let [name, opts, bang] = args

  if len(name)
    let opts.name = name
  end

  " Layout: g:fzf_layout (and deprecated g:fzf_height)
  if bang
    for key in s:layout_keys
      if has_key(opts, key)
        call remove(opts, key)
      endif
    endfor
  elseif !s:has_any(opts, s:layout_keys)
    if !exists('g:fzf_layout') && exists('g:fzf_height')
      let opts.down = g:fzf_height
    else
      let opts = extend(opts, s:validate_layout(get(g:, 'fzf_layout', s:default_layout())))
    endif
  endif

  " Colors: g:fzf_colors
  let opts.options = s:defaults() .' '. s:evaluate_opts(get(opts, 'options', ''))

  " History: g:fzf_history_dir
  if len(name) && len(get(g:, 'fzf_history_dir', ''))
    let dir = s:fzf_expand(g:fzf_history_dir)
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
    let history = fzf#shellescape(dir.'/'.name)
    let opts.options = join(['--history', history, opts.options])
  endif

  " Action: g:fzf_action
  if !s:has_any(opts, ['sink', 'sinklist', 'sink*'])
    let opts._action = get(g:, 'fzf_action', s:default_action)
    let opts.options .= ' --expect='.join(keys(opts._action), ',')
    function! opts.sinklist(lines) abort
      return s:common_sink(self._action, a:lines)
    endfunction
    let opts['sink*'] = opts.sinklist " For backward compatibility
  endif

  return opts
endfunction

function! s:use_sh()
  let [shell, shellslash, shellcmdflag, shellxquote] = [&shell, &shellslash, &shellcmdflag, &shellxquote]
  if s:is_win
    set shell=cmd.exe
    set noshellslash
    let &shellcmdflag = has('nvim') ? '/s /c' : '/c'
    let &shellxquote = has('nvim') ? '"' : '('
  else
    set shell=sh
  endif
  return [shell, shellslash, shellcmdflag, shellxquote]
endfunction

function! s:writefile(...)
  if call('writefile', a:000) == -1
    throw 'Failed to write temporary file. Check if you can write to the path tempname() returns.'
  endif
endfunction

function! s:extract_option(opts, name)
  let opt = ''
  let expect = 0
  " There are a few cases where this function doesn't work as expected.
  " Let's just assume such cases are extremely unlikely in real world.
  "   e.g. --query --border
  for word in split(a:opts)
    if expect && word !~ '^"\=-'
      let opt = opt . ' ' . word
      let expect = 0
    elseif word == '--no-'.a:name
      let opt = ''
    elseif word =~ '^--'.a:name.'='
      let opt = word
    elseif word =~ '^--'.a:name.'$'
      let opt = word
      let expect = 1
    elseif expect
      let expect = 0
    endif
  endfor
  return opt
endfunction

function! fzf#run(...) abort
try
  let [shell, shellslash, shellcmdflag, shellxquote] = s:use_sh()

  let dict   = exists('a:1') ? copy(a:1) : {}
  let temps  = { 'result': s:fzf_tempname() }
  let optstr = s:evaluate_opts(get(dict, 'options', ''))
  try
    let fzf_exec = shellescape(fzf#exec())
  catch
    throw v:exception
  endtry

  if !s:present(dict, 'dir')
    let dict.dir = s:fzf_getcwd()
  endif
  if has('win32unix') && s:present(dict, 'dir')
    let dict.dir = fnamemodify(dict.dir, ':p')
  endif

  if has_key(dict, 'source')
    let source = remove(dict, 'source')
    let type = type(source)
    if type == 1
      let source_command = source
    elseif type == 3
      let temps.input = s:fzf_tempname()
      call s:writefile(source, temps.input)
      let source_command = (s:is_win ? 'type ' : 'cat ').fzf#shellescape(temps.input)
    else
      throw 'Invalid source type'
    endif
  else
    let source_command = ''
  endif

  let prefer_tmux = get(g:, 'fzf_prefer_tmux', 0) || has_key(dict, 'tmux')
  let use_height = has_key(dict, 'down') && !has('gui_running') &&
        \ !(has('nvim') || s:is_win || has('win32unix') || s:present(dict, 'up', 'left', 'right', 'window')) &&
        \ executable('tput') && filereadable('/dev/tty')
  let has_vim8_term = has('terminal') && has('patch-8.0.995')
  let has_nvim_term = has('nvim-0.2.1') || has('nvim') && !s:is_win
  let use_term = has_nvim_term ||
    \ has_vim8_term && !has('win32unix') && (has('gui_running') || s:is_win || s:present(dict, 'down', 'up', 'left', 'right', 'window'))
  let use_tmux = (has_key(dict, 'tmux') || (!use_height && !use_term || prefer_tmux) && !has('win32unix') && s:splittable(dict)) && s:tmux_enabled()
  if prefer_tmux && use_tmux
    let use_height = 0
    let use_term = 0
  endif
  if use_term
    let optstr .= ' --no-height'
  elseif use_height
    let height = s:calc_size(&lines, dict.down, dict)
    let optstr .= ' --height='.height
  endif
  " Respect --border option given in $FZF_DEFAULT_OPTS and 'options'
  let optstr = join([s:border_opt(get(dict, 'window', 0)), s:extract_option($FZF_DEFAULT_OPTS, 'border'), optstr])
  let prev_default_command = $FZF_DEFAULT_COMMAND
  if len(source_command)
    let $FZF_DEFAULT_COMMAND = source_command
  endif
  let command = (use_tmux ? s:fzf_tmux(dict) : fzf_exec).' '.optstr.' > '.temps.result

  if use_term
    return s:execute_term(dict, command, temps)
  endif

  let lines = use_tmux ? s:execute_tmux(dict, command, temps)
                 \ : s:execute(dict, command, use_height, temps)
  call s:callback(dict, lines)
  return lines
finally
  if exists('source_command') && len(source_command)
    if len(prev_default_command)
      let $FZF_DEFAULT_COMMAND = prev_default_command
    else
      let $FZF_DEFAULT_COMMAND = ''
      silent! execute 'unlet $FZF_DEFAULT_COMMAND'
    endif
  endif
  let [&shell, &shellslash, &shellcmdflag, &shellxquote] = [shell, shellslash, shellcmdflag, shellxquote]
endtry
endfunction

function! s:present(dict, ...)
  for key in a:000
    if !empty(get(a:dict, key, ''))
      return 1
    endif
  endfor
  return 0
endfunction

function! s:fzf_tmux(dict)
  let size = get(a:dict, 'tmux', '')
  if empty(size)
    for o in ['up', 'down', 'left', 'right']
      if s:present(a:dict, o)
        let spec = a:dict[o]
        if (o == 'up' || o == 'down') && spec[0] == '~'
          let size = '-'.o[0].s:calc_size(&lines, spec, a:dict)
        else
          " Legacy boolean option
          let size = '-'.o[0].(spec == 1 ? '' : substitute(spec, '^\~', '', ''))
        endif
        break
      endif
    endfor
  endif
  return printf('LINES=%d COLUMNS=%d %s %s - --',
    \ &lines, &columns, fzf#shellescape(s:fzf_tmux), size)
endfunction

function! s:splittable(dict)
  return s:present(a:dict, 'up', 'down') && &lines > 15 ||
        \ s:present(a:dict, 'left', 'right') && &columns > 40
endfunction

function! s:pushd(dict)
  if s:present(a:dict, 'dir')
    let cwd = s:fzf_getcwd()
    let w:fzf_pushd = {
    \   'command': haslocaldir() ? 'lcd' : (exists(':tcd') && haslocaldir(-1) ? 'tcd' : 'cd'),
    \   'origin': cwd,
    \   'bufname': bufname('')
    \ }
    execute 'lcd' s:escape(a:dict.dir)
    let cwd = s:fzf_getcwd()
    let w:fzf_pushd.dir = cwd
    let a:dict.pushd = w:fzf_pushd
    return cwd
  endif
  return ''
endfunction

augroup fzf_popd
  autocmd!
  autocmd WinEnter * call s:dopopd()
augroup END

function! s:dopopd()
  if !exists('w:fzf_pushd')
    return
  endif

  " FIXME: We temporarily change the working directory to 'dir' entry
  " of options dictionary (set to the current working directory if not given)
  " before running fzf.
  "
  " e.g. call fzf#run({'dir': '/tmp', 'source': 'ls', 'sink': 'e'})
  "
  " After processing the sink function, we have to restore the current working
  " directory. But doing so may not be desirable if the function changed the
  " working directory on purpose.
  "
  " So how can we tell if we should do it or not? A simple heuristic we use
  " here is that we change directory only if the current working directory
  " matches 'dir' entry. However, it is possible that the sink function did
  " change the directory to 'dir'. In that case, the user will have an
  " unexpected result.
  if s:fzf_getcwd() ==# w:fzf_pushd.dir && (!&autochdir || w:fzf_pushd.bufname ==# bufname(''))
    execute w:fzf_pushd.command s:escape(w:fzf_pushd.origin)
  endif
  unlet! w:fzf_pushd
endfunction

function! s:xterm_launcher()
  let fmt = 'xterm -T "[fzf]" -bg "%s" -fg "%s" -geometry %dx%d+%d+%d -e bash -ic %%s'
  if has('gui_macvim')
    let fmt .= '&& osascript -e "tell application \"MacVim\" to activate"'
  endif
  return printf(fmt,
    \ escape(synIDattr(hlID("Normal"), "bg"), '#'), escape(synIDattr(hlID("Normal"), "fg"), '#'),
    \ &columns, &lines/2, getwinposx(), getwinposy())
endfunction
unlet! s:launcher
if s:is_win || has('win32unix')
  let s:launcher = '%s'
else
  let s:launcher = function('s:xterm_launcher')
endif

function! s:exit_handler(code, command, ...)
  if a:code == 130
    return 0
  elseif has('nvim') && a:code == 129
    " When deleting the terminal buffer while fzf is still running,
    " Nvim sends SIGHUP.
    return 0
  elseif a:code > 1
    call s:error('Error running ' . a:command)
    if !empty(a:000)
      sleep
    endif
    return 0
  endif
  return 1
endfunction

function! s:execute(dict, command, use_height, temps) abort
  call s:pushd(a:dict)
  if has('unix') && !a:use_height
    silent! !clear 2> /dev/null
  endif
  let escaped = (a:use_height || s:is_win) ? a:command : escape(substitute(a:command, '\n', '\\n', 'g'), '%#!')
  if has('gui_running')
    let Launcher = get(a:dict, 'launcher', get(g:, 'Fzf_launcher', get(g:, 'fzf_launcher', s:launcher)))
    let fmt = type(Launcher) == 2 ? call(Launcher, []) : Launcher
    if has('unix')
      let escaped = "'".substitute(escaped, "'", "'\"'\"'", 'g')."'"
    endif
    let command = printf(fmt, escaped)
  else
    let command = escaped
  endif
  if s:is_win
    let batchfile = s:fzf_tempname().'.bat'
    call s:writefile(s:wrap_cmds(command), batchfile)
    let command = batchfile
    let a:temps.batchfile = batchfile
    if has('nvim')
      let fzf = {}
      let fzf.dict = a:dict
      let fzf.temps = a:temps
      function! fzf.on_exit(job_id, exit_status, event) dict
        call s:pushd(self.dict)
        let lines = s:collect(self.temps)
        call s:callback(self.dict, lines)
      endfunction
      let cmd = 'start /wait cmd /c '.command
      call jobstart(cmd, fzf)
      return []
    endif
  elseif has('win32unix') && $TERM !=# 'cygwin'
    let shellscript = s:fzf_tempname()
    call s:writefile([command], shellscript)
    let command = 'cmd.exe /C '.fzf#shellescape('set "TERM=" & start /WAIT sh -c '.shellscript)
    let a:temps.shellscript = shellscript
  endif
  if a:use_height
    call system(printf('tput cup %d > /dev/tty; tput cnorm > /dev/tty; %s < /dev/tty 2> /dev/tty', &lines, command))
  else
    execute 'silent !'.command
  endif
  let exit_status = v:shell_error
  redraw!
  let lines = s:collect(a:temps)
  return s:exit_handler(exit_status, command) ? lines : []
endfunction

function! s:execute_tmux(dict, command, temps) abort
  let command = a:command
  let cwd = s:pushd(a:dict)
  if len(cwd)
    " -c '#{pane_current_path}' is only available on tmux 1.9 or above
    let command = join(['cd', fzf#shellescape(cwd), '&&', command])
  endif

  call system(command)
  let exit_status = v:shell_error
  redraw!
  let lines = s:collect(a:temps)
  return s:exit_handler(exit_status, command) ? lines : []
endfunction

function! s:calc_size(max, val, dict)
  let val = substitute(a:val, '^\~', '', '')
  if val =~ '%$'
    let size = a:max * str2nr(val[:-2]) / 100
  else
    let size = min([a:max, str2nr(val)])
  endif

  let srcsz = -1
  if type(get(a:dict, 'source', 0)) == type([])
    let srcsz = len(a:dict.source)
  endif

  let opts = $FZF_DEFAULT_OPTS.' '.s:evaluate_opts(get(a:dict, 'options', ''))
  if opts =~ 'preview'
    return size
  endif
  let margin = match(opts, '--inline-info\|--info[^-]\{-}inline') > match(opts, '--no-inline-info\|--info[^-]\{-}\(default\|hidden\)') ? 1 : 2
  let margin += match(opts, '--border\([^-]\|$\)') > match(opts, '--no-border\([^-]\|$\)') ? 2 : 0
  if stridx(opts, '--header') > stridx(opts, '--no-header')
    let margin += len(split(opts, "\n"))
  endif
  return srcsz >= 0 ? min([srcsz + margin, size]) : size
endfunction

function! s:getpos()
  return {'tab': tabpagenr(), 'win': winnr(), 'winid': win_getid(), 'cnt': winnr('$'), 'tcnt': tabpagenr('$')}
endfunction

function! s:border_opt(window)
  if type(a:window) != type({})
    return ''
  endif

  " Border style
  let style = tolower(get(a:window, 'border', ''))
  if !has_key(a:window, 'border') && has_key(a:window, 'rounded')
    let style = a:window.rounded ? 'rounded' : 'sharp'
  endif
  if style == 'none' || style == 'no'
    return ''
  endif

  " For --border styles, we need fzf 0.24.0 or above
  call fzf#exec('0.24.0')
  let opt = ' --border ' . style
  if has_key(a:window, 'highlight')
    let color = s:get_color('fg', a:window.highlight)
    if len(color)
      let opt .= ' --color=border:' . color
    endif
  endif
  return opt
endfunction

function! s:split(dict)
  let directions = {
  \ 'up':    ['topleft', 'resize', &lines],
  \ 'down':  ['botright', 'resize', &lines],
  \ 'left':  ['vertical topleft', 'vertical resize', &columns],
  \ 'right': ['vertical botright', 'vertical resize', &columns] }
  let ppos = s:getpos()
  let is_popup = 0
  try
    if s:present(a:dict, 'window')
      if type(a:dict.window) == type({})
        if !s:popup_support()
          throw 'Nvim 0.4+ or Vim 8.2.191+ with popupwin feature is required for pop-up window'
        end
        call s:popup(a:dict.window)
        let is_popup = 1
      else
        execute 'keepalt' a:dict.window
      endif
    elseif !s:splittable(a:dict)
      execute (tabpagenr()-1).'tabnew'
    else
      for [dir, triple] in items(directions)
        let val = get(a:dict, dir, '')
        if !empty(val)
          let [cmd, resz, max] = triple
          if (dir == 'up' || dir == 'down') && val[0] == '~'
            let sz = s:calc_size(max, val, a:dict)
          else
            let sz = s:calc_size(max, val, {})
          endif
          execute cmd sz.'new'
          execute resz sz
          return [ppos, {}, is_popup]
        endif
      endfor
    endif
    return [ppos, is_popup ? {} : { '&l:wfw': &l:wfw, '&l:wfh': &l:wfh }, is_popup]
  finally
    if !is_popup
      setlocal winfixwidth winfixheight
    endif
  endtry
endfunction

nnoremap <silent> <Plug>(fzf-insert) i
nnoremap <silent> <Plug>(fzf-normal) <Nop>
if exists(':tnoremap')
  tnoremap <silent> <Plug>(fzf-insert) <C-\><C-n>i
  tnoremap <silent> <Plug>(fzf-normal) <C-\><C-n>
endif

let s:warned = 0
function! s:handle_ambidouble(dict)
  if &ambiwidth == 'double'
    let a:dict.env = { 'RUNEWIDTH_EASTASIAN': '1' }
  elseif !s:warned && $RUNEWIDTH_EASTASIAN == '1' && &ambiwidth !=# 'double'
    call s:warn("$RUNEWIDTH_EASTASIAN is '1' but &ambiwidth is not 'double'")
    2sleep
    let s:warned = 1
  endif
endfunction

function! s:execute_term(dict, command, temps) abort
  let winrest = winrestcmd()
  let pbuf = bufnr('')
  let [ppos, winopts, is_popup] = s:split(a:dict)
  call s:use_sh()
  let b:fzf = a:dict
  let fzf = { 'buf': bufnr(''), 'pbuf': pbuf, 'ppos': ppos, 'dict': a:dict, 'temps': a:temps,
            \ 'winopts': winopts, 'winrest': winrest, 'lines': &lines,
            \ 'columns': &columns, 'command': a:command }
  function! fzf.switch_back(inplace)
    if a:inplace && bufnr('') == self.buf
      if bufexists(self.pbuf)
        execute 'keepalt keepjumps b' self.pbuf
      endif
      " No other listed buffer
      if bufnr('') == self.buf
        enew
      endif
    endif
  endfunction
  function! fzf.on_exit(id, code, ...)
    if s:getpos() == self.ppos " {'window': 'enew'}
      for [opt, val] in items(self.winopts)
        execute 'let' opt '=' val
      endfor
      call self.switch_back(1)
    else
      if bufnr('') == self.buf
        " We use close instead of bd! since Vim does not close the split when
        " there's no other listed buffer (nvim +'set nobuflisted')
        close
      endif
      silent! execute 'tabnext' self.ppos.tab
      silent! execute self.ppos.win.'wincmd w'
    endif

    if bufexists(self.buf)
      execute 'bd!' self.buf
    endif

    if &lines == self.lines && &columns == self.columns && s:getpos() == self.ppos
      execute self.winrest
    endif

    let lines = s:collect(self.temps)
    if !s:exit_handler(a:code, self.command, 1)
      return
    endif

    call s:pushd(self.dict)
    call s:callback(self.dict, lines)
    call self.switch_back(s:getpos() == self.ppos)

    if &buftype == 'terminal'
      call feedkeys(&filetype == 'fzf' ? "\<Plug>(fzf-insert)" : "\<Plug>(fzf-normal)")
    endif
  endfunction

  try
    call s:pushd(a:dict)
    if s:is_win
      let fzf.temps.batchfile = s:fzf_tempname().'.bat'
      call s:writefile(s:wrap_cmds(a:command), fzf.temps.batchfile)
      let command = fzf.temps.batchfile
    else
      let command = a:command
    endif
    let command .= s:term_marker
    if has('nvim')
      call s:handle_ambidouble(fzf)
      call termopen(command, fzf)
    else
      let term_opts = {'exit_cb': function(fzf.on_exit)}
      if v:version >= 802
        let term_opts.term_kill = 'term'
      endif
      if is_popup
        let term_opts.hidden = 1
      else
        let term_opts.curwin = 1
      endif
      call s:handle_ambidouble(term_opts)
      let fzf.buf = term_start([&shell, &shellcmdflag, command], term_opts)
      if is_popup && exists('#TerminalWinOpen')
        doautocmd <nomodeline> TerminalWinOpen
      endif
      if !has('patch-8.0.1261') && !s:is_win
        call term_wait(fzf.buf, 20)
      endif
    endif
    tnoremap <buffer> <c-z> <nop>
    if exists('&termwinkey') && (empty(&termwinkey) || &termwinkey =~? '<c-w>')
      tnoremap <buffer> <c-w> <c-w>.
    endif
  finally
    call s:dopopd()
  endtry
  setlocal nospell bufhidden=wipe nobuflisted nonumber
  setf fzf
  startinsert
  return []
endfunction

function! s:collect(temps) abort
  try
    return filereadable(a:temps.result) ? readfile(a:temps.result) : []
  finally
    for tf in values(a:temps)
      silent! call delete(tf)
    endfor
  endtry
endfunction

function! s:callback(dict, lines) abort
  let popd = has_key(a:dict, 'pushd')
  if popd
    let w:fzf_pushd = a:dict.pushd
  endif

  try
    if has_key(a:dict, 'sink')
      for line in a:lines
        if type(a:dict.sink) == 2
          call a:dict.sink(line)
        else
          execute a:dict.sink s:escape(line)
        endif
      endfor
    endif
    if has_key(a:dict, 'sink*')
      call a:dict['sink*'](a:lines)
    elseif has_key(a:dict, 'sinklist')
      call a:dict['sinklist'](a:lines)
    endif
  catch
    if stridx(v:exception, ':E325:') < 0
      echoerr v:exception
    endif
  endtry

  " We may have opened a new window or tab
  if popd
    let w:fzf_pushd = a:dict.pushd
    call s:dopopd()
  endif
endfunction

if has('nvim')
  function s:create_popup(opts) abort
    let buf = nvim_create_buf(v:false, v:true)
    let opts = extend({'relative': 'editor', 'style': 'minimal'}, a:opts)
    let win = nvim_open_win(buf, v:true, opts)
    silent! call setwinvar(win, '&winhighlight', 'Pmenu:,Normal:Normal')
    call setwinvar(win, '&colorcolumn', '')
    return buf
  endfunction
else
  function! s:create_popup(opts) abort
    let s:popup_create = {buf -> popup_create(buf, #{
      \ line: a:opts.row,
      \ col: a:opts.col,
      \ minwidth: a:opts.width,
      \ maxwidth: a:opts.width,
      \ minheight: a:opts.height,
      \ maxheight: a:opts.height,
      \ zindex: 1000,
    \ })}
    autocmd TerminalOpen * ++once call s:popup_create(str2nr(expand('<abuf>')))
  endfunction
endif

function! s:popup(opts) abort
  let xoffset = get(a:opts, 'xoffset', 0.5)
  let yoffset = get(a:opts, 'yoffset', 0.5)
  let relative = get(a:opts, 'relative', 0)

  " Use current window size for positioning relatively positioned popups
  let columns = relative ? winwidth(0) : &columns
  let lines = relative ? winheight(0) : (&lines - has('nvim'))

  " Size and position
  let width = min([max([8, a:opts.width > 1 ? a:opts.width : float2nr(columns * a:opts.width)]), columns])
  let height = min([max([4, a:opts.height > 1 ? a:opts.height : float2nr(lines * a:opts.height)]), lines])
  let row = float2nr(yoffset * (lines - height)) + (relative ? win_screenpos(0)[0] - 1 : 0)
  let col = float2nr(xoffset * (columns - width)) + (relative ? win_screenpos(0)[1] - 1 : 0)

  " Managing the differences
  let row = min([max([0, row]), &lines - has('nvim') - height])
  let col = min([max([0, col]), &columns - width])
  let row += !has('nvim')
  let col += !has('nvim')

  call s:create_popup({
    \ 'row': row, 'col': col, 'width': width, 'height': height
  \ })
endfunction

let s:default_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

function! s:shortpath()
  let short = fnamemodify(getcwd(), ':~:.')
  if !has('win32unix')
    let short = pathshorten(short)
  endif
  let slash = (s:is_win && !&shellslash) ? '\' : '/'
  return empty(short) ? '~'.slash : short . (short =~ escape(slash, '\').'$' ? '' : slash)
endfunction

function! s:cmd(bang, ...) abort
  let args = copy(a:000)
  let opts = { 'options': ['--multi'] }
  if len(args) && isdirectory(expand(args[-1]))
    let opts.dir = substitute(substitute(remove(args, -1), '\\\(["'']\)', '\1', 'g'), '[/\\]*$', '/', '')
    if s:is_win && !&shellslash
      let opts.dir = substitute(opts.dir, '/', '\\', 'g')
    endif
    let prompt = opts.dir
  else
    let prompt = s:shortpath()
  endif
  let prompt = strwidth(prompt) < &columns - 20 ? prompt : '> '
  call extend(opts.options, ['--prompt', prompt])
  call extend(opts.options, args)
  call fzf#run(fzf#wrap('FZF', opts, a:bang))
endfunction

command! -nargs=* -complete=dir -bang FZF call s:cmd(<bang>0, <f-args>)

let &cpo = s:cpo_save
unlet s:cpo_save
./shell/completion.bash	[[[1
382
#     ____      ____
#    / __/___  / __/
#   / /_/_  / / /_
#  / __/ / /_/ __/
# /_/   /___/_/ completion.bash
#
# - $FZF_TMUX               (default: 0)
# - $FZF_TMUX_OPTS          (default: empty)
# - $FZF_COMPLETION_TRIGGER (default: '**')
# - $FZF_COMPLETION_OPTS    (default: empty)

if [[ $- =~ i ]]; then

# To use custom commands instead of find, override _fzf_compgen_{path,dir}
if ! declare -f _fzf_compgen_path > /dev/null; then
  _fzf_compgen_path() {
    echo "$1"
    command find -L "$1" \
      -name .git -prune -o -name .hg -prune -o -name .svn -prune -o \( -type d -o -type f -o -type l \) \
      -a -not -path "$1" -print 2> /dev/null | sed 's@^\./@@'
  }
fi

if ! declare -f _fzf_compgen_dir > /dev/null; then
  _fzf_compgen_dir() {
    command find -L "$1" \
      -name .git -prune -o -name .hg -prune -o -name .svn -prune -o -type d \
      -a -not -path "$1" -print 2> /dev/null | sed 's@^\./@@'
  }
fi

###########################################################

# To redraw line after fzf closes (printf '\e[5n')
bind '"\e[0n": redraw-current-line' 2> /dev/null

__fzf_comprun() {
  if [[ "$(type -t _fzf_comprun 2>&1)" = function ]]; then
    _fzf_comprun "$@"
  elif [[ -n "${TMUX_PANE-}" ]] && { [[ "${FZF_TMUX:-0}" != 0 ]] || [[ -n "${FZF_TMUX_OPTS-}" ]]; }; then
    shift
    fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- "$@"
  else
    shift
    fzf "$@"
  fi
}

__fzf_orig_completion() {
  local l comp f cmd
  while read -r l; do
    if [[ "$l" =~ ^(.*\ -F)\ *([^ ]*).*\ ([^ ]*)$ ]]; then
      comp="${BASH_REMATCH[1]}"
      f="${BASH_REMATCH[2]}"
      cmd="${BASH_REMATCH[3]}"
      [[ "$f" = _fzf_* ]] && continue
      printf -v "_fzf_orig_completion_${cmd//[^A-Za-z0-9_]/_}" "%s" "${comp} %s ${cmd} #${f}"
      if [[ "$l" = *" -o nospace "* ]] && [[ ! "${__fzf_nospace_commands-}" = *" $cmd "* ]]; then
        __fzf_nospace_commands="${__fzf_nospace_commands-} $cmd "
      fi
    fi
  done
}

_fzf_opts_completion() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="
    -x --extended
    -e --exact
    --algo
    -i +i
    -n --nth
    --with-nth
    -d --delimiter
    +s --no-sort
    --tac
    --tiebreak
    -m --multi
    --no-mouse
    --bind
    --cycle
    --no-hscroll
    --jump-labels
    --height
    --literal
    --reverse
    --margin
    --inline-info
    --prompt
    --pointer
    --marker
    --header
    --header-lines
    --ansi
    --tabstop
    --color
    --no-bold
    --history
    --history-size
    --preview
    --preview-window
    -q --query
    -1 --select-1
    -0 --exit-0
    -f --filter
    --print-query
    --expect
    --sync"

  case "${prev}" in
  --tiebreak)
    COMPREPLY=( $(compgen -W "length begin end index" -- "$cur") )
    return 0
    ;;
  --color)
    COMPREPLY=( $(compgen -W "dark light 16 bw" -- "$cur") )
    return 0
    ;;
  --history)
    COMPREPLY=()
    return 0
    ;;
  esac

  if [[ "$cur" =~ ^-|\+ ]]; then
    COMPREPLY=( $(compgen -W "${opts}" -- "$cur") )
    return 0
  fi

  return 0
}

_fzf_handle_dynamic_completion() {
  local cmd orig_var orig ret orig_cmd orig_complete
  cmd="$1"
  shift
  orig_cmd="$1"
  orig_var="_fzf_orig_completion_$cmd"
  orig="${!orig_var-}"
  orig="${orig##*#}"
  if [[ -n "$orig" ]] && type "$orig" > /dev/null 2>&1; then
    $orig "$@"
  elif [[ -n "${_fzf_completion_loader-}" ]]; then
    orig_complete=$(complete -p "$orig_cmd" 2> /dev/null)
    _completion_loader "$@"
    ret=$?
    # _completion_loader may not have updated completion for the command
    if [[ "$(complete -p "$orig_cmd" 2> /dev/null)" != "$orig_complete" ]]; then
      __fzf_orig_completion < <(complete -p "$orig_cmd" 2> /dev/null)
      if [[ "${__fzf_nospace_commands-}" = *" $orig_cmd "* ]]; then
        eval "${orig_complete/ -F / -o nospace -F }"
      else
        eval "$orig_complete"
      fi
    fi
    return $ret
  fi
}

__fzf_generic_path_completion() {
  local cur base dir leftover matches trigger cmd
  cmd="${COMP_WORDS[0]}"
  if [[ $cmd == \\* ]]; then
    cmd="${cmd:1}"
  fi
  cmd="${cmd//[^A-Za-z0-9_=]/_}"
  COMPREPLY=()
  trigger=${FZF_COMPLETION_TRIGGER-'**'}
  cur="${COMP_WORDS[COMP_CWORD]}"
  if [[ "$cur" == *"$trigger" ]]; then
    base=${cur:0:${#cur}-${#trigger}}
    eval "base=$base"

    dir=
    [[ $base = *"/"* ]] && dir="$base"
    while true; do
      if [[ -z "$dir" ]] || [[ -d "$dir" ]]; then
        leftover=${base/#"$dir"}
        leftover=${leftover/#\/}
        [[ -z "$dir" ]] && dir='.'
        [[ "$dir" != "/" ]] && dir="${dir/%\//}"
        matches=$(eval "$1 $(printf %q "$dir")" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_COMPLETION_OPTS-} $2" __fzf_comprun "$4" -q "$leftover" | while read -r item; do
          printf "%q " "${item%$3}$3"
        done)
        matches=${matches% }
        [[ -z "$3" ]] && [[ "${__fzf_nospace_commands-}" = *" ${COMP_WORDS[0]} "* ]] && matches="$matches "
        if [[ -n "$matches" ]]; then
          COMPREPLY=( "$matches" )
        else
          COMPREPLY=( "$cur" )
        fi
        printf '\e[5n'
        return 0
      fi
      dir=$(dirname "$dir")
      [[ "$dir" =~ /$ ]] || dir="$dir"/
    done
  else
    shift
    shift
    shift
    _fzf_handle_dynamic_completion "$cmd" "$@"
  fi
}

_fzf_complete() {
  # Split arguments around --
  local args rest str_arg i sep
  args=("$@")
  sep=
  for i in "${!args[@]}"; do
    if [[ "${args[$i]}" = -- ]]; then
      sep=$i
      break
    fi
  done
  if [[ -n "$sep" ]]; then
    str_arg=
    rest=("${args[@]:$((sep + 1)):${#args[@]}}")
    args=("${args[@]:0:$sep}")
  else
    str_arg=$1
    args=()
    shift
    rest=("$@")
  fi

  local cur selected trigger cmd post
  post="$(caller 0 | awk '{print $2}')_post"
  type -t "$post" > /dev/null 2>&1 || post=cat

  cmd="${COMP_WORDS[0]//[^A-Za-z0-9_=]/_}"
  trigger=${FZF_COMPLETION_TRIGGER-'**'}
  cur="${COMP_WORDS[COMP_CWORD]}"
  if [[ "$cur" == *"$trigger" ]]; then
    cur=${cur:0:${#cur}-${#trigger}}

    selected=$(FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_COMPLETION_OPTS-} $str_arg" __fzf_comprun "${rest[0]}" "${args[@]}" -q "$cur" | $post | tr '\n' ' ')
    selected=${selected% } # Strip trailing space not to repeat "-o nospace"
    if [[ -n "$selected" ]]; then
      COMPREPLY=("$selected")
    else
      COMPREPLY=("$cur")
    fi
    printf '\e[5n'
    return 0
  else
    _fzf_handle_dynamic_completion "$cmd" "${rest[@]}"
  fi
}

_fzf_path_completion() {
  __fzf_generic_path_completion _fzf_compgen_path "-m" "" "$@"
}

# Deprecated. No file only completion.
_fzf_file_completion() {
  _fzf_path_completion "$@"
}

_fzf_dir_completion() {
  __fzf_generic_path_completion _fzf_compgen_dir "" "/" "$@"
}

_fzf_complete_kill() {
  _fzf_proc_completion "$@"
}

_fzf_proc_completion() {
  _fzf_complete -m --header-lines=1 --preview 'echo {}' --preview-window down:3:wrap --min-height 15 -- "$@" < <(
    command ps -eo user,pid,ppid,start,time,command 2> /dev/null ||
      command ps -eo user,pid,ppid,time,args # For BusyBox
  )
}

_fzf_proc_completion_post() {
  awk '{print $2}'
}

_fzf_host_completion() {
  _fzf_complete +m -- "$@" < <(
    command cat <(command tail -n +1 ~/.ssh/config ~/.ssh/config.d/* /etc/ssh/ssh_config 2> /dev/null | command grep -i '^\s*host\(name\)\? ' | awk '{for (i = 2; i <= NF; i++) print $1 " " $i}' | command grep -v '[*?%]') \
        <(command grep -oE '^[[a-z0-9.,:-]+' ~/.ssh/known_hosts | tr ',' '\n' | tr -d '[' | awk '{ print $1 " " $1 }') \
        <(command grep -v '^\s*\(#\|$\)' /etc/hosts | command grep -Fv '0.0.0.0') |
        awk '{if (length($2) > 0) {print $2}}' | sort -u
  )
}

_fzf_var_completion() {
  _fzf_complete -m -- "$@" < <(
    declare -xp | sed -En 's|^declare [^ ]+ ([^=]+).*|\1|p'
  )
}

_fzf_alias_completion() {
  _fzf_complete -m -- "$@" < <(
    alias | sed -En 's|^alias ([^=]+).*|\1|p'
  )
}

# fzf options
complete -o default -F _fzf_opts_completion fzf
# fzf-tmux is a thin fzf wrapper that has only a few more options than fzf
# itself. As a quick improvement we take fzf's completion. Adding the few extra
# fzf-tmux specific options (like `-w WIDTH`) are left as a future patch.
complete -o default -F _fzf_opts_completion fzf-tmux

d_cmds="${FZF_COMPLETION_DIR_COMMANDS:-cd pushd rmdir}"
a_cmds="
  awk bat cat diff diff3
  emacs emacsclient ex file ftp g++ gcc gvim head hg hx java
  javac ld less more mvim nvim patch perl python ruby
  sed sftp sort source tail tee uniq vi view vim wc xdg-open
  basename bunzip2 bzip2 chmod chown curl cp dirname du
  find git grep gunzip gzip hg jar
  ln ls mv open rm rsync scp
  svn tar unzip zip"

# Preserve existing completion
__fzf_orig_completion < <(complete -p $d_cmds $a_cmds 2> /dev/null)

if type _completion_loader > /dev/null 2>&1; then
  _fzf_completion_loader=1
fi

__fzf_defc() {
  local cmd func opts orig_var orig def
  cmd="$1"
  func="$2"
  opts="$3"
  orig_var="_fzf_orig_completion_${cmd//[^A-Za-z0-9_]/_}"
  orig="${!orig_var-}"
  if [[ -n "$orig" ]]; then
    printf -v def "$orig" "$func"
    eval "$def"
  else
    complete -F "$func" $opts "$cmd"
  fi
}

# Anything
for cmd in $a_cmds; do
  __fzf_defc "$cmd" _fzf_path_completion "-o default -o bashdefault"
done

# Directory
for cmd in $d_cmds; do
  __fzf_defc "$cmd" _fzf_dir_completion "-o nospace -o dirnames"
done

unset cmd d_cmds a_cmds

_fzf_setup_completion() {
  local kind fn cmd
  kind=$1
  fn=_fzf_${1}_completion
  if [[ $# -lt 2 ]] || ! type -t "$fn" > /dev/null; then
    echo "usage: ${FUNCNAME[0]} path|dir|var|alias|host|proc COMMANDS..."
    return 1
  fi
  shift
  __fzf_orig_completion < <(complete -p "$@" 2> /dev/null)
  for cmd in "$@"; do
    case "$kind" in
      dir)   __fzf_defc "$cmd" "$fn" "-o nospace -o dirnames" ;;
      var)   __fzf_defc "$cmd" "$fn" "-o default -o nospace -v" ;;
      alias) __fzf_defc "$cmd" "$fn" "-a" ;;
      *)     __fzf_defc "$cmd" "$fn" "-o default -o bashdefault" ;;
    esac
  done
}

# Environment variables / Aliases / Hosts / Process
_fzf_setup_completion 'var'   export unset printenv
_fzf_setup_completion 'alias' unalias
_fzf_setup_completion 'host'  ssh telnet
_fzf_setup_completion 'proc'  kill

fi
./shell/completion.zsh	[[[1
325
#     ____      ____
#    / __/___  / __/
#   / /_/_  / / /_
#  / __/ / /_/ __/
# /_/   /___/_/ completion.zsh
#
# - $FZF_TMUX               (default: 0)
# - $FZF_TMUX_OPTS          (default: '-d 40%')
# - $FZF_COMPLETION_TRIGGER (default: '**')
# - $FZF_COMPLETION_OPTS    (default: empty)

# Both branches of the following `if` do the same thing -- define
# __fzf_completion_options such that `eval $__fzf_completion_options` sets
# all options to the same values they currently have. We'll do just that at
# the bottom of the file after changing options to what we prefer.
#
# IMPORTANT: Until we get to the `emulate` line, all words that *can* be quoted
# *must* be quoted in order to prevent alias expansion. In addition, code must
# be written in a way works with any set of zsh options. This is very tricky, so
# careful when you change it.
#
# Start by loading the builtin zsh/parameter module. It provides `options`
# associative array that stores current shell options.
if 'zmodload' 'zsh/parameter' 2>'/dev/null' && (( ${+options} )); then
  # This is the fast branch and it gets taken on virtually all Zsh installations.
  #
  # ${(kv)options[@]} expands to array of keys (option names) and values ("on"
  # or "off"). The subsequent expansion# with (j: :) flag joins all elements
  # together separated by spaces. __fzf_completion_options ends up with a value
  # like this: "options=(shwordsplit off aliases on ...)".
  __fzf_completion_options="options=(${(j: :)${(kv)options[@]}})"
else
  # This branch is much slower because it forks to get the names of all
  # zsh options. It's possible to eliminate this fork but it's not worth the
  # trouble because this branch gets taken only on very ancient or broken
  # zsh installations.
  () {
    # That `()` above defines an anonymous function. This is essentially a scope
    # for local parameters. We use it to avoid polluting global scope.
    'local' '__fzf_opt'
    __fzf_completion_options="setopt"
    # `set -o` prints one line for every zsh option. Each line contains option
    # name, some spaces, and then either "on" or "off". We just want option names.
    # Expansion with (@f) flag splits a string into lines. The outer expansion
    # removes spaces and everything that follow them on every line. __fzf_opt
    # ends up iterating over option names: shwordsplit, aliases, etc.
    for __fzf_opt in "${(@)${(@f)$(set -o)}%% *}"; do
      if [[ -o "$__fzf_opt" ]]; then
        # Option $__fzf_opt is currently on, so remember to set it back on.
        __fzf_completion_options+=" -o $__fzf_opt"
      else
        # Option $__fzf_opt is currently off, so remember to set it back off.
        __fzf_completion_options+=" +o $__fzf_opt"
      fi
    done
    # The value of __fzf_completion_options here looks like this:
    # "setopt +o shwordsplit -o aliases ..."
  }
fi

# Enable the default zsh options (those marked with <Z> in `man zshoptions`)
# but without `aliases`. Aliases in functions are expanded when functions are
# defined, so if we disable aliases here, we'll be sure to have no pesky
# aliases in any of our functions. This way we won't need prefix every
# command with `command` or to quote every word to defend against global
# aliases. Note that `aliases` is not the only option that's important to
# control. There are several others that could wreck havoc if they are set
# to values we don't expect. With the following `emulate` command we
# sidestep this issue entirely.
'emulate' 'zsh' '-o' 'no_aliases'

# This brace is the start of try-always block. The `always` part is like
# `finally` in lesser languages. We use it to *always* restore user options.
{

# Bail out if not interactive shell.
[[ -o interactive ]] || return 0

# To use custom commands instead of find, override _fzf_compgen_{path,dir}
if ! declare -f _fzf_compgen_path > /dev/null; then
  _fzf_compgen_path() {
    echo "$1"
    command find -L "$1" \
      -name .git -prune -o -name .hg -prune -o -name .svn -prune -o \( -type d -o -type f -o -type l \) \
      -a -not -path "$1" -print 2> /dev/null | sed 's@^\./@@'
  }
fi

if ! declare -f _fzf_compgen_dir > /dev/null; then
  _fzf_compgen_dir() {
    command find -L "$1" \
      -name .git -prune -o -name .hg -prune -o -name .svn -prune -o -type d \
      -a -not -path "$1" -print 2> /dev/null | sed 's@^\./@@'
  }
fi

###########################################################

__fzf_comprun() {
  if [[ "$(type _fzf_comprun 2>&1)" =~ function ]]; then
    _fzf_comprun "$@"
  elif [ -n "${TMUX_PANE-}" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "${FZF_TMUX_OPTS-}" ]; }; then
    shift
    if [ -n "${FZF_TMUX_OPTS-}" ]; then
      fzf-tmux ${(Q)${(Z+n+)FZF_TMUX_OPTS}} -- "$@"
    else
      fzf-tmux -d ${FZF_TMUX_HEIGHT:-40%} -- "$@"
    fi
  else
    shift
    fzf "$@"
  fi
}

# Extract the name of the command. e.g. foo=1 bar baz**<tab>
__fzf_extract_command() {
  local token tokens
  tokens=(${(z)1})
  for token in $tokens; do
    token=${(Q)token}
    if [[ "$token" =~ [[:alnum:]] && ! "$token" =~ "=" ]]; then
      echo "$token"
      return
    fi
  done
  echo "${tokens[1]}"
}

__fzf_generic_path_completion() {
  local base lbuf cmd compgen fzf_opts suffix tail dir leftover matches
  base=$1
  lbuf=$2
  cmd=$(__fzf_extract_command "$lbuf")
  compgen=$3
  fzf_opts=$4
  suffix=$5
  tail=$6

  setopt localoptions nonomatch
  eval "base=$base"
  [[ $base = *"/"* ]] && dir="$base"
  while [ 1 ]; do
    if [[ -z "$dir" || -d ${dir} ]]; then
      leftover=${base/#"$dir"}
      leftover=${leftover/#\/}
      [ -z "$dir" ] && dir='.'
      [ "$dir" != "/" ] && dir="${dir/%\//}"
      matches=$(eval "$compgen $(printf %q "$dir")" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_COMPLETION_OPTS-}" __fzf_comprun "$cmd" ${(Q)${(Z+n+)fzf_opts}} -q "$leftover" | while read item; do
        item="${item%$suffix}$suffix"
        echo -n "${(q)item} "
      done)
      matches=${matches% }
      if [ -n "$matches" ]; then
        LBUFFER="$lbuf$matches$tail"
      fi
      zle reset-prompt
      break
    fi
    dir=$(dirname "$dir")
    dir=${dir%/}/
  done
}

_fzf_path_completion() {
  __fzf_generic_path_completion "$1" "$2" _fzf_compgen_path \
    "-m" "" " "
}

_fzf_dir_completion() {
  __fzf_generic_path_completion "$1" "$2" _fzf_compgen_dir \
    "" "/" ""
}

_fzf_feed_fifo() (
  command rm -f "$1"
  mkfifo "$1"
  cat <&0 > "$1" &
)

_fzf_complete() {
  setopt localoptions ksh_arrays
  # Split arguments around --
  local args rest str_arg i sep
  args=("$@")
  sep=
  for i in {0..${#args[@]}}; do
    if [[ "${args[$i]-}" = -- ]]; then
      sep=$i
      break
    fi
  done
  if [[ -n "$sep" ]]; then
    str_arg=
    rest=("${args[@]:$((sep + 1)):${#args[@]}}")
    args=("${args[@]:0:$sep}")
  else
    str_arg=$1
    args=()
    shift
    rest=("$@")
  fi

  local fifo lbuf cmd matches post
  fifo="${TMPDIR:-/tmp}/fzf-complete-fifo-$$"
  lbuf=${rest[0]}
  cmd=$(__fzf_extract_command "$lbuf")
  post="${funcstack[1]}_post"
  type $post > /dev/null 2>&1 || post=cat

  _fzf_feed_fifo "$fifo"
  matches=$(FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_COMPLETION_OPTS-} $str_arg" __fzf_comprun "$cmd" "${args[@]}" -q "${(Q)prefix}" < "$fifo" | $post | tr '\n' ' ')
  if [ -n "$matches" ]; then
    LBUFFER="$lbuf$matches"
  fi
  command rm -f "$fifo"
}

_fzf_complete_telnet() {
  _fzf_complete +m -- "$@" < <(
    command grep -v '^\s*\(#\|$\)' /etc/hosts | command grep -Fv '0.0.0.0' |
        awk '{if (length($2) > 0) {print $2}}' | sort -u
  )
}

_fzf_complete_ssh() {
  _fzf_complete +m -- "$@" < <(
    setopt localoptions nonomatch
    command cat <(command tail -n +1 ~/.ssh/config ~/.ssh/config.d/* /etc/ssh/ssh_config 2> /dev/null | command grep -i '^\s*host\(name\)\? ' | awk '{for (i = 2; i <= NF; i++) print $1 " " $i}' | command grep -v '[*?%]') \
        <(command grep -oE '^[[a-z0-9.,:-]+' ~/.ssh/known_hosts | tr ',' '\n' | tr -d '[' | awk '{ print $1 " " $1 }') \
        <(command grep -v '^\s*\(#\|$\)' /etc/hosts | command grep -Fv '0.0.0.0') |
        awk '{if (length($2) > 0) {print $2}}' | sort -u
  )
}

_fzf_complete_export() {
  _fzf_complete -m -- "$@" < <(
    declare -xp | sed 's/=.*//' | sed 's/.* //'
  )
}

_fzf_complete_unset() {
  _fzf_complete -m -- "$@" < <(
    declare -xp | sed 's/=.*//' | sed 's/.* //'
  )
}

_fzf_complete_unalias() {
  _fzf_complete +m -- "$@" < <(
    alias | sed 's/=.*//'
  )
}

_fzf_complete_kill() {
  _fzf_complete -m --header-lines=1 --preview 'echo {}' --preview-window down:3:wrap --min-height 15 -- "$@" < <(
    command ps -eo user,pid,ppid,start,time,command 2> /dev/null ||
      command ps -eo user,pid,ppid,time,args # For BusyBox
  )
}

_fzf_complete_kill_post() {
  awk '{print $2}'
}

fzf-completion() {
  local tokens cmd prefix trigger tail matches lbuf d_cmds
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins

  # http://zsh.sourceforge.net/FAQ/zshfaq03.html
  # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
  tokens=(${(z)LBUFFER})
  if [ ${#tokens} -lt 1 ]; then
    zle ${fzf_default_completion:-expand-or-complete}
    return
  fi

  cmd=$(__fzf_extract_command "$LBUFFER")

  # Explicitly allow for empty trigger.
  trigger=${FZF_COMPLETION_TRIGGER-'**'}
  [ -z "$trigger" -a ${LBUFFER[-1]} = ' ' ] && tokens+=("")

  # When the trigger starts with ';', it becomes a separate token
  if [[ ${LBUFFER} = *"${tokens[-2]-}${tokens[-1]}" ]]; then
    tokens[-2]="${tokens[-2]-}${tokens[-1]}"
    tokens=(${tokens[0,-2]})
  fi

  lbuf=$LBUFFER
  tail=${LBUFFER:$(( ${#LBUFFER} - ${#trigger} ))}

  # Trigger sequence given
  if [ ${#tokens} -gt 1 -a "$tail" = "$trigger" ]; then
    d_cmds=(${=FZF_COMPLETION_DIR_COMMANDS:-cd pushd rmdir})

    [ -z "$trigger"      ] && prefix=${tokens[-1]} || prefix=${tokens[-1]:0:-${#trigger}}
    [ -n "${tokens[-1]}" ] && lbuf=${lbuf:0:-${#tokens[-1]}}

    if eval "type _fzf_complete_${cmd} > /dev/null"; then
      prefix="$prefix" eval _fzf_complete_${cmd} ${(q)lbuf}
      zle reset-prompt
    elif [ ${d_cmds[(i)$cmd]} -le ${#d_cmds} ]; then
      _fzf_dir_completion "$prefix" "$lbuf"
    else
      _fzf_path_completion "$prefix" "$lbuf"
    fi
  # Fall back to default completion
  else
    zle ${fzf_default_completion:-expand-or-complete}
  fi
}

[ -z "$fzf_default_completion" ] && {
  binding=$(bindkey '^I')
  [[ $binding =~ 'undefined-key' ]] || fzf_default_completion=$binding[(s: :w)2]
  unset binding
}

zle     -N   fzf-completion
bindkey '^I' fzf-completion

} always {
  # Restore the original options.
  eval $__fzf_completion_options
  'unset' '__fzf_completion_options'
}
./shell/key-bindings.bash	[[[1
102
#     ____      ____
#    / __/___  / __/
#   / /_/_  / / /_
#  / __/ / /_/ __/
# /_/   /___/_/ key-bindings.bash
#
# - $FZF_TMUX_OPTS
# - $FZF_CTRL_T_COMMAND
# - $FZF_CTRL_T_OPTS
# - $FZF_CTRL_R_OPTS
# - $FZF_ALT_C_COMMAND
# - $FZF_ALT_C_OPTS

# Key bindings
# ------------
__fzf_select__() {
  local cmd opts
  cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore --reverse ${FZF_DEFAULT_OPTS-} ${FZF_CTRL_T_OPTS-} -m"
  eval "$cmd" |
    FZF_DEFAULT_OPTS="$opts" $(__fzfcmd) "$@" |
    while read -r item; do
      printf '%q ' "$item"  # escape special chars
    done
}

if [[ $- =~ i ]]; then

__fzfcmd() {
  [[ -n "${TMUX_PANE-}" ]] && { [[ "${FZF_TMUX:-0}" != 0 ]] || [[ -n "${FZF_TMUX_OPTS-}" ]]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

fzf-file-widget() {
  local selected="$(__fzf_select__ "$@")"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}

__fzf_cd__() {
  local cmd opts dir
  cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
  opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore --reverse ${FZF_DEFAULT_OPTS-} ${FZF_ALT_C_OPTS-} +m"
  dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="$opts" $(__fzfcmd)) && printf 'builtin cd -- %q' "$dir"
}

__fzf_history__() {
  local output opts script
  opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort ${FZF_CTRL_R_OPTS-} +m --read0"
  script='BEGIN { getc; $/ = "\n\t"; $HISTCOUNT = $ENV{last_hist} + 1 } s/^[ *]//; print $HISTCOUNT - $. . "\t$_" if !$seen{$_}++'
  output=$(
    builtin fc -lnr -2147483648 |
      last_hist=$(HISTTIMEFORMAT='' builtin history 1) perl -n -l0 -e "$script" |
      FZF_DEFAULT_OPTS="$opts" $(__fzfcmd) --query "$READLINE_LINE"
  ) || return
  READLINE_LINE=${output#*$'\t'}
  if [[ -z "$READLINE_POINT" ]]; then
    echo "$READLINE_LINE"
  else
    READLINE_POINT=0x7fffffff
  fi
}

# Required to refresh the prompt after fzf
bind -m emacs-standard '"\er": redraw-current-line'

bind -m vi-command '"\C-z": emacs-editing-mode'
bind -m vi-insert '"\C-z": emacs-editing-mode'
bind -m emacs-standard '"\C-z": vi-editing-mode'

if (( BASH_VERSINFO[0] < 4 )); then
  # CTRL-T - Paste the selected file path into the command line
  bind -m emacs-standard '"\C-t": " \C-b\C-k \C-u`__fzf_select__`\e\C-e\er\C-a\C-y\C-h\C-e\e \C-y\ey\C-x\C-x\C-f"'
  bind -m vi-command '"\C-t": "\C-z\C-t\C-z"'
  bind -m vi-insert '"\C-t": "\C-z\C-t\C-z"'

  # CTRL-R - Paste the selected command from history into the command line
  bind -m emacs-standard '"\C-r": "\C-e \C-u\C-y\ey\C-u"$(__fzf_history__)"\e\C-e\er"'
  bind -m vi-command '"\C-r": "\C-z\C-r\C-z"'
  bind -m vi-insert '"\C-r": "\C-z\C-r\C-z"'
else
  # CTRL-T - Paste the selected file path into the command line
  bind -m emacs-standard -x '"\C-t": fzf-file-widget'
  bind -m vi-command -x '"\C-t": fzf-file-widget'
  bind -m vi-insert -x '"\C-t": fzf-file-widget'

  # CTRL-R - Paste the selected command from history into the command line
  bind -m emacs-standard -x '"\C-r": __fzf_history__'
  bind -m vi-command -x '"\C-r": __fzf_history__'
  bind -m vi-insert -x '"\C-r": __fzf_history__'
fi

# ALT-C - cd into the selected directory
bind -m emacs-standard '"\ec": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
bind -m vi-command '"\ec": "\C-z\ec\C-z"'
bind -m vi-insert '"\ec": "\C-z\ec\C-z"'

fi
./shell/key-bindings.fish	[[[1
172
#     ____      ____
#    / __/___  / __/
#   / /_/_  / / /_
#  / __/ / /_/ __/
# /_/   /___/_/ key-bindings.fish
#
# - $FZF_TMUX_OPTS
# - $FZF_CTRL_T_COMMAND
# - $FZF_CTRL_T_OPTS
# - $FZF_CTRL_R_OPTS
# - $FZF_ALT_C_COMMAND
# - $FZF_ALT_C_OPTS

# Key bindings
# ------------
function fzf_key_bindings

  # Store current token in $dir as root for the 'find' command
  function fzf-file-widget -d "List files and folders"
    set -l commandline (__fzf_parse_commandline)
    set -l dir $commandline[1]
    set -l fzf_query $commandline[2]
    set -l prefix $commandline[3]

    # "-path \$dir'*/\\.*'" matches hidden files/folders inside $dir but not
    # $dir itself, even if hidden.
    test -n "$FZF_CTRL_T_COMMAND"; or set -l FZF_CTRL_T_COMMAND "
    command find -L \$dir -mindepth 1 \\( -path \$dir'*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed 's@^\./@@'"

    test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
    begin
      set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"
      eval "$FZF_CTRL_T_COMMAND | "(__fzfcmd)' -m --query "'$fzf_query'"' | while read -l r; set result $result $r; end
    end
    if [ -z "$result" ]
      commandline -f repaint
      return
    else
      # Remove last token from commandline.
      commandline -t ""
    end
    for i in $result
      commandline -it -- $prefix
      commandline -it -- (string escape $i)
      commandline -it -- ' '
    end
    commandline -f repaint
  end

  function fzf-history-widget -d "Show command history"
    test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
    begin
      set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS +m"

      set -l FISH_MAJOR (echo $version | cut -f1 -d.)
      set -l FISH_MINOR (echo $version | cut -f2 -d.)

      # history's -z flag is needed for multi-line support.
      # history's -z flag was added in fish 2.4.0, so don't use it for versions
      # before 2.4.0.
      if [ "$FISH_MAJOR" -gt 2 -o \( "$FISH_MAJOR" -eq 2 -a "$FISH_MINOR" -ge 4 \) ];
        history -z | eval (__fzfcmd) --read0 --print0 -q '(commandline)' | read -lz result
        and commandline -- $result
      else
        history | eval (__fzfcmd) -q '(commandline)' | read -l result
        and commandline -- $result
      end
    end
    commandline -f repaint
  end

  function fzf-cd-widget -d "Change directory"
    set -l commandline (__fzf_parse_commandline)
    set -l dir $commandline[1]
    set -l fzf_query $commandline[2]
    set -l prefix $commandline[3]

    test -n "$FZF_ALT_C_COMMAND"; or set -l FZF_ALT_C_COMMAND "
    command find -L \$dir -mindepth 1 \\( -path \$dir'*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
    -o -type d -print 2> /dev/null | sed 's@^\./@@'"
    test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
    begin
      set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS"
      eval "$FZF_ALT_C_COMMAND | "(__fzfcmd)' +m --query "'$fzf_query'"' | read -l result

      if [ -n "$result" ]
        cd -- $result

        # Remove last token from commandline.
        commandline -t ""
        commandline -it -- $prefix
      end
    end

    commandline -f repaint
  end

  function __fzfcmd
    test -n "$FZF_TMUX"; or set FZF_TMUX 0
    test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
    if [ -n "$FZF_TMUX_OPTS" ]
      echo "fzf-tmux $FZF_TMUX_OPTS -- "
    else if [ $FZF_TMUX -eq 1 ]
      echo "fzf-tmux -d$FZF_TMUX_HEIGHT -- "
    else
      echo "fzf"
    end
  end

  bind \ct fzf-file-widget
  bind \cr fzf-history-widget
  bind \ec fzf-cd-widget

  if bind -M insert > /dev/null 2>&1
    bind -M insert \ct fzf-file-widget
    bind -M insert \cr fzf-history-widget
    bind -M insert \ec fzf-cd-widget
  end

  function __fzf_parse_commandline -d 'Parse the current command line token and return split of existing filepath, fzf query, and optional -option= prefix'
    set -l commandline (commandline -t)

    # strip -option= from token if present
    set -l prefix (string match -r -- '^-[^\s=]+=' $commandline)
    set commandline (string replace -- "$prefix" '' $commandline)

    # eval is used to do shell expansion on paths
    eval set commandline $commandline

    if [ -z $commandline ]
      # Default to current directory with no --query
      set dir '.'
      set fzf_query ''
    else
      set dir (__fzf_get_dir $commandline)

      if [ "$dir" = "." -a (string sub -l 1 -- $commandline) != '.' ]
        # if $dir is "." but commandline is not a relative path, this means no file path found
        set fzf_query $commandline
      else
        # Also remove trailing slash after dir, to "split" input properly
        set fzf_query (string replace -r "^$dir/?" -- '' "$commandline")
      end
    end

    echo $dir
    echo $fzf_query
    echo $prefix
  end

  function __fzf_get_dir -d 'Find the longest existing filepath from input string'
    set dir $argv

    # Strip all trailing slashes. Ignore if $dir is root dir (/)
    if [ (string length -- $dir) -gt 1 ]
      set dir (string replace -r '/*$' -- '' $dir)
    end

    # Iteratively check if dir exists and strip tail end of path
    while [ ! -d "$dir" ]
      # If path is absolute, this can keep going until ends up at /
      # If path is relative, this can keep going until entire input is consumed, dirname returns "."
      set dir (dirname -- "$dir")
    end

    echo $dir
  end

end
./shell/key-bindings.zsh	[[[1
120
#     ____      ____
#    / __/___  / __/
#   / /_/_  / / /_
#  / __/ / /_/ __/
# /_/   /___/_/ key-bindings.zsh
#
# - $FZF_TMUX_OPTS
# - $FZF_CTRL_T_COMMAND
# - $FZF_CTRL_T_OPTS
# - $FZF_CTRL_R_OPTS
# - $FZF_ALT_C_COMMAND
# - $FZF_ALT_C_OPTS

# Key bindings
# ------------

# The code at the top and the bottom of this file is the same as in completion.zsh.
# Refer to that file for explanation.
if 'zmodload' 'zsh/parameter' 2>'/dev/null' && (( ${+options} )); then
  __fzf_key_bindings_options="options=(${(j: :)${(kv)options[@]}})"
else
  () {
    __fzf_key_bindings_options="setopt"
    'local' '__fzf_opt'
    for __fzf_opt in "${(@)${(@f)$(set -o)}%% *}"; do
      if [[ -o "$__fzf_opt" ]]; then
        __fzf_key_bindings_options+=" -o $__fzf_opt"
      else
        __fzf_key_bindings_options+=" +o $__fzf_opt"
      fi
    done
  }
fi

'emulate' 'zsh' '-o' 'no_aliases'

{

[[ -o interactive ]] || return 0

# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_CTRL_T_OPTS-}" $(__fzfcmd) -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

__fzfcmd() {
  [ -n "${TMUX_PANE-}" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "${FZF_TMUX_OPTS-}" ]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

fzf-file-widget() {
  LBUFFER="${LBUFFER}$(__fsel)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N            fzf-file-widget
bindkey -M emacs '^T' fzf-file-widget
bindkey -M vicmd '^T' fzf-file-widget
bindkey -M viins '^T' fzf-file-widget

# ALT-C - cd into the selected directory
fzf-cd-widget() {
  local cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_ALT_C_OPTS-}" $(__fzfcmd) +m)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="builtin cd -- ${(q)dir}"
  zle accept-line
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}
zle     -N             fzf-cd-widget
bindkey -M emacs '\ec' fzf-cd-widget
bindkey -M vicmd '\ec' fzf-cd-widget
bindkey -M viins '\ec' fzf-cd-widget

# CTRL-R - Paste the selected command from history into the command line
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
zle     -N            fzf-history-widget
bindkey -M emacs '^R' fzf-history-widget
bindkey -M vicmd '^R' fzf-history-widget
bindkey -M viins '^R' fzf-history-widget

} always {
  eval $__fzf_key_bindings_options
  'unset' '__fzf_key_bindings_options'
}
./src/LICENSE	[[[1
21
The MIT License (MIT)

Copyright (c) 2013-2023 Junegunn Choi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
./src/algo/algo.go	[[[1
946
package algo

/*

Algorithm
---------

FuzzyMatchV1 finds the first "fuzzy" occurrence of the pattern within the given
text in O(n) time where n is the length of the text. Once the position of the
last character is located, it traverses backwards to see if there's a shorter
substring that matches the pattern.

    a_____b___abc__  To find "abc"
    *-----*-----*>   1. Forward scan
             <***    2. Backward scan

The algorithm is simple and fast, but as it only sees the first occurrence,
it is not guaranteed to find the occurrence with the highest score.

    a_____b__c__abc
    *-----*--*  ***

FuzzyMatchV2 implements a modified version of Smith-Waterman algorithm to find
the optimal solution (highest score) according to the scoring criteria. Unlike
the original algorithm, omission or mismatch of a character in the pattern is
not allowed.

Performance
-----------

The new V2 algorithm is slower than V1 as it examines all occurrences of the
pattern instead of stopping immediately after finding the first one. The time
complexity of the algorithm is O(nm) if a match is found and O(n) otherwise
where n is the length of the item and m is the length of the pattern. Thus, the
performance overhead may not be noticeable for a query with high selectivity.
However, if the performance is more important than the quality of the result,
you can still choose v1 algorithm with --algo=v1.

Scoring criteria
----------------

- We prefer matches at special positions, such as the start of a word, or
  uppercase character in camelCase words.

- That is, we prefer an occurrence of the pattern with more characters
  matching at special positions, even if the total match length is longer.
    e.g. "fuzzyfinder" vs. "fuzzy-finder" on "ff"
                            ````````````
- Also, if the first character in the pattern appears at one of the special
  positions, the bonus point for the position is multiplied by a constant
  as it is extremely likely that the first character in the typed pattern
  has more significance than the rest.
    e.g. "fo-bar" vs. "foob-r" on "br"
          ``````
- But since fzf is still a fuzzy finder, not an acronym finder, we should also
  consider the total length of the matched substring. This is why we have the
  gap penalty. The gap penalty increases as the length of the gap (distance
  between the matching characters) increases, so the effect of the bonus is
  eventually cancelled at some point.
    e.g. "fuzzyfinder" vs. "fuzzy-blurry-finder" on "ff"
          ```````````
- Consequently, it is crucial to find the right balance between the bonus
  and the gap penalty. The parameters were chosen that the bonus is cancelled
  when the gap size increases beyond 8 characters.

- The bonus mechanism can have the undesirable side effect where consecutive
  matches are ranked lower than the ones with gaps.
    e.g. "foobar" vs. "foo-bar" on "foob"
                       ```````
- To correct this anomaly, we also give extra bonus point to each character
  in a consecutive matching chunk.
    e.g. "foobar" vs. "foo-bar" on "foob"
          ``````
- The amount of consecutive bonus is primarily determined by the bonus of the
  first character in the chunk.
    e.g. "foobar" vs. "out-of-bound" on "oob"
                       ````````````
*/

import (
	"bytes"
	"fmt"
	"os"
	"strings"
	"unicode"
	"unicode/utf8"

	"github.com/junegunn/fzf/src/util"
)

var DEBUG bool

var delimiterChars = "/,:;|"

const whiteChars = " \t\n\v\f\r\x85\xA0"

func indexAt(index int, max int, forward bool) int {
	if forward {
		return index
	}
	return max - index - 1
}

// Result contains the results of running a match function.
type Result struct {
	// TODO int32 should suffice
	Start int
	End   int
	Score int
}

const (
	scoreMatch        = 16
	scoreGapStart     = -3
	scoreGapExtension = -1

	// We prefer matches at the beginning of a word, but the bonus should not be
	// too great to prevent the longer acronym matches from always winning over
	// shorter fuzzy matches. The bonus point here was specifically chosen that
	// the bonus is cancelled when the gap between the acronyms grows over
	// 8 characters, which is approximately the average length of the words found
	// in web2 dictionary and my file system.
	bonusBoundary = scoreMatch / 2

	// Although bonus point for non-word characters is non-contextual, we need it
	// for computing bonus points for consecutive chunks starting with a non-word
	// character.
	bonusNonWord = scoreMatch / 2

	// Edge-triggered bonus for matches in camelCase words.
	// Compared to word-boundary case, they don't accompany single-character gaps
	// (e.g. FooBar vs. foo-bar), so we deduct bonus point accordingly.
	bonusCamel123 = bonusBoundary + scoreGapExtension

	// Minimum bonus point given to characters in consecutive chunks.
	// Note that bonus points for consecutive matches shouldn't have needed if we
	// used fixed match score as in the original algorithm.
	bonusConsecutive = -(scoreGapStart + scoreGapExtension)

	// The first character in the typed pattern usually has more significance
	// than the rest so it's important that it appears at special positions where
	// bonus points are given, e.g. "to-go" vs. "ongoing" on "og" or on "ogo".
	// The amount of the extra bonus should be limited so that the gap penalty is
	// still respected.
	bonusFirstCharMultiplier = 2
)

var (
	// Extra bonus for word boundary after whitespace character or beginning of the string
	bonusBoundaryWhite int16 = bonusBoundary + 2

	// Extra bonus for word boundary after slash, colon, semi-colon, and comma
	bonusBoundaryDelimiter int16 = bonusBoundary + 1

	initialCharClass charClass = charWhite
)

type charClass int

const (
	charWhite charClass = iota
	charNonWord
	charDelimiter
	charLower
	charUpper
	charLetter
	charNumber
)

func Init(scheme string) bool {
	switch scheme {
	case "default":
		bonusBoundaryWhite = bonusBoundary + 2
		bonusBoundaryDelimiter = bonusBoundary + 1
	case "path":
		bonusBoundaryWhite = bonusBoundary
		bonusBoundaryDelimiter = bonusBoundary + 1
		if os.PathSeparator == '/' {
			delimiterChars = "/"
		} else {
			delimiterChars = string([]rune{os.PathSeparator, '/'})
		}
		initialCharClass = charDelimiter
	case "history":
		bonusBoundaryWhite = bonusBoundary
		bonusBoundaryDelimiter = bonusBoundary
	default:
		return false
	}
	return true
}

func posArray(withPos bool, len int) *[]int {
	if withPos {
		pos := make([]int, 0, len)
		return &pos
	}
	return nil
}

func alloc16(offset int, slab *util.Slab, size int) (int, []int16) {
	if slab != nil && cap(slab.I16) > offset+size {
		slice := slab.I16[offset : offset+size]
		return offset + size, slice
	}
	return offset, make([]int16, size)
}

func alloc32(offset int, slab *util.Slab, size int) (int, []int32) {
	if slab != nil && cap(slab.I32) > offset+size {
		slice := slab.I32[offset : offset+size]
		return offset + size, slice
	}
	return offset, make([]int32, size)
}

func charClassOfAscii(char rune) charClass {
	if char >= 'a' && char <= 'z' {
		return charLower
	} else if char >= 'A' && char <= 'Z' {
		return charUpper
	} else if char >= '0' && char <= '9' {
		return charNumber
	} else if strings.ContainsRune(whiteChars, char) {
		return charWhite
	} else if strings.ContainsRune(delimiterChars, char) {
		return charDelimiter
	}
	return charNonWord
}

func charClassOfNonAscii(char rune) charClass {
	if unicode.IsLower(char) {
		return charLower
	} else if unicode.IsUpper(char) {
		return charUpper
	} else if unicode.IsNumber(char) {
		return charNumber
	} else if unicode.IsLetter(char) {
		return charLetter
	} else if unicode.IsSpace(char) {
		return charWhite
	} else if strings.ContainsRune(delimiterChars, char) {
		return charDelimiter
	}
	return charNonWord
}

func charClassOf(char rune) charClass {
	if char <= unicode.MaxASCII {
		return charClassOfAscii(char)
	}
	return charClassOfNonAscii(char)
}

func bonusFor(prevClass charClass, class charClass) int16 {
	if class > charNonWord {
		if prevClass == charWhite {
			// Word boundary after whitespace
			return bonusBoundaryWhite
		} else if prevClass == charDelimiter {
			// Word boundary after a delimiter character
			return bonusBoundaryDelimiter
		} else if prevClass == charNonWord {
			// Word boundary
			return bonusBoundary
		}
	}
	if prevClass == charLower && class == charUpper ||
		prevClass != charNumber && class == charNumber {
		// camelCase letter123
		return bonusCamel123
	} else if class == charNonWord {
		return bonusNonWord
	} else if class == charWhite {
		return bonusBoundaryWhite
	}
	return 0
}

func bonusAt(input *util.Chars, idx int) int16 {
	if idx == 0 {
		return bonusBoundaryWhite
	}
	return bonusFor(charClassOf(input.Get(idx-1)), charClassOf(input.Get(idx)))
}

func normalizeRune(r rune) rune {
	if r < 0x00C0 || r > 0x2184 {
		return r
	}

	n := normalized[r]
	if n > 0 {
		return n
	}
	return r
}

// Algo functions make two assumptions
// 1. "pattern" is given in lowercase if "caseSensitive" is false
// 2. "pattern" is already normalized if "normalize" is true
type Algo func(caseSensitive bool, normalize bool, forward bool, input *util.Chars, pattern []rune, withPos bool, slab *util.Slab) (Result, *[]int)

func trySkip(input *util.Chars, caseSensitive bool, b byte, from int) int {
	byteArray := input.Bytes()[from:]
	idx := bytes.IndexByte(byteArray, b)
	if idx == 0 {
		// Can't skip any further
		return from
	}
	// We may need to search for the uppercase letter again. We don't have to
	// consider normalization as we can be sure that this is an ASCII string.
	if !caseSensitive && b >= 'a' && b <= 'z' {
		if idx > 0 {
			byteArray = byteArray[:idx]
		}
		uidx := bytes.IndexByte(byteArray, b-32)
		if uidx >= 0 {
			idx = uidx
		}
	}
	if idx < 0 {
		return -1
	}
	return from + idx
}

func isAscii(runes []rune) bool {
	for _, r := range runes {
		if r >= utf8.RuneSelf {
			return false
		}
	}
	return true
}

func asciiFuzzyIndex(input *util.Chars, pattern []rune, caseSensitive bool) int {
	// Can't determine
	if !input.IsBytes() {
		return 0
	}

	// Not possible
	if !isAscii(pattern) {
		return -1
	}

	firstIdx, idx := 0, 0
	for pidx := 0; pidx < len(pattern); pidx++ {
		idx = trySkip(input, caseSensitive, byte(pattern[pidx]), idx)
		if idx < 0 {
			return -1
		}
		if pidx == 0 && idx > 0 {
			// Step back to find the right bonus point
			firstIdx = idx - 1
		}
		idx++
	}
	return firstIdx
}

func debugV2(T []rune, pattern []rune, F []int32, lastIdx int, H []int16, C []int16) {
	width := lastIdx - int(F[0]) + 1

	for i, f := range F {
		I := i * width
		if i == 0 {
			fmt.Print("  ")
			for j := int(f); j <= lastIdx; j++ {
				fmt.Printf(" " + string(T[j]) + " ")
			}
			fmt.Println()
		}
		fmt.Print(string(pattern[i]) + " ")
		for idx := int(F[0]); idx < int(f); idx++ {
			fmt.Print(" 0 ")
		}
		for idx := int(f); idx <= lastIdx; idx++ {
			fmt.Printf("%2d ", H[i*width+idx-int(F[0])])
		}
		fmt.Println()

		fmt.Print("  ")
		for idx, p := range C[I : I+width] {
			if idx+int(F[0]) < int(F[i]) {
				p = 0
			}
			if p > 0 {
				fmt.Printf("%2d ", p)
			} else {
				fmt.Print("   ")
			}
		}
		fmt.Println()
	}
}

func FuzzyMatchV2(caseSensitive bool, normalize bool, forward bool, input *util.Chars, pattern []rune, withPos bool, slab *util.Slab) (Result, *[]int) {
	// Assume that pattern is given in lowercase if case-insensitive.
	// First check if there's a match and calculate bonus for each position.
	// If the input string is too long, consider finding the matching chars in
	// this phase as well (non-optimal alignment).
	M := len(pattern)
	if M == 0 {
		return Result{0, 0, 0}, posArray(withPos, M)
	}
	N := input.Length()

	// Since O(nm) algorithm can be prohibitively expensive for large input,
	// we fall back to the greedy algorithm.
	if slab != nil && N*M > cap(slab.I16) {
		return FuzzyMatchV1(caseSensitive, normalize, forward, input, pattern, withPos, slab)
	}

	// Phase 1. Optimized search for ASCII string
	idx := asciiFuzzyIndex(input, pattern, caseSensitive)
	if idx < 0 {
		return Result{-1, -1, 0}, nil
	}

	// Reuse pre-allocated integer slice to avoid unnecessary sweeping of garbages
	offset16 := 0
	offset32 := 0
	offset16, H0 := alloc16(offset16, slab, N)
	offset16, C0 := alloc16(offset16, slab, N)
	// Bonus point for each position
	offset16, B := alloc16(offset16, slab, N)
	// The first occurrence of each character in the pattern
	offset32, F := alloc32(offset32, slab, M)
	// Rune array
	_, T := alloc32(offset32, slab, N)
	input.CopyRunes(T)

	// Phase 2. Calculate bonus for each point
	maxScore, maxScorePos := int16(0), 0
	pidx, lastIdx := 0, 0
	pchar0, pchar, prevH0, prevClass, inGap := pattern[0], pattern[0], int16(0), initialCharClass, false
	Tsub := T[idx:]
	H0sub, C0sub, Bsub := H0[idx:][:len(Tsub)], C0[idx:][:len(Tsub)], B[idx:][:len(Tsub)]
	for off, char := range Tsub {
		var class charClass
		if char <= unicode.MaxASCII {
			class = charClassOfAscii(char)
			if !caseSensitive && class == charUpper {
				char += 32
			}
		} else {
			class = charClassOfNonAscii(char)
			if !caseSensitive && class == charUpper {
				char = unicode.To(unicode.LowerCase, char)
			}
			if normalize {
				char = normalizeRune(char)
			}
		}

		Tsub[off] = char
		bonus := bonusFor(prevClass, class)
		Bsub[off] = bonus
		prevClass = class

		if char == pchar {
			if pidx < M {
				F[pidx] = int32(idx + off)
				pidx++
				pchar = pattern[util.Min(pidx, M-1)]
			}
			lastIdx = idx + off
		}

		if char == pchar0 {
			score := scoreMatch + bonus*bonusFirstCharMultiplier
			H0sub[off] = score
			C0sub[off] = 1
			if M == 1 && (forward && score > maxScore || !forward && score >= maxScore) {
				maxScore, maxScorePos = score, idx+off
				if forward && bonus >= bonusBoundary {
					break
				}
			}
			inGap = false
		} else {
			if inGap {
				H0sub[off] = util.Max16(prevH0+scoreGapExtension, 0)
			} else {
				H0sub[off] = util.Max16(prevH0+scoreGapStart, 0)
			}
			C0sub[off] = 0
			inGap = true
		}
		prevH0 = H0sub[off]
	}
	if pidx != M {
		return Result{-1, -1, 0}, nil
	}
	if M == 1 {
		result := Result{maxScorePos, maxScorePos + 1, int(maxScore)}
		if !withPos {
			return result, nil
		}
		pos := []int{maxScorePos}
		return result, &pos
	}

	// Phase 3. Fill in score matrix (H)
	// Unlike the original algorithm, we do not allow omission.
	f0 := int(F[0])
	width := lastIdx - f0 + 1
	offset16, H := alloc16(offset16, slab, width*M)
	copy(H, H0[f0:lastIdx+1])

	// Possible length of consecutive chunk at each position.
	_, C := alloc16(offset16, slab, width*M)
	copy(C, C0[f0:lastIdx+1])

	Fsub := F[1:]
	Psub := pattern[1:][:len(Fsub)]
	for off, f := range Fsub {
		f := int(f)
		pchar := Psub[off]
		pidx := off + 1
		row := pidx * width
		inGap := false
		Tsub := T[f : lastIdx+1]
		Bsub := B[f:][:len(Tsub)]
		Csub := C[row+f-f0:][:len(Tsub)]
		Cdiag := C[row+f-f0-1-width:][:len(Tsub)]
		Hsub := H[row+f-f0:][:len(Tsub)]
		Hdiag := H[row+f-f0-1-width:][:len(Tsub)]
		Hleft := H[row+f-f0-1:][:len(Tsub)]
		Hleft[0] = 0
		for off, char := range Tsub {
			col := off + f
			var s1, s2, consecutive int16

			if inGap {
				s2 = Hleft[off] + scoreGapExtension
			} else {
				s2 = Hleft[off] + scoreGapStart
			}

			if pchar == char {
				s1 = Hdiag[off] + scoreMatch
				b := Bsub[off]
				consecutive = Cdiag[off] + 1
				if consecutive > 1 {
					fb := B[col-int(consecutive)+1]
					// Break consecutive chunk
					if b >= bonusBoundary && b > fb {
						consecutive = 1
					} else {
						b = util.Max16(b, util.Max16(bonusConsecutive, fb))
					}
				}
				if s1+b < s2 {
					s1 += Bsub[off]
					consecutive = 0
				} else {
					s1 += b
				}
			}
			Csub[off] = consecutive

			inGap = s1 < s2
			score := util.Max16(util.Max16(s1, s2), 0)
			if pidx == M-1 && (forward && score > maxScore || !forward && score >= maxScore) {
				maxScore, maxScorePos = score, col
			}
			Hsub[off] = score
		}
	}

	if DEBUG {
		debugV2(T, pattern, F, lastIdx, H, C)
	}

	// Phase 4. (Optional) Backtrace to find character positions
	pos := posArray(withPos, M)
	j := f0
	if withPos {
		i := M - 1
		j = maxScorePos
		preferMatch := true
		for {
			I := i * width
			j0 := j - f0
			s := H[I+j0]

			var s1, s2 int16
			if i > 0 && j >= int(F[i]) {
				s1 = H[I-width+j0-1]
			}
			if j > int(F[i]) {
				s2 = H[I+j0-1]
			}

			if s > s1 && (s > s2 || s == s2 && preferMatch) {
				*pos = append(*pos, j)
				if i == 0 {
					break
				}
				i--
			}
			preferMatch = C[I+j0] > 1 || I+width+j0+1 < len(C) && C[I+width+j0+1] > 0
			j--
		}
	}
	// Start offset we return here is only relevant when begin tiebreak is used.
	// However finding the accurate offset requires backtracking, and we don't
	// want to pay extra cost for the option that has lost its importance.
	return Result{j, maxScorePos + 1, int(maxScore)}, pos
}

// Implement the same sorting criteria as V2
func calculateScore(caseSensitive bool, normalize bool, text *util.Chars, pattern []rune, sidx int, eidx int, withPos bool) (int, *[]int) {
	pidx, score, inGap, consecutive, firstBonus := 0, 0, false, 0, int16(0)
	pos := posArray(withPos, len(pattern))
	prevClass := initialCharClass
	if sidx > 0 {
		prevClass = charClassOf(text.Get(sidx - 1))
	}
	for idx := sidx; idx < eidx; idx++ {
		char := text.Get(idx)
		class := charClassOf(char)
		if !caseSensitive {
			if char >= 'A' && char <= 'Z' {
				char += 32
			} else if char > unicode.MaxASCII {
				char = unicode.To(unicode.LowerCase, char)
			}
		}
		// pattern is already normalized
		if normalize {
			char = normalizeRune(char)
		}
		if char == pattern[pidx] {
			if withPos {
				*pos = append(*pos, idx)
			}
			score += scoreMatch
			bonus := bonusFor(prevClass, class)
			if consecutive == 0 {
				firstBonus = bonus
			} else {
				// Break consecutive chunk
				if bonus >= bonusBoundary && bonus > firstBonus {
					firstBonus = bonus
				}
				bonus = util.Max16(util.Max16(bonus, firstBonus), bonusConsecutive)
			}
			if pidx == 0 {
				score += int(bonus * bonusFirstCharMultiplier)
			} else {
				score += int(bonus)
			}
			inGap = false
			consecutive++
			pidx++
		} else {
			if inGap {
				score += scoreGapExtension
			} else {
				score += scoreGapStart
			}
			inGap = true
			consecutive = 0
			firstBonus = 0
		}
		prevClass = class
	}
	return score, pos
}

// FuzzyMatchV1 performs fuzzy-match
func FuzzyMatchV1(caseSensitive bool, normalize bool, forward bool, text *util.Chars, pattern []rune, withPos bool, slab *util.Slab) (Result, *[]int) {
	if len(pattern) == 0 {
		return Result{0, 0, 0}, nil
	}
	if asciiFuzzyIndex(text, pattern, caseSensitive) < 0 {
		return Result{-1, -1, 0}, nil
	}

	pidx := 0
	sidx := -1
	eidx := -1

	lenRunes := text.Length()
	lenPattern := len(pattern)

	for index := 0; index < lenRunes; index++ {
		char := text.Get(indexAt(index, lenRunes, forward))
		// This is considerably faster than blindly applying strings.ToLower to the
		// whole string
		if !caseSensitive {
			// Partially inlining `unicode.ToLower`. Ugly, but makes a noticeable
			// difference in CPU cost. (Measured on Go 1.4.1. Also note that the Go
			// compiler as of now does not inline non-leaf functions.)
			if char >= 'A' && char <= 'Z' {
				char += 32
			} else if char > unicode.MaxASCII {
				char = unicode.To(unicode.LowerCase, char)
			}
		}
		if normalize {
			char = normalizeRune(char)
		}
		pchar := pattern[indexAt(pidx, lenPattern, forward)]
		if char == pchar {
			if sidx < 0 {
				sidx = index
			}
			if pidx++; pidx == lenPattern {
				eidx = index + 1
				break
			}
		}
	}

	if sidx >= 0 && eidx >= 0 {
		pidx--
		for index := eidx - 1; index >= sidx; index-- {
			tidx := indexAt(index, lenRunes, forward)
			char := text.Get(tidx)
			if !caseSensitive {
				if char >= 'A' && char <= 'Z' {
					char += 32
				} else if char > unicode.MaxASCII {
					char = unicode.To(unicode.LowerCase, char)
				}
			}

			pidx_ := indexAt(pidx, lenPattern, forward)
			pchar := pattern[pidx_]
			if char == pchar {
				if pidx--; pidx < 0 {
					sidx = index
					break
				}
			}
		}

		if !forward {
			sidx, eidx = lenRunes-eidx, lenRunes-sidx
		}

		score, pos := calculateScore(caseSensitive, normalize, text, pattern, sidx, eidx, withPos)
		return Result{sidx, eidx, score}, pos
	}
	return Result{-1, -1, 0}, nil
}

// ExactMatchNaive is a basic string searching algorithm that handles case
// sensitivity. Although naive, it still performs better than the combination
// of strings.ToLower + strings.Index for typical fzf use cases where input
// strings and patterns are not very long.
//
// Since 0.15.0, this function searches for the match with the highest
// bonus point, instead of stopping immediately after finding the first match.
// The solution is much cheaper since there is only one possible alignment of
// the pattern.
func ExactMatchNaive(caseSensitive bool, normalize bool, forward bool, text *util.Chars, pattern []rune, withPos bool, slab *util.Slab) (Result, *[]int) {
	if len(pattern) == 0 {
		return Result{0, 0, 0}, nil
	}

	lenRunes := text.Length()
	lenPattern := len(pattern)

	if lenRunes < lenPattern {
		return Result{-1, -1, 0}, nil
	}

	if asciiFuzzyIndex(text, pattern, caseSensitive) < 0 {
		return Result{-1, -1, 0}, nil
	}

	// For simplicity, only look at the bonus at the first character position
	pidx := 0
	bestPos, bonus, bestBonus := -1, int16(0), int16(-1)
	for index := 0; index < lenRunes; index++ {
		index_ := indexAt(index, lenRunes, forward)
		char := text.Get(index_)
		if !caseSensitive {
			if char >= 'A' && char <= 'Z' {
				char += 32
			} else if char > unicode.MaxASCII {
				char = unicode.To(unicode.LowerCase, char)
			}
		}
		if normalize {
			char = normalizeRune(char)
		}
		pidx_ := indexAt(pidx, lenPattern, forward)
		pchar := pattern[pidx_]
		if pchar == char {
			if pidx_ == 0 {
				bonus = bonusAt(text, index_)
			}
			pidx++
			if pidx == lenPattern {
				if bonus > bestBonus {
					bestPos, bestBonus = index, bonus
				}
				if bonus >= bonusBoundary {
					break
				}
				index -= pidx - 1
				pidx, bonus = 0, 0
			}
		} else {
			index -= pidx
			pidx, bonus = 0, 0
		}
	}
	if bestPos >= 0 {
		var sidx, eidx int
		if forward {
			sidx = bestPos - lenPattern + 1
			eidx = bestPos + 1
		} else {
			sidx = lenRunes - (bestPos + 1)
			eidx = lenRunes - (bestPos - lenPattern + 1)
		}
		score, _ := calculateScore(caseSensitive, normalize, text, pattern, sidx, eidx, false)
		return Result{sidx, eidx, score}, nil
	}
	return Result{-1, -1, 0}, nil
}

// PrefixMatch performs prefix-match
func PrefixMatch(caseSensitive bool, normalize bool, forward bool, text *util.Chars, pattern []rune, withPos bool, slab *util.Slab) (Result, *[]int) {
	if len(pattern) == 0 {
		return Result{0, 0, 0}, nil
	}

	trimmedLen := 0
	if !unicode.IsSpace(pattern[0]) {
		trimmedLen = text.LeadingWhitespaces()
	}

	if text.Length()-trimmedLen < len(pattern) {
		return Result{-1, -1, 0}, nil
	}

	for index, r := range pattern {
		char := text.Get(trimmedLen + index)
		if !caseSensitive {
			char = unicode.ToLower(char)
		}
		if normalize {
			char = normalizeRune(char)
		}
		if char != r {
			return Result{-1, -1, 0}, nil
		}
	}
	lenPattern := len(pattern)
	score, _ := calculateScore(caseSensitive, normalize, text, pattern, trimmedLen, trimmedLen+lenPattern, false)
	return Result{trimmedLen, trimmedLen + lenPattern, score}, nil
}

// SuffixMatch performs suffix-match
func SuffixMatch(caseSensitive bool, normalize bool, forward bool, text *util.Chars, pattern []rune, withPos bool, slab *util.Slab) (Result, *[]int) {
	lenRunes := text.Length()
	trimmedLen := lenRunes
	if len(pattern) == 0 || !unicode.IsSpace(pattern[len(pattern)-1]) {
		trimmedLen -= text.TrailingWhitespaces()
	}
	if len(pattern) == 0 {
		return Result{trimmedLen, trimmedLen, 0}, nil
	}
	diff := trimmedLen - len(pattern)
	if diff < 0 {
		return Result{-1, -1, 0}, nil
	}

	for index, r := range pattern {
		char := text.Get(index + diff)
		if !caseSensitive {
			char = unicode.ToLower(char)
		}
		if normalize {
			char = normalizeRune(char)
		}
		if char != r {
			return Result{-1, -1, 0}, nil
		}
	}
	lenPattern := len(pattern)
	sidx := trimmedLen - lenPattern
	eidx := trimmedLen
	score, _ := calculateScore(caseSensitive, normalize, text, pattern, sidx, eidx, false)
	return Result{sidx, eidx, score}, nil
}

// EqualMatch performs equal-match
func EqualMatch(caseSensitive bool, normalize bool, forward bool, text *util.Chars, pattern []rune, withPos bool, slab *util.Slab) (Result, *[]int) {
	lenPattern := len(pattern)
	if lenPattern == 0 {
		return Result{-1, -1, 0}, nil
	}

	// Strip leading whitespaces
	trimmedLen := 0
	if !unicode.IsSpace(pattern[0]) {
		trimmedLen = text.LeadingWhitespaces()
	}

	// Strip trailing whitespaces
	trimmedEndLen := 0
	if !unicode.IsSpace(pattern[lenPattern-1]) {
		trimmedEndLen = text.TrailingWhitespaces()
	}

	if text.Length()-trimmedLen-trimmedEndLen != lenPattern {
		return Result{-1, -1, 0}, nil
	}
	match := true
	if normalize {
		runes := text.ToRunes()
		for idx, pchar := range pattern {
			char := runes[trimmedLen+idx]
			if !caseSensitive {
				char = unicode.To(unicode.LowerCase, char)
			}
			if normalizeRune(pchar) != normalizeRune(char) {
				match = false
				break
			}
		}
	} else {
		runes := text.ToRunes()
		runesStr := string(runes[trimmedLen : len(runes)-trimmedEndLen])
		if !caseSensitive {
			runesStr = strings.ToLower(runesStr)
		}
		match = runesStr == string(pattern)
	}
	if match {
		return Result{trimmedLen, trimmedLen + lenPattern, (scoreMatch+int(bonusBoundaryWhite))*lenPattern +
			(bonusFirstCharMultiplier-1)*int(bonusBoundaryWhite)}, nil
	}
	return Result{-1, -1, 0}, nil
}
./src/algo/algo_test.go	[[[1
198
package algo

import (
	"math"
	"sort"
	"strings"
	"testing"

	"github.com/junegunn/fzf/src/util"
)

func assertMatch(t *testing.T, fun Algo, caseSensitive, forward bool, input, pattern string, sidx int, eidx int, score int) {
	assertMatch2(t, fun, caseSensitive, false, forward, input, pattern, sidx, eidx, score)
}

func assertMatch2(t *testing.T, fun Algo, caseSensitive, normalize, forward bool, input, pattern string, sidx int, eidx int, score int) {
	if !caseSensitive {
		pattern = strings.ToLower(pattern)
	}
	chars := util.ToChars([]byte(input))
	res, pos := fun(caseSensitive, normalize, forward, &chars, []rune(pattern), true, nil)
	var start, end int
	if pos == nil || len(*pos) == 0 {
		start = res.Start
		end = res.End
	} else {
		sort.Ints(*pos)
		start = (*pos)[0]
		end = (*pos)[len(*pos)-1] + 1
	}
	if start != sidx {
		t.Errorf("Invalid start index: %d (expected: %d, %s / %s)", start, sidx, input, pattern)
	}
	if end != eidx {
		t.Errorf("Invalid end index: %d (expected: %d, %s / %s)", end, eidx, input, pattern)
	}
	if res.Score != score {
		t.Errorf("Invalid score: %d (expected: %d, %s / %s)", res.Score, score, input, pattern)
	}
}

func TestFuzzyMatch(t *testing.T) {
	for _, fn := range []Algo{FuzzyMatchV1, FuzzyMatchV2} {
		for _, forward := range []bool{true, false} {
			assertMatch(t, fn, false, forward, "fooBarbaz1", "oBZ", 2, 9,
				scoreMatch*3+bonusCamel123+scoreGapStart+scoreGapExtension*3)
			assertMatch(t, fn, false, forward, "foo bar baz", "fbb", 0, 9,
				scoreMatch*3+int(bonusBoundaryWhite)*bonusFirstCharMultiplier+
					int(bonusBoundaryWhite)*2+2*scoreGapStart+4*scoreGapExtension)
			assertMatch(t, fn, false, forward, "/AutomatorDocument.icns", "rdoc", 9, 13,
				scoreMatch*4+bonusCamel123+bonusConsecutive*2)
			assertMatch(t, fn, false, forward, "/man1/zshcompctl.1", "zshc", 6, 10,
				scoreMatch*4+int(bonusBoundaryDelimiter)*bonusFirstCharMultiplier+int(bonusBoundaryDelimiter)*3)
			assertMatch(t, fn, false, forward, "/.oh-my-zsh/cache", "zshc", 8, 13,
				scoreMatch*4+bonusBoundary*bonusFirstCharMultiplier+bonusBoundary*2+scoreGapStart+int(bonusBoundaryDelimiter))
			assertMatch(t, fn, false, forward, "ab0123 456", "12356", 3, 10,
				scoreMatch*5+bonusConsecutive*3+scoreGapStart+scoreGapExtension)
			assertMatch(t, fn, false, forward, "abc123 456", "12356", 3, 10,
				scoreMatch*5+bonusCamel123*bonusFirstCharMultiplier+bonusCamel123*2+bonusConsecutive+scoreGapStart+scoreGapExtension)
			assertMatch(t, fn, false, forward, "foo/bar/baz", "fbb", 0, 9,
				scoreMatch*3+int(bonusBoundaryWhite)*bonusFirstCharMultiplier+
					int(bonusBoundaryDelimiter)*2+2*scoreGapStart+4*scoreGapExtension)
			assertMatch(t, fn, false, forward, "fooBarBaz", "fbb", 0, 7,
				scoreMatch*3+int(bonusBoundaryWhite)*bonusFirstCharMultiplier+
					bonusCamel123*2+2*scoreGapStart+2*scoreGapExtension)
			assertMatch(t, fn, false, forward, "foo barbaz", "fbb", 0, 8,
				scoreMatch*3+int(bonusBoundaryWhite)*bonusFirstCharMultiplier+int(bonusBoundaryWhite)+
					scoreGapStart*2+scoreGapExtension*3)
			assertMatch(t, fn, false, forward, "fooBar Baz", "foob", 0, 4,
				scoreMatch*4+int(bonusBoundaryWhite)*bonusFirstCharMultiplier+int(bonusBoundaryWhite)*3)
			assertMatch(t, fn, false, forward, "xFoo-Bar Baz", "foo-b", 1, 6,
				scoreMatch*5+bonusCamel123*bonusFirstCharMultiplier+bonusCamel123*2+
					bonusNonWord+bonusBoundary)

			assertMatch(t, fn, true, forward, "fooBarbaz", "oBz", 2, 9,
				scoreMatch*3+bonusCamel123+scoreGapStart+scoreGapExtension*3)
			assertMatch(t, fn, true, forward, "Foo/Bar/Baz", "FBB", 0, 9,
				scoreMatch*3+int(bonusBoundaryWhite)*bonusFirstCharMultiplier+int(bonusBoundaryDelimiter)*2+
					scoreGapStart*2+scoreGapExtension*4)
			assertMatch(t, fn, true, forward, "FooBarBaz", "FBB", 0, 7,
				scoreMatch*3+int(bonusBoundaryWhite)*bonusFirstCharMultiplier+bonusCamel123*2+
					scoreGapStart*2+scoreGapExtension*2)
			assertMatch(t, fn, true, forward, "FooBar Baz", "FooB", 0, 4,
				scoreMatch*4+int(bonusBoundaryWhite)*bonusFirstCharMultiplier+int(bonusBoundaryWhite)*2+
					util.Max(bonusCamel123, int(bonusBoundaryWhite)))

			// Consecutive bonus updated
			assertMatch(t, fn, true, forward, "foo-bar", "o-ba", 2, 6,
				scoreMatch*4+bonusBoundary*3)

			// Non-match
			assertMatch(t, fn, true, forward, "fooBarbaz", "oBZ", -1, -1, 0)
			assertMatch(t, fn, true, forward, "Foo Bar Baz", "fbb", -1, -1, 0)
			assertMatch(t, fn, true, forward, "fooBarbaz", "fooBarbazz", -1, -1, 0)
		}
	}
}

func TestFuzzyMatchBackward(t *testing.T) {
	assertMatch(t, FuzzyMatchV1, false, true, "foobar fb", "fb", 0, 4,
		scoreMatch*2+int(bonusBoundaryWhite)*bonusFirstCharMultiplier+
			scoreGapStart+scoreGapExtension)
	assertMatch(t, FuzzyMatchV1, false, false, "foobar fb", "fb", 7, 9,
		scoreMatch*2+int(bonusBoundaryWhite)*bonusFirstCharMultiplier+int(bonusBoundaryWhite))
}

func TestExactMatchNaive(t *testing.T) {
	for _, dir := range []bool{true, false} {
		assertMatch(t, ExactMatchNaive, true, dir, "fooBarbaz", "oBA", -1, -1, 0)
		assertMatch(t, ExactMatchNaive, true, dir, "fooBarbaz", "fooBarbazz", -1, -1, 0)

		assertMatch(t, ExactMatchNaive, false, dir, "fooBarbaz", "oBA", 2, 5,
			scoreMatch*3+bonusCamel123+bonusConsecutive)
		assertMatch(t, ExactMatchNaive, false, dir, "/AutomatorDocument.icns", "rdoc", 9, 13,
			scoreMatch*4+bonusCamel123+bonusConsecutive*2)
		assertMatch(t, ExactMatchNaive, false, dir, "/man1/zshcompctl.1", "zshc", 6, 10,
			scoreMatch*4+int(bonusBoundaryDelimiter)*(bonusFirstCharMultiplier+3))
		assertMatch(t, ExactMatchNaive, false, dir, "/.oh-my-zsh/cache", "zsh/c", 8, 13,
			scoreMatch*5+bonusBoundary*(bonusFirstCharMultiplier+3)+int(bonusBoundaryDelimiter))
	}
}

func TestExactMatchNaiveBackward(t *testing.T) {
	assertMatch(t, ExactMatchNaive, false, true, "foobar foob", "oo", 1, 3,
		scoreMatch*2+bonusConsecutive)
	assertMatch(t, ExactMatchNaive, false, false, "foobar foob", "oo", 8, 10,
		scoreMatch*2+bonusConsecutive)
}

func TestPrefixMatch(t *testing.T) {
	score := scoreMatch*3 + int(bonusBoundaryWhite)*bonusFirstCharMultiplier + int(bonusBoundaryWhite)*2

	for _, dir := range []bool{true, false} {
		assertMatch(t, PrefixMatch, true, dir, "fooBarbaz", "Foo", -1, -1, 0)
		assertMatch(t, PrefixMatch, false, dir, "fooBarBaz", "baz", -1, -1, 0)
		assertMatch(t, PrefixMatch, false, dir, "fooBarbaz", "Foo", 0, 3, score)
		assertMatch(t, PrefixMatch, false, dir, "foOBarBaZ", "foo", 0, 3, score)
		assertMatch(t, PrefixMatch, false, dir, "f-oBarbaz", "f-o", 0, 3, score)

		assertMatch(t, PrefixMatch, false, dir, " fooBar", "foo", 1, 4, score)
		assertMatch(t, PrefixMatch, false, dir, " fooBar", " fo", 0, 3, score)
		assertMatch(t, PrefixMatch, false, dir, "     fo", "foo", -1, -1, 0)
	}
}

func TestSuffixMatch(t *testing.T) {
	for _, dir := range []bool{true, false} {
		assertMatch(t, SuffixMatch, true, dir, "fooBarbaz", "Baz", -1, -1, 0)
		assertMatch(t, SuffixMatch, false, dir, "fooBarbaz", "Foo", -1, -1, 0)

		assertMatch(t, SuffixMatch, false, dir, "fooBarbaz", "baz", 6, 9,
			scoreMatch*3+bonusConsecutive*2)
		assertMatch(t, SuffixMatch, false, dir, "fooBarBaZ", "baz", 6, 9,
			(scoreMatch+bonusCamel123)*3+bonusCamel123*(bonusFirstCharMultiplier-1))

		// Strip trailing white space from the string
		assertMatch(t, SuffixMatch, false, dir, "fooBarbaz ", "baz", 6, 9,
			scoreMatch*3+bonusConsecutive*2)

		// Only when the pattern doesn't end with a space
		assertMatch(t, SuffixMatch, false, dir, "fooBarbaz ", "baz ", 6, 10,
			scoreMatch*4+bonusConsecutive*2+int(bonusBoundaryWhite))
	}
}

func TestEmptyPattern(t *testing.T) {
	for _, dir := range []bool{true, false} {
		assertMatch(t, FuzzyMatchV1, true, dir, "foobar", "", 0, 0, 0)
		assertMatch(t, FuzzyMatchV2, true, dir, "foobar", "", 0, 0, 0)
		assertMatch(t, ExactMatchNaive, true, dir, "foobar", "", 0, 0, 0)
		assertMatch(t, PrefixMatch, true, dir, "foobar", "", 0, 0, 0)
		assertMatch(t, SuffixMatch, true, dir, "foobar", "", 6, 6, 0)
	}
}

func TestNormalize(t *testing.T) {
	caseSensitive := false
	normalize := true
	forward := true
	test := func(input, pattern string, sidx, eidx, score int, funs ...Algo) {
		for _, fun := range funs {
			assertMatch2(t, fun, caseSensitive, normalize, forward,
				input, pattern, sidx, eidx, score)
		}
	}
	test("Só Danço Samba", "So", 0, 2, 62, FuzzyMatchV1, FuzzyMatchV2, PrefixMatch, ExactMatchNaive)
	test("Só Danço Samba", "sodc", 0, 7, 97, FuzzyMatchV1, FuzzyMatchV2)
	test("Danço", "danco", 0, 5, 140, FuzzyMatchV1, FuzzyMatchV2, PrefixMatch, SuffixMatch, ExactMatchNaive, EqualMatch)
}

func TestLongString(t *testing.T) {
	bytes := make([]byte, math.MaxUint16*2)
	for i := range bytes {
		bytes[i] = 'x'
	}
	bytes[math.MaxUint16] = 'z'
	assertMatch(t, FuzzyMatchV2, true, true, string(bytes), "zx", math.MaxUint16, math.MaxUint16+2, scoreMatch*2+bonusConsecutive)
}
./src/algo/normalize.go	[[[1
492
// Normalization of latin script letters
// Reference: http://www.unicode.org/Public/UCD/latest/ucd/Index.txt

package algo

var normalized map[rune]rune = map[rune]rune{
	0x00E1: 'a', //  WITH ACUTE, LATIN SMALL LETTER
	0x0103: 'a', //  WITH BREVE, LATIN SMALL LETTER
	0x01CE: 'a', //  WITH CARON, LATIN SMALL LETTER
	0x00E2: 'a', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x00E4: 'a', //  WITH DIAERESIS, LATIN SMALL LETTER
	0x0227: 'a', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1EA1: 'a', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x0201: 'a', //  WITH DOUBLE GRAVE, LATIN SMALL LETTER
	0x00E0: 'a', //  WITH GRAVE, LATIN SMALL LETTER
	0x1EA3: 'a', //  WITH HOOK ABOVE, LATIN SMALL LETTER
	0x0203: 'a', //  WITH INVERTED BREVE, LATIN SMALL LETTER
	0x0101: 'a', //  WITH MACRON, LATIN SMALL LETTER
	0x0105: 'a', //  WITH OGONEK, LATIN SMALL LETTER
	0x1E9A: 'a', //  WITH RIGHT HALF RING, LATIN SMALL LETTER
	0x00E5: 'a', //  WITH RING ABOVE, LATIN SMALL LETTER
	0x1E01: 'a', //  WITH RING BELOW, LATIN SMALL LETTER
	0x00E3: 'a', //  WITH TILDE, LATIN SMALL LETTER
	0x0363: 'a', // , COMBINING LATIN SMALL LETTER
	0x0250: 'a', // , LATIN SMALL LETTER TURNED
	0x1E03: 'b', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1E05: 'b', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x0253: 'b', //  WITH HOOK, LATIN SMALL LETTER
	0x1E07: 'b', //  WITH LINE BELOW, LATIN SMALL LETTER
	0x0180: 'b', //  WITH STROKE, LATIN SMALL LETTER
	0x0183: 'b', //  WITH TOPBAR, LATIN SMALL LETTER
	0x0107: 'c', //  WITH ACUTE, LATIN SMALL LETTER
	0x010D: 'c', //  WITH CARON, LATIN SMALL LETTER
	0x00E7: 'c', //  WITH CEDILLA, LATIN SMALL LETTER
	0x0109: 'c', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x0255: 'c', //  WITH CURL, LATIN SMALL LETTER
	0x010B: 'c', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x0188: 'c', //  WITH HOOK, LATIN SMALL LETTER
	0x023C: 'c', //  WITH STROKE, LATIN SMALL LETTER
	0x0368: 'c', // , COMBINING LATIN SMALL LETTER
	0x0297: 'c', // , LATIN LETTER STRETCHED
	0x2184: 'c', // , LATIN SMALL LETTER REVERSED
	0x010F: 'd', //  WITH CARON, LATIN SMALL LETTER
	0x1E11: 'd', //  WITH CEDILLA, LATIN SMALL LETTER
	0x1E13: 'd', //  WITH CIRCUMFLEX BELOW, LATIN SMALL LETTER
	0x0221: 'd', //  WITH CURL, LATIN SMALL LETTER
	0x1E0B: 'd', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1E0D: 'd', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x0257: 'd', //  WITH HOOK, LATIN SMALL LETTER
	0x1E0F: 'd', //  WITH LINE BELOW, LATIN SMALL LETTER
	0x0111: 'd', //  WITH STROKE, LATIN SMALL LETTER
	0x0256: 'd', //  WITH TAIL, LATIN SMALL LETTER
	0x018C: 'd', //  WITH TOPBAR, LATIN SMALL LETTER
	0x0369: 'd', // , COMBINING LATIN SMALL LETTER
	0x00E9: 'e', //  WITH ACUTE, LATIN SMALL LETTER
	0x0115: 'e', //  WITH BREVE, LATIN SMALL LETTER
	0x011B: 'e', //  WITH CARON, LATIN SMALL LETTER
	0x0229: 'e', //  WITH CEDILLA, LATIN SMALL LETTER
	0x1E19: 'e', //  WITH CIRCUMFLEX BELOW, LATIN SMALL LETTER
	0x00EA: 'e', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x00EB: 'e', //  WITH DIAERESIS, LATIN SMALL LETTER
	0x0117: 'e', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1EB9: 'e', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x0205: 'e', //  WITH DOUBLE GRAVE, LATIN SMALL LETTER
	0x00E8: 'e', //  WITH GRAVE, LATIN SMALL LETTER
	0x1EBB: 'e', //  WITH HOOK ABOVE, LATIN SMALL LETTER
	0x025D: 'e', //  WITH HOOK, LATIN SMALL LETTER REVERSED OPEN
	0x0207: 'e', //  WITH INVERTED BREVE, LATIN SMALL LETTER
	0x0113: 'e', //  WITH MACRON, LATIN SMALL LETTER
	0x0119: 'e', //  WITH OGONEK, LATIN SMALL LETTER
	0x0247: 'e', //  WITH STROKE, LATIN SMALL LETTER
	0x1E1B: 'e', //  WITH TILDE BELOW, LATIN SMALL LETTER
	0x1EBD: 'e', //  WITH TILDE, LATIN SMALL LETTER
	0x0364: 'e', // , COMBINING LATIN SMALL LETTER
	0x029A: 'e', // , LATIN SMALL LETTER CLOSED OPEN
	0x025E: 'e', // , LATIN SMALL LETTER CLOSED REVERSED OPEN
	0x025B: 'e', // , LATIN SMALL LETTER OPEN
	0x0258: 'e', // , LATIN SMALL LETTER REVERSED
	0x025C: 'e', // , LATIN SMALL LETTER REVERSED OPEN
	0x01DD: 'e', // , LATIN SMALL LETTER TURNED
	0x1D08: 'e', // , LATIN SMALL LETTER TURNED OPEN
	0x1E1F: 'f', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x0192: 'f', //  WITH HOOK, LATIN SMALL LETTER
	0x01F5: 'g', //  WITH ACUTE, LATIN SMALL LETTER
	0x011F: 'g', //  WITH BREVE, LATIN SMALL LETTER
	0x01E7: 'g', //  WITH CARON, LATIN SMALL LETTER
	0x0123: 'g', //  WITH CEDILLA, LATIN SMALL LETTER
	0x011D: 'g', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x0121: 'g', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x0260: 'g', //  WITH HOOK, LATIN SMALL LETTER
	0x1E21: 'g', //  WITH MACRON, LATIN SMALL LETTER
	0x01E5: 'g', //  WITH STROKE, LATIN SMALL LETTER
	0x0261: 'g', // , LATIN SMALL LETTER SCRIPT
	0x1E2B: 'h', //  WITH BREVE BELOW, LATIN SMALL LETTER
	0x021F: 'h', //  WITH CARON, LATIN SMALL LETTER
	0x1E29: 'h', //  WITH CEDILLA, LATIN SMALL LETTER
	0x0125: 'h', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x1E27: 'h', //  WITH DIAERESIS, LATIN SMALL LETTER
	0x1E23: 'h', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1E25: 'h', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x02AE: 'h', //  WITH FISHHOOK, LATIN SMALL LETTER TURNED
	0x0266: 'h', //  WITH HOOK, LATIN SMALL LETTER
	0x1E96: 'h', //  WITH LINE BELOW, LATIN SMALL LETTER
	0x0127: 'h', //  WITH STROKE, LATIN SMALL LETTER
	0x036A: 'h', // , COMBINING LATIN SMALL LETTER
	0x0265: 'h', // , LATIN SMALL LETTER TURNED
	0x2095: 'h', // , LATIN SUBSCRIPT SMALL LETTER
	0x00ED: 'i', //  WITH ACUTE, LATIN SMALL LETTER
	0x012D: 'i', //  WITH BREVE, LATIN SMALL LETTER
	0x01D0: 'i', //  WITH CARON, LATIN SMALL LETTER
	0x00EE: 'i', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x00EF: 'i', //  WITH DIAERESIS, LATIN SMALL LETTER
	0x1ECB: 'i', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x0209: 'i', //  WITH DOUBLE GRAVE, LATIN SMALL LETTER
	0x00EC: 'i', //  WITH GRAVE, LATIN SMALL LETTER
	0x1EC9: 'i', //  WITH HOOK ABOVE, LATIN SMALL LETTER
	0x020B: 'i', //  WITH INVERTED BREVE, LATIN SMALL LETTER
	0x012B: 'i', //  WITH MACRON, LATIN SMALL LETTER
	0x012F: 'i', //  WITH OGONEK, LATIN SMALL LETTER
	0x0268: 'i', //  WITH STROKE, LATIN SMALL LETTER
	0x1E2D: 'i', //  WITH TILDE BELOW, LATIN SMALL LETTER
	0x0129: 'i', //  WITH TILDE, LATIN SMALL LETTER
	0x0365: 'i', // , COMBINING LATIN SMALL LETTER
	0x0131: 'i', // , LATIN SMALL LETTER DOTLESS
	0x1D09: 'i', // , LATIN SMALL LETTER TURNED
	0x1D62: 'i', // , LATIN SUBSCRIPT SMALL LETTER
	0x2071: 'i', // , SUPERSCRIPT LATIN SMALL LETTER
	0x01F0: 'j', //  WITH CARON, LATIN SMALL LETTER
	0x0135: 'j', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x029D: 'j', //  WITH CROSSED-TAIL, LATIN SMALL LETTER
	0x0249: 'j', //  WITH STROKE, LATIN SMALL LETTER
	0x025F: 'j', //  WITH STROKE, LATIN SMALL LETTER DOTLESS
	0x0237: 'j', // , LATIN SMALL LETTER DOTLESS
	0x1E31: 'k', //  WITH ACUTE, LATIN SMALL LETTER
	0x01E9: 'k', //  WITH CARON, LATIN SMALL LETTER
	0x0137: 'k', //  WITH CEDILLA, LATIN SMALL LETTER
	0x1E33: 'k', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x0199: 'k', //  WITH HOOK, LATIN SMALL LETTER
	0x1E35: 'k', //  WITH LINE BELOW, LATIN SMALL LETTER
	0x029E: 'k', // , LATIN SMALL LETTER TURNED
	0x2096: 'k', // , LATIN SUBSCRIPT SMALL LETTER
	0x013A: 'l', //  WITH ACUTE, LATIN SMALL LETTER
	0x019A: 'l', //  WITH BAR, LATIN SMALL LETTER
	0x026C: 'l', //  WITH BELT, LATIN SMALL LETTER
	0x013E: 'l', //  WITH CARON, LATIN SMALL LETTER
	0x013C: 'l', //  WITH CEDILLA, LATIN SMALL LETTER
	0x1E3D: 'l', //  WITH CIRCUMFLEX BELOW, LATIN SMALL LETTER
	0x0234: 'l', //  WITH CURL, LATIN SMALL LETTER
	0x1E37: 'l', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x1E3B: 'l', //  WITH LINE BELOW, LATIN SMALL LETTER
	0x0140: 'l', //  WITH MIDDLE DOT, LATIN SMALL LETTER
	0x026B: 'l', //  WITH MIDDLE TILDE, LATIN SMALL LETTER
	0x026D: 'l', //  WITH RETROFLEX HOOK, LATIN SMALL LETTER
	0x0142: 'l', //  WITH STROKE, LATIN SMALL LETTER
	0x2097: 'l', // , LATIN SUBSCRIPT SMALL LETTER
	0x1E3F: 'm', //  WITH ACUTE, LATIN SMALL LETTER
	0x1E41: 'm', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1E43: 'm', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x0271: 'm', //  WITH HOOK, LATIN SMALL LETTER
	0x0270: 'm', //  WITH LONG LEG, LATIN SMALL LETTER TURNED
	0x036B: 'm', // , COMBINING LATIN SMALL LETTER
	0x1D1F: 'm', // , LATIN SMALL LETTER SIDEWAYS TURNED
	0x026F: 'm', // , LATIN SMALL LETTER TURNED
	0x2098: 'm', // , LATIN SUBSCRIPT SMALL LETTER
	0x0144: 'n', //  WITH ACUTE, LATIN SMALL LETTER
	0x0148: 'n', //  WITH CARON, LATIN SMALL LETTER
	0x0146: 'n', //  WITH CEDILLA, LATIN SMALL LETTER
	0x1E4B: 'n', //  WITH CIRCUMFLEX BELOW, LATIN SMALL LETTER
	0x0235: 'n', //  WITH CURL, LATIN SMALL LETTER
	0x1E45: 'n', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1E47: 'n', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x01F9: 'n', //  WITH GRAVE, LATIN SMALL LETTER
	0x0272: 'n', //  WITH LEFT HOOK, LATIN SMALL LETTER
	0x1E49: 'n', //  WITH LINE BELOW, LATIN SMALL LETTER
	0x019E: 'n', //  WITH LONG RIGHT LEG, LATIN SMALL LETTER
	0x0273: 'n', //  WITH RETROFLEX HOOK, LATIN SMALL LETTER
	0x00F1: 'n', //  WITH TILDE, LATIN SMALL LETTER
	0x2099: 'n', // , LATIN SUBSCRIPT SMALL LETTER
	0x00F3: 'o', //  WITH ACUTE, LATIN SMALL LETTER
	0x014F: 'o', //  WITH BREVE, LATIN SMALL LETTER
	0x01D2: 'o', //  WITH CARON, LATIN SMALL LETTER
	0x00F4: 'o', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x00F6: 'o', //  WITH DIAERESIS, LATIN SMALL LETTER
	0x022F: 'o', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1ECD: 'o', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x0151: 'o', //  WITH DOUBLE ACUTE, LATIN SMALL LETTER
	0x020D: 'o', //  WITH DOUBLE GRAVE, LATIN SMALL LETTER
	0x00F2: 'o', //  WITH GRAVE, LATIN SMALL LETTER
	0x1ECF: 'o', //  WITH HOOK ABOVE, LATIN SMALL LETTER
	0x01A1: 'o', //  WITH HORN, LATIN SMALL LETTER
	0x020F: 'o', //  WITH INVERTED BREVE, LATIN SMALL LETTER
	0x014D: 'o', //  WITH MACRON, LATIN SMALL LETTER
	0x01EB: 'o', //  WITH OGONEK, LATIN SMALL LETTER
	0x00F8: 'o', //  WITH STROKE, LATIN SMALL LETTER
	0x1D13: 'o', //  WITH STROKE, LATIN SMALL LETTER SIDEWAYS
	0x00F5: 'o', //  WITH TILDE, LATIN SMALL LETTER
	0x0366: 'o', // , COMBINING LATIN SMALL LETTER
	0x0275: 'o', // , LATIN SMALL LETTER BARRED
	0x1D17: 'o', // , LATIN SMALL LETTER BOTTOM HALF
	0x0254: 'o', // , LATIN SMALL LETTER OPEN
	0x1D11: 'o', // , LATIN SMALL LETTER SIDEWAYS
	0x1D12: 'o', // , LATIN SMALL LETTER SIDEWAYS OPEN
	0x1D16: 'o', // , LATIN SMALL LETTER TOP HALF
	0x1E55: 'p', //  WITH ACUTE, LATIN SMALL LETTER
	0x1E57: 'p', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x01A5: 'p', //  WITH HOOK, LATIN SMALL LETTER
	0x209A: 'p', // , LATIN SUBSCRIPT SMALL LETTER
	0x024B: 'q', //  WITH HOOK TAIL, LATIN SMALL LETTER
	0x02A0: 'q', //  WITH HOOK, LATIN SMALL LETTER
	0x0155: 'r', //  WITH ACUTE, LATIN SMALL LETTER
	0x0159: 'r', //  WITH CARON, LATIN SMALL LETTER
	0x0157: 'r', //  WITH CEDILLA, LATIN SMALL LETTER
	0x1E59: 'r', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1E5B: 'r', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x0211: 'r', //  WITH DOUBLE GRAVE, LATIN SMALL LETTER
	0x027E: 'r', //  WITH FISHHOOK, LATIN SMALL LETTER
	0x027F: 'r', //  WITH FISHHOOK, LATIN SMALL LETTER REVERSED
	0x027B: 'r', //  WITH HOOK, LATIN SMALL LETTER TURNED
	0x0213: 'r', //  WITH INVERTED BREVE, LATIN SMALL LETTER
	0x1E5F: 'r', //  WITH LINE BELOW, LATIN SMALL LETTER
	0x027C: 'r', //  WITH LONG LEG, LATIN SMALL LETTER
	0x027A: 'r', //  WITH LONG LEG, LATIN SMALL LETTER TURNED
	0x024D: 'r', //  WITH STROKE, LATIN SMALL LETTER
	0x027D: 'r', //  WITH TAIL, LATIN SMALL LETTER
	0x036C: 'r', // , COMBINING LATIN SMALL LETTER
	0x0279: 'r', // , LATIN SMALL LETTER TURNED
	0x1D63: 'r', // , LATIN SUBSCRIPT SMALL LETTER
	0x015B: 's', //  WITH ACUTE, LATIN SMALL LETTER
	0x0161: 's', //  WITH CARON, LATIN SMALL LETTER
	0x015F: 's', //  WITH CEDILLA, LATIN SMALL LETTER
	0x015D: 's', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x0219: 's', //  WITH COMMA BELOW, LATIN SMALL LETTER
	0x1E61: 's', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1E9B: 's', //  WITH DOT ABOVE, LATIN SMALL LETTER LONG
	0x1E63: 's', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x0282: 's', //  WITH HOOK, LATIN SMALL LETTER
	0x023F: 's', //  WITH SWASH TAIL, LATIN SMALL LETTER
	0x017F: 's', // , LATIN SMALL LETTER LONG
	0x00DF: 's', // , LATIN SMALL LETTER SHARP
	0x209B: 's', // , LATIN SUBSCRIPT SMALL LETTER
	0x0165: 't', //  WITH CARON, LATIN SMALL LETTER
	0x0163: 't', //  WITH CEDILLA, LATIN SMALL LETTER
	0x1E71: 't', //  WITH CIRCUMFLEX BELOW, LATIN SMALL LETTER
	0x021B: 't', //  WITH COMMA BELOW, LATIN SMALL LETTER
	0x0236: 't', //  WITH CURL, LATIN SMALL LETTER
	0x1E97: 't', //  WITH DIAERESIS, LATIN SMALL LETTER
	0x1E6B: 't', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1E6D: 't', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x01AD: 't', //  WITH HOOK, LATIN SMALL LETTER
	0x1E6F: 't', //  WITH LINE BELOW, LATIN SMALL LETTER
	0x01AB: 't', //  WITH PALATAL HOOK, LATIN SMALL LETTER
	0x0288: 't', //  WITH RETROFLEX HOOK, LATIN SMALL LETTER
	0x0167: 't', //  WITH STROKE, LATIN SMALL LETTER
	0x036D: 't', // , COMBINING LATIN SMALL LETTER
	0x0287: 't', // , LATIN SMALL LETTER TURNED
	0x209C: 't', // , LATIN SUBSCRIPT SMALL LETTER
	0x0289: 'u', //  BAR, LATIN SMALL LETTER
	0x00FA: 'u', //  WITH ACUTE, LATIN SMALL LETTER
	0x016D: 'u', //  WITH BREVE, LATIN SMALL LETTER
	0x01D4: 'u', //  WITH CARON, LATIN SMALL LETTER
	0x1E77: 'u', //  WITH CIRCUMFLEX BELOW, LATIN SMALL LETTER
	0x00FB: 'u', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x1E73: 'u', //  WITH DIAERESIS BELOW, LATIN SMALL LETTER
	0x00FC: 'u', //  WITH DIAERESIS, LATIN SMALL LETTER
	0x1EE5: 'u', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x0171: 'u', //  WITH DOUBLE ACUTE, LATIN SMALL LETTER
	0x0215: 'u', //  WITH DOUBLE GRAVE, LATIN SMALL LETTER
	0x00F9: 'u', //  WITH GRAVE, LATIN SMALL LETTER
	0x1EE7: 'u', //  WITH HOOK ABOVE, LATIN SMALL LETTER
	0x01B0: 'u', //  WITH HORN, LATIN SMALL LETTER
	0x0217: 'u', //  WITH INVERTED BREVE, LATIN SMALL LETTER
	0x016B: 'u', //  WITH MACRON, LATIN SMALL LETTER
	0x0173: 'u', //  WITH OGONEK, LATIN SMALL LETTER
	0x016F: 'u', //  WITH RING ABOVE, LATIN SMALL LETTER
	0x1E75: 'u', //  WITH TILDE BELOW, LATIN SMALL LETTER
	0x0169: 'u', //  WITH TILDE, LATIN SMALL LETTER
	0x0367: 'u', // , COMBINING LATIN SMALL LETTER
	0x1D1D: 'u', // , LATIN SMALL LETTER SIDEWAYS
	0x1D1E: 'u', // , LATIN SMALL LETTER SIDEWAYS DIAERESIZED
	0x1D64: 'u', // , LATIN SUBSCRIPT SMALL LETTER
	0x1E7F: 'v', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x028B: 'v', //  WITH HOOK, LATIN SMALL LETTER
	0x1E7D: 'v', //  WITH TILDE, LATIN SMALL LETTER
	0x036E: 'v', // , COMBINING LATIN SMALL LETTER
	0x028C: 'v', // , LATIN SMALL LETTER TURNED
	0x1D65: 'v', // , LATIN SUBSCRIPT SMALL LETTER
	0x1E83: 'w', //  WITH ACUTE, LATIN SMALL LETTER
	0x0175: 'w', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x1E85: 'w', //  WITH DIAERESIS, LATIN SMALL LETTER
	0x1E87: 'w', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1E89: 'w', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x1E81: 'w', //  WITH GRAVE, LATIN SMALL LETTER
	0x1E98: 'w', //  WITH RING ABOVE, LATIN SMALL LETTER
	0x028D: 'w', // , LATIN SMALL LETTER TURNED
	0x1E8D: 'x', //  WITH DIAERESIS, LATIN SMALL LETTER
	0x1E8B: 'x', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x036F: 'x', // , COMBINING LATIN SMALL LETTER
	0x00FD: 'y', //  WITH ACUTE, LATIN SMALL LETTER
	0x0177: 'y', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x00FF: 'y', //  WITH DIAERESIS, LATIN SMALL LETTER
	0x1E8F: 'y', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1EF5: 'y', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x1EF3: 'y', //  WITH GRAVE, LATIN SMALL LETTER
	0x1EF7: 'y', //  WITH HOOK ABOVE, LATIN SMALL LETTER
	0x01B4: 'y', //  WITH HOOK, LATIN SMALL LETTER
	0x0233: 'y', //  WITH MACRON, LATIN SMALL LETTER
	0x1E99: 'y', //  WITH RING ABOVE, LATIN SMALL LETTER
	0x024F: 'y', //  WITH STROKE, LATIN SMALL LETTER
	0x1EF9: 'y', //  WITH TILDE, LATIN SMALL LETTER
	0x028E: 'y', // , LATIN SMALL LETTER TURNED
	0x017A: 'z', //  WITH ACUTE, LATIN SMALL LETTER
	0x017E: 'z', //  WITH CARON, LATIN SMALL LETTER
	0x1E91: 'z', //  WITH CIRCUMFLEX, LATIN SMALL LETTER
	0x0291: 'z', //  WITH CURL, LATIN SMALL LETTER
	0x017C: 'z', //  WITH DOT ABOVE, LATIN SMALL LETTER
	0x1E93: 'z', //  WITH DOT BELOW, LATIN SMALL LETTER
	0x0225: 'z', //  WITH HOOK, LATIN SMALL LETTER
	0x1E95: 'z', //  WITH LINE BELOW, LATIN SMALL LETTER
	0x0290: 'z', //  WITH RETROFLEX HOOK, LATIN SMALL LETTER
	0x01B6: 'z', //  WITH STROKE, LATIN SMALL LETTER
	0x0240: 'z', //  WITH SWASH TAIL, LATIN SMALL LETTER
	0x0251: 'a', // , latin small letter script
	0x00C1: 'A', //  WITH ACUTE, LATIN CAPITAL LETTER
	0x00C2: 'A', //  WITH CIRCUMFLEX, LATIN CAPITAL LETTER
	0x00C4: 'A', //  WITH DIAERESIS, LATIN CAPITAL LETTER
	0x00C0: 'A', //  WITH GRAVE, LATIN CAPITAL LETTER
	0x00C5: 'A', //  WITH RING ABOVE, LATIN CAPITAL LETTER
	0x023A: 'A', //  WITH STROKE, LATIN CAPITAL LETTER
	0x00C3: 'A', //  WITH TILDE, LATIN CAPITAL LETTER
	0x1D00: 'A', // , LATIN LETTER SMALL CAPITAL
	0x0181: 'B', //  WITH HOOK, LATIN CAPITAL LETTER
	0x0243: 'B', //  WITH STROKE, LATIN CAPITAL LETTER
	0x0299: 'B', // , LATIN LETTER SMALL CAPITAL
	0x1D03: 'B', // , LATIN LETTER SMALL CAPITAL BARRED
	0x00C7: 'C', //  WITH CEDILLA, LATIN CAPITAL LETTER
	0x023B: 'C', //  WITH STROKE, LATIN CAPITAL LETTER
	0x1D04: 'C', // , LATIN LETTER SMALL CAPITAL
	0x018A: 'D', //  WITH HOOK, LATIN CAPITAL LETTER
	0x0189: 'D', // , LATIN CAPITAL LETTER AFRICAN
	0x1D05: 'D', // , LATIN LETTER SMALL CAPITAL
	0x00C9: 'E', //  WITH ACUTE, LATIN CAPITAL LETTER
	0x00CA: 'E', //  WITH CIRCUMFLEX, LATIN CAPITAL LETTER
	0x00CB: 'E', //  WITH DIAERESIS, LATIN CAPITAL LETTER
	0x00C8: 'E', //  WITH GRAVE, LATIN CAPITAL LETTER
	0x0246: 'E', //  WITH STROKE, LATIN CAPITAL LETTER
	0x0190: 'E', // , LATIN CAPITAL LETTER OPEN
	0x018E: 'E', // , LATIN CAPITAL LETTER REVERSED
	0x1D07: 'E', // , LATIN LETTER SMALL CAPITAL
	0x0193: 'G', //  WITH HOOK, LATIN CAPITAL LETTER
	0x029B: 'G', //  WITH HOOK, LATIN LETTER SMALL CAPITAL
	0x0262: 'G', // , LATIN LETTER SMALL CAPITAL
	0x029C: 'H', // , LATIN LETTER SMALL CAPITAL
	0x00CD: 'I', //  WITH ACUTE, LATIN CAPITAL LETTER
	0x00CE: 'I', //  WITH CIRCUMFLEX, LATIN CAPITAL LETTER
	0x00CF: 'I', //  WITH DIAERESIS, LATIN CAPITAL LETTER
	0x0130: 'I', //  WITH DOT ABOVE, LATIN CAPITAL LETTER
	0x00CC: 'I', //  WITH GRAVE, LATIN CAPITAL LETTER
	0x0197: 'I', //  WITH STROKE, LATIN CAPITAL LETTER
	0x026A: 'I', // , LATIN LETTER SMALL CAPITAL
	0x0248: 'J', //  WITH STROKE, LATIN CAPITAL LETTER
	0x1D0A: 'J', // , LATIN LETTER SMALL CAPITAL
	0x1D0B: 'K', // , LATIN LETTER SMALL CAPITAL
	0x023D: 'L', //  WITH BAR, LATIN CAPITAL LETTER
	0x1D0C: 'L', //  WITH STROKE, LATIN LETTER SMALL CAPITAL
	0x029F: 'L', // , LATIN LETTER SMALL CAPITAL
	0x019C: 'M', // , LATIN CAPITAL LETTER TURNED
	0x1D0D: 'M', // , LATIN LETTER SMALL CAPITAL
	0x019D: 'N', //  WITH LEFT HOOK, LATIN CAPITAL LETTER
	0x0220: 'N', //  WITH LONG RIGHT LEG, LATIN CAPITAL LETTER
	0x00D1: 'N', //  WITH TILDE, LATIN CAPITAL LETTER
	0x0274: 'N', // , LATIN LETTER SMALL CAPITAL
	0x1D0E: 'N', // , LATIN LETTER SMALL CAPITAL REVERSED
	0x00D3: 'O', //  WITH ACUTE, LATIN CAPITAL LETTER
	0x00D4: 'O', //  WITH CIRCUMFLEX, LATIN CAPITAL LETTER
	0x00D6: 'O', //  WITH DIAERESIS, LATIN CAPITAL LETTER
	0x00D2: 'O', //  WITH GRAVE, LATIN CAPITAL LETTER
	0x019F: 'O', //  WITH MIDDLE TILDE, LATIN CAPITAL LETTER
	0x00D8: 'O', //  WITH STROKE, LATIN CAPITAL LETTER
	0x00D5: 'O', //  WITH TILDE, LATIN CAPITAL LETTER
	0x0186: 'O', // , LATIN CAPITAL LETTER OPEN
	0x1D0F: 'O', // , LATIN LETTER SMALL CAPITAL
	0x1D10: 'O', // , LATIN LETTER SMALL CAPITAL OPEN
	0x1D18: 'P', // , LATIN LETTER SMALL CAPITAL
	0x024A: 'Q', //  WITH HOOK TAIL, LATIN CAPITAL LETTER SMALL
	0x024C: 'R', //  WITH STROKE, LATIN CAPITAL LETTER
	0x0280: 'R', // , LATIN LETTER SMALL CAPITAL
	0x0281: 'R', // , LATIN LETTER SMALL CAPITAL INVERTED
	0x1D19: 'R', // , LATIN LETTER SMALL CAPITAL REVERSED
	0x1D1A: 'R', // , LATIN LETTER SMALL CAPITAL TURNED
	0x023E: 'T', //  WITH DIAGONAL STROKE, LATIN CAPITAL LETTER
	0x01AE: 'T', //  WITH RETROFLEX HOOK, LATIN CAPITAL LETTER
	0x1D1B: 'T', // , LATIN LETTER SMALL CAPITAL
	0x0244: 'U', //  BAR, LATIN CAPITAL LETTER
	0x00DA: 'U', //  WITH ACUTE, LATIN CAPITAL LETTER
	0x00DB: 'U', //  WITH CIRCUMFLEX, LATIN CAPITAL LETTER
	0x00DC: 'U', //  WITH DIAERESIS, LATIN CAPITAL LETTER
	0x00D9: 'U', //  WITH GRAVE, LATIN CAPITAL LETTER
	0x1D1C: 'U', // , LATIN LETTER SMALL CAPITAL
	0x01B2: 'V', //  WITH HOOK, LATIN CAPITAL LETTER
	0x0245: 'V', // , LATIN CAPITAL LETTER TURNED
	0x1D20: 'V', // , LATIN LETTER SMALL CAPITAL
	0x1D21: 'W', // , LATIN LETTER SMALL CAPITAL
	0x00DD: 'Y', //  WITH ACUTE, LATIN CAPITAL LETTER
	0x0178: 'Y', //  WITH DIAERESIS, LATIN CAPITAL LETTER
	0x024E: 'Y', //  WITH STROKE, LATIN CAPITAL LETTER
	0x028F: 'Y', // , LATIN LETTER SMALL CAPITAL
	0x1D22: 'Z', // , LATIN LETTER SMALL CAPITAL

	'Ắ': 'A',
	'Ấ': 'A',
	'Ằ': 'A',
	'Ầ': 'A',
	'Ẳ': 'A',
	'Ẩ': 'A',
	'Ẵ': 'A',
	'Ẫ': 'A',
	'Ặ': 'A',
	'Ậ': 'A',

	'ắ': 'a',
	'ấ': 'a',
	'ằ': 'a',
	'ầ': 'a',
	'ẳ': 'a',
	'ẩ': 'a',
	'ẵ': 'a',
	'ẫ': 'a',
	'ặ': 'a',
	'ậ': 'a',

	'Ế': 'E',
	'Ề': 'E',
	'Ể': 'E',
	'Ễ': 'E',
	'Ệ': 'E',

	'ế': 'e',
	'ề': 'e',
	'ể': 'e',
	'ễ': 'e',
	'ệ': 'e',

	'Ố': 'O',
	'Ớ': 'O',
	'Ồ': 'O',
	'Ờ': 'O',
	'Ổ': 'O',
	'Ở': 'O',
	'Ỗ': 'O',
	'Ỡ': 'O',
	'Ộ': 'O',
	'Ợ': 'O',

	'ố': 'o',
	'ớ': 'o',
	'ồ': 'o',
	'ờ': 'o',
	'ổ': 'o',
	'ở': 'o',
	'ỗ': 'o',
	'ỡ': 'o',
	'ộ': 'o',
	'ợ': 'o',

	'Ứ': 'U',
	'Ừ': 'U',
	'Ử': 'U',
	'Ữ': 'U',
	'Ự': 'U',

	'ứ': 'u',
	'ừ': 'u',
	'ử': 'u',
	'ữ': 'u',
	'ự': 'u',
}

// NormalizeRunes normalizes latin script letters
func NormalizeRunes(runes []rune) []rune {
	ret := make([]rune, len(runes))
	copy(ret, runes)
	for idx, r := range runes {
		if r < 0x00C0 || r > 0x2184 {
			continue
		}
		n := normalized[r]
		if n > 0 {
			ret[idx] = normalized[r]
		}
	}
	return ret
}
./src/ansi.go	[[[1
433
package fzf

import (
	"strconv"
	"strings"
	"unicode/utf8"

	"github.com/junegunn/fzf/src/tui"
)

type ansiOffset struct {
	offset [2]int32
	color  ansiState
}

type ansiState struct {
	fg   tui.Color
	bg   tui.Color
	attr tui.Attr
	lbg  tui.Color
}

func (s *ansiState) colored() bool {
	return s.fg != -1 || s.bg != -1 || s.attr > 0 || s.lbg >= 0
}

func (s *ansiState) equals(t *ansiState) bool {
	if t == nil {
		return !s.colored()
	}
	return s.fg == t.fg && s.bg == t.bg && s.attr == t.attr && s.lbg == t.lbg
}

func (s *ansiState) ToString() string {
	if !s.colored() {
		return ""
	}

	ret := ""
	if s.attr&tui.Bold > 0 {
		ret += "1;"
	}
	if s.attr&tui.Dim > 0 {
		ret += "2;"
	}
	if s.attr&tui.Italic > 0 {
		ret += "3;"
	}
	if s.attr&tui.Underline > 0 {
		ret += "4;"
	}
	if s.attr&tui.Blink > 0 {
		ret += "5;"
	}
	if s.attr&tui.Reverse > 0 {
		ret += "7;"
	}
	if s.attr&tui.StrikeThrough > 0 {
		ret += "9;"
	}
	ret += toAnsiString(s.fg, 30) + toAnsiString(s.bg, 40)

	return "\x1b[" + strings.TrimSuffix(ret, ";") + "m"
}

func toAnsiString(color tui.Color, offset int) string {
	col := int(color)
	ret := ""
	if col == -1 {
		ret += strconv.Itoa(offset + 9)
	} else if col < 8 {
		ret += strconv.Itoa(offset + col)
	} else if col < 16 {
		ret += strconv.Itoa(offset - 30 + 90 + col - 8)
	} else if col < 256 {
		ret += strconv.Itoa(offset+8) + ";5;" + strconv.Itoa(col)
	} else if col >= (1 << 24) {
		r := strconv.Itoa((col >> 16) & 0xff)
		g := strconv.Itoa((col >> 8) & 0xff)
		b := strconv.Itoa(col & 0xff)
		ret += strconv.Itoa(offset+8) + ";2;" + r + ";" + g + ";" + b
	}
	return ret + ";"
}

func isPrint(c uint8) bool {
	return '\x20' <= c && c <= '\x7e'
}

func matchOperatingSystemCommand(s string) int {
	// `\x1b][0-9][;:][[:print:]]+(?:\x1b\\\\|\x07)`
	//                        ^ match starting here
	//
	i := 5 // prefix matched in nextAnsiEscapeSequence()
	for ; i < len(s) && isPrint(s[i]); i++ {
	}
	if i < len(s) {
		if s[i] == '\x07' {
			return i + 1
		}
		if s[i] == '\x1b' && i < len(s)-1 && s[i+1] == '\\' {
			return i + 2
		}
	}
	return -1
}

func matchControlSequence(s string) int {
	// `\x1b[\\[()][0-9;:?]*[a-zA-Z@]`
	//                     ^ match starting here
	//
	i := 2 // prefix matched in nextAnsiEscapeSequence()
	for ; i < len(s); i++ {
		c := s[i]
		switch c {
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ';', ':', '?':
			// ok
		default:
			if 'a' <= c && c <= 'z' || 'A' <= c && c <= 'Z' || c == '@' {
				return i + 1
			}
			return -1
		}
	}
	return -1
}

func isCtrlSeqStart(c uint8) bool {
	switch c {
	case '\\', '[', '(', ')':
		return true
	}
	return false
}

// nextAnsiEscapeSequence returns the ANSI escape sequence and is equivalent to
// calling FindStringIndex() on the below regex (which was originally used):
//
// "(?:\x1b[\\[()][0-9;:?]*[a-zA-Z@]|\x1b][0-9][;:][[:print:]]+(?:\x1b\\\\|\x07)|\x1b.|[\x0e\x0f]|.\x08)"
func nextAnsiEscapeSequence(s string) (int, int) {
	// fast check for ANSI escape sequences
	i := 0
	for ; i < len(s); i++ {
		switch s[i] {
		case '\x0e', '\x0f', '\x1b', '\x08':
			// We ignore the fact that '\x08' cannot be the first char
			// in the string and be an escape sequence for the sake of
			// speed and simplicity.
			goto Loop
		}
	}
	return -1, -1

Loop:
	for ; i < len(s); i++ {
		switch s[i] {
		case '\x08':
			// backtrack to match: `.\x08`
			if i > 0 && s[i-1] != '\n' {
				if s[i-1] < utf8.RuneSelf {
					return i - 1, i + 1
				}
				_, n := utf8.DecodeLastRuneInString(s[:i])
				return i - n, i + 1
			}
		case '\x1b':
			// match: `\x1b[\\[()][0-9;:?]*[a-zA-Z@]`
			if i+2 < len(s) && isCtrlSeqStart(s[i+1]) {
				if j := matchControlSequence(s[i:]); j != -1 {
					return i, i + j
				}
			}

			// match: `\x1b][0-9][;:][[:print:]]+(?:\x1b\\\\|\x07)`
			if i+5 < len(s) && s[i+1] == ']' && isNumeric(s[i+2]) &&
				(s[i+3] == ';' || s[i+3] == ':') && isPrint(s[i+4]) {

				if j := matchOperatingSystemCommand(s[i:]); j != -1 {
					return i, i + j
				}
			}

			// match: `\x1b.`
			if i+1 < len(s) && s[i+1] != '\n' {
				if s[i+1] < utf8.RuneSelf {
					return i, i + 2
				}
				_, n := utf8.DecodeRuneInString(s[i+1:])
				return i, i + n + 1
			}
		case '\x0e', '\x0f':
			// match: `[\x0e\x0f]`
			return i, i + 1
		}
	}
	return -1, -1
}

func extractColor(str string, state *ansiState, proc func(string, *ansiState) bool) (string, *[]ansiOffset, *ansiState) {
	// We append to a stack allocated variable that we'll
	// later copy and return, to save on allocations.
	offsets := make([]ansiOffset, 0, 32)

	if state != nil {
		offsets = append(offsets, ansiOffset{[2]int32{0, 0}, *state})
	}

	var (
		pstate    *ansiState // lazily allocated
		output    strings.Builder
		prevIdx   int
		runeCount int
	)
	for idx := 0; idx < len(str); {
		// Make sure that we found an ANSI code
		start, end := nextAnsiEscapeSequence(str[idx:])
		if start == -1 {
			break
		}
		start += idx
		idx += end

		// Check if we should continue
		prev := str[prevIdx:start]
		if proc != nil && !proc(prev, state) {
			return "", nil, nil
		}
		prevIdx = idx

		if len(prev) != 0 {
			runeCount += utf8.RuneCountInString(prev)
			// Grow the buffer size to the maximum possible length (string length
			// containing ansi codes) to avoid repetitive allocation
			if output.Cap() == 0 {
				output.Grow(len(str))
			}
			output.WriteString(prev)
		}

		newState := interpretCode(str[start:idx], state)
		if !newState.equals(state) {
			if state != nil {
				// Update last offset
				(&offsets[len(offsets)-1]).offset[1] = int32(runeCount)
			}

			if newState.colored() {
				// Append new offset
				if pstate == nil {
					pstate = &ansiState{}
				}
				*pstate = newState
				state = pstate
				offsets = append(offsets, ansiOffset{
					[2]int32{int32(runeCount), int32(runeCount)},
					newState,
				})
			} else {
				// Discard state
				state = nil
			}
		}
	}

	var rest string
	var trimmed string
	if prevIdx == 0 {
		// No ANSI code found
		rest = str
		trimmed = str
	} else {
		rest = str[prevIdx:]
		output.WriteString(rest)
		trimmed = output.String()
	}
	if proc != nil {
		proc(rest, state)
	}
	if len(offsets) > 0 {
		if len(rest) > 0 && state != nil {
			// Update last offset
			runeCount += utf8.RuneCountInString(rest)
			(&offsets[len(offsets)-1]).offset[1] = int32(runeCount)
		}
		// Return a copy of the offsets slice
		a := make([]ansiOffset, len(offsets))
		copy(a, offsets)
		return trimmed, &a, state
	}
	return trimmed, nil, state
}

func parseAnsiCode(s string, delimiter byte) (int, byte, string) {
	var remaining string
	i := -1
	if delimiter == 0 {
		// Faster than strings.IndexAny(";:")
		i = strings.IndexByte(s, ';')
		if i < 0 {
			i = strings.IndexByte(s, ':')
		}
	} else {
		i = strings.IndexByte(s, delimiter)
	}
	if i >= 0 {
		delimiter = s[i]
		remaining = s[i+1:]
		s = s[:i]
	}

	if len(s) > 0 {
		// Inlined version of strconv.Atoi() that only handles positive
		// integers and does not allocate on error.
		code := 0
		for _, ch := range []byte(s) {
			ch -= '0'
			if ch > 9 {
				return -1, delimiter, remaining
			}
			code = code*10 + int(ch)
		}
		return code, delimiter, remaining
	}

	return -1, delimiter, remaining
}

func interpretCode(ansiCode string, prevState *ansiState) ansiState {
	var state ansiState
	if prevState == nil {
		state = ansiState{-1, -1, 0, -1}
	} else {
		state = ansiState{prevState.fg, prevState.bg, prevState.attr, prevState.lbg}
	}
	if ansiCode[0] != '\x1b' || ansiCode[1] != '[' || ansiCode[len(ansiCode)-1] != 'm' {
		if prevState != nil && strings.HasSuffix(ansiCode, "0K") {
			state.lbg = prevState.bg
		}
		return state
	}

	if len(ansiCode) <= 3 {
		state.fg = -1
		state.bg = -1
		state.attr = 0
		return state
	}
	ansiCode = ansiCode[2 : len(ansiCode)-1]

	state256 := 0
	ptr := &state.fg

	var delimiter byte = 0
	for len(ansiCode) != 0 {
		var num int
		if num, delimiter, ansiCode = parseAnsiCode(ansiCode, delimiter); num != -1 {
			switch state256 {
			case 0:
				switch num {
				case 38:
					ptr = &state.fg
					state256++
				case 48:
					ptr = &state.bg
					state256++
				case 39:
					state.fg = -1
				case 49:
					state.bg = -1
				case 1:
					state.attr = state.attr | tui.Bold
				case 2:
					state.attr = state.attr | tui.Dim
				case 3:
					state.attr = state.attr | tui.Italic
				case 4:
					state.attr = state.attr | tui.Underline
				case 5:
					state.attr = state.attr | tui.Blink
				case 7:
					state.attr = state.attr | tui.Reverse
				case 9:
					state.attr = state.attr | tui.StrikeThrough
				case 23: // tput rmso
					state.attr = state.attr &^ tui.Italic
				case 24: // tput rmul
					state.attr = state.attr &^ tui.Underline
				case 0:
					state.fg = -1
					state.bg = -1
					state.attr = 0
					state256 = 0
				default:
					if num >= 30 && num <= 37 {
						state.fg = tui.Color(num - 30)
					} else if num >= 40 && num <= 47 {
						state.bg = tui.Color(num - 40)
					} else if num >= 90 && num <= 97 {
						state.fg = tui.Color(num - 90 + 8)
					} else if num >= 100 && num <= 107 {
						state.bg = tui.Color(num - 100 + 8)
					}
				}
			case 1:
				switch num {
				case 2:
					state256 = 10 // MAGIC
				case 5:
					state256++
				default:
					state256 = 0
				}
			case 2:
				*ptr = tui.Color(num)
				state256 = 0
			case 10:
				*ptr = tui.Color(1<<24) | tui.Color(num<<16)
				state256++
			case 11:
				*ptr = *ptr | tui.Color(num<<8)
				state256++
			case 12:
				*ptr = *ptr | tui.Color(num)
				state256 = 0
			}
		}
	}

	if state256 > 0 {
		*ptr = -1
	}
	return state
}
./src/ansi_test.go	[[[1
428
package fzf

import (
	"math/rand"
	"regexp"
	"strings"
	"testing"
	"unicode/utf8"

	"github.com/junegunn/fzf/src/tui"
)

// The following regular expression will include not all but most of the
// frequently used ANSI sequences. This regex is used as a reference for
// testing nextAnsiEscapeSequence().
//
// References:
//   - https://github.com/gnachman/iTerm2
//   - https://web.archive.org/web/20090204053813/http://ascii-table.com/ansi-escape-sequences.php
//     (archived from http://ascii-table.com/ansi-escape-sequences.php)
//   - https://web.archive.org/web/20090227051140/http://ascii-table.com/ansi-escape-sequences-vt-100.php
//     (archived from http://ascii-table.com/ansi-escape-sequences-vt-100.php)
//   - http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html
//   - https://invisible-island.net/xterm/ctlseqs/ctlseqs.html
var ansiRegexReference = regexp.MustCompile("(?:\x1b[\\[()][0-9;:]*[a-zA-Z@]|\x1b][0-9][;:][[:print:]]+(?:\x1b\\\\|\x07)|\x1b.|[\x0e\x0f]|.\x08)")

func testParserReference(t testing.TB, str string) {
	t.Helper()

	toSlice := func(start, end int) []int {
		if start == -1 {
			return nil
		}
		return []int{start, end}
	}

	s := str
	for i := 0; ; i++ {
		got := toSlice(nextAnsiEscapeSequence(s))
		exp := ansiRegexReference.FindStringIndex(s)

		equal := len(got) == len(exp)
		if equal {
			for i := 0; i < len(got); i++ {
				if got[i] != exp[i] {
					equal = false
					break
				}
			}
		}
		if !equal {
			var exps, gots []rune
			if len(got) == 2 {
				gots = []rune(s[got[0]:got[1]])
			}
			if len(exp) == 2 {
				exps = []rune(s[exp[0]:exp[1]])
			}
			t.Errorf("%d: %q: got: %v (%q) want: %v (%q)", i, s, got, gots, exp, exps)
			return
		}
		if len(exp) == 0 {
			return
		}
		s = s[exp[1]:]
	}
}

func TestNextAnsiEscapeSequence(t *testing.T) {
	testStrs := []string{
		"\x1b[0mhello world",
		"\x1b[1mhello world",
		"椙\x1b[1m椙",
		"椙\x1b[1椙m椙",
		"\x1b[1mhello \x1b[mw\x1b7o\x1b8r\x1b(Bl\x1b[2@d",
		"\x1b[1mhello \x1b[Kworld",
		"hello \x1b[34;45;1mworld",
		"hello \x1b[34;45;1mwor\x1b[34;45;1mld",
		"hello \x1b[34;45;1mwor\x1b[0mld",
		"hello \x1b[34;48;5;233;1mwo\x1b[38;5;161mr\x1b[0ml\x1b[38;5;161md",
		"hello \x1b[38;5;38;48;5;48;1mwor\x1b[38;5;48;48;5;38ml\x1b[0md",
		"hello \x1b[32;1mworld",
		"hello world",
		"hello \x1b[0;38;5;200;48;5;100mworld",
		"\x1b椙",
		"椙\x08",
		"\n\x08",
		"X\x08",
		"",
		"\x1b]4;3;rgb:aa/bb/cc\x07 ",
		"\x1b]4;3;rgb:aa/bb/cc\x1b\\ ",
		ansiBenchmarkString,
	}

	for _, s := range testStrs {
		testParserReference(t, s)
	}
}

func TestNextAnsiEscapeSequence_Fuzz_Modified(t *testing.T) {
	t.Parallel()
	if testing.Short() {
		t.Skip("short test")
	}

	testStrs := []string{
		"\x1b[0mhello world",
		"\x1b[1mhello world",
		"椙\x1b[1m椙",
		"椙\x1b[1椙m椙",
		"\x1b[1mhello \x1b[mw\x1b7o\x1b8r\x1b(Bl\x1b[2@d",
		"\x1b[1mhello \x1b[Kworld",
		"hello \x1b[34;45;1mworld",
		"hello \x1b[34;45;1mwor\x1b[34;45;1mld",
		"hello \x1b[34;45;1mwor\x1b[0mld",
		"hello \x1b[34;48;5;233;1mwo\x1b[38;5;161mr\x1b[0ml\x1b[38;5;161md",
		"hello \x1b[38;5;38;48;5;48;1mwor\x1b[38;5;48;48;5;38ml\x1b[0md",
		"hello \x1b[32;1mworld",
		"hello world",
		"hello \x1b[0;38;5;200;48;5;100mworld",
		ansiBenchmarkString,
	}

	replacementBytes := [...]rune{'\x0e', '\x0f', '\x1b', '\x08'}

	modifyString := func(s string, rr *rand.Rand) string {
		n := rr.Intn(len(s))
		b := []rune(s)
		for ; n >= 0 && len(b) != 0; n-- {
			i := rr.Intn(len(b))
			switch x := rr.Intn(4); x {
			case 0:
				b = append(b[:i], b[i+1:]...)
			case 1:
				j := rr.Intn(len(replacementBytes) - 1)
				b[i] = replacementBytes[j]
			case 2:
				x := rune(rr.Intn(utf8.MaxRune))
				for !utf8.ValidRune(x) {
					x = rune(rr.Intn(utf8.MaxRune))
				}
				b[i] = x
			case 3:
				b[i] = rune(rr.Intn(utf8.MaxRune)) // potentially invalid
			default:
				t.Fatalf("unsupported value: %d", x)
			}
		}
		return string(b)
	}

	rr := rand.New(rand.NewSource(1))
	for _, s := range testStrs {
		for i := 1_000; i >= 0; i-- {
			testParserReference(t, modifyString(s, rr))
		}
	}
}

func TestNextAnsiEscapeSequence_Fuzz_Random(t *testing.T) {
	t.Parallel()

	if testing.Short() {
		t.Skip("short test")
	}

	randomString := func(rr *rand.Rand) string {
		numChars := rand.Intn(50)
		codePoints := make([]rune, numChars)
		for i := 0; i < len(codePoints); i++ {
			var r rune
			for n := 0; n < 1000; n++ {
				r = rune(rr.Intn(utf8.MaxRune))
				// Allow 10% of runes to be invalid
				if utf8.ValidRune(r) || rr.Float64() < 0.10 {
					break
				}
			}
			codePoints[i] = r
		}
		return string(codePoints)
	}

	rr := rand.New(rand.NewSource(1))
	for i := 0; i < 100_000; i++ {
		testParserReference(t, randomString(rr))
	}
}

func TestExtractColor(t *testing.T) {
	assert := func(offset ansiOffset, b int32, e int32, fg tui.Color, bg tui.Color, bold bool) {
		var attr tui.Attr
		if bold {
			attr = tui.Bold
		}
		if offset.offset[0] != b || offset.offset[1] != e ||
			offset.color.fg != fg || offset.color.bg != bg || offset.color.attr != attr {
			t.Error(offset, b, e, fg, bg, attr)
		}
	}

	src := "hello world"
	var state *ansiState
	clean := "\x1b[0m"
	check := func(assertion func(ansiOffsets *[]ansiOffset, state *ansiState)) {
		output, ansiOffsets, newState := extractColor(src, state, nil)
		state = newState
		if output != "hello world" {
			t.Errorf("Invalid output: %s %v", output, []rune(output))
		}
		t.Log(src, ansiOffsets, clean)
		assertion(ansiOffsets, state)
	}

	check(func(offsets *[]ansiOffset, state *ansiState) {
		if offsets != nil {
			t.Fail()
		}
	})

	state = nil
	src = "\x1b[0mhello world"
	check(func(offsets *[]ansiOffset, state *ansiState) {
		if offsets != nil {
			t.Fail()
		}
	})

	state = nil
	src = "\x1b[1mhello world"
	check(func(offsets *[]ansiOffset, state *ansiState) {
		if len(*offsets) != 1 {
			t.Fail()
		}
		assert((*offsets)[0], 0, 11, -1, -1, true)
	})

	state = nil
	src = "\x1b[1mhello \x1b[mw\x1b7o\x1b8r\x1b(Bl\x1b[2@d"
	check(func(offsets *[]ansiOffset, state *ansiState) {
		if len(*offsets) != 1 {
			t.Fail()
		}
		assert((*offsets)[0], 0, 6, -1, -1, true)
	})

	state = nil
	src = "\x1b[1mhello \x1b[Kworld"
	check(func(offsets *[]ansiOffset, state *ansiState) {
		if len(*offsets) != 1 {
			t.Fail()
		}
		assert((*offsets)[0], 0, 11, -1, -1, true)
	})

	state = nil
	src = "hello \x1b[34;45;1mworld"
	check(func(offsets *[]ansiOffset, state *ansiState) {
		if len(*offsets) != 1 {
			t.Fail()
		}
		assert((*offsets)[0], 6, 11, 4, 5, true)
	})

	state = nil
	src = "hello \x1b[34;45;1mwor\x1b[34;45;1mld"
	check(func(offsets *[]ansiOffset, state *ansiState) {
		if len(*offsets) != 1 {
			t.Fail()
		}
		assert((*offsets)[0], 6, 11, 4, 5, true)
	})

	state = nil
	src = "hello \x1b[34;45;1mwor\x1b[0mld"
	check(func(offsets *[]ansiOffset, state *ansiState) {
		if len(*offsets) != 1 {
			t.Fail()
		}
		assert((*offsets)[0], 6, 9, 4, 5, true)
	})

	state = nil
	src = "hello \x1b[34;48;5;233;1mwo\x1b[38;5;161mr\x1b[0ml\x1b[38;5;161md"
	check(func(offsets *[]ansiOffset, state *ansiState) {
		if len(*offsets) != 3 {
			t.Fail()
		}
		assert((*offsets)[0], 6, 8, 4, 233, true)
		assert((*offsets)[1], 8, 9, 161, 233, true)
		assert((*offsets)[2], 10, 11, 161, -1, false)
	})

	// {38,48};5;{38,48}
	state = nil
	src = "hello \x1b[38;5;38;48;5;48;1mwor\x1b[38;5;48;48;5;38ml\x1b[0md"
	check(func(offsets *[]ansiOffset, state *ansiState) {
		if len(*offsets) != 2 {
			t.Fail()
		}
		assert((*offsets)[0], 6, 9, 38, 48, true)
		assert((*offsets)[1], 9, 10, 48, 38, true)
	})

	src = "hello \x1b[32;1mworld"
	check(func(offsets *[]ansiOffset, state *ansiState) {
		if len(*offsets) != 1 {
			t.Fail()
		}
		if state.fg != 2 || state.bg != -1 || state.attr == 0 {
			t.Fail()
		}
		assert((*offsets)[0], 6, 11, 2, -1, true)
	})

	src = "hello world"
	check(func(offsets *[]ansiOffset, state *ansiState) {
		if len(*offsets) != 1 {
			t.Fail()
		}
		if state.fg != 2 || state.bg != -1 || state.attr == 0 {
			t.Fail()
		}
		assert((*offsets)[0], 0, 11, 2, -1, true)
	})

	src = "hello \x1b[0;38;5;200;48;5;100mworld"
	check(func(offsets *[]ansiOffset, state *ansiState) {
		if len(*offsets) != 2 {
			t.Fail()
		}
		if state.fg != 200 || state.bg != 100 || state.attr > 0 {
			t.Fail()
		}
		assert((*offsets)[0], 0, 6, 2, -1, true)
		assert((*offsets)[1], 6, 11, 200, 100, false)
	})
}

func TestAnsiCodeStringConversion(t *testing.T) {
	assert := func(code string, prevState *ansiState, expected string) {
		state := interpretCode(code, prevState)
		if expected != state.ToString() {
			t.Errorf("expected: %s, actual: %s",
				strings.Replace(expected, "\x1b[", "\\x1b[", -1),
				strings.Replace(state.ToString(), "\x1b[", "\\x1b[", -1))
		}
	}
	assert("\x1b[m", nil, "")
	assert("\x1b[m", &ansiState{attr: tui.Blink, lbg: -1}, "")

	assert("\x1b[31m", nil, "\x1b[31;49m")
	assert("\x1b[41m", nil, "\x1b[39;41m")

	assert("\x1b[92m", nil, "\x1b[92;49m")
	assert("\x1b[102m", nil, "\x1b[39;102m")

	assert("\x1b[31m", &ansiState{fg: 4, bg: 4, lbg: -1}, "\x1b[31;44m")
	assert("\x1b[1;2;31m", &ansiState{fg: 2, bg: -1, attr: tui.Reverse, lbg: -1}, "\x1b[1;2;7;31;49m")
	assert("\x1b[38;5;100;48;5;200m", nil, "\x1b[38;5;100;48;5;200m")
	assert("\x1b[38:5:100:48:5:200m", nil, "\x1b[38;5;100;48;5;200m")
	assert("\x1b[48;5;100;38;5;200m", nil, "\x1b[38;5;200;48;5;100m")
	assert("\x1b[48;5;100;38;2;10;20;30;1m", nil, "\x1b[1;38;2;10;20;30;48;5;100m")
	assert("\x1b[48;5;100;38;2;10;20;30;7m",
		&ansiState{attr: tui.Dim | tui.Italic, fg: 1, bg: 1},
		"\x1b[2;3;7;38;2;10;20;30;48;5;100m")
}

func TestParseAnsiCode(t *testing.T) {
	tests := []struct {
		In, Exp string
		N       int
	}{
		{"123", "", 123},
		{"1a", "", -1},
		{"1a;12", "12", -1},
		{"12;a", "a", 12},
		{"-2", "", -1},
	}
	for _, x := range tests {
		n, _, s := parseAnsiCode(x.In, 0)
		if n != x.N || s != x.Exp {
			t.Fatalf("%q: got: (%d %q) want: (%d %q)", x.In, n, s, x.N, x.Exp)
		}
	}
}

// kernel/bpf/preload/iterators/README
const ansiBenchmarkString = "\x1b[38;5;81m\x1b[01;31m\x1b[Kkernel/\x1b[0m\x1b[38:5:81mbpf/" +
	"\x1b[0m\x1b[38:5:81mpreload/\x1b[0m\x1b[38;5;81miterators/" +
	"\x1b[0m\x1b[38:5:149mMakefile\x1b[m\x1b[K\x1b[0m"

func BenchmarkNextAnsiEscapeSequence(b *testing.B) {
	b.SetBytes(int64(len(ansiBenchmarkString)))
	for i := 0; i < b.N; i++ {
		s := ansiBenchmarkString
		for {
			_, o := nextAnsiEscapeSequence(s)
			if o == -1 {
				break
			}
			s = s[o:]
		}
	}
}

// Baseline test to compare the speed of nextAnsiEscapeSequence() to the
// previously used regex based implementation.
func BenchmarkNextAnsiEscapeSequence_Regex(b *testing.B) {
	b.SetBytes(int64(len(ansiBenchmarkString)))
	for i := 0; i < b.N; i++ {
		s := ansiBenchmarkString
		for {
			a := ansiRegexReference.FindStringIndex(s)
			if len(a) == 0 {
				break
			}
			s = s[a[1]:]
		}
	}
}

func BenchmarkExtractColor(b *testing.B) {
	b.SetBytes(int64(len(ansiBenchmarkString)))
	for i := 0; i < b.N; i++ {
		extractColor(ansiBenchmarkString, nil, nil)
	}
}
./src/cache.go	[[[1
81
package fzf

import "sync"

// queryCache associates strings to lists of items
type queryCache map[string][]Result

// ChunkCache associates Chunk and query string to lists of items
type ChunkCache struct {
	mutex sync.Mutex
	cache map[*Chunk]*queryCache
}

// NewChunkCache returns a new ChunkCache
func NewChunkCache() ChunkCache {
	return ChunkCache{sync.Mutex{}, make(map[*Chunk]*queryCache)}
}

// Add adds the list to the cache
func (cc *ChunkCache) Add(chunk *Chunk, key string, list []Result) {
	if len(key) == 0 || !chunk.IsFull() || len(list) > queryCacheMax {
		return
	}

	cc.mutex.Lock()
	defer cc.mutex.Unlock()

	qc, ok := cc.cache[chunk]
	if !ok {
		cc.cache[chunk] = &queryCache{}
		qc = cc.cache[chunk]
	}
	(*qc)[key] = list
}

// Lookup is called to lookup ChunkCache
func (cc *ChunkCache) Lookup(chunk *Chunk, key string) []Result {
	if len(key) == 0 || !chunk.IsFull() {
		return nil
	}

	cc.mutex.Lock()
	defer cc.mutex.Unlock()

	qc, ok := cc.cache[chunk]
	if ok {
		list, ok := (*qc)[key]
		if ok {
			return list
		}
	}
	return nil
}

func (cc *ChunkCache) Search(chunk *Chunk, key string) []Result {
	if len(key) == 0 || !chunk.IsFull() {
		return nil
	}

	cc.mutex.Lock()
	defer cc.mutex.Unlock()

	qc, ok := cc.cache[chunk]
	if !ok {
		return nil
	}

	for idx := 1; idx < len(key); idx++ {
		// [---------| ] | [ |---------]
		// [--------|  ] | [  |--------]
		// [-------|   ] | [   |-------]
		prefix := key[:len(key)-idx]
		suffix := key[idx:]
		for _, substr := range [2]string{prefix, suffix} {
			if cached, found := (*qc)[substr]; found {
				return cached
			}
		}
	}
	return nil
}
./src/cache_test.go	[[[1
39
package fzf

import "testing"

func TestChunkCache(t *testing.T) {
	cache := NewChunkCache()
	chunk1p := &Chunk{}
	chunk2p := &Chunk{count: chunkSize}
	items1 := []Result{{}}
	items2 := []Result{{}, {}}
	cache.Add(chunk1p, "foo", items1)
	cache.Add(chunk2p, "foo", items1)
	cache.Add(chunk2p, "bar", items2)

	{ // chunk1 is not full
		cached := cache.Lookup(chunk1p, "foo")
		if cached != nil {
			t.Error("Cached disabled for non-empty chunks", cached)
		}
	}
	{
		cached := cache.Lookup(chunk2p, "foo")
		if cached == nil || len(cached) != 1 {
			t.Error("Expected 1 item cached", cached)
		}
	}
	{
		cached := cache.Lookup(chunk2p, "bar")
		if cached == nil || len(cached) != 2 {
			t.Error("Expected 2 items cached", cached)
		}
	}
	{
		cached := cache.Lookup(chunk1p, "foobar")
		if cached != nil {
			t.Error("Expected 0 item cached", cached)
		}
	}
}
./src/chunklist.go	[[[1
89
package fzf

import "sync"

// Chunk is a list of Items whose size has the upper limit of chunkSize
type Chunk struct {
	items [chunkSize]Item
	count int
}

// ItemBuilder is a closure type that builds Item object from byte array
type ItemBuilder func(*Item, []byte) bool

// ChunkList is a list of Chunks
type ChunkList struct {
	chunks []*Chunk
	mutex  sync.Mutex
	trans  ItemBuilder
}

// NewChunkList returns a new ChunkList
func NewChunkList(trans ItemBuilder) *ChunkList {
	return &ChunkList{
		chunks: []*Chunk{},
		mutex:  sync.Mutex{},
		trans:  trans}
}

func (c *Chunk) push(trans ItemBuilder, data []byte) bool {
	if trans(&c.items[c.count], data) {
		c.count++
		return true
	}
	return false
}

// IsFull returns true if the Chunk is full
func (c *Chunk) IsFull() bool {
	return c.count == chunkSize
}

func (cl *ChunkList) lastChunk() *Chunk {
	return cl.chunks[len(cl.chunks)-1]
}

// CountItems returns the total number of Items
func CountItems(cs []*Chunk) int {
	if len(cs) == 0 {
		return 0
	}
	return chunkSize*(len(cs)-1) + cs[len(cs)-1].count
}

// Push adds the item to the list
func (cl *ChunkList) Push(data []byte) bool {
	cl.mutex.Lock()

	if len(cl.chunks) == 0 || cl.lastChunk().IsFull() {
		cl.chunks = append(cl.chunks, &Chunk{})
	}

	ret := cl.lastChunk().push(cl.trans, data)
	cl.mutex.Unlock()
	return ret
}

// Clear clears the data
func (cl *ChunkList) Clear() {
	cl.mutex.Lock()
	cl.chunks = nil
	cl.mutex.Unlock()
}

// Snapshot returns immutable snapshot of the ChunkList
func (cl *ChunkList) Snapshot() ([]*Chunk, int) {
	cl.mutex.Lock()

	ret := make([]*Chunk, len(cl.chunks))
	copy(ret, cl.chunks)

	// Duplicate the last chunk
	if cnt := len(ret); cnt > 0 {
		newChunk := *ret[cnt-1]
		ret[cnt-1] = &newChunk
	}

	cl.mutex.Unlock()
	return ret, CountItems(ret)
}
./src/chunklist_test.go	[[[1
80
package fzf

import (
	"fmt"
	"testing"

	"github.com/junegunn/fzf/src/util"
)

func TestChunkList(t *testing.T) {
	// FIXME global
	sortCriteria = []criterion{byScore, byLength}

	cl := NewChunkList(func(item *Item, s []byte) bool {
		item.text = util.ToChars(s)
		return true
	})

	// Snapshot
	snapshot, count := cl.Snapshot()
	if len(snapshot) > 0 || count > 0 {
		t.Error("Snapshot should be empty now")
	}

	// Add some data
	cl.Push([]byte("hello"))
	cl.Push([]byte("world"))

	// Previously created snapshot should remain the same
	if len(snapshot) > 0 {
		t.Error("Snapshot should not have changed")
	}

	// But the new snapshot should contain the added items
	snapshot, count = cl.Snapshot()
	if len(snapshot) != 1 && count != 2 {
		t.Error("Snapshot should not be empty now")
	}

	// Check the content of the ChunkList
	chunk1 := snapshot[0]
	if chunk1.count != 2 {
		t.Error("Snapshot should contain only two items")
	}
	if chunk1.items[0].text.ToString() != "hello" ||
		chunk1.items[1].text.ToString() != "world" {
		t.Error("Invalid data")
	}
	if chunk1.IsFull() {
		t.Error("Chunk should not have been marked full yet")
	}

	// Add more data
	for i := 0; i < chunkSize*2; i++ {
		cl.Push([]byte(fmt.Sprintf("item %d", i)))
	}

	// Previous snapshot should remain the same
	if len(snapshot) != 1 {
		t.Error("Snapshot should stay the same")
	}

	// New snapshot
	snapshot, count = cl.Snapshot()
	if len(snapshot) != 3 || !snapshot[0].IsFull() ||
		!snapshot[1].IsFull() || snapshot[2].IsFull() || count != chunkSize*2+2 {
		t.Error("Expected two full chunks and one more chunk")
	}
	if snapshot[2].count != 2 {
		t.Error("Unexpected number of items")
	}

	cl.Push([]byte("hello"))
	cl.Push([]byte("world"))

	lastChunkCount := snapshot[len(snapshot)-1].count
	if lastChunkCount != 2 {
		t.Error("Unexpected number of items:", lastChunkCount)
	}
}
./src/constants.go	[[[1
85
package fzf

import (
	"math"
	"os"
	"time"

	"github.com/junegunn/fzf/src/util"
)

const (
	// Core
	coordinatorDelayMax  time.Duration = 100 * time.Millisecond
	coordinatorDelayStep time.Duration = 10 * time.Millisecond

	// Reader
	readerBufferSize       = 64 * 1024
	readerPollIntervalMin  = 10 * time.Millisecond
	readerPollIntervalStep = 5 * time.Millisecond
	readerPollIntervalMax  = 50 * time.Millisecond

	// Terminal
	initialDelay      = 20 * time.Millisecond
	initialDelayTac   = 100 * time.Millisecond
	spinnerDuration   = 100 * time.Millisecond
	previewCancelWait = 500 * time.Millisecond
	previewChunkDelay = 100 * time.Millisecond
	previewDelayed    = 500 * time.Millisecond
	maxPatternLength  = 300
	maxMulti          = math.MaxInt32

	// Matcher
	numPartitionsMultiplier = 8
	maxPartitions           = 32
	progressMinDuration     = 200 * time.Millisecond

	// Capacity of each chunk
	chunkSize int = 100

	// Pre-allocated memory slices to minimize GC
	slab16Size int = 100 * 1024 // 200KB * 32 = 12.8MB
	slab32Size int = 2048       // 8KB * 32 = 256KB

	// Do not cache results of low selectivity queries
	queryCacheMax int = chunkSize / 5

	// Not to cache mergers with large lists
	mergerCacheMax int = 100000

	// History
	defaultHistoryMax int = 1000

	// Jump labels
	defaultJumpLabels string = "asdfghjklqwertyuiopzxcvbnm1234567890ASDFGHJKLQWERTYUIOPZXCVBNM`~;:,<.>/?'\"!@#$%^&*()[{]}-_=+"
)

var defaultCommand string

func init() {
	if !util.IsWindows() {
		defaultCommand = `set -o pipefail; command find -L . -mindepth 1 \( -path '*/\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \) -prune -o -type f -print -o -type l -print 2> /dev/null | cut -b3-`
	} else if os.Getenv("TERM") == "cygwin" {
		defaultCommand = `sh -c "command find -L . -mindepth 1 -path '*/\.*' -prune -o -type f -print -o -type l -print 2> /dev/null | cut -b3-"`
	}
}

// fzf events
const (
	EvtReadNew util.EventType = iota
	EvtReadFin
	EvtSearchNew
	EvtSearchProgress
	EvtSearchFin
	EvtHeader
	EvtReady
	EvtQuit
)

const (
	exitCancel    = -1
	exitOk        = 0
	exitNoMatch   = 1
	exitError     = 2
	exitInterrupt = 130
)
./src/core.go	[[[1
378
// Package fzf implements fzf, a command-line fuzzy finder.
package fzf

import (
	"fmt"
	"os"
	"time"

	"github.com/junegunn/fzf/src/util"
)

/*
Reader   -> EvtReadFin
Reader   -> EvtReadNew        -> Matcher  (restart)
Terminal -> EvtSearchNew:bool -> Matcher  (restart)
Matcher  -> EvtSearchProgress -> Terminal (update info)
Matcher  -> EvtSearchFin      -> Terminal (update list)
Matcher  -> EvtHeader         -> Terminal (update header)
*/

// Run starts fzf
func Run(opts *Options, version string, revision string) {
	sort := opts.Sort > 0
	sortCriteria = opts.Criteria

	if opts.Version {
		if len(revision) > 0 {
			fmt.Printf("%s (%s)\n", version, revision)
		} else {
			fmt.Println(version)
		}
		os.Exit(exitOk)
	}

	// Event channel
	eventBox := util.NewEventBox()

	// ANSI code processor
	ansiProcessor := func(data []byte) (util.Chars, *[]ansiOffset) {
		return util.ToChars(data), nil
	}

	var lineAnsiState, prevLineAnsiState *ansiState
	if opts.Ansi {
		if opts.Theme.Colored {
			ansiProcessor = func(data []byte) (util.Chars, *[]ansiOffset) {
				prevLineAnsiState = lineAnsiState
				trimmed, offsets, newState := extractColor(string(data), lineAnsiState, nil)
				lineAnsiState = newState
				return util.ToChars([]byte(trimmed)), offsets
			}
		} else {
			// When color is disabled but ansi option is given,
			// we simply strip out ANSI codes from the input
			ansiProcessor = func(data []byte) (util.Chars, *[]ansiOffset) {
				trimmed, _, _ := extractColor(string(data), nil, nil)
				return util.ToChars([]byte(trimmed)), nil
			}
		}
	}

	// Chunk list
	var chunkList *ChunkList
	var itemIndex int32
	header := make([]string, 0, opts.HeaderLines)
	if len(opts.WithNth) == 0 {
		chunkList = NewChunkList(func(item *Item, data []byte) bool {
			if len(header) < opts.HeaderLines {
				header = append(header, string(data))
				eventBox.Set(EvtHeader, header)
				return false
			}
			item.text, item.colors = ansiProcessor(data)
			item.text.Index = itemIndex
			itemIndex++
			return true
		})
	} else {
		chunkList = NewChunkList(func(item *Item, data []byte) bool {
			tokens := Tokenize(string(data), opts.Delimiter)
			if opts.Ansi && opts.Theme.Colored && len(tokens) > 1 {
				var ansiState *ansiState
				if prevLineAnsiState != nil {
					ansiStateDup := *prevLineAnsiState
					ansiState = &ansiStateDup
				}
				for _, token := range tokens {
					prevAnsiState := ansiState
					_, _, ansiState = extractColor(token.text.ToString(), ansiState, nil)
					if prevAnsiState != nil {
						token.text.Prepend("\x1b[m" + prevAnsiState.ToString())
					} else {
						token.text.Prepend("\x1b[m")
					}
				}
			}
			trans := Transform(tokens, opts.WithNth)
			transformed := joinTokens(trans)
			if len(header) < opts.HeaderLines {
				header = append(header, transformed)
				eventBox.Set(EvtHeader, header)
				return false
			}
			item.text, item.colors = ansiProcessor([]byte(transformed))
			item.text.TrimTrailingWhitespaces()
			item.text.Index = itemIndex
			item.origText = &data
			itemIndex++
			return true
		})
	}

	// Reader
	streamingFilter := opts.Filter != nil && !sort && !opts.Tac && !opts.Sync
	var reader *Reader
	if !streamingFilter {
		reader = NewReader(func(data []byte) bool {
			return chunkList.Push(data)
		}, eventBox, opts.ReadZero, opts.Filter == nil)
		go reader.ReadSource()
	}

	// Matcher
	forward := true
	withPos := false
	for idx := len(opts.Criteria) - 1; idx > 0; idx-- {
		switch opts.Criteria[idx] {
		case byChunk:
			withPos = true
		case byEnd:
			forward = false
		case byBegin:
			forward = true
		}
	}
	patternBuilder := func(runes []rune) *Pattern {
		return BuildPattern(
			opts.Fuzzy, opts.FuzzyAlgo, opts.Extended, opts.Case, opts.Normalize, forward, withPos,
			opts.Filter == nil, opts.Nth, opts.Delimiter, runes)
	}
	inputRevision := 0
	snapshotRevision := 0
	matcher := NewMatcher(patternBuilder, sort, opts.Tac, eventBox, inputRevision)

	// Filtering mode
	if opts.Filter != nil {
		if opts.PrintQuery {
			opts.Printer(*opts.Filter)
		}

		pattern := patternBuilder([]rune(*opts.Filter))
		matcher.sort = pattern.sortable

		found := false
		if streamingFilter {
			slab := util.MakeSlab(slab16Size, slab32Size)
			reader := NewReader(
				func(runes []byte) bool {
					item := Item{}
					if chunkList.trans(&item, runes) {
						if result, _, _ := pattern.MatchItem(&item, false, slab); result != nil {
							opts.Printer(item.text.ToString())
							found = true
						}
					}
					return false
				}, eventBox, opts.ReadZero, false)
			reader.ReadSource()
		} else {
			eventBox.Unwatch(EvtReadNew)
			eventBox.WaitFor(EvtReadFin)

			snapshot, _ := chunkList.Snapshot()
			merger, _ := matcher.scan(MatchRequest{
				chunks:  snapshot,
				pattern: pattern})
			for i := 0; i < merger.Length(); i++ {
				opts.Printer(merger.Get(i).item.AsString(opts.Ansi))
				found = true
			}
		}
		if found {
			os.Exit(exitOk)
		}
		os.Exit(exitNoMatch)
	}

	// Synchronous search
	if opts.Sync {
		eventBox.Unwatch(EvtReadNew)
		eventBox.WaitFor(EvtReadFin)
	}

	// Go interactive
	go matcher.Loop()

	// Terminal I/O
	terminal := NewTerminal(opts, eventBox)
	maxFit := 0 // Maximum number of items that can fit on screen
	padHeight := 0
	heightUnknown := opts.Height.auto
	if heightUnknown {
		maxFit, padHeight = terminal.MaxFitAndPad(opts)
	}
	deferred := opts.Select1 || opts.Exit0
	go terminal.Loop()
	if !deferred && !heightUnknown {
		// Start right away
		terminal.startChan <- fitpad{-1, -1}
	}

	// Event coordination
	reading := true
	ticks := 0
	var nextCommand *string
	eventBox.Watch(EvtReadNew)
	total := 0
	query := []rune{}
	determine := func(final bool) {
		if heightUnknown {
			if total >= maxFit || final {
				deferred = false
				heightUnknown = false
				terminal.startChan <- fitpad{util.Min(total, maxFit), padHeight}
			}
		} else if deferred {
			deferred = false
			terminal.startChan <- fitpad{-1, -1}
		}
	}

	useSnapshot := false
	var snapshot []*Chunk
	var count int
	restart := func(command string) {
		reading = true
		chunkList.Clear()
		itemIndex = 0
		inputRevision++
		header = make([]string, 0, opts.HeaderLines)
		go reader.restart(command)
	}
	for {
		delay := true
		ticks++
		input := func() []rune {
			reloaded := snapshotRevision != inputRevision
			paused, input := terminal.Input()
			if reloaded && paused {
				query = []rune{}
			} else if !paused {
				query = input
			}
			return query
		}
		eventBox.Wait(func(events *util.Events) {
			if _, fin := (*events)[EvtReadFin]; fin {
				delete(*events, EvtReadNew)
			}
			for evt, value := range *events {
				switch evt {
				case EvtQuit:
					if reading {
						reader.terminate()
					}
					os.Exit(value.(int))
				case EvtReadNew, EvtReadFin:
					if evt == EvtReadFin && nextCommand != nil {
						restart(*nextCommand)
						nextCommand = nil
						break
					} else {
						reading = reading && evt == EvtReadNew
					}
					if useSnapshot && evt == EvtReadFin {
						useSnapshot = false
					}
					if !useSnapshot {
						snapshot, count = chunkList.Snapshot()
						snapshotRevision = inputRevision
					}
					total = count
					terminal.UpdateCount(total, !reading, value.(*string))
					if opts.Sync {
						opts.Sync = false
						terminal.UpdateList(PassMerger(&snapshot, opts.Tac, snapshotRevision))
					}
					if heightUnknown && !deferred {
						determine(!reading)
					}
					matcher.Reset(snapshot, input(), false, !reading, sort, snapshotRevision)

				case EvtSearchNew:
					var command *string
					var changed bool
					switch val := value.(type) {
					case searchRequest:
						sort = val.sort
						command = val.command
						changed = val.changed
						if command != nil {
							useSnapshot = val.sync
						}
					}
					if command != nil {
						if reading {
							reader.terminate()
							nextCommand = command
						} else {
							restart(*command)
						}
					}
					if !changed {
						break
					}
					if !useSnapshot {
						newSnapshot, _ := chunkList.Snapshot()
						// We want to avoid showing empty list when reload is triggered
						// and the query string is changed at the same time i.e. command != nil && changed
						if command == nil || len(newSnapshot) > 0 {
							snapshot = newSnapshot
							snapshotRevision = inputRevision
						}
					}
					matcher.Reset(snapshot, input(), true, !reading, sort, snapshotRevision)
					delay = false

				case EvtSearchProgress:
					switch val := value.(type) {
					case float32:
						terminal.UpdateProgress(val)
					}

				case EvtHeader:
					headerPadded := make([]string, opts.HeaderLines)
					copy(headerPadded, value.([]string))
					terminal.UpdateHeader(headerPadded)

				case EvtSearchFin:
					switch val := value.(type) {
					case *Merger:
						if deferred {
							count := val.Length()
							if opts.Select1 && count > 1 || opts.Exit0 && !opts.Select1 && count > 0 {
								determine(val.final)
							} else if val.final {
								if opts.Exit0 && count == 0 || opts.Select1 && count == 1 {
									if opts.PrintQuery {
										opts.Printer(opts.Query)
									}
									if len(opts.Expect) > 0 {
										opts.Printer("")
									}
									for i := 0; i < count; i++ {
										opts.Printer(val.Get(i).item.AsString(opts.Ansi))
									}
									if count > 0 {
										os.Exit(exitOk)
									}
									os.Exit(exitNoMatch)
								}
								determine(val.final)
							}
						}
						terminal.UpdateList(val)
					}
				}
			}
			events.Clear()
		})
		if delay && reading {
			dur := util.DurWithin(
				time.Duration(ticks)*coordinatorDelayStep,
				0, coordinatorDelayMax)
			time.Sleep(dur)
		}
	}
}
./src/history.go	[[[1
96
package fzf

import (
	"errors"
	"io/ioutil"
	"os"
	"strings"
)

// History struct represents input history
type History struct {
	path     string
	lines    []string
	modified map[int]string
	maxSize  int
	cursor   int
}

// NewHistory returns the pointer to a new History struct
func NewHistory(path string, maxSize int) (*History, error) {
	fmtError := func(e error) error {
		if os.IsPermission(e) {
			return errors.New("permission denied: " + path)
		}
		return errors.New("invalid history file: " + e.Error())
	}

	// Read history file
	data, err := ioutil.ReadFile(path)
	if err != nil {
		// If it doesn't exist, check if we can create a file with the name
		if os.IsNotExist(err) {
			data = []byte{}
			if err := ioutil.WriteFile(path, data, 0600); err != nil {
				return nil, fmtError(err)
			}
		} else {
			return nil, fmtError(err)
		}
	}
	// Split lines and limit the maximum number of lines
	lines := strings.Split(strings.Trim(string(data), "\n"), "\n")
	if len(lines[len(lines)-1]) > 0 {
		lines = append(lines, "")
	}
	return &History{
		path:     path,
		maxSize:  maxSize,
		lines:    lines,
		modified: make(map[int]string),
		cursor:   len(lines) - 1}, nil
}

func (h *History) append(line string) error {
	// We don't append empty lines
	if len(line) == 0 {
		return nil
	}

	lines := append(h.lines[:len(h.lines)-1], line)
	if len(lines) > h.maxSize {
		lines = lines[len(lines)-h.maxSize:]
	}
	h.lines = append(lines, "")
	return ioutil.WriteFile(h.path, []byte(strings.Join(h.lines, "\n")), 0600)
}

func (h *History) override(str string) {
	// You can update the history but they're not written to the file
	if h.cursor == len(h.lines)-1 {
		h.lines[h.cursor] = str
	} else if h.cursor < len(h.lines)-1 {
		h.modified[h.cursor] = str
	}
}

func (h *History) current() string {
	if str, prs := h.modified[h.cursor]; prs {
		return str
	}
	return h.lines[h.cursor]
}

func (h *History) previous() string {
	if h.cursor > 0 {
		h.cursor--
	}
	return h.current()
}

func (h *History) next() string {
	if h.cursor < len(h.lines)-1 {
		h.cursor++
	}
	return h.current()
}
./src/history_test.go	[[[1
68
package fzf

import (
	"io/ioutil"
	"os"
	"runtime"
	"testing"
)

func TestHistory(t *testing.T) {
	maxHistory := 50

	// Invalid arguments
	var paths []string
	if runtime.GOOS == "windows" {
		// GOPATH should exist, so we shouldn't be able to override it
		paths = []string{os.Getenv("GOPATH")}
	} else {
		paths = []string{"/etc", "/proc"}
	}

	for _, path := range paths {
		if _, e := NewHistory(path, maxHistory); e == nil {
			t.Error("Error expected for: " + path)
		}
	}

	f, _ := ioutil.TempFile("", "fzf-history")
	f.Close()

	{ // Append lines
		h, _ := NewHistory(f.Name(), maxHistory)
		for i := 0; i < maxHistory+10; i++ {
			h.append("foobar")
		}
	}
	{ // Read lines
		h, _ := NewHistory(f.Name(), maxHistory)
		if len(h.lines) != maxHistory+1 {
			t.Errorf("Expected: %d, actual: %d\n", maxHistory+1, len(h.lines))
		}
		for i := 0; i < maxHistory; i++ {
			if h.lines[i] != "foobar" {
				t.Error("Expected: foobar, actual: " + h.lines[i])
			}
		}
	}
	{ // Append lines
		h, _ := NewHistory(f.Name(), maxHistory)
		h.append("barfoo")
		h.append("")
		h.append("foobarbaz")
	}
	{ // Read lines again
		h, _ := NewHistory(f.Name(), maxHistory)
		if len(h.lines) != maxHistory+1 {
			t.Errorf("Expected: %d, actual: %d\n", maxHistory+1, len(h.lines))
		}
		compare := func(idx int, exp string) {
			if h.lines[idx] != exp {
				t.Errorf("Expected: %s, actual: %s\n", exp, h.lines[idx])
			}
		}
		compare(maxHistory-3, "foobar")
		compare(maxHistory-2, "barfoo")
		compare(maxHistory-1, "foobarbaz")
	}
}
./src/item.go	[[[1
44
package fzf

import (
	"github.com/junegunn/fzf/src/util"
)

// Item represents each input line. 56 bytes.
type Item struct {
	text        util.Chars    // 32 = 24 + 1 + 1 + 2 + 4
	transformed *[]Token      // 8
	origText    *[]byte       // 8
	colors      *[]ansiOffset // 8
}

// Index returns ordinal index of the Item
func (item *Item) Index() int32 {
	return item.text.Index
}

var minItem = Item{text: util.Chars{Index: -1}}

func (item *Item) TrimLength() uint16 {
	return item.text.TrimLength()
}

// Colors returns ansiOffsets of the Item
func (item *Item) Colors() []ansiOffset {
	if item.colors == nil {
		return []ansiOffset{}
	}
	return *item.colors
}

// AsString returns the original string
func (item *Item) AsString(stripAnsi bool) string {
	if item.origText != nil {
		if stripAnsi {
			trimmed, _, _ := extractColor(string(*item.origText), nil, nil)
			return trimmed
		}
		return string(*item.origText)
	}
	return item.text.ToString()
}
./src/item_test.go	[[[1
23
package fzf

import (
	"testing"

	"github.com/junegunn/fzf/src/util"
)

func TestStringPtr(t *testing.T) {
	orig := []byte("\x1b[34mfoo")
	text := []byte("\x1b[34mbar")
	item := Item{origText: &orig, text: util.ToChars(text)}
	if item.AsString(true) != "foo" || item.AsString(false) != string(orig) {
		t.Fail()
	}
	if item.AsString(true) != "foo" {
		t.Fail()
	}
	item.origText = nil
	if item.AsString(true) != string(text) || item.AsString(false) != string(text) {
		t.Fail()
	}
}
./src/matcher.go	[[[1
238
package fzf

import (
	"fmt"
	"runtime"
	"sort"
	"sync"
	"time"

	"github.com/junegunn/fzf/src/util"
)

// MatchRequest represents a search request
type MatchRequest struct {
	chunks   []*Chunk
	pattern  *Pattern
	final    bool
	sort     bool
	revision int
}

// Matcher is responsible for performing search
type Matcher struct {
	patternBuilder func([]rune) *Pattern
	sort           bool
	tac            bool
	eventBox       *util.EventBox
	reqBox         *util.EventBox
	partitions     int
	slab           []*util.Slab
	mergerCache    map[string]*Merger
	revision       int
}

const (
	reqRetry util.EventType = iota
	reqReset
)

// NewMatcher returns a new Matcher
func NewMatcher(patternBuilder func([]rune) *Pattern,
	sort bool, tac bool, eventBox *util.EventBox, revision int) *Matcher {
	partitions := util.Min(numPartitionsMultiplier*runtime.NumCPU(), maxPartitions)
	return &Matcher{
		patternBuilder: patternBuilder,
		sort:           sort,
		tac:            tac,
		eventBox:       eventBox,
		reqBox:         util.NewEventBox(),
		partitions:     partitions,
		slab:           make([]*util.Slab, partitions),
		mergerCache:    make(map[string]*Merger),
		revision:       revision}
}

// Loop puts Matcher in action
func (m *Matcher) Loop() {
	prevCount := 0

	for {
		var request MatchRequest

		m.reqBox.Wait(func(events *util.Events) {
			for _, val := range *events {
				switch val := val.(type) {
				case MatchRequest:
					request = val
				default:
					panic(fmt.Sprintf("Unexpected type: %T", val))
				}
			}
			events.Clear()
		})

		if request.sort != m.sort || request.revision != m.revision {
			m.sort = request.sort
			m.revision = request.revision
			m.mergerCache = make(map[string]*Merger)
			clearChunkCache()
		}

		// Restart search
		patternString := request.pattern.AsString()
		var merger *Merger
		cancelled := false
		count := CountItems(request.chunks)

		foundCache := false
		if count == prevCount {
			// Look up mergerCache
			if cached, found := m.mergerCache[patternString]; found {
				foundCache = true
				merger = cached
			}
		} else {
			// Invalidate mergerCache
			prevCount = count
			m.mergerCache = make(map[string]*Merger)
		}

		if !foundCache {
			merger, cancelled = m.scan(request)
		}

		if !cancelled {
			if merger.cacheable() {
				m.mergerCache[patternString] = merger
			}
			merger.final = request.final
			m.eventBox.Set(EvtSearchFin, merger)
		}
	}
}

func (m *Matcher) sliceChunks(chunks []*Chunk) [][]*Chunk {
	partitions := m.partitions
	perSlice := len(chunks) / partitions

	if perSlice == 0 {
		partitions = len(chunks)
		perSlice = 1
	}

	slices := make([][]*Chunk, partitions)
	for i := 0; i < partitions; i++ {
		start := i * perSlice
		end := start + perSlice
		if i == partitions-1 {
			end = len(chunks)
		}
		slices[i] = chunks[start:end]
	}
	return slices
}

type partialResult struct {
	index   int
	matches []Result
}

func (m *Matcher) scan(request MatchRequest) (*Merger, bool) {
	startedAt := time.Now()

	numChunks := len(request.chunks)
	if numChunks == 0 {
		return EmptyMerger(request.revision), false
	}
	pattern := request.pattern
	if pattern.IsEmpty() {
		return PassMerger(&request.chunks, m.tac, request.revision), false
	}

	cancelled := util.NewAtomicBool(false)

	slices := m.sliceChunks(request.chunks)
	numSlices := len(slices)
	resultChan := make(chan partialResult, numSlices)
	countChan := make(chan int, numChunks)
	waitGroup := sync.WaitGroup{}

	for idx, chunks := range slices {
		waitGroup.Add(1)
		if m.slab[idx] == nil {
			m.slab[idx] = util.MakeSlab(slab16Size, slab32Size)
		}
		go func(idx int, slab *util.Slab, chunks []*Chunk) {
			defer func() { waitGroup.Done() }()
			count := 0
			allMatches := make([][]Result, len(chunks))
			for idx, chunk := range chunks {
				matches := request.pattern.Match(chunk, slab)
				allMatches[idx] = matches
				count += len(matches)
				if cancelled.Get() {
					return
				}
				countChan <- len(matches)
			}
			sliceMatches := make([]Result, 0, count)
			for _, matches := range allMatches {
				sliceMatches = append(sliceMatches, matches...)
			}
			if m.sort {
				if m.tac {
					sort.Sort(ByRelevanceTac(sliceMatches))
				} else {
					sort.Sort(ByRelevance(sliceMatches))
				}
			}
			resultChan <- partialResult{idx, sliceMatches}
		}(idx, m.slab[idx], chunks)
	}

	wait := func() bool {
		cancelled.Set(true)
		waitGroup.Wait()
		return true
	}

	count := 0
	matchCount := 0
	for matchesInChunk := range countChan {
		count++
		matchCount += matchesInChunk

		if count == numChunks {
			break
		}

		if m.reqBox.Peek(reqReset) {
			return nil, wait()
		}

		if time.Since(startedAt) > progressMinDuration {
			m.eventBox.Set(EvtSearchProgress, float32(count)/float32(numChunks))
		}
	}

	partialResults := make([][]Result, numSlices)
	for range slices {
		partialResult := <-resultChan
		partialResults[partialResult.index] = partialResult.matches
	}
	return NewMerger(pattern, partialResults, m.sort, m.tac, request.revision), false
}

// Reset is called to interrupt/signal the ongoing search
func (m *Matcher) Reset(chunks []*Chunk, patternRunes []rune, cancel bool, final bool, sort bool, revision int) {
	pattern := m.patternBuilder(patternRunes)

	var event util.EventType
	if cancel {
		event = reqReset
	} else {
		event = reqRetry
	}
	m.reqBox.Set(event, MatchRequest{chunks, pattern, final, sort && pattern.sortable, revision})
}
./src/merger.go	[[[1
158
package fzf

import "fmt"

// EmptyMerger is a Merger with no data
func EmptyMerger(revision int) *Merger {
	return NewMerger(nil, [][]Result{}, false, false, revision)
}

// Merger holds a set of locally sorted lists of items and provides the view of
// a single, globally-sorted list
type Merger struct {
	pattern  *Pattern
	lists    [][]Result
	merged   []Result
	chunks   *[]*Chunk
	cursors  []int
	sorted   bool
	tac      bool
	final    bool
	count    int
	pass     bool
	revision int
}

// PassMerger returns a new Merger that simply returns the items in the
// original order
func PassMerger(chunks *[]*Chunk, tac bool, revision int) *Merger {
	mg := Merger{
		pattern:  nil,
		chunks:   chunks,
		tac:      tac,
		count:    0,
		pass:     true,
		revision: revision}

	for _, chunk := range *mg.chunks {
		mg.count += chunk.count
	}
	return &mg
}

// NewMerger returns a new Merger
func NewMerger(pattern *Pattern, lists [][]Result, sorted bool, tac bool, revision int) *Merger {
	mg := Merger{
		pattern:  pattern,
		lists:    lists,
		merged:   []Result{},
		chunks:   nil,
		cursors:  make([]int, len(lists)),
		sorted:   sorted,
		tac:      tac,
		final:    false,
		count:    0,
		revision: revision}

	for _, list := range mg.lists {
		mg.count += len(list)
	}
	return &mg
}

// Revision returns revision number
func (mg *Merger) Revision() int {
	return mg.revision
}

// Length returns the number of items
func (mg *Merger) Length() int {
	return mg.count
}

func (mg *Merger) First() Result {
	if mg.tac && !mg.sorted {
		return mg.Get(mg.count - 1)
	}
	return mg.Get(0)
}

// FindIndex returns the index of the item with the given item index
func (mg *Merger) FindIndex(itemIndex int32) int {
	index := -1
	if mg.pass {
		index = int(itemIndex)
		if mg.tac {
			index = mg.count - index - 1
		}
	} else {
		for i := 0; i < mg.count; i++ {
			if mg.Get(i).item.Index() == itemIndex {
				index = i
				break
			}
		}
	}
	return index
}

// Get returns the pointer to the Result object indexed by the given integer
func (mg *Merger) Get(idx int) Result {
	if mg.chunks != nil {
		if mg.tac {
			idx = mg.count - idx - 1
		}
		chunk := (*mg.chunks)[idx/chunkSize]
		return Result{item: &chunk.items[idx%chunkSize]}
	}

	if mg.sorted {
		return mg.mergedGet(idx)
	}

	if mg.tac {
		idx = mg.count - idx - 1
	}
	for _, list := range mg.lists {
		numItems := len(list)
		if idx < numItems {
			return list[idx]
		}
		idx -= numItems
	}
	panic(fmt.Sprintf("Index out of bounds (unsorted, %d/%d)", idx, mg.count))
}

func (mg *Merger) cacheable() bool {
	return mg.count < mergerCacheMax
}

func (mg *Merger) mergedGet(idx int) Result {
	for i := len(mg.merged); i <= idx; i++ {
		minRank := minRank()
		minIdx := -1
		for listIdx, list := range mg.lists {
			cursor := mg.cursors[listIdx]
			if cursor < 0 || cursor == len(list) {
				mg.cursors[listIdx] = -1
				continue
			}
			if cursor >= 0 {
				rank := list[cursor]
				if minIdx < 0 || compareRanks(rank, minRank, mg.tac) {
					minRank = rank
					minIdx = listIdx
				}
			}
		}

		if minIdx >= 0 {
			chosen := mg.lists[minIdx]
			mg.merged = append(mg.merged, chosen[mg.cursors[minIdx]])
			mg.cursors[minIdx]++
		} else {
			panic(fmt.Sprintf("Index out of bounds (sorted, %d/%d)", i, mg.count))
		}
	}
	return mg.merged[idx]
}
./src/merger_test.go	[[[1
88
package fzf

import (
	"fmt"
	"math/rand"
	"sort"
	"testing"

	"github.com/junegunn/fzf/src/util"
)

func assert(t *testing.T, cond bool, msg ...string) {
	if !cond {
		t.Error(msg)
	}
}

func randResult() Result {
	str := fmt.Sprintf("%d", rand.Uint32())
	chars := util.ToChars([]byte(str))
	chars.Index = rand.Int31()
	return Result{item: &Item{text: chars}}
}

func TestEmptyMerger(t *testing.T) {
	assert(t, EmptyMerger(0).Length() == 0, "Not empty")
	assert(t, EmptyMerger(0).count == 0, "Invalid count")
	assert(t, len(EmptyMerger(0).lists) == 0, "Invalid lists")
	assert(t, len(EmptyMerger(0).merged) == 0, "Invalid merged list")
}

func buildLists(partiallySorted bool) ([][]Result, []Result) {
	numLists := 4
	lists := make([][]Result, numLists)
	cnt := 0
	for i := 0; i < numLists; i++ {
		numResults := rand.Int() % 20
		cnt += numResults
		lists[i] = make([]Result, numResults)
		for j := 0; j < numResults; j++ {
			item := randResult()
			lists[i][j] = item
		}
		if partiallySorted {
			sort.Sort(ByRelevance(lists[i]))
		}
	}
	items := []Result{}
	for _, list := range lists {
		items = append(items, list...)
	}
	return lists, items
}

func TestMergerUnsorted(t *testing.T) {
	lists, items := buildLists(false)
	cnt := len(items)

	// Not sorted: same order
	mg := NewMerger(nil, lists, false, false, 0)
	assert(t, cnt == mg.Length(), "Invalid Length")
	for i := 0; i < cnt; i++ {
		assert(t, items[i] == mg.Get(i), "Invalid Get")
	}
}

func TestMergerSorted(t *testing.T) {
	lists, items := buildLists(true)
	cnt := len(items)

	// Sorted sorted order
	mg := NewMerger(nil, lists, true, false, 0)
	assert(t, cnt == mg.Length(), "Invalid Length")
	sort.Sort(ByRelevance(items))
	for i := 0; i < cnt; i++ {
		if items[i] != mg.Get(i) {
			t.Error("Not sorted", items[i], mg.Get(i))
		}
	}

	// Inverse order
	mg2 := NewMerger(nil, lists, true, false, 0)
	for i := cnt - 1; i >= 0; i-- {
		if items[i] != mg2.Get(i) {
			t.Error("Not sorted", items[i], mg2.Get(i))
		}
	}
}
./src/options.go	[[[1
2116
package fzf

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
	"unicode"

	"github.com/junegunn/fzf/src/algo"
	"github.com/junegunn/fzf/src/tui"
	"github.com/junegunn/fzf/src/util"

	"github.com/mattn/go-runewidth"
	"github.com/mattn/go-shellwords"
)

const usage = `usage: fzf [options]

  Search
    -x, --extended         Extended-search mode
                           (enabled by default; +x or --no-extended to disable)
    -e, --exact            Enable Exact-match
    -i                     Case-insensitive match (default: smart-case match)
    +i                     Case-sensitive match
    --scheme=SCHEME        Scoring scheme [default|path|history]
    --literal              Do not normalize latin script letters before matching
    -n, --nth=N[,..]       Comma-separated list of field index expressions
                           for limiting search scope. Each can be a non-zero
                           integer or a range expression ([BEGIN]..[END]).
    --with-nth=N[,..]      Transform the presentation of each line using
                           field index expressions
    -d, --delimiter=STR    Field delimiter regex (default: AWK-style)
    +s, --no-sort          Do not sort the result
    --track                Track the current selection when the result is updated
    --tac                  Reverse the order of the input
    --disabled             Do not perform search
    --tiebreak=CRI[,..]    Comma-separated list of sort criteria to apply
                           when the scores are tied [length|chunk|begin|end|index]
                           (default: length)

  Interface
    -m, --multi[=MAX]      Enable multi-select with tab/shift-tab
    --no-mouse             Disable mouse
    --bind=KEYBINDS        Custom key bindings. Refer to the man page.
    --cycle                Enable cyclic scroll
    --keep-right           Keep the right end of the line visible on overflow
    --scroll-off=LINES     Number of screen lines to keep above or below when
                           scrolling to the top or to the bottom (default: 0)
    --no-hscroll           Disable horizontal scroll
    --hscroll-off=COLS     Number of screen columns to keep to the right of the
                           highlighted substring (default: 10)
    --filepath-word        Make word-wise movements respect path separators
    --jump-labels=CHARS    Label characters for jump and jump-accept

  Layout
    --height=[~]HEIGHT[%]  Display fzf window below the cursor with the given
                           height instead of using fullscreen.
                           If prefixed with '~', fzf will determine the height
                           according to the input size.
    --min-height=HEIGHT    Minimum height when --height is given in percent
                           (default: 10)
    --layout=LAYOUT        Choose layout: [default|reverse|reverse-list]
    --border[=STYLE]       Draw border around the finder
                           [rounded|sharp|bold|block|thinblock|double|horizontal|vertical|
                            top|bottom|left|right|none] (default: rounded)
    --border-label=LABEL   Label to print on the border
    --border-label-pos=COL Position of the border label
                           [POSITIVE_INTEGER: columns from left|
                            NEGATIVE_INTEGER: columns from right][:bottom]
                           (default: 0 or center)
    --margin=MARGIN        Screen margin (TRBL | TB,RL | T,RL,B | T,R,B,L)
    --padding=PADDING      Padding inside border (TRBL | TB,RL | T,RL,B | T,R,B,L)
    --info=STYLE           Finder info style
                           [default|right|hidden|inline[:SEPARATOR]|inline-right]
    --separator=STR        String to form horizontal separator on info line
    --no-separator         Hide info line separator
    --scrollbar[=C1[C2]]   Scrollbar character(s) (each for main and preview window)
    --no-scrollbar         Hide scrollbar
    --prompt=STR           Input prompt (default: '> ')
    --pointer=STR          Pointer to the current line (default: '>')
    --marker=STR           Multi-select marker (default: '>')
    --header=STR           String to print as header
    --header-lines=N       The first N lines of the input are treated as header
    --header-first         Print header before the prompt line
    --ellipsis=STR         Ellipsis to show when line is truncated (default: '..')

  Display
    --ansi                 Enable processing of ANSI color codes
    --tabstop=SPACES       Number of spaces for a tab character (default: 8)
    --color=COLSPEC        Base scheme (dark|light|16|bw) and/or custom colors
    --no-bold              Do not use bold text

  History
    --history=FILE         History file
    --history-size=N       Maximum number of history entries (default: 1000)

  Preview
    --preview=COMMAND      Command to preview highlighted line ({})
    --preview-window=OPT   Preview window layout (default: right:50%)
                           [up|down|left|right][,SIZE[%]]
                           [,[no]wrap][,[no]cycle][,[no]follow][,[no]hidden]
                           [,border-BORDER_OPT]
                           [,+SCROLL[OFFSETS][/DENOM]][,~HEADER_LINES]
                           [,default][,<SIZE_THRESHOLD(ALTERNATIVE_LAYOUT)]
    --preview-label=LABEL
    --preview-label-pos=N  Same as --border-label and --border-label-pos,
                           but for preview window

  Scripting
    -q, --query=STR        Start the finder with the given query
    -1, --select-1         Automatically select the only match
    -0, --exit-0           Exit immediately when there's no match
    -f, --filter=STR       Filter mode. Do not start interactive finder.
    --print-query          Print query as the first line
    --expect=KEYS          Comma-separated list of keys to complete fzf
    --read0                Read input delimited by ASCII NUL characters
    --print0               Print output delimited by ASCII NUL characters
    --sync                 Synchronous search for multi-staged filtering
    --listen[=HTTP_PORT]   Start HTTP server to receive actions (POST /)
    --version              Display version information and exit

  Environment variables
    FZF_DEFAULT_COMMAND    Default command to use when input is tty
    FZF_DEFAULT_OPTS       Default options
                           (e.g. '--layout=reverse --inline-info')

`

const defaultInfoSep = " < "

// Case denotes case-sensitivity of search
type Case int

// Case-sensitivities
const (
	CaseSmart Case = iota
	CaseIgnore
	CaseRespect
)

// Sort criteria
type criterion int

const (
	byScore criterion = iota
	byChunk
	byLength
	byBegin
	byEnd
)

type heightSpec struct {
	size    float64
	percent bool
	auto    bool
}

type sizeSpec struct {
	size    float64
	percent bool
}

func defaultMargin() [4]sizeSpec {
	return [4]sizeSpec{}
}

type trackOption int

const (
	trackDisabled trackOption = iota
	trackEnabled
	trackCurrent
)

type windowPosition int

const (
	posUp windowPosition = iota
	posDown
	posLeft
	posRight
)

type layoutType int

const (
	layoutDefault layoutType = iota
	layoutReverse
	layoutReverseList
)

type infoStyle int

const (
	infoDefault infoStyle = iota
	infoRight
	infoInline
	infoInlineRight
	infoHidden
)

func (s infoStyle) noExtraLine() bool {
	return s == infoInline || s == infoInlineRight || s == infoHidden
}

type labelOpts struct {
	label  string
	column int
	bottom bool
}

type previewOpts struct {
	command     string
	position    windowPosition
	size        sizeSpec
	scroll      string
	hidden      bool
	wrap        bool
	cycle       bool
	follow      bool
	border      tui.BorderShape
	headerLines int
	threshold   int
	alternative *previewOpts
}

func (o *previewOpts) Visible() bool {
	return o.size.size > 0 || o.alternative != nil && o.alternative.size.size > 0
}

func (o *previewOpts) Toggle() {
	o.hidden = !o.hidden
}

func parseLabelPosition(opts *labelOpts, arg string) {
	opts.column = 0
	opts.bottom = false
	for _, token := range splitRegexp.Split(strings.ToLower(arg), -1) {
		switch token {
		case "center":
			opts.column = 0
		case "bottom":
			opts.bottom = true
		case "top":
			opts.bottom = false
		default:
			opts.column = atoi(token)
		}
	}
}

func (a previewOpts) aboveOrBelow() bool {
	return a.size.size > 0 && (a.position == posUp || a.position == posDown)
}

func (a previewOpts) sameLayout(b previewOpts) bool {
	return a.size == b.size && a.position == b.position && a.border == b.border && a.hidden == b.hidden && a.threshold == b.threshold &&
		(a.alternative != nil && b.alternative != nil && a.alternative.sameLayout(*b.alternative) ||
			a.alternative == nil && b.alternative == nil)
}

func (a previewOpts) sameContentLayout(b previewOpts) bool {
	return a.wrap == b.wrap && a.headerLines == b.headerLines
}

func firstLine(s string) string {
	return strings.SplitN(s, "\n", 2)[0]
}

// Options stores the values of command-line options
type Options struct {
	Fuzzy        bool
	FuzzyAlgo    algo.Algo
	Scheme       string
	Extended     bool
	Phony        bool
	Case         Case
	Normalize    bool
	Nth          []Range
	WithNth      []Range
	Delimiter    Delimiter
	Sort         int
	Track        trackOption
	Tac          bool
	Criteria     []criterion
	Multi        int
	Ansi         bool
	Mouse        bool
	Theme        *tui.ColorTheme
	Black        bool
	Bold         bool
	Height       heightSpec
	MinHeight    int
	Layout       layoutType
	Cycle        bool
	KeepRight    bool
	Hscroll      bool
	HscrollOff   int
	ScrollOff    int
	FileWord     bool
	InfoStyle    infoStyle
	InfoSep      string
	Separator    *string
	JumpLabels   string
	Prompt       string
	Pointer      string
	Marker       string
	Query        string
	Select1      bool
	Exit0        bool
	Filter       *string
	ToggleSort   bool
	Expect       map[tui.Event]string
	Keymap       map[tui.Event][]*action
	Preview      previewOpts
	PrintQuery   bool
	ReadZero     bool
	Printer      func(string)
	PrintSep     string
	Sync         bool
	History      *History
	Header       []string
	HeaderLines  int
	HeaderFirst  bool
	Ellipsis     string
	Scrollbar    *string
	Margin       [4]sizeSpec
	Padding      [4]sizeSpec
	BorderShape  tui.BorderShape
	BorderLabel  labelOpts
	PreviewLabel labelOpts
	Unicode      bool
	Tabstop      int
	ListenPort   *int
	ClearOnExit  bool
	Version      bool
}

func defaultPreviewOpts(command string) previewOpts {
	return previewOpts{command, posRight, sizeSpec{50, true}, "", false, false, false, false, tui.DefaultBorderShape, 0, 0, nil}
}

func defaultOptions() *Options {
	return &Options{
		Fuzzy:        true,
		FuzzyAlgo:    algo.FuzzyMatchV2,
		Scheme:       "default",
		Extended:     true,
		Phony:        false,
		Case:         CaseSmart,
		Normalize:    true,
		Nth:          make([]Range, 0),
		WithNth:      make([]Range, 0),
		Delimiter:    Delimiter{},
		Sort:         1000,
		Track:        trackDisabled,
		Tac:          false,
		Criteria:     []criterion{byScore, byLength},
		Multi:        0,
		Ansi:         false,
		Mouse:        true,
		Theme:        tui.EmptyTheme(),
		Black:        false,
		Bold:         true,
		MinHeight:    10,
		Layout:       layoutDefault,
		Cycle:        false,
		KeepRight:    false,
		Hscroll:      true,
		HscrollOff:   10,
		ScrollOff:    0,
		FileWord:     false,
		InfoStyle:    infoDefault,
		Separator:    nil,
		JumpLabels:   defaultJumpLabels,
		Prompt:       "> ",
		Pointer:      ">",
		Marker:       ">",
		Query:        "",
		Select1:      false,
		Exit0:        false,
		Filter:       nil,
		ToggleSort:   false,
		Expect:       make(map[tui.Event]string),
		Keymap:       make(map[tui.Event][]*action),
		Preview:      defaultPreviewOpts(""),
		PrintQuery:   false,
		ReadZero:     false,
		Printer:      func(str string) { fmt.Println(str) },
		PrintSep:     "\n",
		Sync:         false,
		History:      nil,
		Header:       make([]string, 0),
		HeaderLines:  0,
		HeaderFirst:  false,
		Ellipsis:     "..",
		Scrollbar:    nil,
		Margin:       defaultMargin(),
		Padding:      defaultMargin(),
		Unicode:      true,
		Tabstop:      8,
		BorderLabel:  labelOpts{},
		PreviewLabel: labelOpts{},
		ClearOnExit:  true,
		Version:      false}
}

func help(code int) {
	os.Stdout.WriteString(usage)
	os.Exit(code)
}

func errorExit(msg string) {
	os.Stderr.WriteString(msg + "\n")
	os.Exit(exitError)
}

func optString(arg string, prefixes ...string) (bool, string) {
	for _, prefix := range prefixes {
		if strings.HasPrefix(arg, prefix) {
			return true, arg[len(prefix):]
		}
	}
	return false, ""
}

func nextString(args []string, i *int, message string) string {
	if len(args) > *i+1 {
		*i++
	} else {
		errorExit(message)
	}
	return args[*i]
}

func optionalNextString(args []string, i *int) (bool, string) {
	if len(args) > *i+1 && !strings.HasPrefix(args[*i+1], "-") && !strings.HasPrefix(args[*i+1], "+") {
		*i++
		return true, args[*i]
	}
	return false, ""
}

func atoi(str string) int {
	num, err := strconv.Atoi(str)
	if err != nil {
		errorExit("not a valid integer: " + str)
	}
	return num
}

func atof(str string) float64 {
	num, err := strconv.ParseFloat(str, 64)
	if err != nil {
		errorExit("not a valid number: " + str)
	}
	return num
}

func nextInt(args []string, i *int, message string) int {
	if len(args) > *i+1 {
		*i++
	} else {
		errorExit(message)
	}
	return atoi(args[*i])
}

func optionalNumeric(args []string, i *int, defaultValue int) int {
	if len(args) > *i+1 {
		if strings.IndexAny(args[*i+1], "0123456789") == 0 {
			*i++
			return atoi(args[*i])
		}
	}
	return defaultValue
}

func splitNth(str string) []Range {
	if match, _ := regexp.MatchString("^[0-9,-.]+$", str); !match {
		errorExit("invalid format: " + str)
	}

	tokens := strings.Split(str, ",")
	ranges := make([]Range, len(tokens))
	for idx, s := range tokens {
		r, ok := ParseRange(&s)
		if !ok {
			errorExit("invalid format: " + str)
		}
		ranges[idx] = r
	}
	return ranges
}

func delimiterRegexp(str string) Delimiter {
	// Special handling of \t
	str = strings.Replace(str, "\\t", "\t", -1)

	// 1. Pattern does not contain any special character
	if regexp.QuoteMeta(str) == str {
		return Delimiter{str: &str}
	}

	rx, e := regexp.Compile(str)
	// 2. Pattern is not a valid regular expression
	if e != nil {
		return Delimiter{str: &str}
	}

	// 3. Pattern as regular expression. Slow.
	return Delimiter{regex: rx}
}

func isAlphabet(char uint8) bool {
	return char >= 'a' && char <= 'z'
}

func isNumeric(char uint8) bool {
	return char >= '0' && char <= '9'
}

func parseAlgo(str string) algo.Algo {
	switch str {
	case "v1":
		return algo.FuzzyMatchV1
	case "v2":
		return algo.FuzzyMatchV2
	default:
		errorExit("invalid algorithm (expected: v1 or v2)")
	}
	return algo.FuzzyMatchV2
}

func processScheme(opts *Options) {
	if !algo.Init(opts.Scheme) {
		errorExit("invalid scoring scheme (expected: default|path|history)")
	}
	if opts.Scheme == "history" {
		opts.Criteria = []criterion{byScore}
	}
}

func parseBorder(str string, optional bool) tui.BorderShape {
	switch str {
	case "rounded":
		return tui.BorderRounded
	case "sharp":
		return tui.BorderSharp
	case "bold":
		return tui.BorderBold
	case "block":
		return tui.BorderBlock
	case "thinblock":
		return tui.BorderThinBlock
	case "double":
		return tui.BorderDouble
	case "horizontal":
		return tui.BorderHorizontal
	case "vertical":
		return tui.BorderVertical
	case "top":
		return tui.BorderTop
	case "bottom":
		return tui.BorderBottom
	case "left":
		return tui.BorderLeft
	case "right":
		return tui.BorderRight
	case "none":
		return tui.BorderNone
	default:
		if optional && str == "" {
			return tui.DefaultBorderShape
		}
		errorExit("invalid border style (expected: rounded|sharp|bold|block|thinblock|double|horizontal|vertical|top|bottom|left|right|none)")
	}
	return tui.BorderNone
}

func parseKeyChords(str string, message string) map[tui.Event]string {
	return parseKeyChordsImpl(str, message, errorExit)
}

func parseKeyChordsImpl(str string, message string, exit func(string)) map[tui.Event]string {
	if len(str) == 0 {
		exit(message)
		return nil
	}

	str = regexp.MustCompile("(?i)(alt-),").ReplaceAllString(str, "$1"+string([]rune{escapedComma}))
	tokens := strings.Split(str, ",")
	if str == "," || strings.HasPrefix(str, ",,") || strings.HasSuffix(str, ",,") || strings.Contains(str, ",,,") {
		tokens = append(tokens, ",")
	}

	chords := make(map[tui.Event]string)
	for _, key := range tokens {
		if len(key) == 0 {
			continue // ignore
		}
		key = strings.ReplaceAll(key, string([]rune{escapedComma}), ",")
		lkey := strings.ToLower(key)
		add := func(e tui.EventType) {
			chords[e.AsEvent()] = key
		}
		switch lkey {
		case "up":
			add(tui.Up)
		case "down":
			add(tui.Down)
		case "left":
			add(tui.Left)
		case "right":
			add(tui.Right)
		case "enter", "return":
			add(tui.CtrlM)
		case "space":
			chords[tui.Key(' ')] = key
		case "bspace", "bs":
			add(tui.BSpace)
		case "ctrl-space":
			add(tui.CtrlSpace)
		case "ctrl-delete":
			add(tui.CtrlDelete)
		case "ctrl-^", "ctrl-6":
			add(tui.CtrlCaret)
		case "ctrl-/", "ctrl-_":
			add(tui.CtrlSlash)
		case "ctrl-\\":
			add(tui.CtrlBackSlash)
		case "ctrl-]":
			add(tui.CtrlRightBracket)
		case "change":
			add(tui.Change)
		case "backward-eof":
			add(tui.BackwardEOF)
		case "start":
			add(tui.Start)
		case "load":
			add(tui.Load)
		case "focus":
			add(tui.Focus)
		case "one":
			add(tui.One)
		case "zero":
			add(tui.Zero)
		case "alt-enter", "alt-return":
			chords[tui.CtrlAltKey('m')] = key
		case "alt-space":
			chords[tui.AltKey(' ')] = key
		case "alt-bs", "alt-bspace":
			add(tui.AltBS)
		case "alt-up":
			add(tui.AltUp)
		case "alt-down":
			add(tui.AltDown)
		case "alt-left":
			add(tui.AltLeft)
		case "alt-right":
			add(tui.AltRight)
		case "tab":
			add(tui.Tab)
		case "btab", "shift-tab":
			add(tui.BTab)
		case "esc":
			add(tui.ESC)
		case "del":
			add(tui.Del)
		case "home":
			add(tui.Home)
		case "end":
			add(tui.End)
		case "insert":
			add(tui.Insert)
		case "pgup", "page-up":
			add(tui.PgUp)
		case "pgdn", "page-down":
			add(tui.PgDn)
		case "alt-shift-up", "shift-alt-up":
			add(tui.AltSUp)
		case "alt-shift-down", "shift-alt-down":
			add(tui.AltSDown)
		case "alt-shift-left", "shift-alt-left":
			add(tui.AltSLeft)
		case "alt-shift-right", "shift-alt-right":
			add(tui.AltSRight)
		case "shift-up":
			add(tui.SUp)
		case "shift-down":
			add(tui.SDown)
		case "shift-left":
			add(tui.SLeft)
		case "shift-right":
			add(tui.SRight)
		case "shift-delete":
			add(tui.SDelete)
		case "left-click":
			add(tui.LeftClick)
		case "right-click":
			add(tui.RightClick)
		case "double-click":
			add(tui.DoubleClick)
		case "f10":
			add(tui.F10)
		case "f11":
			add(tui.F11)
		case "f12":
			add(tui.F12)
		default:
			runes := []rune(key)
			if len(key) == 10 && strings.HasPrefix(lkey, "ctrl-alt-") && isAlphabet(lkey[9]) {
				chords[tui.CtrlAltKey(rune(key[9]))] = key
			} else if len(key) == 6 && strings.HasPrefix(lkey, "ctrl-") && isAlphabet(lkey[5]) {
				add(tui.EventType(tui.CtrlA.Int() + int(lkey[5]) - 'a'))
			} else if len(runes) == 5 && strings.HasPrefix(lkey, "alt-") {
				r := runes[4]
				switch r {
				case escapedColon:
					r = ':'
				case escapedComma:
					r = ','
				case escapedPlus:
					r = '+'
				}
				chords[tui.AltKey(r)] = key
			} else if len(key) == 2 && strings.HasPrefix(lkey, "f") && key[1] >= '1' && key[1] <= '9' {
				add(tui.EventType(tui.F1.Int() + int(key[1]) - '1'))
			} else if len(runes) == 1 {
				chords[tui.Key(runes[0])] = key
			} else {
				exit("unsupported key: " + key)
				return nil
			}
		}
	}
	return chords
}

func parseTiebreak(str string) []criterion {
	criteria := []criterion{byScore}
	hasIndex := false
	hasChunk := false
	hasLength := false
	hasBegin := false
	hasEnd := false
	check := func(notExpected *bool, name string) {
		if *notExpected {
			errorExit("duplicate sort criteria: " + name)
		}
		if hasIndex {
			errorExit("index should be the last criterion")
		}
		*notExpected = true
	}
	for _, str := range strings.Split(strings.ToLower(str), ",") {
		switch str {
		case "index":
			check(&hasIndex, "index")
		case "chunk":
			check(&hasChunk, "chunk")
			criteria = append(criteria, byChunk)
		case "length":
			check(&hasLength, "length")
			criteria = append(criteria, byLength)
		case "begin":
			check(&hasBegin, "begin")
			criteria = append(criteria, byBegin)
		case "end":
			check(&hasEnd, "end")
			criteria = append(criteria, byEnd)
		default:
			errorExit("invalid sort criterion: " + str)
		}
	}
	if len(criteria) > 4 {
		errorExit("at most 3 tiebreaks are allowed: " + str)
	}
	return criteria
}

func dupeTheme(theme *tui.ColorTheme) *tui.ColorTheme {
	dupe := *theme
	return &dupe
}

func parseTheme(defaultTheme *tui.ColorTheme, str string) *tui.ColorTheme {
	theme := dupeTheme(defaultTheme)
	rrggbb := regexp.MustCompile("^#[0-9a-fA-F]{6}$")
	for _, str := range strings.Split(strings.ToLower(str), ",") {
		switch str {
		case "dark":
			theme = dupeTheme(tui.Dark256)
		case "light":
			theme = dupeTheme(tui.Light256)
		case "16":
			theme = dupeTheme(tui.Default16)
		case "bw", "no":
			theme = tui.NoColorTheme()
		default:
			fail := func() {
				errorExit("invalid color specification: " + str)
			}
			// Color is disabled
			if theme == nil {
				continue
			}

			components := strings.Split(str, ":")
			if len(components) < 2 {
				fail()
			}

			mergeAttr := func(cattr *tui.ColorAttr) {
				for _, component := range components[1:] {
					switch component {
					case "regular":
						cattr.Attr = tui.AttrRegular
					case "bold", "strong":
						cattr.Attr |= tui.Bold
					case "dim":
						cattr.Attr |= tui.Dim
					case "italic":
						cattr.Attr |= tui.Italic
					case "underline":
						cattr.Attr |= tui.Underline
					case "blink":
						cattr.Attr |= tui.Blink
					case "reverse":
						cattr.Attr |= tui.Reverse
					case "strikethrough":
						cattr.Attr |= tui.StrikeThrough
					case "black":
						cattr.Color = tui.Color(0)
					case "red":
						cattr.Color = tui.Color(1)
					case "green":
						cattr.Color = tui.Color(2)
					case "yellow":
						cattr.Color = tui.Color(3)
					case "blue":
						cattr.Color = tui.Color(4)
					case "magenta":
						cattr.Color = tui.Color(5)
					case "cyan":
						cattr.Color = tui.Color(6)
					case "white":
						cattr.Color = tui.Color(7)
					case "bright-black", "gray", "grey":
						cattr.Color = tui.Color(8)
					case "bright-red":
						cattr.Color = tui.Color(9)
					case "bright-green":
						cattr.Color = tui.Color(10)
					case "bright-yellow":
						cattr.Color = tui.Color(11)
					case "bright-blue":
						cattr.Color = tui.Color(12)
					case "bright-magenta":
						cattr.Color = tui.Color(13)
					case "bright-cyan":
						cattr.Color = tui.Color(14)
					case "bright-white":
						cattr.Color = tui.Color(15)
					case "":
					default:
						if rrggbb.MatchString(component) {
							cattr.Color = tui.HexToColor(component)
						} else {
							ansi32, err := strconv.Atoi(component)
							if err != nil || ansi32 < -1 || ansi32 > 255 {
								fail()
							}
							cattr.Color = tui.Color(ansi32)
						}
					}
				}
			}
			switch components[0] {
			case "query", "input":
				mergeAttr(&theme.Input)
			case "disabled":
				mergeAttr(&theme.Disabled)
			case "fg":
				mergeAttr(&theme.Fg)
			case "bg":
				mergeAttr(&theme.Bg)
			case "preview-fg":
				mergeAttr(&theme.PreviewFg)
			case "preview-bg":
				mergeAttr(&theme.PreviewBg)
			case "fg+":
				mergeAttr(&theme.Current)
			case "bg+":
				mergeAttr(&theme.DarkBg)
			case "gutter":
				mergeAttr(&theme.Gutter)
			case "hl":
				mergeAttr(&theme.Match)
			case "hl+":
				mergeAttr(&theme.CurrentMatch)
			case "border":
				mergeAttr(&theme.Border)
			case "preview-border":
				mergeAttr(&theme.PreviewBorder)
			case "separator":
				mergeAttr(&theme.Separator)
			case "scrollbar":
				mergeAttr(&theme.Scrollbar)
			case "preview-scrollbar":
				mergeAttr(&theme.PreviewScrollbar)
			case "label":
				mergeAttr(&theme.BorderLabel)
			case "preview-label":
				mergeAttr(&theme.PreviewLabel)
			case "prompt":
				mergeAttr(&theme.Prompt)
			case "spinner":
				mergeAttr(&theme.Spinner)
			case "info":
				mergeAttr(&theme.Info)
			case "pointer":
				mergeAttr(&theme.Cursor)
			case "marker":
				mergeAttr(&theme.Selected)
			case "header":
				mergeAttr(&theme.Header)
			default:
				fail()
			}
		}
	}
	return theme
}

var (
	executeRegexp    *regexp.Regexp
	splitRegexp      *regexp.Regexp
	actionNameRegexp *regexp.Regexp
)

func firstKey(keymap map[tui.Event]string) tui.Event {
	for k := range keymap {
		return k
	}
	return tui.EventType(0).AsEvent()
}

const (
	escapedColon = 0
	escapedComma = 1
	escapedPlus  = 2
)

func init() {
	executeRegexp = regexp.MustCompile(
		`(?si)[:+](become|execute(?:-multi|-silent)?|reload(?:-sync)?|preview|(?:change|transform)-(?:header|query|prompt|border-label|preview-label)|change-preview-window|change-preview|(?:re|un)bind|pos|put)`)
	splitRegexp = regexp.MustCompile("[,:]+")
	actionNameRegexp = regexp.MustCompile("(?i)^[a-z-]+")
}

func maskActionContents(action string) string {
	masked := ""
Loop:
	for len(action) > 0 {
		loc := executeRegexp.FindStringIndex(action)
		if loc == nil {
			masked += action
			break
		}
		masked += action[:loc[1]]
		action = action[loc[1]:]
		if len(action) == 0 {
			break
		}
		cs := string(action[0])
		ce := ")"
		switch action[0] {
		case ':':
			masked += strings.Repeat(" ", len(action))
			break Loop
		case '(':
			ce = ")"
		case '{':
			ce = "}"
		case '[':
			ce = "]"
		case '<':
			ce = ">"
		case '~', '!', '@', '#', '$', '%', '^', '&', '*', ';', '/', '|':
			ce = string(cs)
		default:
			continue
		}
		cs = regexp.QuoteMeta(cs)
		ce = regexp.QuoteMeta(ce)

		// @$ or @+
		loc = regexp.MustCompile(fmt.Sprintf(`(?s)^%s.*?(%s[+,]|%s$)`, cs, ce, ce)).FindStringIndex(action)
		if loc == nil {
			masked += action
			break
		}
		// Keep + or , at the end
		lastChar := action[loc[1]-1]
		if lastChar == '+' || lastChar == ',' {
			loc[1]--
		}
		masked += strings.Repeat(" ", loc[1])
		action = action[loc[1]:]
	}
	masked = strings.Replace(masked, "::", string([]rune{escapedColon, ':'}), -1)
	masked = strings.Replace(masked, ",:", string([]rune{escapedComma, ':'}), -1)
	masked = strings.Replace(masked, "+:", string([]rune{escapedPlus, ':'}), -1)
	return masked
}

func parseSingleActionList(str string, exit func(string)) []*action {
	// We prepend a colon to satisfy executeRegexp and remove it later
	masked := maskActionContents(":" + str)[1:]
	return parseActionList(masked, str, []*action{}, false, exit)
}

func parseActionList(masked string, original string, prevActions []*action, putAllowed bool, exit func(string)) []*action {
	maskedStrings := strings.Split(masked, "+")
	originalStrings := make([]string, len(maskedStrings))
	idx := 0
	for i, maskedString := range maskedStrings {
		originalStrings[i] = original[idx : idx+len(maskedString)]
		idx += len(maskedString) + 1
	}
	actions := make([]*action, 0, len(maskedStrings))
	appendAction := func(types ...actionType) {
		actions = append(actions, toActions(types...)...)
	}
	prevSpec := ""
	for specIndex, spec := range originalStrings {
		spec = prevSpec + spec
		specLower := strings.ToLower(spec)
		switch specLower {
		case "ignore":
			appendAction(actIgnore)
		case "beginning-of-line":
			appendAction(actBeginningOfLine)
		case "abort":
			appendAction(actAbort)
		case "accept":
			appendAction(actAccept)
		case "accept-non-empty":
			appendAction(actAcceptNonEmpty)
		case "print-query":
			appendAction(actPrintQuery)
		case "refresh-preview":
			appendAction(actRefreshPreview)
		case "replace-query":
			appendAction(actReplaceQuery)
		case "backward-char":
			appendAction(actBackwardChar)
		case "backward-delete-char":
			appendAction(actBackwardDeleteChar)
		case "backward-delete-char/eof":
			appendAction(actBackwardDeleteCharEOF)
		case "backward-word":
			appendAction(actBackwardWord)
		case "clear-screen":
			appendAction(actClearScreen)
		case "delete-char":
			appendAction(actDeleteChar)
		case "delete-char/eof":
			appendAction(actDeleteCharEOF)
		case "deselect":
			appendAction(actDeselect)
		case "end-of-line":
			appendAction(actEndOfLine)
		case "cancel":
			appendAction(actCancel)
		case "clear-query":
			appendAction(actClearQuery)
		case "clear-selection":
			appendAction(actClearSelection)
		case "forward-char":
			appendAction(actForwardChar)
		case "forward-word":
			appendAction(actForwardWord)
		case "jump":
			appendAction(actJump)
		case "jump-accept":
			appendAction(actJumpAccept)
		case "kill-line":
			appendAction(actKillLine)
		case "kill-word":
			appendAction(actKillWord)
		case "unix-line-discard", "line-discard":
			appendAction(actUnixLineDiscard)
		case "unix-word-rubout", "word-rubout":
			appendAction(actUnixWordRubout)
		case "yank":
			appendAction(actYank)
		case "backward-kill-word":
			appendAction(actBackwardKillWord)
		case "toggle-down":
			appendAction(actToggle, actDown)
		case "toggle-up":
			appendAction(actToggle, actUp)
		case "toggle-in":
			appendAction(actToggleIn)
		case "toggle-out":
			appendAction(actToggleOut)
		case "toggle-all":
			appendAction(actToggleAll)
		case "toggle-search":
			appendAction(actToggleSearch)
		case "toggle-track":
			appendAction(actToggleTrack)
		case "track":
			appendAction(actTrack)
		case "select":
			appendAction(actSelect)
		case "select-all":
			appendAction(actSelectAll)
		case "deselect-all":
			appendAction(actDeselectAll)
		case "close":
			appendAction(actClose)
		case "toggle":
			appendAction(actToggle)
		case "down":
			appendAction(actDown)
		case "up":
			appendAction(actUp)
		case "first", "top":
			appendAction(actFirst)
		case "last":
			appendAction(actLast)
		case "page-up":
			appendAction(actPageUp)
		case "page-down":
			appendAction(actPageDown)
		case "half-page-up":
			appendAction(actHalfPageUp)
		case "half-page-down":
			appendAction(actHalfPageDown)
		case "prev-history", "previous-history":
			appendAction(actPrevHistory)
		case "next-history":
			appendAction(actNextHistory)
		case "prev-selected":
			appendAction(actPrevSelected)
		case "next-selected":
			appendAction(actNextSelected)
		case "show-preview":
			appendAction(actShowPreview)
		case "hide-preview":
			appendAction(actHidePreview)
		case "toggle-preview":
			appendAction(actTogglePreview)
		case "toggle-preview-wrap":
			appendAction(actTogglePreviewWrap)
		case "toggle-sort":
			appendAction(actToggleSort)
		case "preview-top":
			appendAction(actPreviewTop)
		case "preview-bottom":
			appendAction(actPreviewBottom)
		case "preview-up":
			appendAction(actPreviewUp)
		case "preview-down":
			appendAction(actPreviewDown)
		case "preview-page-up":
			appendAction(actPreviewPageUp)
		case "preview-page-down":
			appendAction(actPreviewPageDown)
		case "preview-half-page-up":
			appendAction(actPreviewHalfPageUp)
		case "preview-half-page-down":
			appendAction(actPreviewHalfPageDown)
		case "enable-search":
			appendAction(actEnableSearch)
		case "disable-search":
			appendAction(actDisableSearch)
		case "put":
			if putAllowed {
				appendAction(actRune)
			} else {
				exit("unable to put non-printable character")
			}
		default:
			t := isExecuteAction(specLower)
			if t == actIgnore {
				if specIndex == 0 && specLower == "" {
					actions = append(prevActions, actions...)
				} else {
					exit("unknown action: " + spec)
				}
			} else {
				offset := len(actionNameRegexp.FindString(spec))
				var actionArg string
				if spec[offset] == ':' {
					if specIndex == len(originalStrings)-1 {
						actionArg = spec[offset+1:]
						actions = append(actions, &action{t: t, a: actionArg})
					} else {
						prevSpec = spec + "+"
						continue
					}
				} else {
					actionArg = spec[offset+1 : len(spec)-1]
					actions = append(actions, &action{t: t, a: actionArg})
				}
				switch t {
				case actBecome:
					if util.IsWindows() {
						exit("become action is not supported on Windows")
					}
				case actUnbind, actRebind:
					parseKeyChordsImpl(actionArg, spec[0:offset]+" target required", exit)
				case actChangePreviewWindow:
					opts := previewOpts{}
					for _, arg := range strings.Split(actionArg, "|") {
						// Make sure that each expression is valid
						parsePreviewWindowImpl(&opts, arg, exit)
					}
				}
			}
		}
		prevSpec = ""
	}
	return actions
}

func parseKeymap(keymap map[tui.Event][]*action, str string, exit func(string)) {
	masked := maskActionContents(str)
	idx := 0
	for _, pairStr := range strings.Split(masked, ",") {
		origPairStr := str[idx : idx+len(pairStr)]
		idx += len(pairStr) + 1

		pair := strings.SplitN(pairStr, ":", 2)
		if len(pair) < 2 {
			exit("bind action not specified: " + origPairStr)
		}
		var key tui.Event
		if len(pair[0]) == 1 && pair[0][0] == escapedColon {
			key = tui.Key(':')
		} else if len(pair[0]) == 1 && pair[0][0] == escapedComma {
			key = tui.Key(',')
		} else if len(pair[0]) == 1 && pair[0][0] == escapedPlus {
			key = tui.Key('+')
		} else {
			keys := parseKeyChordsImpl(pair[0], "key name required", exit)
			key = firstKey(keys)
		}
		putAllowed := key.Type == tui.Rune && unicode.IsGraphic(key.Char)
		keymap[key] = parseActionList(pair[1], origPairStr[len(pair[0])+1:], keymap[key], putAllowed, exit)
	}
}

func isExecuteAction(str string) actionType {
	masked := maskActionContents(":" + str)[1:]
	if masked == str {
		// Not masked
		return actIgnore
	}

	prefix := actionNameRegexp.FindString(str)
	switch prefix {
	case "become":
		return actBecome
	case "reload":
		return actReload
	case "reload-sync":
		return actReloadSync
	case "unbind":
		return actUnbind
	case "rebind":
		return actRebind
	case "preview":
		return actPreview
	case "change-border-label":
		return actChangeBorderLabel
	case "change-header":
		return actChangeHeader
	case "change-preview-label":
		return actChangePreviewLabel
	case "change-preview-window":
		return actChangePreviewWindow
	case "change-preview":
		return actChangePreview
	case "change-prompt":
		return actChangePrompt
	case "change-query":
		return actChangeQuery
	case "pos":
		return actPosition
	case "execute":
		return actExecute
	case "execute-silent":
		return actExecuteSilent
	case "execute-multi":
		return actExecuteMulti
	case "put":
		return actPut
	case "transform-border-label":
		return actTransformBorderLabel
	case "transform-preview-label":
		return actTransformPreviewLabel
	case "transform-header":
		return actTransformHeader
	case "transform-prompt":
		return actTransformPrompt
	case "transform-query":
		return actTransformQuery
	}
	return actIgnore
}

func parseToggleSort(keymap map[tui.Event][]*action, str string) {
	keys := parseKeyChords(str, "key name required")
	if len(keys) != 1 {
		errorExit("multiple keys specified")
	}
	keymap[firstKey(keys)] = toActions(actToggleSort)
}

func strLines(str string) []string {
	return strings.Split(strings.TrimSuffix(str, "\n"), "\n")
}

func parseSize(str string, maxPercent float64, label string) sizeSpec {
	var val float64
	percent := strings.HasSuffix(str, "%")
	if percent {
		val = atof(str[:len(str)-1])
		if val < 0 {
			errorExit(label + " must be non-negative")
		}
		if val > maxPercent {
			errorExit(fmt.Sprintf("%s too large (max: %d%%)", label, int(maxPercent)))
		}
	} else {
		if strings.Contains(str, ".") {
			errorExit(label + " (without %) must be a non-negative integer")
		}

		val = float64(atoi(str))
		if val < 0 {
			errorExit(label + " must be non-negative")
		}
	}
	return sizeSpec{val, percent}
}

func parseHeight(str string) heightSpec {
	heightSpec := heightSpec{}
	if strings.HasPrefix(str, "~") {
		heightSpec.auto = true
		str = str[1:]
	}

	size := parseSize(str, 100, "height")
	heightSpec.size = size.size
	heightSpec.percent = size.percent
	return heightSpec
}

func parseLayout(str string) layoutType {
	switch str {
	case "default":
		return layoutDefault
	case "reverse":
		return layoutReverse
	case "reverse-list":
		return layoutReverseList
	default:
		errorExit("invalid layout (expected: default / reverse / reverse-list)")
	}
	return layoutDefault
}

func parseInfoStyle(str string) (infoStyle, string) {
	switch str {
	case "default":
		return infoDefault, ""
	case "right":
		return infoRight, ""
	case "inline":
		return infoInline, defaultInfoSep
	case "inline-right":
		return infoInlineRight, ""
	case "hidden":
		return infoHidden, ""
	default:
		prefix := "inline:"
		if strings.HasPrefix(str, prefix) {
			return infoInline, strings.ReplaceAll(str[len(prefix):], "\n", " ")
		}
		errorExit("invalid info style (expected: default|right|hidden|inline[:SEPARATOR]|inline-right)")
	}
	return infoDefault, ""
}

func parsePreviewWindow(opts *previewOpts, input string) {
	parsePreviewWindowImpl(opts, input, errorExit)
}

func parsePreviewWindowImpl(opts *previewOpts, input string, exit func(string)) {
	tokenRegex := regexp.MustCompile(`[:,]*(<([1-9][0-9]*)\(([^)<]+)\)|[^,:]+)`)
	sizeRegex := regexp.MustCompile("^[0-9]+%?$")
	offsetRegex := regexp.MustCompile(`^(\+{-?[0-9]+})?([+-][0-9]+)*(-?/[1-9][0-9]*)?$`)
	headerRegex := regexp.MustCompile("^~(0|[1-9][0-9]*)$")
	tokens := tokenRegex.FindAllStringSubmatch(input, -1)
	var alternative string
	for _, match := range tokens {
		if len(match[2]) > 0 {
			opts.threshold = atoi(match[2])
			alternative = match[3]
			continue
		}
		token := match[1]
		switch token {
		case "":
		case "default":
			*opts = defaultPreviewOpts(opts.command)
		case "hidden":
			opts.hidden = true
		case "nohidden":
			opts.hidden = false
		case "wrap":
			opts.wrap = true
		case "nowrap":
			opts.wrap = false
		case "cycle":
			opts.cycle = true
		case "nocycle":
			opts.cycle = false
		case "up", "top":
			opts.position = posUp
		case "down", "bottom":
			opts.position = posDown
		case "left":
			opts.position = posLeft
		case "right":
			opts.position = posRight
		case "rounded", "border", "border-rounded":
			opts.border = tui.BorderRounded
		case "sharp", "border-sharp":
			opts.border = tui.BorderSharp
		case "border-bold":
			opts.border = tui.BorderBold
		case "border-block":
			opts.border = tui.BorderBlock
		case "border-thinblock":
			opts.border = tui.BorderThinBlock
		case "border-double":
			opts.border = tui.BorderDouble
		case "noborder", "border-none":
			opts.border = tui.BorderNone
		case "border-horizontal":
			opts.border = tui.BorderHorizontal
		case "border-vertical":
			opts.border = tui.BorderVertical
		case "border-up", "border-top":
			opts.border = tui.BorderTop
		case "border-down", "border-bottom":
			opts.border = tui.BorderBottom
		case "border-left":
			opts.border = tui.BorderLeft
		case "border-right":
			opts.border = tui.BorderRight
		case "follow":
			opts.follow = true
		case "nofollow":
			opts.follow = false
		default:
			if headerRegex.MatchString(token) {
				opts.headerLines = atoi(token[1:])
			} else if sizeRegex.MatchString(token) {
				opts.size = parseSize(token, 99, "window size")
			} else if offsetRegex.MatchString(token) {
				opts.scroll = token
			} else {
				exit("invalid preview window option: " + token)
				return
			}
		}
	}
	if len(alternative) > 0 {
		alternativeOpts := *opts
		opts.alternative = &alternativeOpts
		opts.alternative.hidden = false
		opts.alternative.alternative = nil
		parsePreviewWindowImpl(opts.alternative, alternative, exit)
	}
}

func parseMargin(opt string, margin string) [4]sizeSpec {
	margins := strings.Split(margin, ",")
	checked := func(str string) sizeSpec {
		return parseSize(str, 49, opt)
	}
	switch len(margins) {
	case 1:
		m := checked(margins[0])
		return [4]sizeSpec{m, m, m, m}
	case 2:
		tb := checked(margins[0])
		rl := checked(margins[1])
		return [4]sizeSpec{tb, rl, tb, rl}
	case 3:
		t := checked(margins[0])
		rl := checked(margins[1])
		b := checked(margins[2])
		return [4]sizeSpec{t, rl, b, rl}
	case 4:
		return [4]sizeSpec{
			checked(margins[0]), checked(margins[1]),
			checked(margins[2]), checked(margins[3])}
	default:
		errorExit("invalid " + opt + ": " + margin)
	}
	return defaultMargin()
}

func parseOptions(opts *Options, allArgs []string) {
	var historyMax int
	if opts.History == nil {
		historyMax = defaultHistoryMax
	} else {
		historyMax = opts.History.maxSize
	}
	setHistory := func(path string) {
		h, e := NewHistory(path, historyMax)
		if e != nil {
			errorExit(e.Error())
		}
		opts.History = h
	}
	setHistoryMax := func(max int) {
		historyMax = max
		if historyMax < 1 {
			errorExit("history max must be a positive integer")
		}
		if opts.History != nil {
			opts.History.maxSize = historyMax
		}
	}
	validateJumpLabels := false
	validatePointer := false
	validateMarker := false
	for i := 0; i < len(allArgs); i++ {
		arg := allArgs[i]
		switch arg {
		case "-h", "--help":
			help(exitOk)
		case "-x", "--extended":
			opts.Extended = true
		case "-e", "--exact":
			opts.Fuzzy = false
		case "--extended-exact":
			// Note that we now don't have --no-extended-exact
			opts.Fuzzy = false
			opts.Extended = true
		case "+x", "--no-extended":
			opts.Extended = false
		case "+e", "--no-exact":
			opts.Fuzzy = true
		case "-q", "--query":
			opts.Query = nextString(allArgs, &i, "query string required")
		case "-f", "--filter":
			filter := nextString(allArgs, &i, "query string required")
			opts.Filter = &filter
		case "--literal":
			opts.Normalize = false
		case "--no-literal":
			opts.Normalize = true
		case "--algo":
			opts.FuzzyAlgo = parseAlgo(nextString(allArgs, &i, "algorithm required (v1|v2)"))
		case "--scheme":
			opts.Scheme = strings.ToLower(nextString(allArgs, &i, "scoring scheme required (default|path|history)"))
		case "--expect":
			for k, v := range parseKeyChords(nextString(allArgs, &i, "key names required"), "key names required") {
				opts.Expect[k] = v
			}
		case "--no-expect":
			opts.Expect = make(map[tui.Event]string)
		case "--enabled", "--no-phony":
			opts.Phony = false
		case "--disabled", "--phony":
			opts.Phony = true
		case "--tiebreak":
			opts.Criteria = parseTiebreak(nextString(allArgs, &i, "sort criterion required"))
		case "--bind":
			parseKeymap(opts.Keymap, nextString(allArgs, &i, "bind expression required"), errorExit)
		case "--color":
			_, spec := optionalNextString(allArgs, &i)
			if len(spec) == 0 {
				opts.Theme = tui.EmptyTheme()
			} else {
				opts.Theme = parseTheme(opts.Theme, spec)
			}
		case "--toggle-sort":
			parseToggleSort(opts.Keymap, nextString(allArgs, &i, "key name required"))
		case "-d", "--delimiter":
			opts.Delimiter = delimiterRegexp(nextString(allArgs, &i, "delimiter required"))
		case "-n", "--nth":
			opts.Nth = splitNth(nextString(allArgs, &i, "nth expression required"))
		case "--with-nth":
			opts.WithNth = splitNth(nextString(allArgs, &i, "nth expression required"))
		case "-s", "--sort":
			opts.Sort = optionalNumeric(allArgs, &i, 1)
		case "+s", "--no-sort":
			opts.Sort = 0
		case "--track":
			opts.Track = trackEnabled
		case "--no-track":
			opts.Track = trackDisabled
		case "--tac":
			opts.Tac = true
		case "--no-tac":
			opts.Tac = false
		case "-i":
			opts.Case = CaseIgnore
		case "+i":
			opts.Case = CaseRespect
		case "-m", "--multi":
			opts.Multi = optionalNumeric(allArgs, &i, maxMulti)
		case "+m", "--no-multi":
			opts.Multi = 0
		case "--ansi":
			opts.Ansi = true
		case "--no-ansi":
			opts.Ansi = false
		case "--no-mouse":
			opts.Mouse = false
		case "+c", "--no-color":
			opts.Theme = tui.NoColorTheme()
		case "+2", "--no-256":
			opts.Theme = tui.Default16
		case "--black":
			opts.Black = true
		case "--no-black":
			opts.Black = false
		case "--bold":
			opts.Bold = true
		case "--no-bold":
			opts.Bold = false
		case "--layout":
			opts.Layout = parseLayout(
				nextString(allArgs, &i, "layout required (default / reverse / reverse-list)"))
		case "--reverse":
			opts.Layout = layoutReverse
		case "--no-reverse":
			opts.Layout = layoutDefault
		case "--cycle":
			opts.Cycle = true
		case "--no-cycle":
			opts.Cycle = false
		case "--keep-right":
			opts.KeepRight = true
		case "--no-keep-right":
			opts.KeepRight = false
		case "--hscroll":
			opts.Hscroll = true
		case "--no-hscroll":
			opts.Hscroll = false
		case "--hscroll-off":
			opts.HscrollOff = nextInt(allArgs, &i, "hscroll offset required")
		case "--scroll-off":
			opts.ScrollOff = nextInt(allArgs, &i, "scroll offset required")
		case "--filepath-word":
			opts.FileWord = true
		case "--no-filepath-word":
			opts.FileWord = false
		case "--info":
			opts.InfoStyle, opts.InfoSep = parseInfoStyle(
				nextString(allArgs, &i, "info style required"))
		case "--no-info":
			opts.InfoStyle = infoHidden
		case "--inline-info":
			opts.InfoStyle = infoInline
			opts.InfoSep = defaultInfoSep
		case "--no-inline-info":
			opts.InfoStyle = infoDefault
		case "--separator":
			separator := nextString(allArgs, &i, "separator character required")
			opts.Separator = &separator
		case "--no-separator":
			nosep := ""
			opts.Separator = &nosep
		case "--scrollbar":
			given, bar := optionalNextString(allArgs, &i)
			if given {
				opts.Scrollbar = &bar
			} else {
				opts.Scrollbar = nil
			}
		case "--no-scrollbar":
			noBar := ""
			opts.Scrollbar = &noBar
		case "--jump-labels":
			opts.JumpLabels = nextString(allArgs, &i, "label characters required")
			validateJumpLabels = true
		case "-1", "--select-1":
			opts.Select1 = true
		case "+1", "--no-select-1":
			opts.Select1 = false
		case "-0", "--exit-0":
			opts.Exit0 = true
		case "+0", "--no-exit-0":
			opts.Exit0 = false
		case "--read0":
			opts.ReadZero = true
		case "--no-read0":
			opts.ReadZero = false
		case "--print0":
			opts.Printer = func(str string) { fmt.Print(str, "\x00") }
			opts.PrintSep = "\x00"
		case "--no-print0":
			opts.Printer = func(str string) { fmt.Println(str) }
			opts.PrintSep = "\n"
		case "--print-query":
			opts.PrintQuery = true
		case "--no-print-query":
			opts.PrintQuery = false
		case "--prompt":
			opts.Prompt = nextString(allArgs, &i, "prompt string required")
		case "--pointer":
			opts.Pointer = firstLine(nextString(allArgs, &i, "pointer sign string required"))
			validatePointer = true
		case "--marker":
			opts.Marker = firstLine(nextString(allArgs, &i, "selected sign string required"))
			validateMarker = true
		case "--sync":
			opts.Sync = true
		case "--no-sync":
			opts.Sync = false
		case "--async":
			opts.Sync = false
		case "--no-history":
			opts.History = nil
		case "--history":
			setHistory(nextString(allArgs, &i, "history file path required"))
		case "--history-size":
			setHistoryMax(nextInt(allArgs, &i, "history max size required"))
		case "--no-header":
			opts.Header = []string{}
		case "--no-header-lines":
			opts.HeaderLines = 0
		case "--header":
			opts.Header = strLines(nextString(allArgs, &i, "header string required"))
		case "--header-lines":
			opts.HeaderLines = atoi(
				nextString(allArgs, &i, "number of header lines required"))
		case "--header-first":
			opts.HeaderFirst = true
		case "--no-header-first":
			opts.HeaderFirst = false
		case "--ellipsis":
			opts.Ellipsis = nextString(allArgs, &i, "ellipsis string required")
		case "--preview":
			opts.Preview.command = nextString(allArgs, &i, "preview command required")
		case "--no-preview":
			opts.Preview.command = ""
		case "--preview-window":
			parsePreviewWindow(&opts.Preview,
				nextString(allArgs, &i, "preview window layout required: [up|down|left|right][,SIZE[%]][,border-BORDER_OPT][,wrap][,cycle][,hidden][,+SCROLL[OFFSETS][/DENOM]][,~HEADER_LINES][,default]"))
		case "--height":
			opts.Height = parseHeight(nextString(allArgs, &i, "height required: [~]HEIGHT[%]"))
		case "--min-height":
			opts.MinHeight = nextInt(allArgs, &i, "height required: HEIGHT")
		case "--no-height":
			opts.Height = heightSpec{}
		case "--no-margin":
			opts.Margin = defaultMargin()
		case "--no-padding":
			opts.Padding = defaultMargin()
		case "--no-border":
			opts.BorderShape = tui.BorderNone
		case "--border":
			hasArg, arg := optionalNextString(allArgs, &i)
			opts.BorderShape = parseBorder(arg, !hasArg)
		case "--no-border-label":
			opts.BorderLabel.label = ""
		case "--border-label":
			opts.BorderLabel.label = nextString(allArgs, &i, "label required")
		case "--border-label-pos":
			pos := nextString(allArgs, &i, "label position required (positive or negative integer or 'center')")
			parseLabelPosition(&opts.BorderLabel, pos)
		case "--no-preview-label":
			opts.PreviewLabel.label = ""
		case "--preview-label":
			opts.PreviewLabel.label = nextString(allArgs, &i, "preview label required")
		case "--preview-label-pos":
			pos := nextString(allArgs, &i, "preview label position required (positive or negative integer or 'center')")
			parseLabelPosition(&opts.PreviewLabel, pos)
		case "--no-unicode":
			opts.Unicode = false
		case "--unicode":
			opts.Unicode = true
		case "--margin":
			opts.Margin = parseMargin(
				"margin",
				nextString(allArgs, &i, "margin required (TRBL / TB,RL / T,RL,B / T,R,B,L)"))
		case "--padding":
			opts.Padding = parseMargin(
				"padding",
				nextString(allArgs, &i, "padding required (TRBL / TB,RL / T,RL,B / T,R,B,L)"))
		case "--tabstop":
			opts.Tabstop = nextInt(allArgs, &i, "tab stop required")
		case "--listen":
			port := optionalNumeric(allArgs, &i, 0)
			opts.ListenPort = &port
		case "--no-listen":
			opts.ListenPort = nil
		case "--clear":
			opts.ClearOnExit = true
		case "--no-clear":
			opts.ClearOnExit = false
		case "--version":
			opts.Version = true
		case "--":
			// Ignored
		default:
			if match, value := optString(arg, "--algo="); match {
				opts.FuzzyAlgo = parseAlgo(value)
			} else if match, value := optString(arg, "--scheme="); match {
				opts.Scheme = strings.ToLower(value)
			} else if match, value := optString(arg, "-q", "--query="); match {
				opts.Query = value
			} else if match, value := optString(arg, "-f", "--filter="); match {
				opts.Filter = &value
			} else if match, value := optString(arg, "-d", "--delimiter="); match {
				opts.Delimiter = delimiterRegexp(value)
			} else if match, value := optString(arg, "--border="); match {
				opts.BorderShape = parseBorder(value, false)
			} else if match, value := optString(arg, "--border-label="); match {
				opts.BorderLabel.label = value
			} else if match, value := optString(arg, "--border-label-pos="); match {
				parseLabelPosition(&opts.BorderLabel, value)
			} else if match, value := optString(arg, "--preview-label="); match {
				opts.PreviewLabel.label = value
			} else if match, value := optString(arg, "--preview-label-pos="); match {
				parseLabelPosition(&opts.PreviewLabel, value)
			} else if match, value := optString(arg, "--prompt="); match {
				opts.Prompt = value
			} else if match, value := optString(arg, "--pointer="); match {
				opts.Pointer = firstLine(value)
				validatePointer = true
			} else if match, value := optString(arg, "--marker="); match {
				opts.Marker = firstLine(value)
				validateMarker = true
			} else if match, value := optString(arg, "-n", "--nth="); match {
				opts.Nth = splitNth(value)
			} else if match, value := optString(arg, "--with-nth="); match {
				opts.WithNth = splitNth(value)
			} else if match, _ := optString(arg, "-s", "--sort="); match {
				opts.Sort = 1 // Don't care
			} else if match, value := optString(arg, "-m", "--multi="); match {
				opts.Multi = atoi(value)
			} else if match, value := optString(arg, "--height="); match {
				opts.Height = parseHeight(value)
			} else if match, value := optString(arg, "--min-height="); match {
				opts.MinHeight = atoi(value)
			} else if match, value := optString(arg, "--layout="); match {
				opts.Layout = parseLayout(value)
			} else if match, value := optString(arg, "--info="); match {
				opts.InfoStyle, opts.InfoSep = parseInfoStyle(value)
			} else if match, value := optString(arg, "--separator="); match {
				opts.Separator = &value
			} else if match, value := optString(arg, "--scrollbar="); match {
				opts.Scrollbar = &value
			} else if match, value := optString(arg, "--toggle-sort="); match {
				parseToggleSort(opts.Keymap, value)
			} else if match, value := optString(arg, "--expect="); match {
				for k, v := range parseKeyChords(value, "key names required") {
					opts.Expect[k] = v
				}
			} else if match, value := optString(arg, "--tiebreak="); match {
				opts.Criteria = parseTiebreak(value)
			} else if match, value := optString(arg, "--color="); match {
				opts.Theme = parseTheme(opts.Theme, value)
			} else if match, value := optString(arg, "--bind="); match {
				parseKeymap(opts.Keymap, value, errorExit)
			} else if match, value := optString(arg, "--history="); match {
				setHistory(value)
			} else if match, value := optString(arg, "--history-size="); match {
				setHistoryMax(atoi(value))
			} else if match, value := optString(arg, "--header="); match {
				opts.Header = strLines(value)
			} else if match, value := optString(arg, "--header-lines="); match {
				opts.HeaderLines = atoi(value)
			} else if match, value := optString(arg, "--ellipsis="); match {
				opts.Ellipsis = value
			} else if match, value := optString(arg, "--preview="); match {
				opts.Preview.command = value
			} else if match, value := optString(arg, "--preview-window="); match {
				parsePreviewWindow(&opts.Preview, value)
			} else if match, value := optString(arg, "--margin="); match {
				opts.Margin = parseMargin("margin", value)
			} else if match, value := optString(arg, "--padding="); match {
				opts.Padding = parseMargin("padding", value)
			} else if match, value := optString(arg, "--tabstop="); match {
				opts.Tabstop = atoi(value)
			} else if match, value := optString(arg, "--listen="); match {
				port := atoi(value)
				opts.ListenPort = &port
			} else if match, value := optString(arg, "--hscroll-off="); match {
				opts.HscrollOff = atoi(value)
			} else if match, value := optString(arg, "--scroll-off="); match {
				opts.ScrollOff = atoi(value)
			} else if match, value := optString(arg, "--jump-labels="); match {
				opts.JumpLabels = value
				validateJumpLabels = true
			} else {
				errorExit("unknown option: " + arg)
			}
		}
	}

	if opts.HeaderLines < 0 {
		errorExit("header lines must be a non-negative integer")
	}

	if opts.HscrollOff < 0 {
		errorExit("hscroll offset must be a non-negative integer")
	}

	if opts.ScrollOff < 0 {
		errorExit("scroll offset must be a non-negative integer")
	}

	if opts.Tabstop < 1 {
		errorExit("tab stop must be a positive integer")
	}

	if opts.ListenPort != nil && (*opts.ListenPort < 0 || *opts.ListenPort > 65535) {
		errorExit("invalid listen port")
	}

	if len(opts.JumpLabels) == 0 {
		errorExit("empty jump labels")
	}

	if validateJumpLabels {
		for _, r := range opts.JumpLabels {
			if r < 32 || r > 126 {
				errorExit("non-ascii jump labels are not allowed")
			}
		}
	}

	if validatePointer {
		if err := validateSign(opts.Pointer, "pointer"); err != nil {
			errorExit(err.Error())
		}
	}

	if validateMarker {
		if err := validateSign(opts.Marker, "marker"); err != nil {
			errorExit(err.Error())
		}
	}
}

func validateSign(sign string, signOptName string) error {
	if sign == "" {
		return fmt.Errorf("%v cannot be empty", signOptName)
	}
	if runewidth.StringWidth(sign) > 2 {
		return fmt.Errorf("%v display width should be up to 2", signOptName)
	}
	return nil
}

func postProcessOptions(opts *Options) {
	if !opts.Version && !tui.IsLightRendererSupported() && opts.Height.size > 0 {
		errorExit("--height option is currently not supported on this platform")
	}

	if opts.Scrollbar != nil {
		runes := []rune(*opts.Scrollbar)
		if len(runes) > 2 {
			errorExit("--scrollbar should be given one or two characters")
		}
		for _, r := range runes {
			if runewidth.RuneWidth(r) != 1 {
				errorExit("scrollbar display width should be 1")
			}
		}
	}

	// Default actions for CTRL-N / CTRL-P when --history is set
	if opts.History != nil {
		if _, prs := opts.Keymap[tui.CtrlP.AsEvent()]; !prs {
			opts.Keymap[tui.CtrlP.AsEvent()] = toActions(actPrevHistory)
		}
		if _, prs := opts.Keymap[tui.CtrlN.AsEvent()]; !prs {
			opts.Keymap[tui.CtrlN.AsEvent()] = toActions(actNextHistory)
		}
	}

	// Extend the default key map
	keymap := defaultKeymap()
	for key, actions := range opts.Keymap {
		reordered := []*action{}
		for _, act := range actions {
			switch act.t {
			case actToggleSort:
				// To display "+S"/"-S" on info line
				opts.ToggleSort = true
			case actTogglePreview, actShowPreview, actHidePreview, actChangePreviewWindow:
				reordered = append(reordered, act)
			}
		}

		// Re-organize actions so that we put actions that change the preview window first in the list.
		//  *  change-preview-window(up,+10)+preview(sleep 3; cat {})+change-preview-window(up,+20)
		//  -> change-preview-window(up,+10)+change-preview-window(up,+20)+preview(sleep 3; cat {})
		if len(reordered) > 0 {
			for _, act := range actions {
				switch act.t {
				case actTogglePreview, actShowPreview, actHidePreview, actChangePreviewWindow:
				default:
					reordered = append(reordered, act)
				}
			}
			actions = reordered
		}
		keymap[key] = actions
	}
	opts.Keymap = keymap

	// If 'double-click' is left unbound, bind it to the action bound to 'enter'
	if _, prs := opts.Keymap[tui.DoubleClick.AsEvent()]; !prs {
		opts.Keymap[tui.DoubleClick.AsEvent()] = opts.Keymap[tui.CtrlM.AsEvent()]
	}

	if opts.Height.auto {
		for _, s := range []sizeSpec{opts.Margin[0], opts.Margin[2]} {
			if s.percent {
				errorExit("adaptive height is not compatible with top/bottom percent margin")
			}
		}
		for _, s := range []sizeSpec{opts.Padding[0], opts.Padding[2]} {
			if s.percent {
				errorExit("adaptive height is not compatible with top/bottom percent padding")
			}
		}
	}

	// If we're not using extended search mode, --nth option becomes irrelevant
	// if it contains the whole range
	if !opts.Extended || len(opts.Nth) == 1 {
		for _, r := range opts.Nth {
			if r.begin == rangeEllipsis && r.end == rangeEllipsis {
				opts.Nth = make([]Range, 0)
				return
			}
		}
	}

	if opts.Bold {
		theme := opts.Theme
		boldify := func(c tui.ColorAttr) tui.ColorAttr {
			dup := c
			if (c.Attr & tui.AttrRegular) == 0 {
				dup.Attr |= tui.Bold
			}
			return dup
		}
		theme.Current = boldify(theme.Current)
		theme.CurrentMatch = boldify(theme.CurrentMatch)
		theme.Prompt = boldify(theme.Prompt)
		theme.Input = boldify(theme.Input)
		theme.Cursor = boldify(theme.Cursor)
		theme.Spinner = boldify(theme.Spinner)
	}

	if opts.Scheme != "default" {
		processScheme(opts)
	}
}

func expectsArbitraryString(opt string) bool {
	switch opt {
	case "-q", "--query", "-f", "--filter", "--header", "--prompt":
		return true
	}
	return false
}

// ParseOptions parses command-line options
func ParseOptions() *Options {
	opts := defaultOptions()

	for idx, arg := range os.Args[1:] {
		if arg == "--version" && (idx == 0 || idx > 0 && !expectsArbitraryString(os.Args[idx])) {
			opts.Version = true
			return opts
		}
	}

	// Options from Env var
	words, _ := shellwords.Parse(os.Getenv("FZF_DEFAULT_OPTS"))
	if len(words) > 0 {
		parseOptions(opts, words)
	}

	// Options from command-line arguments
	parseOptions(opts, os.Args[1:])

	postProcessOptions(opts)
	return opts
}
./src/options_test.go	[[[1
510
package fzf

import (
	"fmt"
	"io/ioutil"
	"testing"

	"github.com/junegunn/fzf/src/tui"
)

func TestDelimiterRegex(t *testing.T) {
	// Valid regex
	delim := delimiterRegexp(".")
	if delim.regex == nil || delim.str != nil {
		t.Error(delim)
	}
	// Broken regex -> string
	delim = delimiterRegexp("[0-9")
	if delim.regex != nil || *delim.str != "[0-9" {
		t.Error(delim)
	}
	// Valid regex
	delim = delimiterRegexp("[0-9]")
	if delim.regex.String() != "[0-9]" || delim.str != nil {
		t.Error(delim)
	}
	// Tab character
	delim = delimiterRegexp("\t")
	if delim.regex != nil || *delim.str != "\t" {
		t.Error(delim)
	}
	// Tab expression
	delim = delimiterRegexp("\\t")
	if delim.regex != nil || *delim.str != "\t" {
		t.Error(delim)
	}
	// Tabs -> regex
	delim = delimiterRegexp("\t+")
	if delim.regex == nil || delim.str != nil {
		t.Error(delim)
	}
}

func TestDelimiterRegexString(t *testing.T) {
	delim := delimiterRegexp("*")
	tokens := Tokenize("-*--*---**---", delim)
	if delim.regex != nil ||
		tokens[0].text.ToString() != "-*" ||
		tokens[1].text.ToString() != "--*" ||
		tokens[2].text.ToString() != "---*" ||
		tokens[3].text.ToString() != "*" ||
		tokens[4].text.ToString() != "---" {
		t.Errorf("%s %v %d", delim, tokens, len(tokens))
	}
}

func TestDelimiterRegexRegex(t *testing.T) {
	delim := delimiterRegexp("--\\*")
	tokens := Tokenize("-*--*---**---", delim)
	if delim.str != nil ||
		tokens[0].text.ToString() != "-*--*" ||
		tokens[1].text.ToString() != "---*" ||
		tokens[2].text.ToString() != "*---" {
		t.Errorf("%s %d", tokens, len(tokens))
	}
}

func TestDelimiterRegexRegexCaret(t *testing.T) {
	delim := delimiterRegexp(`(^\s*|\s+)`)
	tokens := Tokenize("foo  bar baz", delim)
	if delim.str != nil ||
		len(tokens) != 4 ||
		tokens[0].text.ToString() != "" ||
		tokens[1].text.ToString() != "foo  " ||
		tokens[2].text.ToString() != "bar " ||
		tokens[3].text.ToString() != "baz" {
		t.Errorf("%s %d", tokens, len(tokens))
	}
}

func TestSplitNth(t *testing.T) {
	{
		ranges := splitNth("..")
		if len(ranges) != 1 ||
			ranges[0].begin != rangeEllipsis ||
			ranges[0].end != rangeEllipsis {
			t.Errorf("%v", ranges)
		}
	}
	{
		ranges := splitNth("..3,1..,2..3,4..-1,-3..-2,..,2,-2,2..-2,1..-1")
		if len(ranges) != 10 ||
			ranges[0].begin != rangeEllipsis || ranges[0].end != 3 ||
			ranges[1].begin != rangeEllipsis || ranges[1].end != rangeEllipsis ||
			ranges[2].begin != 2 || ranges[2].end != 3 ||
			ranges[3].begin != 4 || ranges[3].end != rangeEllipsis ||
			ranges[4].begin != -3 || ranges[4].end != -2 ||
			ranges[5].begin != rangeEllipsis || ranges[5].end != rangeEllipsis ||
			ranges[6].begin != 2 || ranges[6].end != 2 ||
			ranges[7].begin != -2 || ranges[7].end != -2 ||
			ranges[8].begin != 2 || ranges[8].end != -2 ||
			ranges[9].begin != rangeEllipsis || ranges[9].end != rangeEllipsis {
			t.Errorf("%v", ranges)
		}
	}
}

func TestIrrelevantNth(t *testing.T) {
	{
		opts := defaultOptions()
		words := []string{"--nth", "..", "-x"}
		parseOptions(opts, words)
		postProcessOptions(opts)
		if len(opts.Nth) != 0 {
			t.Errorf("nth should be empty: %v", opts.Nth)
		}
	}
	for _, words := range [][]string{{"--nth", "..,3", "+x"}, {"--nth", "3,1..", "+x"}, {"--nth", "..-1,1", "+x"}} {
		{
			opts := defaultOptions()
			parseOptions(opts, words)
			postProcessOptions(opts)
			if len(opts.Nth) != 0 {
				t.Errorf("nth should be empty: %v", opts.Nth)
			}
		}
		{
			opts := defaultOptions()
			words = append(words, "-x")
			parseOptions(opts, words)
			postProcessOptions(opts)
			if len(opts.Nth) != 2 {
				t.Errorf("nth should not be empty: %v", opts.Nth)
			}
		}
	}
}

func TestParseKeys(t *testing.T) {
	pairs := parseKeyChords("ctrl-z,alt-z,f2,@,Alt-a,!,ctrl-G,J,g,ctrl-alt-a,ALT-enter,alt-SPACE", "")
	checkEvent := func(e tui.Event, s string) {
		if pairs[e] != s {
			t.Errorf("%s != %s", pairs[e], s)
		}
	}
	check := func(et tui.EventType, s string) {
		checkEvent(et.AsEvent(), s)
	}
	if len(pairs) != 12 {
		t.Error(12)
	}
	check(tui.CtrlZ, "ctrl-z")
	check(tui.F2, "f2")
	check(tui.CtrlG, "ctrl-G")
	checkEvent(tui.AltKey('z'), "alt-z")
	checkEvent(tui.Key('@'), "@")
	checkEvent(tui.AltKey('a'), "Alt-a")
	checkEvent(tui.Key('!'), "!")
	checkEvent(tui.Key('J'), "J")
	checkEvent(tui.Key('g'), "g")
	checkEvent(tui.CtrlAltKey('a'), "ctrl-alt-a")
	checkEvent(tui.CtrlAltKey('m'), "ALT-enter")
	checkEvent(tui.AltKey(' '), "alt-SPACE")

	// Synonyms
	pairs = parseKeyChords("enter,Return,space,tab,btab,esc,up,down,left,right", "")
	if len(pairs) != 9 {
		t.Error(9)
	}
	check(tui.CtrlM, "Return")
	checkEvent(tui.Key(' '), "space")
	check(tui.Tab, "tab")
	check(tui.BTab, "btab")
	check(tui.ESC, "esc")
	check(tui.Up, "up")
	check(tui.Down, "down")
	check(tui.Left, "left")
	check(tui.Right, "right")

	pairs = parseKeyChords("Tab,Ctrl-I,PgUp,page-up,pgdn,Page-Down,Home,End,Alt-BS,Alt-BSpace,shift-left,shift-right,btab,shift-tab,return,Enter,bspace", "")
	if len(pairs) != 11 {
		t.Error(11)
	}
	check(tui.Tab, "Ctrl-I")
	check(tui.PgUp, "page-up")
	check(tui.PgDn, "Page-Down")
	check(tui.Home, "Home")
	check(tui.End, "End")
	check(tui.AltBS, "Alt-BSpace")
	check(tui.SLeft, "shift-left")
	check(tui.SRight, "shift-right")
	check(tui.BTab, "shift-tab")
	check(tui.CtrlM, "Enter")
	check(tui.BSpace, "bspace")
}

func TestParseKeysWithComma(t *testing.T) {
	checkN := func(a int, b int) {
		if a != b {
			t.Errorf("%d != %d", a, b)
		}
	}
	check := func(pairs map[tui.Event]string, e tui.Event, s string) {
		if pairs[e] != s {
			t.Errorf("%s != %s", pairs[e], s)
		}
	}

	pairs := parseKeyChords(",", "")
	checkN(len(pairs), 1)
	check(pairs, tui.Key(','), ",")

	pairs = parseKeyChords(",,a,b", "")
	checkN(len(pairs), 3)
	check(pairs, tui.Key('a'), "a")
	check(pairs, tui.Key('b'), "b")
	check(pairs, tui.Key(','), ",")

	pairs = parseKeyChords("a,b,,", "")
	checkN(len(pairs), 3)
	check(pairs, tui.Key('a'), "a")
	check(pairs, tui.Key('b'), "b")
	check(pairs, tui.Key(','), ",")

	pairs = parseKeyChords("a,,,b", "")
	checkN(len(pairs), 3)
	check(pairs, tui.Key('a'), "a")
	check(pairs, tui.Key('b'), "b")
	check(pairs, tui.Key(','), ",")

	pairs = parseKeyChords("a,,,b,c", "")
	checkN(len(pairs), 4)
	check(pairs, tui.Key('a'), "a")
	check(pairs, tui.Key('b'), "b")
	check(pairs, tui.Key('c'), "c")
	check(pairs, tui.Key(','), ",")

	pairs = parseKeyChords(",,,", "")
	checkN(len(pairs), 1)
	check(pairs, tui.Key(','), ",")

	pairs = parseKeyChords(",ALT-,,", "")
	checkN(len(pairs), 1)
	check(pairs, tui.AltKey(','), "ALT-,")
}

func TestBind(t *testing.T) {
	keymap := defaultKeymap()
	check := func(event tui.Event, arg1 string, types ...actionType) {
		if len(keymap[event]) != len(types) {
			t.Errorf("invalid number of actions for %v (%d != %d)",
				event, len(types), len(keymap[event]))
			return
		}
		for idx, action := range keymap[event] {
			if types[idx] != action.t {
				t.Errorf("invalid action type (%d != %d)", types[idx], action.t)
			}
		}
		if len(arg1) > 0 && keymap[event][0].a != arg1 {
			t.Errorf("invalid action argument: (%s != %s)", arg1, keymap[event][0].a)
		}
	}
	check(tui.CtrlA.AsEvent(), "", actBeginningOfLine)
	errorString := ""
	errorFn := func(e string) {
		errorString = e
	}
	parseKeymap(keymap,
		"ctrl-a:kill-line,ctrl-b:toggle-sort+up+down,c:page-up,alt-z:page-down,"+
			"f1:execute(ls {+})+abort+execute(echo \n{+})+select-all,f2:execute/echo {}, {}, {}/,f3:execute[echo '({})'],f4:execute;less {};,"+
			"alt-a:execute-Multi@echo (,),[,],/,:,;,%,{}@,alt-b:execute;echo (,),[,],/,:,@,%,{};,"+
			"x:Execute(foo+bar),X:execute/bar+baz/"+
			",f1:+first,f1:+top"+
			",,:abort,::accept,+:execute:++\nfoobar,Y:execute(baz)+up", errorFn)
	check(tui.CtrlA.AsEvent(), "", actKillLine)
	check(tui.CtrlB.AsEvent(), "", actToggleSort, actUp, actDown)
	check(tui.Key('c'), "", actPageUp)
	check(tui.Key(','), "", actAbort)
	check(tui.Key(':'), "", actAccept)
	check(tui.AltKey('z'), "", actPageDown)
	check(tui.F1.AsEvent(), "ls {+}", actExecute, actAbort, actExecute, actSelectAll, actFirst, actFirst)
	check(tui.F2.AsEvent(), "echo {}, {}, {}", actExecute)
	check(tui.F3.AsEvent(), "echo '({})'", actExecute)
	check(tui.F4.AsEvent(), "less {}", actExecute)
	check(tui.Key('x'), "foo+bar", actExecute)
	check(tui.Key('X'), "bar+baz", actExecute)
	check(tui.AltKey('a'), "echo (,),[,],/,:,;,%,{}", actExecuteMulti)
	check(tui.AltKey('b'), "echo (,),[,],/,:,@,%,{}", actExecute)
	check(tui.Key('+'), "++\nfoobar,Y:execute(baz)+up", actExecute)

	for idx, char := range []rune{'~', '!', '@', '#', '$', '%', '^', '&', '*', '|', ';', '/'} {
		parseKeymap(keymap, fmt.Sprintf("%d:execute%cfoobar%c", idx%10, char, char), errorFn)
		check(tui.Key([]rune(fmt.Sprintf("%d", idx%10))[0]), "foobar", actExecute)
	}

	parseKeymap(keymap, "f1:abort", errorFn)
	check(tui.F1.AsEvent(), "", actAbort)
	if len(errorString) > 0 {
		t.Errorf("error parsing keymap: %s", errorString)
	}
}

func TestColorSpec(t *testing.T) {
	theme := tui.Dark256
	dark := parseTheme(theme, "dark")
	if *dark != *theme {
		t.Errorf("colors should be equivalent")
	}
	if dark == theme {
		t.Errorf("point should not be equivalent")
	}

	light := parseTheme(theme, "dark,light")
	if *light == *theme {
		t.Errorf("should not be equivalent")
	}
	if *light != *tui.Light256 {
		t.Errorf("colors should be equivalent")
	}
	if light == theme {
		t.Errorf("point should not be equivalent")
	}

	customized := parseTheme(theme, "fg:231,bg:232")
	if customized.Fg.Color != 231 || customized.Bg.Color != 232 {
		t.Errorf("color not customized")
	}
	if *tui.Dark256 == *customized {
		t.Errorf("colors should not be equivalent")
	}
	customized.Fg = tui.Dark256.Fg
	customized.Bg = tui.Dark256.Bg
	if *tui.Dark256 != *customized {
		t.Errorf("colors should now be equivalent: %v, %v", tui.Dark256, customized)
	}

	customized = parseTheme(theme, "fg:231,dark,bg:232")
	if customized.Fg != tui.Dark256.Fg || customized.Bg == tui.Dark256.Bg {
		t.Errorf("color not customized")
	}
}

func TestDefaultCtrlNP(t *testing.T) {
	check := func(words []string, et tui.EventType, expected actionType) {
		e := et.AsEvent()
		opts := defaultOptions()
		parseOptions(opts, words)
		postProcessOptions(opts)
		if opts.Keymap[e][0].t != expected {
			t.Error()
		}
	}
	check([]string{}, tui.CtrlN, actDown)
	check([]string{}, tui.CtrlP, actUp)

	check([]string{"--bind=ctrl-n:accept"}, tui.CtrlN, actAccept)
	check([]string{"--bind=ctrl-p:accept"}, tui.CtrlP, actAccept)

	f, _ := ioutil.TempFile("", "fzf-history")
	f.Close()
	hist := "--history=" + f.Name()
	check([]string{hist}, tui.CtrlN, actNextHistory)
	check([]string{hist}, tui.CtrlP, actPrevHistory)

	check([]string{hist, "--bind=ctrl-n:accept"}, tui.CtrlN, actAccept)
	check([]string{hist, "--bind=ctrl-n:accept"}, tui.CtrlP, actPrevHistory)

	check([]string{hist, "--bind=ctrl-p:accept"}, tui.CtrlN, actNextHistory)
	check([]string{hist, "--bind=ctrl-p:accept"}, tui.CtrlP, actAccept)
}

func optsFor(words ...string) *Options {
	opts := defaultOptions()
	parseOptions(opts, words)
	postProcessOptions(opts)
	return opts
}

func TestToggle(t *testing.T) {
	opts := optsFor()
	if opts.ToggleSort {
		t.Error()
	}

	opts = optsFor("--bind=a:toggle-sort")
	if !opts.ToggleSort {
		t.Error()
	}

	opts = optsFor("--bind=a:toggle-sort", "--bind=a:up")
	if opts.ToggleSort {
		t.Error()
	}
}

func TestPreviewOpts(t *testing.T) {
	opts := optsFor()
	if !(opts.Preview.command == "" &&
		opts.Preview.hidden == false &&
		opts.Preview.wrap == false &&
		opts.Preview.position == posRight &&
		opts.Preview.size.percent == true &&
		opts.Preview.size.size == 50) {
		t.Error()
	}
	opts = optsFor("--preview", "cat {}", "--preview-window=left:15,hidden,wrap:+{1}-/2")
	if !(opts.Preview.command == "cat {}" &&
		opts.Preview.hidden == true &&
		opts.Preview.wrap == true &&
		opts.Preview.position == posLeft &&
		opts.Preview.scroll == "+{1}-/2" &&
		opts.Preview.size.percent == false &&
		opts.Preview.size.size == 15) {
		t.Error(opts.Preview)
	}
	opts = optsFor("--preview-window=up,15,wrap,hidden,+{1}+3-1-2/2", "--preview-window=down", "--preview-window=cycle")
	if !(opts.Preview.command == "" &&
		opts.Preview.hidden == true &&
		opts.Preview.wrap == true &&
		opts.Preview.cycle == true &&
		opts.Preview.position == posDown &&
		opts.Preview.scroll == "+{1}+3-1-2/2" &&
		opts.Preview.size.percent == false &&
		opts.Preview.size.size == 15) {
		t.Error(opts.Preview.size.size)
	}
	opts = optsFor("--preview-window=up:15:wrap:hidden")
	if !(opts.Preview.command == "" &&
		opts.Preview.hidden == true &&
		opts.Preview.wrap == true &&
		opts.Preview.position == posUp &&
		opts.Preview.size.percent == false &&
		opts.Preview.size.size == 15) {
		t.Error(opts.Preview)
	}
	opts = optsFor("--preview=foo", "--preview-window=up", "--preview-window=default:70%")
	if !(opts.Preview.command == "foo" &&
		opts.Preview.position == posRight &&
		opts.Preview.size.percent == true &&
		opts.Preview.size.size == 70) {
		t.Error(opts.Preview)
	}
}

func TestAdditiveExpect(t *testing.T) {
	opts := optsFor("--expect=a", "--expect", "b", "--expect=c")
	if len(opts.Expect) != 3 {
		t.Error(opts.Expect)
	}
}

func TestValidateSign(t *testing.T) {
	testCases := []struct {
		inputSign string
		isValid   bool
	}{
		{"> ", true},
		{"아", true},
		{"😀", true},
		{"", false},
		{">>>", false},
	}

	for _, testCase := range testCases {
		err := validateSign(testCase.inputSign, "")
		if testCase.isValid && err != nil {
			t.Errorf("Input sign `%s` caused error", testCase.inputSign)
		}

		if !testCase.isValid && err == nil {
			t.Errorf("Input sign `%s` did not cause error", testCase.inputSign)
		}
	}
}

func TestParseSingleActionList(t *testing.T) {
	actions := parseSingleActionList("Execute@foo+bar,baz@+up+up+reload:down+down", func(string) {})
	if len(actions) != 4 {
		t.Errorf("Invalid number of actions parsed:%d", len(actions))
	}
	if actions[0].t != actExecute || actions[0].a != "foo+bar,baz" {
		t.Errorf("Invalid action parsed: %v", actions[0])
	}
	if actions[1].t != actUp || actions[2].t != actUp {
		t.Errorf("Invalid action parsed: %v / %v", actions[1], actions[2])
	}
	if actions[3].t != actReload || actions[3].a != "down+down" {
		t.Errorf("Invalid action parsed: %v", actions[3])
	}
}

func TestParseSingleActionListError(t *testing.T) {
	err := ""
	parseSingleActionList("change-query(foobar)baz", func(e string) {
		err = e
	})
	if len(err) == 0 {
		t.Errorf("Failed to detect error")
	}
}

func TestMaskActionContents(t *testing.T) {
	original := ":execute((f)(o)(o)(b)(a)(r))+change-query@qu@ry@+up,x:reload:hello:world"
	expected := ":execute                    +change-query       +up,x:reload            "
	masked := maskActionContents(original)
	if masked != expected {
		t.Errorf("Not masked: %s", masked)
	}
}
./src/pattern.go	[[[1
427
package fzf

import (
	"fmt"
	"regexp"
	"strings"

	"github.com/junegunn/fzf/src/algo"
	"github.com/junegunn/fzf/src/util"
)

// fuzzy
// 'exact
// ^prefix-exact
// suffix-exact$
// !inverse-exact
// !'inverse-fuzzy
// !^inverse-prefix-exact
// !inverse-suffix-exact$

type termType int

const (
	termFuzzy termType = iota
	termExact
	termPrefix
	termSuffix
	termEqual
)

type term struct {
	typ           termType
	inv           bool
	text          []rune
	caseSensitive bool
	normalize     bool
}

// String returns the string representation of a term.
func (t term) String() string {
	return fmt.Sprintf("term{typ: %d, inv: %v, text: []rune(%q), caseSensitive: %v}", t.typ, t.inv, string(t.text), t.caseSensitive)
}

type termSet []term

// Pattern represents search pattern
type Pattern struct {
	fuzzy         bool
	fuzzyAlgo     algo.Algo
	extended      bool
	caseSensitive bool
	normalize     bool
	forward       bool
	withPos       bool
	text          []rune
	termSets      []termSet
	sortable      bool
	cacheable     bool
	cacheKey      string
	delimiter     Delimiter
	nth           []Range
	procFun       map[termType]algo.Algo
}

var (
	_patternCache map[string]*Pattern
	_splitRegex   *regexp.Regexp
	_cache        ChunkCache
)

func init() {
	_splitRegex = regexp.MustCompile(" +")
	clearPatternCache()
	clearChunkCache()
}

func clearPatternCache() {
	// We can uniquely identify the pattern for a given string since
	// search mode and caseMode do not change while the program is running
	_patternCache = make(map[string]*Pattern)
}

func clearChunkCache() {
	_cache = NewChunkCache()
}

// BuildPattern builds Pattern object from the given arguments
func BuildPattern(fuzzy bool, fuzzyAlgo algo.Algo, extended bool, caseMode Case, normalize bool, forward bool,
	withPos bool, cacheable bool, nth []Range, delimiter Delimiter, runes []rune) *Pattern {

	var asString string
	if extended {
		asString = strings.TrimLeft(string(runes), " ")
		for strings.HasSuffix(asString, " ") && !strings.HasSuffix(asString, "\\ ") {
			asString = asString[:len(asString)-1]
		}
	} else {
		asString = string(runes)
	}

	cached, found := _patternCache[asString]
	if found {
		return cached
	}

	caseSensitive := true
	sortable := true
	termSets := []termSet{}

	if extended {
		termSets = parseTerms(fuzzy, caseMode, normalize, asString)
		// We should not sort the result if there are only inverse search terms
		sortable = false
	Loop:
		for _, termSet := range termSets {
			for idx, term := range termSet {
				if !term.inv {
					sortable = true
				}
				// If the query contains inverse search terms or OR operators,
				// we cannot cache the search scope
				if !cacheable || idx > 0 || term.inv || fuzzy && term.typ != termFuzzy || !fuzzy && term.typ != termExact {
					cacheable = false
					if sortable {
						// Can't break until we see at least one non-inverse term
						break Loop
					}
				}
			}
		}
	} else {
		lowerString := strings.ToLower(asString)
		normalize = normalize &&
			lowerString == string(algo.NormalizeRunes([]rune(lowerString)))
		caseSensitive = caseMode == CaseRespect ||
			caseMode == CaseSmart && lowerString != asString
		if !caseSensitive {
			asString = lowerString
		}
	}

	ptr := &Pattern{
		fuzzy:         fuzzy,
		fuzzyAlgo:     fuzzyAlgo,
		extended:      extended,
		caseSensitive: caseSensitive,
		normalize:     normalize,
		forward:       forward,
		withPos:       withPos,
		text:          []rune(asString),
		termSets:      termSets,
		sortable:      sortable,
		cacheable:     cacheable,
		nth:           nth,
		delimiter:     delimiter,
		procFun:       make(map[termType]algo.Algo)}

	ptr.cacheKey = ptr.buildCacheKey()
	ptr.procFun[termFuzzy] = fuzzyAlgo
	ptr.procFun[termEqual] = algo.EqualMatch
	ptr.procFun[termExact] = algo.ExactMatchNaive
	ptr.procFun[termPrefix] = algo.PrefixMatch
	ptr.procFun[termSuffix] = algo.SuffixMatch

	_patternCache[asString] = ptr
	return ptr
}

func parseTerms(fuzzy bool, caseMode Case, normalize bool, str string) []termSet {
	str = strings.Replace(str, "\\ ", "\t", -1)
	tokens := _splitRegex.Split(str, -1)
	sets := []termSet{}
	set := termSet{}
	switchSet := false
	afterBar := false
	for _, token := range tokens {
		typ, inv, text := termFuzzy, false, strings.Replace(token, "\t", " ", -1)
		lowerText := strings.ToLower(text)
		caseSensitive := caseMode == CaseRespect ||
			caseMode == CaseSmart && text != lowerText
		normalizeTerm := normalize &&
			lowerText == string(algo.NormalizeRunes([]rune(lowerText)))
		if !caseSensitive {
			text = lowerText
		}
		if !fuzzy {
			typ = termExact
		}

		if len(set) > 0 && !afterBar && text == "|" {
			switchSet = false
			afterBar = true
			continue
		}
		afterBar = false

		if strings.HasPrefix(text, "!") {
			inv = true
			typ = termExact
			text = text[1:]
		}

		if text != "$" && strings.HasSuffix(text, "$") {
			typ = termSuffix
			text = text[:len(text)-1]
		}

		if strings.HasPrefix(text, "'") {
			// Flip exactness
			if fuzzy && !inv {
				typ = termExact
				text = text[1:]
			} else {
				typ = termFuzzy
				text = text[1:]
			}
		} else if strings.HasPrefix(text, "^") {
			if typ == termSuffix {
				typ = termEqual
			} else {
				typ = termPrefix
			}
			text = text[1:]
		}

		if len(text) > 0 {
			if switchSet {
				sets = append(sets, set)
				set = termSet{}
			}
			textRunes := []rune(text)
			if normalizeTerm {
				textRunes = algo.NormalizeRunes(textRunes)
			}
			set = append(set, term{
				typ:           typ,
				inv:           inv,
				text:          textRunes,
				caseSensitive: caseSensitive,
				normalize:     normalizeTerm})
			switchSet = true
		}
	}
	if len(set) > 0 {
		sets = append(sets, set)
	}
	return sets
}

// IsEmpty returns true if the pattern is effectively empty
func (p *Pattern) IsEmpty() bool {
	if !p.extended {
		return len(p.text) == 0
	}
	return len(p.termSets) == 0
}

// AsString returns the search query in string type
func (p *Pattern) AsString() string {
	return string(p.text)
}

func (p *Pattern) buildCacheKey() string {
	if !p.extended {
		return p.AsString()
	}
	cacheableTerms := []string{}
	for _, termSet := range p.termSets {
		if len(termSet) == 1 && !termSet[0].inv && (p.fuzzy || termSet[0].typ == termExact) {
			cacheableTerms = append(cacheableTerms, string(termSet[0].text))
		}
	}
	return strings.Join(cacheableTerms, "\t")
}

// CacheKey is used to build string to be used as the key of result cache
func (p *Pattern) CacheKey() string {
	return p.cacheKey
}

// Match returns the list of matches Items in the given Chunk
func (p *Pattern) Match(chunk *Chunk, slab *util.Slab) []Result {
	// ChunkCache: Exact match
	cacheKey := p.CacheKey()
	if p.cacheable {
		if cached := _cache.Lookup(chunk, cacheKey); cached != nil {
			return cached
		}
	}

	// Prefix/suffix cache
	space := _cache.Search(chunk, cacheKey)

	matches := p.matchChunk(chunk, space, slab)

	if p.cacheable {
		_cache.Add(chunk, cacheKey, matches)
	}
	return matches
}

func (p *Pattern) matchChunk(chunk *Chunk, space []Result, slab *util.Slab) []Result {
	matches := []Result{}

	if space == nil {
		for idx := 0; idx < chunk.count; idx++ {
			if match, _, _ := p.MatchItem(&chunk.items[idx], p.withPos, slab); match != nil {
				matches = append(matches, *match)
			}
		}
	} else {
		for _, result := range space {
			if match, _, _ := p.MatchItem(result.item, p.withPos, slab); match != nil {
				matches = append(matches, *match)
			}
		}
	}
	return matches
}

// MatchItem returns true if the Item is a match
func (p *Pattern) MatchItem(item *Item, withPos bool, slab *util.Slab) (*Result, []Offset, *[]int) {
	if p.extended {
		if offsets, bonus, pos := p.extendedMatch(item, withPos, slab); len(offsets) == len(p.termSets) {
			result := buildResult(item, offsets, bonus)
			return &result, offsets, pos
		}
		return nil, nil, nil
	}
	offset, bonus, pos := p.basicMatch(item, withPos, slab)
	if sidx := offset[0]; sidx >= 0 {
		offsets := []Offset{offset}
		result := buildResult(item, offsets, bonus)
		return &result, offsets, pos
	}
	return nil, nil, nil
}

func (p *Pattern) basicMatch(item *Item, withPos bool, slab *util.Slab) (Offset, int, *[]int) {
	var input []Token
	if len(p.nth) == 0 {
		input = []Token{{text: &item.text, prefixLength: 0}}
	} else {
		input = p.transformInput(item)
	}
	if p.fuzzy {
		return p.iter(p.fuzzyAlgo, input, p.caseSensitive, p.normalize, p.forward, p.text, withPos, slab)
	}
	return p.iter(algo.ExactMatchNaive, input, p.caseSensitive, p.normalize, p.forward, p.text, withPos, slab)
}

func (p *Pattern) extendedMatch(item *Item, withPos bool, slab *util.Slab) ([]Offset, int, *[]int) {
	var input []Token
	if len(p.nth) == 0 {
		input = []Token{{text: &item.text, prefixLength: 0}}
	} else {
		input = p.transformInput(item)
	}
	offsets := []Offset{}
	var totalScore int
	var allPos *[]int
	if withPos {
		allPos = &[]int{}
	}
	for _, termSet := range p.termSets {
		var offset Offset
		var currentScore int
		matched := false
		for _, term := range termSet {
			pfun := p.procFun[term.typ]
			off, score, pos := p.iter(pfun, input, term.caseSensitive, term.normalize, p.forward, term.text, withPos, slab)
			if sidx := off[0]; sidx >= 0 {
				if term.inv {
					continue
				}
				offset, currentScore = off, score
				matched = true
				if withPos {
					if pos != nil {
						*allPos = append(*allPos, *pos...)
					} else {
						for idx := off[0]; idx < off[1]; idx++ {
							*allPos = append(*allPos, int(idx))
						}
					}
				}
				break
			} else if term.inv {
				offset, currentScore = Offset{0, 0}, 0
				matched = true
				continue
			}
		}
		if matched {
			offsets = append(offsets, offset)
			totalScore += currentScore
		}
	}
	return offsets, totalScore, allPos
}

func (p *Pattern) transformInput(item *Item) []Token {
	if item.transformed != nil {
		return *item.transformed
	}

	tokens := Tokenize(item.text.ToString(), p.delimiter)
	ret := Transform(tokens, p.nth)
	item.transformed = &ret
	return ret
}

func (p *Pattern) iter(pfun algo.Algo, tokens []Token, caseSensitive bool, normalize bool, forward bool, pattern []rune, withPos bool, slab *util.Slab) (Offset, int, *[]int) {
	for _, part := range tokens {
		if res, pos := pfun(caseSensitive, normalize, forward, part.text, pattern, withPos, slab); res.Start >= 0 {
			sidx := int32(res.Start) + part.prefixLength
			eidx := int32(res.End) + part.prefixLength
			if pos != nil {
				for idx := range *pos {
					(*pos)[idx] += int(part.prefixLength)
				}
			}
			return Offset{sidx, eidx}, res.Score, pos
		}
	}
	return Offset{-1, -1}, 0, nil
}
./src/pattern_test.go	[[[1
209
package fzf

import (
	"reflect"
	"testing"

	"github.com/junegunn/fzf/src/algo"
	"github.com/junegunn/fzf/src/util"
)

var slab *util.Slab

func init() {
	slab = util.MakeSlab(slab16Size, slab32Size)
}

func TestParseTermsExtended(t *testing.T) {
	terms := parseTerms(true, CaseSmart, false,
		"aaa 'bbb ^ccc ddd$ !eee !'fff !^ggg !hhh$ | ^iii$ ^xxx | 'yyy | zzz$ | !ZZZ |")
	if len(terms) != 9 ||
		terms[0][0].typ != termFuzzy || terms[0][0].inv ||
		terms[1][0].typ != termExact || terms[1][0].inv ||
		terms[2][0].typ != termPrefix || terms[2][0].inv ||
		terms[3][0].typ != termSuffix || terms[3][0].inv ||
		terms[4][0].typ != termExact || !terms[4][0].inv ||
		terms[5][0].typ != termFuzzy || !terms[5][0].inv ||
		terms[6][0].typ != termPrefix || !terms[6][0].inv ||
		terms[7][0].typ != termSuffix || !terms[7][0].inv ||
		terms[7][1].typ != termEqual || terms[7][1].inv ||
		terms[8][0].typ != termPrefix || terms[8][0].inv ||
		terms[8][1].typ != termExact || terms[8][1].inv ||
		terms[8][2].typ != termSuffix || terms[8][2].inv ||
		terms[8][3].typ != termExact || !terms[8][3].inv {
		t.Errorf("%v", terms)
	}
	for _, termSet := range terms[:8] {
		term := termSet[0]
		if len(term.text) != 3 {
			t.Errorf("%v", term)
		}
	}
}

func TestParseTermsExtendedExact(t *testing.T) {
	terms := parseTerms(false, CaseSmart, false,
		"aaa 'bbb ^ccc ddd$ !eee !'fff !^ggg !hhh$")
	if len(terms) != 8 ||
		terms[0][0].typ != termExact || terms[0][0].inv || len(terms[0][0].text) != 3 ||
		terms[1][0].typ != termFuzzy || terms[1][0].inv || len(terms[1][0].text) != 3 ||
		terms[2][0].typ != termPrefix || terms[2][0].inv || len(terms[2][0].text) != 3 ||
		terms[3][0].typ != termSuffix || terms[3][0].inv || len(terms[3][0].text) != 3 ||
		terms[4][0].typ != termExact || !terms[4][0].inv || len(terms[4][0].text) != 3 ||
		terms[5][0].typ != termFuzzy || !terms[5][0].inv || len(terms[5][0].text) != 3 ||
		terms[6][0].typ != termPrefix || !terms[6][0].inv || len(terms[6][0].text) != 3 ||
		terms[7][0].typ != termSuffix || !terms[7][0].inv || len(terms[7][0].text) != 3 {
		t.Errorf("%v", terms)
	}
}

func TestParseTermsEmpty(t *testing.T) {
	terms := parseTerms(true, CaseSmart, false, "' ^ !' !^")
	if len(terms) != 0 {
		t.Errorf("%v", terms)
	}
}

func TestExact(t *testing.T) {
	defer clearPatternCache()
	clearPatternCache()
	pattern := BuildPattern(true, algo.FuzzyMatchV2, true, CaseSmart, false, true, false, true,
		[]Range{}, Delimiter{}, []rune("'abc"))
	chars := util.ToChars([]byte("aabbcc abc"))
	res, pos := algo.ExactMatchNaive(
		pattern.caseSensitive, pattern.normalize, pattern.forward, &chars, pattern.termSets[0][0].text, true, nil)
	if res.Start != 7 || res.End != 10 {
		t.Errorf("%v / %d / %d", pattern.termSets, res.Start, res.End)
	}
	if pos != nil {
		t.Errorf("pos is expected to be nil")
	}
}

func TestEqual(t *testing.T) {
	defer clearPatternCache()
	clearPatternCache()
	pattern := BuildPattern(true, algo.FuzzyMatchV2, true, CaseSmart, false, true, false, true, []Range{}, Delimiter{}, []rune("^AbC$"))

	match := func(str string, sidxExpected int, eidxExpected int) {
		chars := util.ToChars([]byte(str))
		res, pos := algo.EqualMatch(
			pattern.caseSensitive, pattern.normalize, pattern.forward, &chars, pattern.termSets[0][0].text, true, nil)
		if res.Start != sidxExpected || res.End != eidxExpected {
			t.Errorf("%v / %d / %d", pattern.termSets, res.Start, res.End)
		}
		if pos != nil {
			t.Errorf("pos is expected to be nil")
		}
	}
	match("ABC", -1, -1)
	match("AbC", 0, 3)
	match("AbC  ", 0, 3)
	match(" AbC ", 1, 4)
	match("  AbC", 2, 5)
}

func TestCaseSensitivity(t *testing.T) {
	defer clearPatternCache()
	clearPatternCache()
	pat1 := BuildPattern(true, algo.FuzzyMatchV2, false, CaseSmart, false, true, false, true, []Range{}, Delimiter{}, []rune("abc"))
	clearPatternCache()
	pat2 := BuildPattern(true, algo.FuzzyMatchV2, false, CaseSmart, false, true, false, true, []Range{}, Delimiter{}, []rune("Abc"))
	clearPatternCache()
	pat3 := BuildPattern(true, algo.FuzzyMatchV2, false, CaseIgnore, false, true, false, true, []Range{}, Delimiter{}, []rune("abc"))
	clearPatternCache()
	pat4 := BuildPattern(true, algo.FuzzyMatchV2, false, CaseIgnore, false, true, false, true, []Range{}, Delimiter{}, []rune("Abc"))
	clearPatternCache()
	pat5 := BuildPattern(true, algo.FuzzyMatchV2, false, CaseRespect, false, true, false, true, []Range{}, Delimiter{}, []rune("abc"))
	clearPatternCache()
	pat6 := BuildPattern(true, algo.FuzzyMatchV2, false, CaseRespect, false, true, false, true, []Range{}, Delimiter{}, []rune("Abc"))

	if string(pat1.text) != "abc" || pat1.caseSensitive != false ||
		string(pat2.text) != "Abc" || pat2.caseSensitive != true ||
		string(pat3.text) != "abc" || pat3.caseSensitive != false ||
		string(pat4.text) != "abc" || pat4.caseSensitive != false ||
		string(pat5.text) != "abc" || pat5.caseSensitive != true ||
		string(pat6.text) != "Abc" || pat6.caseSensitive != true {
		t.Error("Invalid case conversion")
	}
}

func TestOrigTextAndTransformed(t *testing.T) {
	pattern := BuildPattern(true, algo.FuzzyMatchV2, true, CaseSmart, false, true, false, true, []Range{}, Delimiter{}, []rune("jg"))
	tokens := Tokenize("junegunn", Delimiter{})
	trans := Transform(tokens, []Range{{1, 1}})

	origBytes := []byte("junegunn.choi")
	for _, extended := range []bool{false, true} {
		chunk := Chunk{count: 1}
		chunk.items[0] = Item{
			text:        util.ToChars([]byte("junegunn")),
			origText:    &origBytes,
			transformed: &trans}
		pattern.extended = extended
		matches := pattern.matchChunk(&chunk, nil, slab) // No cache
		if !(matches[0].item.text.ToString() == "junegunn" &&
			string(*matches[0].item.origText) == "junegunn.choi" &&
			reflect.DeepEqual(*matches[0].item.transformed, trans)) {
			t.Error("Invalid match result", matches)
		}

		match, offsets, pos := pattern.MatchItem(&chunk.items[0], true, slab)
		if !(match.item.text.ToString() == "junegunn" &&
			string(*match.item.origText) == "junegunn.choi" &&
			offsets[0][0] == 0 && offsets[0][1] == 5 &&
			reflect.DeepEqual(*match.item.transformed, trans)) {
			t.Error("Invalid match result", match, offsets, extended)
		}
		if !((*pos)[0] == 4 && (*pos)[1] == 0) {
			t.Error("Invalid pos array", *pos)
		}
	}
}

func TestCacheKey(t *testing.T) {
	test := func(extended bool, patStr string, expected string, cacheable bool) {
		clearPatternCache()
		pat := BuildPattern(true, algo.FuzzyMatchV2, extended, CaseSmart, false, true, false, true, []Range{}, Delimiter{}, []rune(patStr))
		if pat.CacheKey() != expected {
			t.Errorf("Expected: %s, actual: %s", expected, pat.CacheKey())
		}
		if pat.cacheable != cacheable {
			t.Errorf("Expected: %t, actual: %t (%s)", cacheable, pat.cacheable, patStr)
		}
		clearPatternCache()
	}
	test(false, "foo !bar", "foo !bar", true)
	test(false, "foo | bar !baz", "foo | bar !baz", true)
	test(true, "foo  bar  baz", "foo\tbar\tbaz", true)
	test(true, "foo !bar", "foo", false)
	test(true, "foo !bar   baz", "foo\tbaz", false)
	test(true, "foo | bar baz", "baz", false)
	test(true, "foo | bar | baz", "", false)
	test(true, "foo | bar !baz", "", false)
	test(true, "| | foo", "", false)
	test(true, "| | | foo", "foo", false)
}

func TestCacheable(t *testing.T) {
	test := func(fuzzy bool, str string, expected string, cacheable bool) {
		clearPatternCache()
		pat := BuildPattern(fuzzy, algo.FuzzyMatchV2, true, CaseSmart, true, true, false, true, []Range{}, Delimiter{}, []rune(str))
		if pat.CacheKey() != expected {
			t.Errorf("Expected: %s, actual: %s", expected, pat.CacheKey())
		}
		if cacheable != pat.cacheable {
			t.Errorf("Invalid Pattern.cacheable for \"%s\": %v (expected: %v)", str, pat.cacheable, cacheable)
		}
		clearPatternCache()
	}
	test(true, "foo bar", "foo\tbar", true)
	test(true, "foo 'bar", "foo\tbar", false)
	test(true, "foo !bar", "foo", false)

	test(false, "foo bar", "foo\tbar", true)
	test(false, "foo 'bar", "foo", false)
	test(false, "foo '", "foo", true)
	test(false, "foo 'bar", "foo", false)
	test(false, "foo !bar", "foo", false)
}
./src/protector/protector.go	[[[1
8
//go:build !openbsd

package protector

// Protect calls OS specific protections like pledge on OpenBSD
func Protect() {
	return
}
./src/protector/protector_openbsd.go	[[[1
10
//go:build openbsd

package protector

import "golang.org/x/sys/unix"

// Protect calls OS specific protections like pledge on OpenBSD
func Protect() {
	unix.PledgePromises("stdio rpath tty proc exec")
}
./src/reader.go	[[[1
201
package fzf

import (
	"bufio"
	"context"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"sync"
	"sync/atomic"
	"time"

	"github.com/junegunn/fzf/src/util"
	"github.com/saracen/walker"
)

// Reader reads from command or standard input
type Reader struct {
	pusher   func([]byte) bool
	eventBox *util.EventBox
	delimNil bool
	event    int32
	finChan  chan bool
	mutex    sync.Mutex
	exec     *exec.Cmd
	command  *string
	killed   bool
	wait     bool
}

// NewReader returns new Reader object
func NewReader(pusher func([]byte) bool, eventBox *util.EventBox, delimNil bool, wait bool) *Reader {
	return &Reader{pusher, eventBox, delimNil, int32(EvtReady), make(chan bool, 1), sync.Mutex{}, nil, nil, false, wait}
}

func (r *Reader) startEventPoller() {
	go func() {
		ptr := &r.event
		pollInterval := readerPollIntervalMin
		for {
			if atomic.CompareAndSwapInt32(ptr, int32(EvtReadNew), int32(EvtReady)) {
				r.eventBox.Set(EvtReadNew, (*string)(nil))
				pollInterval = readerPollIntervalMin
			} else if atomic.LoadInt32(ptr) == int32(EvtReadFin) {
				if r.wait {
					r.finChan <- true
				}
				return
			} else {
				pollInterval += readerPollIntervalStep
				if pollInterval > readerPollIntervalMax {
					pollInterval = readerPollIntervalMax
				}
			}
			time.Sleep(pollInterval)
		}
	}()
}

func (r *Reader) fin(success bool) {
	atomic.StoreInt32(&r.event, int32(EvtReadFin))
	if r.wait {
		<-r.finChan
	}

	r.mutex.Lock()
	ret := r.command
	if success || r.killed {
		ret = nil
	}
	r.mutex.Unlock()

	r.eventBox.Set(EvtReadFin, ret)
}

func (r *Reader) terminate() {
	r.mutex.Lock()
	defer func() { r.mutex.Unlock() }()

	r.killed = true
	if r.exec != nil && r.exec.Process != nil {
		util.KillCommand(r.exec)
	} else if defaultCommand != "" {
		os.Stdin.Close()
	}
}

func (r *Reader) restart(command string) {
	r.event = int32(EvtReady)
	r.startEventPoller()
	success := r.readFromCommand(nil, command)
	r.fin(success)
}

// ReadSource reads data from the default command or from standard input
func (r *Reader) ReadSource() {
	r.startEventPoller()
	var success bool
	if util.IsTty() {
		// The default command for *nix requires bash
		shell := "bash"
		cmd := os.Getenv("FZF_DEFAULT_COMMAND")
		if len(cmd) == 0 {
			if defaultCommand != "" {
				success = r.readFromCommand(&shell, defaultCommand)
			} else {
				success = r.readFiles()
			}
		} else {
			success = r.readFromCommand(nil, cmd)
		}
	} else {
		success = r.readFromStdin()
	}
	r.fin(success)
}

func (r *Reader) feed(src io.Reader) {
	delim := byte('\n')
	if r.delimNil {
		delim = '\000'
	}
	reader := bufio.NewReaderSize(src, readerBufferSize)
	for {
		// ReadBytes returns err != nil if and only if the returned data does not
		// end in delim.
		bytea, err := reader.ReadBytes(delim)
		byteaLen := len(bytea)
		if byteaLen > 0 {
			if err == nil {
				// get rid of carriage return if under Windows:
				if util.IsWindows() && byteaLen >= 2 && bytea[byteaLen-2] == byte('\r') {
					bytea = bytea[:byteaLen-2]
				} else {
					bytea = bytea[:byteaLen-1]
				}
			}
			if r.pusher(bytea) {
				atomic.StoreInt32(&r.event, int32(EvtReadNew))
			}
		}
		if err != nil {
			break
		}
	}
}

func (r *Reader) readFromStdin() bool {
	r.feed(os.Stdin)
	return true
}

func (r *Reader) readFiles() bool {
	r.killed = false
	fn := func(path string, mode os.FileInfo) error {
		path = filepath.Clean(path)
		if path != "." {
			isDir := mode.Mode().IsDir()
			if isDir && filepath.Base(path)[0] == '.' {
				return filepath.SkipDir
			}
			if !isDir && r.pusher([]byte(path)) {
				atomic.StoreInt32(&r.event, int32(EvtReadNew))
			}
		}
		r.mutex.Lock()
		defer r.mutex.Unlock()
		if r.killed {
			return context.Canceled
		}
		return nil
	}
	cb := walker.WithErrorCallback(func(pathname string, err error) error {
		return nil
	})
	return walker.Walk(".", fn, cb) == nil
}

func (r *Reader) readFromCommand(shell *string, command string) bool {
	r.mutex.Lock()
	r.killed = false
	r.command = &command
	if shell != nil {
		r.exec = util.ExecCommandWith(*shell, command, true)
	} else {
		r.exec = util.ExecCommand(command, true)
	}
	out, err := r.exec.StdoutPipe()
	if err != nil {
		r.mutex.Unlock()
		return false
	}
	err = r.exec.Start()
	r.mutex.Unlock()
	if err != nil {
		return false
	}
	r.feed(out)
	return r.exec.Wait() == nil
}
./src/reader_test.go	[[[1
63
package fzf

import (
	"testing"
	"time"

	"github.com/junegunn/fzf/src/util"
)

func TestReadFromCommand(t *testing.T) {
	strs := []string{}
	eb := util.NewEventBox()
	reader := NewReader(
		func(s []byte) bool { strs = append(strs, string(s)); return true },
		eb, false, true)

	reader.startEventPoller()

	// Check EventBox
	if eb.Peek(EvtReadNew) {
		t.Error("EvtReadNew should not be set yet")
	}

	// Normal command
	reader.fin(reader.readFromCommand(nil, `echo abc&&echo def`))
	if len(strs) != 2 || strs[0] != "abc" || strs[1] != "def" {
		t.Errorf("%s", strs)
	}

	// Check EventBox again
	eb.WaitFor(EvtReadFin)

	// Wait should return immediately
	eb.Wait(func(events *util.Events) {
		events.Clear()
	})

	// EventBox is cleared
	if eb.Peek(EvtReadNew) {
		t.Error("EvtReadNew should not be set yet")
	}

	// Make sure that event poller is finished
	time.Sleep(readerPollIntervalMax)

	// Restart event poller
	reader.startEventPoller()

	// Failing command
	reader.fin(reader.readFromCommand(nil, `no-such-command`))
	strs = []string{}
	if len(strs) > 0 {
		t.Errorf("%s", strs)
	}

	// Check EventBox again
	if eb.Peek(EvtReadNew) {
		t.Error("Command failed. EvtReadNew should not be set")
	}
	if !eb.Peek(EvtReadFin) {
		t.Error("EvtReadFin should be set")
	}
}
./src/result.go	[[[1
259
package fzf

import (
	"math"
	"sort"
	"unicode"

	"github.com/junegunn/fzf/src/tui"
	"github.com/junegunn/fzf/src/util"
)

// Offset holds two 32-bit integers denoting the offsets of a matched substring
type Offset [2]int32

type colorOffset struct {
	offset [2]int32
	color  tui.ColorPair
}

type Result struct {
	item   *Item
	points [4]uint16
}

func buildResult(item *Item, offsets []Offset, score int) Result {
	if len(offsets) > 1 {
		sort.Sort(ByOrder(offsets))
	}

	result := Result{item: item}
	numChars := item.text.Length()
	minBegin := math.MaxUint16
	minEnd := math.MaxUint16
	maxEnd := 0
	validOffsetFound := false
	for _, offset := range offsets {
		b, e := int(offset[0]), int(offset[1])
		if b < e {
			minBegin = util.Min(b, minBegin)
			minEnd = util.Min(e, minEnd)
			maxEnd = util.Max(e, maxEnd)
			validOffsetFound = true
		}
	}

	for idx, criterion := range sortCriteria {
		val := uint16(math.MaxUint16)
		switch criterion {
		case byScore:
			// Higher is better
			val = math.MaxUint16 - util.AsUint16(score)
		case byChunk:
			if validOffsetFound {
				b := minBegin
				e := maxEnd
				for ; b >= 1; b-- {
					if unicode.IsSpace(item.text.Get(b - 1)) {
						break
					}
				}
				for ; e < numChars; e++ {
					if unicode.IsSpace(item.text.Get(e)) {
						break
					}
				}
				val = util.AsUint16(e - b)
			}
		case byLength:
			val = item.TrimLength()
		case byBegin, byEnd:
			if validOffsetFound {
				whitePrefixLen := 0
				for idx := 0; idx < numChars; idx++ {
					r := item.text.Get(idx)
					whitePrefixLen = idx
					if idx == minBegin || !unicode.IsSpace(r) {
						break
					}
				}
				if criterion == byBegin {
					val = util.AsUint16(minEnd - whitePrefixLen)
				} else {
					val = util.AsUint16(math.MaxUint16 - math.MaxUint16*(maxEnd-whitePrefixLen)/int(item.TrimLength()))
				}
			}
		}
		result.points[3-idx] = val
	}

	return result
}

// Sort criteria to use. Never changes once fzf is started.
var sortCriteria []criterion

// Index returns ordinal index of the Item
func (result *Result) Index() int32 {
	return result.item.Index()
}

func minRank() Result {
	return Result{item: &minItem, points: [4]uint16{math.MaxUint16, 0, 0, 0}}
}

func (result *Result) colorOffsets(matchOffsets []Offset, theme *tui.ColorTheme, colBase tui.ColorPair, colMatch tui.ColorPair, current bool) []colorOffset {
	itemColors := result.item.Colors()

	// No ANSI codes
	if len(itemColors) == 0 {
		var offsets []colorOffset
		for _, off := range matchOffsets {
			offsets = append(offsets, colorOffset{offset: [2]int32{off[0], off[1]}, color: colMatch})
		}
		return offsets
	}

	// Find max column
	var maxCol int32
	for _, off := range matchOffsets {
		if off[1] > maxCol {
			maxCol = off[1]
		}
	}
	for _, ansi := range itemColors {
		if ansi.offset[1] > maxCol {
			maxCol = ansi.offset[1]
		}
	}

	cols := make([]int, maxCol)
	for colorIndex, ansi := range itemColors {
		for i := ansi.offset[0]; i < ansi.offset[1]; i++ {
			cols[i] = colorIndex + 1 // 1-based index of itemColors
		}
	}

	for _, off := range matchOffsets {
		for i := off[0]; i < off[1]; i++ {
			// Negative of 1-based index of itemColors
			// - The extra -1 means highlighted
			cols[i] = cols[i]*-1 - 1
		}
	}

	// sort.Sort(ByOrder(offsets))

	// Merge offsets
	// ------------  ----  --  ----
	//   ++++++++      ++++++++++
	// --++++++++--  --++++++++++---
	curr := 0
	start := 0
	ansiToColorPair := func(ansi ansiOffset, base tui.ColorPair) tui.ColorPair {
		fg := ansi.color.fg
		bg := ansi.color.bg
		if fg == -1 {
			if current {
				fg = theme.Current.Color
			} else {
				fg = theme.Fg.Color
			}
		}
		if bg == -1 {
			if current {
				bg = theme.DarkBg.Color
			} else {
				bg = theme.Bg.Color
			}
		}
		return tui.NewColorPair(fg, bg, ansi.color.attr).MergeAttr(base)
	}
	var colors []colorOffset
	add := func(idx int) {
		if curr != 0 && idx > start {
			if curr < 0 {
				color := colMatch
				if curr < -1 && theme.Colored {
					origColor := ansiToColorPair(itemColors[-curr-2], colMatch)
					// hl or hl+ only sets the foreground color, so colMatch is the
					// combination of either [hl and bg] or [hl+ and bg+].
					//
					// If the original text already has background color, and the
					// foreground color of colMatch is -1, we shouldn't only apply the
					// background color of colMatch.
					// e.g. echo -e "\x1b[32;7mfoo\x1b[mbar" | fzf --ansi --color bg+:1,hl+:-1:underline
					//      echo -e "\x1b[42mfoo\x1b[mbar" | fzf --ansi --color bg+:1,hl+:-1:underline
					if color.Fg().IsDefault() && origColor.HasBg() {
						color = origColor
					} else {
						color = origColor.MergeNonDefault(color)
					}
				}
				colors = append(colors, colorOffset{
					offset: [2]int32{int32(start), int32(idx)}, color: color})
			} else {
				ansi := itemColors[curr-1]
				colors = append(colors, colorOffset{
					offset: [2]int32{int32(start), int32(idx)},
					color:  ansiToColorPair(ansi, colBase)})
			}
		}
	}
	for idx, col := range cols {
		if col != curr {
			add(idx)
			start = idx
			curr = col
		}
	}
	add(int(maxCol))
	return colors
}

// ByOrder is for sorting substring offsets
type ByOrder []Offset

func (a ByOrder) Len() int {
	return len(a)
}

func (a ByOrder) Swap(i, j int) {
	a[i], a[j] = a[j], a[i]
}

func (a ByOrder) Less(i, j int) bool {
	ioff := a[i]
	joff := a[j]
	return (ioff[0] < joff[0]) || (ioff[0] == joff[0]) && (ioff[1] <= joff[1])
}

// ByRelevance is for sorting Items
type ByRelevance []Result

func (a ByRelevance) Len() int {
	return len(a)
}

func (a ByRelevance) Swap(i, j int) {
	a[i], a[j] = a[j], a[i]
}

func (a ByRelevance) Less(i, j int) bool {
	return compareRanks(a[i], a[j], false)
}

// ByRelevanceTac is for sorting Items
type ByRelevanceTac []Result

func (a ByRelevanceTac) Len() int {
	return len(a)
}

func (a ByRelevanceTac) Swap(i, j int) {
	a[i], a[j] = a[j], a[i]
}

func (a ByRelevanceTac) Less(i, j int) bool {
	return compareRanks(a[i], a[j], true)
}
./src/result_others.go	[[[1
16
//go:build !386 && !amd64

package fzf

func compareRanks(irank Result, jrank Result, tac bool) bool {
	for idx := 3; idx >= 0; idx-- {
		left := irank.points[idx]
		right := jrank.points[idx]
		if left < right {
			return true
		} else if left > right {
			return false
		}
	}
	return (irank.item.Index() <= jrank.item.Index()) != tac
}
./src/result_test.go	[[[1
174
package fzf

import (
	"math"
	"sort"
	"testing"

	"github.com/junegunn/fzf/src/tui"
	"github.com/junegunn/fzf/src/util"
)

func withIndex(i *Item, index int) *Item {
	(*i).text.Index = int32(index)
	return i
}

func TestOffsetSort(t *testing.T) {
	offsets := []Offset{
		{3, 5}, {2, 7},
		{1, 3}, {2, 9}}
	sort.Sort(ByOrder(offsets))

	if offsets[0][0] != 1 || offsets[0][1] != 3 ||
		offsets[1][0] != 2 || offsets[1][1] != 7 ||
		offsets[2][0] != 2 || offsets[2][1] != 9 ||
		offsets[3][0] != 3 || offsets[3][1] != 5 {
		t.Error("Invalid order:", offsets)
	}
}

func TestRankComparison(t *testing.T) {
	rank := func(vals ...uint16) Result {
		return Result{
			points: [4]uint16{vals[0], vals[1], vals[2], vals[3]},
			item:   &Item{text: util.Chars{Index: int32(vals[4])}}}
	}
	if compareRanks(rank(3, 0, 0, 0, 5), rank(2, 0, 0, 0, 7), false) ||
		!compareRanks(rank(3, 0, 0, 0, 5), rank(3, 0, 0, 0, 6), false) ||
		!compareRanks(rank(1, 2, 0, 0, 3), rank(1, 3, 0, 0, 2), false) ||
		!compareRanks(rank(0, 0, 0, 0, 0), rank(0, 0, 0, 0, 0), false) {
		t.Error("Invalid order")
	}

	if compareRanks(rank(3, 0, 0, 0, 5), rank(2, 0, 0, 0, 7), true) ||
		!compareRanks(rank(3, 0, 0, 0, 5), rank(3, 0, 0, 0, 6), false) ||
		!compareRanks(rank(1, 2, 0, 0, 3), rank(1, 3, 0, 0, 2), true) ||
		!compareRanks(rank(0, 0, 0, 0, 0), rank(0, 0, 0, 0, 0), false) {
		t.Error("Invalid order (tac)")
	}
}

// Match length, string length, index
func TestResultRank(t *testing.T) {
	// FIXME global
	sortCriteria = []criterion{byScore, byLength}

	str := []rune("foo")
	item1 := buildResult(
		withIndex(&Item{text: util.RunesToChars(str)}, 1), []Offset{}, 2)
	if item1.points[3] != math.MaxUint16-2 || // Bonus
		item1.points[2] != 3 || // Length
		item1.points[1] != 0 || // Unused
		item1.points[0] != 0 || // Unused
		item1.item.Index() != 1 {
		t.Error(item1)
	}
	// Only differ in index
	item2 := buildResult(&Item{text: util.RunesToChars(str)}, []Offset{}, 2)

	items := []Result{item1, item2}
	sort.Sort(ByRelevance(items))
	if items[0] != item2 || items[1] != item1 {
		t.Error(items)
	}

	items = []Result{item2, item1, item1, item2}
	sort.Sort(ByRelevance(items))
	if items[0] != item2 || items[1] != item2 ||
		items[2] != item1 || items[3] != item1 {
		t.Error(items, item1, item1.item.Index(), item2, item2.item.Index())
	}

	// Sort by relevance
	item3 := buildResult(
		withIndex(&Item{}, 2), []Offset{{1, 3}, {5, 7}}, 3)
	item4 := buildResult(
		withIndex(&Item{}, 2), []Offset{{1, 2}, {6, 7}}, 4)
	item5 := buildResult(
		withIndex(&Item{}, 2), []Offset{{1, 3}, {5, 7}}, 5)
	item6 := buildResult(
		withIndex(&Item{}, 2), []Offset{{1, 2}, {6, 7}}, 6)
	items = []Result{item1, item2, item3, item4, item5, item6}
	sort.Sort(ByRelevance(items))
	if !(items[0] == item6 && items[1] == item5 &&
		items[2] == item4 && items[3] == item3 &&
		items[4] == item2 && items[5] == item1) {
		t.Error(items, item1, item2, item3, item4, item5, item6)
	}
}

func TestChunkTiebreak(t *testing.T) {
	// FIXME global
	sortCriteria = []criterion{byScore, byChunk}

	score := 100
	test := func(input string, offset Offset, chunk string) {
		item := buildResult(withIndex(&Item{text: util.RunesToChars([]rune(input))}, 1), []Offset{offset}, score)
		if !(item.points[3] == math.MaxUint16-uint16(score) && item.points[2] == uint16(len(chunk))) {
			t.Error(item.points)
		}
	}
	test("hello foobar goodbye", Offset{8, 9}, "foobar")
	test("hello foobar goodbye", Offset{7, 18}, "foobar goodbye")
	test("hello foobar goodbye", Offset{0, 1}, "hello")
	test("hello foobar goodbye", Offset{5, 7}, "hello foobar") // TBD
}

func TestColorOffset(t *testing.T) {
	// ------------ 20 ----  --  ----
	//   ++++++++        ++++++++++
	// --++++++++--    --++++++++++---

	offsets := []Offset{{5, 15}, {25, 35}}
	item := Result{
		item: &Item{
			colors: &[]ansiOffset{
				{[2]int32{0, 20}, ansiState{1, 5, 0, -1}},
				{[2]int32{22, 27}, ansiState{2, 6, tui.Bold, -1}},
				{[2]int32{30, 32}, ansiState{3, 7, 0, -1}},
				{[2]int32{33, 40}, ansiState{4, 8, tui.Bold, -1}}}}}

	colBase := tui.NewColorPair(89, 189, tui.AttrUndefined)
	colMatch := tui.NewColorPair(99, 199, tui.AttrUndefined)
	colors := item.colorOffsets(offsets, tui.Dark256, colBase, colMatch, true)
	assert := func(idx int, b int32, e int32, c tui.ColorPair) {
		o := colors[idx]
		if o.offset[0] != b || o.offset[1] != e || o.color != c {
			t.Error(o, b, e, c)
		}
	}
	// [{[0 5] {1 5 0}} {[5 15] {99 199 0}} {[15 20] {1 5 0}}
	//  {[22 25] {2 6 1}} {[25 27] {99 199 1}} {[27 30] {99 199 0}}
	//  {[30 32] {99 199 0}} {[32 33] {99 199 0}} {[33 35] {99 199 1}}
	//  {[35 40] {4 8 1}}]
	assert(0, 0, 5, tui.NewColorPair(1, 5, tui.AttrUndefined))
	assert(1, 5, 15, colMatch)
	assert(2, 15, 20, tui.NewColorPair(1, 5, tui.AttrUndefined))
	assert(3, 22, 25, tui.NewColorPair(2, 6, tui.Bold))
	assert(4, 25, 27, colMatch.WithAttr(tui.Bold))
	assert(5, 27, 30, colMatch)
	assert(6, 30, 32, colMatch)
	assert(7, 32, 33, colMatch) // TODO: Should we merge consecutive blocks?
	assert(8, 33, 35, colMatch.WithAttr(tui.Bold))
	assert(9, 35, 40, tui.NewColorPair(4, 8, tui.Bold))

	colRegular := tui.NewColorPair(-1, -1, tui.AttrUndefined)
	colUnderline := tui.NewColorPair(-1, -1, tui.Underline)
	colors = item.colorOffsets(offsets, tui.Dark256, colRegular, colUnderline, true)

	// [{[0 5] {1 5 0}} {[5 15] {1 5 8}} {[15 20] {1 5 0}}
	//  {[22 25] {2 6 1}} {[25 27] {2 6 9}} {[27 30] {-1 -1 8}}
	//  {[30 32] {3 7 8}} {[32 33] {-1 -1 8}} {[33 35] {4 8 9}}
	//  {[35 40] {4 8 1}}]
	assert(0, 0, 5, tui.NewColorPair(1, 5, tui.AttrUndefined))
	assert(1, 5, 15, tui.NewColorPair(1, 5, tui.Underline))
	assert(2, 15, 20, tui.NewColorPair(1, 5, tui.AttrUndefined))
	assert(3, 22, 25, tui.NewColorPair(2, 6, tui.Bold))
	assert(4, 25, 27, tui.NewColorPair(2, 6, tui.Bold|tui.Underline))
	assert(5, 27, 30, colUnderline)
	assert(6, 30, 32, tui.NewColorPair(3, 7, tui.Underline))
	assert(7, 32, 33, colUnderline)
	assert(8, 33, 35, tui.NewColorPair(4, 8, tui.Bold|tui.Underline))
	assert(9, 35, 40, tui.NewColorPair(4, 8, tui.Bold))
}
./src/result_x86.go	[[[1
16
//go:build 386 || amd64

package fzf

import "unsafe"

func compareRanks(irank Result, jrank Result, tac bool) bool {
	left := *(*uint64)(unsafe.Pointer(&irank.points[0]))
	right := *(*uint64)(unsafe.Pointer(&jrank.points[0]))
	if left < right {
		return true
	} else if left > right {
		return false
	}
	return (irank.item.Index() <= jrank.item.Index()) != tac
}
./src/server.go	[[[1
138
package fzf

import (
	"bufio"
	"bytes"
	"errors"
	"fmt"
	"net"
	"strconv"
	"strings"
	"time"
)

const (
	crlf             = "\r\n"
	httpOk           = "HTTP/1.1 200 OK" + crlf
	httpBadRequest   = "HTTP/1.1 400 Bad Request" + crlf
	httpReadTimeout  = 10 * time.Second
	maxContentLength = 1024 * 1024
)

func startHttpServer(port int, channel chan []*action) (error, int) {
	if port < 0 {
		return nil, port
	}

	listener, err := net.Listen("tcp", fmt.Sprintf("localhost:%d", port))
	if err != nil {
		return fmt.Errorf("port not available: %d", port), port
	}
	if port == 0 {
		addr := listener.Addr().String()
		parts := strings.SplitN(addr, ":", 2)
		if len(parts) < 2 {
			return fmt.Errorf("cannot extract port: %s", addr), port
		}
		var err error
		port, err = strconv.Atoi(parts[1])
		if err != nil {
			return err, port
		}
	}

	go func() {
		for {
			conn, err := listener.Accept()
			if err != nil {
				if errors.Is(err, net.ErrClosed) {
					break
				} else {
					continue
				}
			}
			conn.Write([]byte(handleHttpRequest(conn, channel)))
			conn.Close()
		}
		listener.Close()
	}()

	return nil, port
}

// Here we are writing a simplistic HTTP server without using net/http
// package to reduce the size of the binary.
//
// * No --listen:            2.8MB
// * --listen with net/http: 5.7MB
// * --listen w/o net/http:  3.3MB
func handleHttpRequest(conn net.Conn, channel chan []*action) string {
	contentLength := 0
	body := ""
	bad := func(message string) string {
		message += "\n"
		return httpBadRequest + fmt.Sprintf("Content-Length: %d%s", len(message), crlf+crlf+message)
	}
	conn.SetReadDeadline(time.Now().Add(httpReadTimeout))
	scanner := bufio.NewScanner(conn)
	scanner.Split(func(data []byte, atEOF bool) (int, []byte, error) {
		found := bytes.Index(data, []byte(crlf))
		if found >= 0 {
			token := data[:found+len(crlf)]
			return len(token), token, nil
		}
		if atEOF || len(body)+len(data) >= contentLength {
			return 0, data, bufio.ErrFinalToken
		}
		return 0, nil, nil
	})

	section := 0
	for scanner.Scan() {
		text := scanner.Text()
		switch section {
		case 0:
			if !strings.HasPrefix(text, "POST / HTTP") {
				return bad("invalid request method")
			}
			section++
		case 1:
			if text == crlf {
				if contentLength == 0 {
					return bad("content-length header missing")
				}
				section++
				continue
			}
			pair := strings.SplitN(text, ":", 2)
			if len(pair) == 2 && strings.ToLower(pair[0]) == "content-length" {
				length, err := strconv.Atoi(strings.TrimSpace(pair[1]))
				if err != nil || length <= 0 || length > maxContentLength {
					return bad("invalid content length")
				}
				contentLength = length
			}
		case 2:
			body += text
		}
	}

	if len(body) < contentLength {
		return bad("incomplete request")
	}
	body = body[:contentLength]

	errorMessage := ""
	actions := parseSingleActionList(strings.Trim(string(body), "\r\n"), func(message string) {
		errorMessage = message
	})
	if len(errorMessage) > 0 {
		return bad(errorMessage)
	}
	if len(actions) == 0 {
		return bad("no action specified")
	}

	channel <- actions
	return httpOk
}
./src/terminal.go	[[[1
3766
package fzf

import (
	"bufio"
	"fmt"
	"io"
	"io/ioutil"
	"math"
	"os"
	"os/exec"
	"os/signal"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"sync"
	"syscall"
	"time"

	"github.com/mattn/go-runewidth"
	"github.com/rivo/uniseg"

	"github.com/junegunn/fzf/src/tui"
	"github.com/junegunn/fzf/src/util"
)

// import "github.com/pkg/profile"

/*
Placeholder regex is used to extract placeholders from fzf's template
strings. Acts as input validation for parsePlaceholder function.
Describes the syntax, but it is fairly lenient.

The following pseudo regex has been reverse engineered from the
implementation. It is overly strict, but better describes what's possible.
As such it is not useful for validation, but rather to generate test
cases for example.

	\\?(?:                                      # escaped type
	    {\+?s?f?RANGE(?:,RANGE)*}               # token type
	    |{q}                                    # query type
	    |{\+?n?f?}                              # item type (notice no mandatory element inside brackets)
	)
	RANGE = (?:
	    (?:-?[0-9]+)?\.\.(?:-?[0-9]+)?          # ellipsis syntax for token range (x..y)
	    |-?[0-9]+                               # shorthand syntax (x..x)
	)
*/
var placeholder *regexp.Regexp
var whiteSuffix *regexp.Regexp
var offsetComponentRegex *regexp.Regexp
var offsetTrimCharsRegex *regexp.Regexp
var activeTempFiles []string

const clearCode string = "\x1b[2J"

func init() {
	placeholder = regexp.MustCompile(`\\?(?:{[+sf]*[0-9,-.]*}|{q}|{\+?f?nf?})`)
	whiteSuffix = regexp.MustCompile(`\s*$`)
	offsetComponentRegex = regexp.MustCompile(`([+-][0-9]+)|(-?/[1-9][0-9]*)`)
	offsetTrimCharsRegex = regexp.MustCompile(`[^0-9/+-]`)
	activeTempFiles = []string{}
}

type jumpMode int

const (
	jumpDisabled jumpMode = iota
	jumpEnabled
	jumpAcceptEnabled
)

type resumableState int

const (
	disabledState resumableState = iota
	pausedState
	enabledState
)

func (s resumableState) Enabled() bool {
	return s == enabledState
}

func (s *resumableState) Force(flag bool) {
	if flag {
		*s = enabledState
	} else {
		*s = disabledState
	}
}

func (s *resumableState) Set(flag bool) {
	if *s == disabledState {
		return
	}

	if flag {
		*s = enabledState
	} else {
		*s = pausedState
	}
}

type previewer struct {
	version    int64
	lines      []string
	offset     int
	scrollable bool
	final      bool
	following  resumableState
	spinner    string
	bar        []bool
}

type previewed struct {
	version  int64
	numLines int
	offset   int
	filled   bool
}

type eachLine struct {
	line string
	err  error
}

type itemLine struct {
	current  bool
	selected bool
	label    string
	queryLen int
	width    int
	bar      bool
	result   Result
}

type fitpad struct {
	fit int
	pad int
}

var emptyLine = itemLine{}

type labelPrinter func(tui.Window, int)

// Terminal represents terminal input/output
type Terminal struct {
	initDelay          time.Duration
	infoStyle          infoStyle
	infoSep            string
	separator          labelPrinter
	separatorLen       int
	spinner            []string
	prompt             func()
	promptLen          int
	borderLabel        labelPrinter
	borderLabelLen     int
	borderLabelOpts    labelOpts
	previewLabel       labelPrinter
	previewLabelLen    int
	previewLabelOpts   labelOpts
	pointer            string
	pointerLen         int
	pointerEmpty       string
	marker             string
	markerLen          int
	markerEmpty        string
	queryLen           [2]int
	layout             layoutType
	fullscreen         bool
	keepRight          bool
	hscroll            bool
	hscrollOff         int
	scrollOff          int
	wordRubout         string
	wordNext           string
	cx                 int
	cy                 int
	offset             int
	xoffset            int
	yanked             []rune
	input              []rune
	multi              int
	sort               bool
	toggleSort         bool
	track              trackOption
	delimiter          Delimiter
	expect             map[tui.Event]string
	keymap             map[tui.Event][]*action
	keymapOrg          map[tui.Event][]*action
	pressed            string
	printQuery         bool
	history            *History
	cycle              bool
	headerFirst        bool
	headerLines        int
	header             []string
	header0            []string
	ellipsis           string
	scrollbar          string
	previewScrollbar   string
	ansi               bool
	tabstop            int
	margin             [4]sizeSpec
	padding            [4]sizeSpec
	unicode            bool
	listenPort         *int
	borderShape        tui.BorderShape
	cleanExit          bool
	paused             bool
	border             tui.Window
	window             tui.Window
	pborder            tui.Window
	pwindow            tui.Window
	borderWidth        int
	count              int
	progress           int
	hasLoadActions     bool
	triggerLoad        bool
	reading            bool
	running            bool
	failed             *string
	jumping            jumpMode
	jumpLabels         string
	printer            func(string)
	printsep           string
	merger             *Merger
	selected           map[int32]selectedItem
	version            int64
	revision           int
	reqBox             *util.EventBox
	initialPreviewOpts previewOpts
	previewOpts        previewOpts
	activePreviewOpts  *previewOpts
	previewer          previewer
	previewed          previewed
	previewBox         *util.EventBox
	eventBox           *util.EventBox
	mutex              sync.Mutex
	initFunc           func()
	prevLines          []itemLine
	suppress           bool
	sigstop            bool
	startChan          chan fitpad
	killChan           chan int
	serverChan         chan []*action
	eventChan          chan tui.Event
	slab               *util.Slab
	theme              *tui.ColorTheme
	tui                tui.Renderer
	executing          *util.AtomicBool
}

type selectedItem struct {
	at   time.Time
	item *Item
}

type byTimeOrder []selectedItem

func (a byTimeOrder) Len() int {
	return len(a)
}

func (a byTimeOrder) Swap(i, j int) {
	a[i], a[j] = a[j], a[i]
}

func (a byTimeOrder) Less(i, j int) bool {
	return a[i].at.Before(a[j].at)
}

const (
	reqPrompt util.EventType = iota
	reqInfo
	reqHeader
	reqList
	reqJump
	reqRefresh
	reqReinit
	reqFullRedraw
	reqRedrawBorderLabel
	reqRedrawPreviewLabel
	reqClose
	reqPrintQuery
	reqPreviewEnqueue
	reqPreviewDisplay
	reqPreviewRefresh
	reqPreviewDelayed
	reqQuit
)

type action struct {
	t actionType
	a string
}

type actionType int

const (
	actIgnore actionType = iota
	actInvalid
	actRune
	actMouse
	actBeginningOfLine
	actAbort
	actAccept
	actAcceptNonEmpty
	actBackwardChar
	actBackwardDeleteChar
	actBackwardDeleteCharEOF
	actBackwardWord
	actCancel
	actChangeBorderLabel
	actChangeHeader
	actChangePreviewLabel
	actChangePrompt
	actChangeQuery
	actClearScreen
	actClearQuery
	actClearSelection
	actClose
	actDeleteChar
	actDeleteCharEOF
	actEndOfLine
	actForwardChar
	actForwardWord
	actKillLine
	actKillWord
	actUnixLineDiscard
	actUnixWordRubout
	actYank
	actBackwardKillWord
	actSelectAll
	actDeselectAll
	actToggle
	actToggleSearch
	actToggleAll
	actToggleDown
	actToggleUp
	actToggleIn
	actToggleOut
	actToggleTrack
	actTrack
	actDown
	actUp
	actPageUp
	actPageDown
	actPosition
	actHalfPageUp
	actHalfPageDown
	actJump
	actJumpAccept
	actPrintQuery
	actRefreshPreview
	actReplaceQuery
	actToggleSort
	actShowPreview
	actHidePreview
	actTogglePreview
	actTogglePreviewWrap
	actTransformBorderLabel
	actTransformHeader
	actTransformPreviewLabel
	actTransformPrompt
	actTransformQuery
	actPreview
	actChangePreview
	actChangePreviewWindow
	actPreviewTop
	actPreviewBottom
	actPreviewUp
	actPreviewDown
	actPreviewPageUp
	actPreviewPageDown
	actPreviewHalfPageUp
	actPreviewHalfPageDown
	actPrevHistory
	actPrevSelected
	actPut
	actNextHistory
	actNextSelected
	actExecute
	actExecuteSilent
	actExecuteMulti // Deprecated
	actSigStop
	actFirst
	actLast
	actReload
	actReloadSync
	actDisableSearch
	actEnableSearch
	actSelect
	actDeselect
	actUnbind
	actRebind
	actBecome
)

type placeholderFlags struct {
	plus          bool
	preserveSpace bool
	number        bool
	query         bool
	file          bool
}

type searchRequest struct {
	sort    bool
	sync    bool
	command *string
	changed bool
}

type previewRequest struct {
	template     string
	pwindow      tui.Window
	scrollOffset int
	list         []*Item
}

type previewResult struct {
	version int64
	lines   []string
	offset  int
	spinner string
}

func toActions(types ...actionType) []*action {
	actions := make([]*action, len(types))
	for idx, t := range types {
		actions[idx] = &action{t: t, a: ""}
	}
	return actions
}

func defaultKeymap() map[tui.Event][]*action {
	keymap := make(map[tui.Event][]*action)
	add := func(e tui.EventType, a actionType) {
		keymap[e.AsEvent()] = toActions(a)
	}
	addEvent := func(e tui.Event, a actionType) {
		keymap[e] = toActions(a)
	}

	add(tui.Invalid, actInvalid)
	add(tui.Resize, actClearScreen)
	add(tui.CtrlA, actBeginningOfLine)
	add(tui.CtrlB, actBackwardChar)
	add(tui.CtrlC, actAbort)
	add(tui.CtrlG, actAbort)
	add(tui.CtrlQ, actAbort)
	add(tui.ESC, actAbort)
	add(tui.CtrlD, actDeleteCharEOF)
	add(tui.CtrlE, actEndOfLine)
	add(tui.CtrlF, actForwardChar)
	add(tui.CtrlH, actBackwardDeleteChar)
	add(tui.BSpace, actBackwardDeleteChar)
	add(tui.Tab, actToggleDown)
	add(tui.BTab, actToggleUp)
	add(tui.CtrlJ, actDown)
	add(tui.CtrlK, actUp)
	add(tui.CtrlL, actClearScreen)
	add(tui.CtrlM, actAccept)
	add(tui.CtrlN, actDown)
	add(tui.CtrlP, actUp)
	add(tui.CtrlU, actUnixLineDiscard)
	add(tui.CtrlW, actUnixWordRubout)
	add(tui.CtrlY, actYank)
	if !util.IsWindows() {
		add(tui.CtrlZ, actSigStop)
	}

	addEvent(tui.AltKey('b'), actBackwardWord)
	add(tui.SLeft, actBackwardWord)
	addEvent(tui.AltKey('f'), actForwardWord)
	add(tui.SRight, actForwardWord)
	addEvent(tui.AltKey('d'), actKillWord)
	add(tui.AltBS, actBackwardKillWord)

	add(tui.Up, actUp)
	add(tui.Down, actDown)
	add(tui.Left, actBackwardChar)
	add(tui.Right, actForwardChar)

	add(tui.Home, actBeginningOfLine)
	add(tui.End, actEndOfLine)
	add(tui.Del, actDeleteChar)
	add(tui.PgUp, actPageUp)
	add(tui.PgDn, actPageDown)

	add(tui.SUp, actPreviewUp)
	add(tui.SDown, actPreviewDown)

	add(tui.Mouse, actMouse)
	add(tui.LeftClick, actIgnore)
	add(tui.RightClick, actToggle)
	return keymap
}

func trimQuery(query string) []rune {
	return []rune(strings.Replace(query, "\t", " ", -1))
}

func hasPreviewAction(opts *Options) bool {
	for _, actions := range opts.Keymap {
		for _, action := range actions {
			if action.t == actPreview || action.t == actChangePreview {
				return true
			}
		}
	}
	return false
}

func makeSpinner(unicode bool) []string {
	if unicode {
		return []string{`⠋`, `⠙`, `⠹`, `⠸`, `⠼`, `⠴`, `⠦`, `⠧`, `⠇`, `⠏`}
	}
	return []string{`-`, `\`, `|`, `/`, `-`, `\`, `|`, `/`}
}

func evaluateHeight(opts *Options, termHeight int) int {
	if opts.Height.percent {
		return util.Max(int(opts.Height.size*float64(termHeight)/100.0), opts.MinHeight)
	}
	return int(opts.Height.size)
}

// NewTerminal returns new Terminal object
func NewTerminal(opts *Options, eventBox *util.EventBox) *Terminal {
	input := trimQuery(opts.Query)
	var header []string
	switch opts.Layout {
	case layoutDefault, layoutReverseList:
		header = reverseStringArray(opts.Header)
	default:
		header = opts.Header
	}
	var delay time.Duration
	if opts.Tac {
		delay = initialDelayTac
	} else {
		delay = initialDelay
	}
	var previewBox *util.EventBox
	// We need to start previewer if HTTP server is enabled even when --preview option is not specified
	if len(opts.Preview.command) > 0 || hasPreviewAction(opts) || opts.ListenPort != nil {
		previewBox = util.NewEventBox()
	}
	var renderer tui.Renderer
	fullscreen := !opts.Height.auto && (opts.Height.size == 0 || opts.Height.percent && opts.Height.size == 100)
	if fullscreen {
		if tui.HasFullscreenRenderer() {
			renderer = tui.NewFullscreenRenderer(opts.Theme, opts.Black, opts.Mouse)
		} else {
			renderer = tui.NewLightRenderer(opts.Theme, opts.Black, opts.Mouse, opts.Tabstop, opts.ClearOnExit,
				true, func(h int) int { return h })
		}
	} else {
		maxHeightFunc := func(termHeight int) int {
			// Minimum height required to render fzf excluding margin and padding
			effectiveMinHeight := minHeight
			if previewBox != nil && opts.Preview.aboveOrBelow() {
				effectiveMinHeight += 1 + borderLines(opts.Preview.border)
			}
			if opts.InfoStyle.noExtraLine() {
				effectiveMinHeight--
			}
			effectiveMinHeight += borderLines(opts.BorderShape)
			return util.Min(termHeight, util.Max(evaluateHeight(opts, termHeight), effectiveMinHeight))
		}
		renderer = tui.NewLightRenderer(opts.Theme, opts.Black, opts.Mouse, opts.Tabstop, opts.ClearOnExit, false, maxHeightFunc)
	}
	wordRubout := "[^\\pL\\pN][\\pL\\pN]"
	wordNext := "[\\pL\\pN][^\\pL\\pN]|(.$)"
	if opts.FileWord {
		sep := regexp.QuoteMeta(string(os.PathSeparator))
		wordRubout = fmt.Sprintf("%s[^%s]", sep, sep)
		wordNext = fmt.Sprintf("[^%s]%s|(.$)", sep, sep)
	}
	keymapCopy := make(map[tui.Event][]*action)
	for key, action := range opts.Keymap {
		keymapCopy[key] = action
	}
	t := Terminal{
		initDelay:          delay,
		infoStyle:          opts.InfoStyle,
		infoSep:            opts.InfoSep,
		separator:          nil,
		spinner:            makeSpinner(opts.Unicode),
		queryLen:           [2]int{0, 0},
		layout:             opts.Layout,
		fullscreen:         fullscreen,
		keepRight:          opts.KeepRight,
		hscroll:            opts.Hscroll,
		hscrollOff:         opts.HscrollOff,
		scrollOff:          opts.ScrollOff,
		wordRubout:         wordRubout,
		wordNext:           wordNext,
		cx:                 len(input),
		cy:                 0,
		offset:             0,
		xoffset:            0,
		yanked:             []rune{},
		input:              input,
		multi:              opts.Multi,
		sort:               opts.Sort > 0,
		toggleSort:         opts.ToggleSort,
		track:              opts.Track,
		delimiter:          opts.Delimiter,
		expect:             opts.Expect,
		keymap:             opts.Keymap,
		keymapOrg:          keymapCopy,
		pressed:            "",
		printQuery:         opts.PrintQuery,
		history:            opts.History,
		margin:             opts.Margin,
		padding:            opts.Padding,
		unicode:            opts.Unicode,
		listenPort:         opts.ListenPort,
		borderShape:        opts.BorderShape,
		borderWidth:        1,
		borderLabel:        nil,
		borderLabelOpts:    opts.BorderLabel,
		previewLabel:       nil,
		previewLabelOpts:   opts.PreviewLabel,
		cleanExit:          opts.ClearOnExit,
		paused:             opts.Phony,
		cycle:              opts.Cycle,
		headerFirst:        opts.HeaderFirst,
		headerLines:        opts.HeaderLines,
		header:             []string{},
		header0:            header,
		ellipsis:           opts.Ellipsis,
		ansi:               opts.Ansi,
		tabstop:            opts.Tabstop,
		hasLoadActions:     false,
		triggerLoad:        false,
		reading:            true,
		running:            true,
		failed:             nil,
		jumping:            jumpDisabled,
		jumpLabels:         opts.JumpLabels,
		printer:            opts.Printer,
		printsep:           opts.PrintSep,
		merger:             EmptyMerger(0),
		selected:           make(map[int32]selectedItem),
		reqBox:             util.NewEventBox(),
		initialPreviewOpts: opts.Preview,
		previewOpts:        opts.Preview,
		previewer:          previewer{0, []string{}, 0, false, true, disabledState, "", []bool{}},
		previewed:          previewed{0, 0, 0, false},
		previewBox:         previewBox,
		eventBox:           eventBox,
		mutex:              sync.Mutex{},
		suppress:           true,
		sigstop:            false,
		slab:               util.MakeSlab(slab16Size, slab32Size),
		theme:              opts.Theme,
		startChan:          make(chan fitpad, 1),
		killChan:           make(chan int),
		serverChan:         make(chan []*action, 10),
		eventChan:          make(chan tui.Event, 1),
		tui:                renderer,
		initFunc:           func() { renderer.Init() },
		executing:          util.NewAtomicBool(false)}
	t.prompt, t.promptLen = t.parsePrompt(opts.Prompt)
	t.pointer, t.pointerLen = t.processTabs([]rune(opts.Pointer), 0)
	t.marker, t.markerLen = t.processTabs([]rune(opts.Marker), 0)
	// Pre-calculated empty pointer and marker signs
	t.pointerEmpty = strings.Repeat(" ", t.pointerLen)
	t.markerEmpty = strings.Repeat(" ", t.markerLen)
	t.borderLabel, t.borderLabelLen = t.ansiLabelPrinter(opts.BorderLabel.label, &tui.ColBorderLabel, false)
	t.previewLabel, t.previewLabelLen = t.ansiLabelPrinter(opts.PreviewLabel.label, &tui.ColPreviewLabel, false)
	if opts.Separator == nil || len(*opts.Separator) > 0 {
		bar := "─"
		if opts.Separator != nil {
			bar = *opts.Separator
		} else if !t.unicode {
			bar = "-"
		}
		t.separator, t.separatorLen = t.ansiLabelPrinter(bar, &tui.ColSeparator, true)
	}
	if t.unicode {
		t.borderWidth = runewidth.RuneWidth('│')
	}
	if opts.Scrollbar == nil {
		if t.unicode && t.borderWidth == 1 {
			t.scrollbar = "│"
		} else {
			t.scrollbar = "|"
		}
		t.previewScrollbar = t.scrollbar
	} else {
		runes := []rune(*opts.Scrollbar)
		if len(runes) > 0 {
			t.scrollbar = string(runes[0])
			t.previewScrollbar = t.scrollbar
			if len(runes) > 1 {
				t.previewScrollbar = string(runes[1])
			}
		}
	}

	_, t.hasLoadActions = t.keymap[tui.Load.AsEvent()]

	if t.listenPort != nil {
		err, port := startHttpServer(*t.listenPort, t.serverChan)
		if err != nil {
			errorExit(err.Error())
		}
		t.listenPort = &port
	}

	return &t
}

func (t *Terminal) environ() []string {
	env := os.Environ()
	if t.listenPort != nil {
		env = append(env, fmt.Sprintf("FZF_PORT=%d", *t.listenPort))
	}
	return env
}

func borderLines(shape tui.BorderShape) int {
	switch shape {
	case tui.BorderHorizontal, tui.BorderRounded, tui.BorderSharp, tui.BorderBold, tui.BorderBlock, tui.BorderThinBlock, tui.BorderDouble:
		return 2
	case tui.BorderTop, tui.BorderBottom:
		return 1
	}
	return 0
}

// Extra number of lines needed to display fzf
func (t *Terminal) extraLines() int {
	extra := len(t.header0) + t.headerLines + 1
	if !t.noInfoLine() {
		extra++
	}
	return extra
}

func (t *Terminal) MaxFitAndPad(opts *Options) (int, int) {
	_, screenHeight, marginInt, paddingInt := t.adjustMarginAndPadding()
	padHeight := marginInt[0] + marginInt[2] + paddingInt[0] + paddingInt[2]
	fit := screenHeight - padHeight - t.extraLines()
	return fit, padHeight
}

func (t *Terminal) ansiLabelPrinter(str string, color *tui.ColorPair, fill bool) (labelPrinter, int) {
	// Nothing to do
	if len(str) == 0 {
		return nil, 0
	}

	// Extract ANSI color codes
	str = firstLine(str)
	text, colors, _ := extractColor(str, nil, nil)
	runes := []rune(text)

	// Simpler printer for strings without ANSI colors or tab characters
	if colors == nil && !strings.ContainsRune(str, '\t') {
		length := util.StringWidth(str)
		if length == 0 {
			return nil, 0
		}
		printFn := func(window tui.Window, limit int) {
			if length > limit {
				trimmedRunes, _ := t.trimRight(runes, limit)
				window.CPrint(*color, string(trimmedRunes))
			} else if fill {
				window.CPrint(*color, util.RepeatToFill(str, length, limit))
			} else {
				window.CPrint(*color, str)
			}
		}
		return printFn, len(text)
	}

	// Printer that correctly handles ANSI color codes and tab characters
	item := &Item{text: util.RunesToChars(runes), colors: colors}
	length := t.displayWidth(runes)
	if length == 0 {
		return nil, 0
	}
	result := Result{item: item}
	var offsets []colorOffset
	printFn := func(window tui.Window, limit int) {
		if offsets == nil {
			// tui.Col* are not initialized until renderer.Init()
			offsets = result.colorOffsets(nil, t.theme, *color, *color, false)
		}
		for limit > 0 {
			if length > limit {
				trimmedRunes, _ := t.trimRight(runes, limit)
				t.printColoredString(window, trimmedRunes, offsets, *color)
				break
			} else if fill {
				t.printColoredString(window, runes, offsets, *color)
				limit -= length
			} else {
				t.printColoredString(window, runes, offsets, *color)
				break
			}
		}
	}
	return printFn, length
}

func (t *Terminal) parsePrompt(prompt string) (func(), int) {
	var state *ansiState
	prompt = firstLine(prompt)
	trimmed, colors, _ := extractColor(prompt, state, nil)
	item := &Item{text: util.ToChars([]byte(trimmed)), colors: colors}

	// "Prompt>  "
	//  -------    // Do not apply ANSI attributes to the trailing whitespaces
	//             // unless the part has a non-default ANSI state
	loc := whiteSuffix.FindStringIndex(trimmed)
	if loc != nil {
		blankState := ansiOffset{[2]int32{int32(loc[0]), int32(loc[1])}, ansiState{-1, -1, tui.AttrClear, -1}}
		if item.colors != nil {
			lastColor := (*item.colors)[len(*item.colors)-1]
			if lastColor.offset[1] < int32(loc[1]) {
				blankState.offset[0] = lastColor.offset[1]
				colors := append(*item.colors, blankState)
				item.colors = &colors
			}
		} else {
			colors := []ansiOffset{blankState}
			item.colors = &colors
		}
	}
	output := func() {
		t.printHighlighted(
			Result{item: item}, tui.ColPrompt, tui.ColPrompt, false, false)
	}
	_, promptLen := t.processTabs([]rune(trimmed), 0)

	return output, promptLen
}

func (t *Terminal) noInfoLine() bool {
	return t.infoStyle.noExtraLine()
}

func getScrollbar(total int, height int, offset int) (int, int) {
	if total == 0 || total <= height {
		return 0, 0
	}
	barLength := util.Max(1, height*height/total)
	var barStart int
	if total == height {
		barStart = 0
	} else {
		barStart = (height - barLength) * offset / (total - height)
	}
	return barLength, barStart
}

func (t *Terminal) getScrollbar() (int, int) {
	return getScrollbar(t.merger.Length(), t.maxItems(), t.offset)
}

// Input returns current query string
func (t *Terminal) Input() (bool, []rune) {
	t.mutex.Lock()
	defer t.mutex.Unlock()
	return t.paused, copySlice(t.input)
}

// UpdateCount updates the count information
func (t *Terminal) UpdateCount(cnt int, final bool, failedCommand *string) {
	t.mutex.Lock()
	t.count = cnt
	if t.hasLoadActions && t.reading && final {
		t.triggerLoad = true
	}
	t.reading = !final
	t.failed = failedCommand
	t.mutex.Unlock()
	t.reqBox.Set(reqInfo, nil)
	if final {
		t.reqBox.Set(reqRefresh, nil)
	}
}

func reverseStringArray(input []string) []string {
	size := len(input)
	reversed := make([]string, size)
	for idx, str := range input {
		reversed[size-idx-1] = str
	}
	return reversed
}

func (t *Terminal) changeHeader(header string) bool {
	lines := strings.Split(strings.TrimSuffix(header, "\n"), "\n")
	switch t.layout {
	case layoutDefault, layoutReverseList:
		lines = reverseStringArray(lines)
	}
	needFullRedraw := len(t.header0) != len(lines)
	t.header0 = lines
	return needFullRedraw
}

// UpdateHeader updates the header
func (t *Terminal) UpdateHeader(header []string) {
	t.mutex.Lock()
	t.header = header
	t.mutex.Unlock()
	t.reqBox.Set(reqHeader, nil)
}

// UpdateProgress updates the search progress
func (t *Terminal) UpdateProgress(progress float32) {
	t.mutex.Lock()
	newProgress := int(progress * 100)
	changed := t.progress != newProgress
	t.progress = newProgress
	t.mutex.Unlock()

	if changed {
		t.reqBox.Set(reqInfo, nil)
	}
}

// UpdateList updates Merger to display the list
func (t *Terminal) UpdateList(merger *Merger) {
	t.mutex.Lock()
	var prevIndex int32 = -1
	reset := t.revision != merger.Revision()
	if !reset && t.track != trackDisabled {
		if t.merger.Length() > 0 {
			prevIndex = t.merger.Get(t.cy).item.Index()
		} else if merger.Length() > 0 {
			prevIndex = merger.First().item.Index()
		}
	}
	t.progress = 100
	t.merger = merger
	if reset {
		t.selected = make(map[int32]selectedItem)
		t.revision = merger.Revision()
		t.version++
	}
	if t.triggerLoad {
		t.triggerLoad = false
		t.eventChan <- tui.Load.AsEvent()
	}
	if prevIndex >= 0 {
		pos := t.cy - t.offset
		count := t.merger.Length()
		i := t.merger.FindIndex(prevIndex)
		if i >= 0 {
			t.cy = i
			t.offset = t.cy - pos
		} else if t.track == trackCurrent {
			t.track = trackDisabled
			t.cy = pos
			t.offset = 0
		} else if t.cy > count {
			// Try to keep the vertical position when the list shrinks
			t.cy = count - util.Min(count, t.maxItems()) + pos
		}
	}
	if !t.reading {
		switch t.merger.Length() {
		case 0:
			zero := tui.Zero.AsEvent()
			if _, prs := t.keymap[zero]; prs {
				t.eventChan <- zero
			}
		case 1:
			one := tui.One.AsEvent()
			if _, prs := t.keymap[one]; prs {
				t.eventChan <- one
			}
		}
	}
	t.mutex.Unlock()
	t.reqBox.Set(reqInfo, nil)
	t.reqBox.Set(reqList, nil)
}

func (t *Terminal) output() bool {
	if t.printQuery {
		t.printer(string(t.input))
	}
	if len(t.expect) > 0 {
		t.printer(t.pressed)
	}
	found := len(t.selected) > 0
	if !found {
		current := t.currentItem()
		if current != nil {
			t.printer(current.AsString(t.ansi))
			found = true
		}
	} else {
		for _, sel := range t.sortSelected() {
			t.printer(sel.item.AsString(t.ansi))
		}
	}
	return found
}

func (t *Terminal) sortSelected() []selectedItem {
	sels := make([]selectedItem, 0, len(t.selected))
	for _, sel := range t.selected {
		sels = append(sels, sel)
	}
	sort.Sort(byTimeOrder(sels))
	return sels
}

func (t *Terminal) displayWidth(runes []rune) int {
	width, _ := util.RunesWidth(runes, 0, t.tabstop, math.MaxInt32)
	return width
}

const (
	minWidth  = 4
	minHeight = 3
)

func calculateSize(base int, size sizeSpec, occupied int, minSize int, pad int) int {
	max := base - occupied
	if max < minSize {
		max = minSize
	}
	if size.percent {
		return util.Constrain(int(float64(base)*0.01*size.size), minSize, max)
	}
	return util.Constrain(int(size.size)+pad, minSize, max)
}

func (t *Terminal) adjustMarginAndPadding() (int, int, [4]int, [4]int) {
	screenWidth := t.tui.MaxX()
	screenHeight := t.tui.MaxY()
	marginInt := [4]int{}  // TRBL
	paddingInt := [4]int{} // TRBL
	sizeSpecToInt := func(index int, spec sizeSpec) int {
		if spec.percent {
			var max float64
			if index%2 == 0 {
				max = float64(screenHeight)
			} else {
				max = float64(screenWidth)
			}
			return int(max * spec.size * 0.01)
		}
		return int(spec.size)
	}
	for idx, sizeSpec := range t.padding {
		paddingInt[idx] = sizeSpecToInt(idx, sizeSpec)
	}

	bw := t.borderWidth
	extraMargin := [4]int{} // TRBL
	for idx, sizeSpec := range t.margin {
		switch t.borderShape {
		case tui.BorderHorizontal:
			extraMargin[idx] += 1 - idx%2
		case tui.BorderVertical:
			extraMargin[idx] += (1 + bw) * (idx % 2)
		case tui.BorderTop:
			if idx == 0 {
				extraMargin[idx]++
			}
		case tui.BorderRight:
			if idx == 1 {
				extraMargin[idx] += 1 + bw
			}
		case tui.BorderBottom:
			if idx == 2 {
				extraMargin[idx]++
			}
		case tui.BorderLeft:
			if idx == 3 {
				extraMargin[idx] += 1 + bw
			}
		case tui.BorderRounded, tui.BorderSharp, tui.BorderBold, tui.BorderBlock, tui.BorderThinBlock, tui.BorderDouble:
			extraMargin[idx] += 1 + bw*(idx%2)
		}
		marginInt[idx] = sizeSpecToInt(idx, sizeSpec) + extraMargin[idx]
	}

	adjust := func(idx1 int, idx2 int, max int, min int) {
		if min > max {
			min = max
		}
		margin := marginInt[idx1] + marginInt[idx2] + paddingInt[idx1] + paddingInt[idx2]
		if max-margin < min {
			desired := max - min
			paddingInt[idx1] = desired * paddingInt[idx1] / margin
			paddingInt[idx2] = desired * paddingInt[idx2] / margin
			marginInt[idx1] = util.Max(extraMargin[idx1], desired*marginInt[idx1]/margin)
			marginInt[idx2] = util.Max(extraMargin[idx2], desired*marginInt[idx2]/margin)
		}
	}

	minAreaWidth := minWidth
	minAreaHeight := minHeight
	if t.noInfoLine() {
		minAreaHeight -= 1
	}
	if t.needPreviewWindow() {
		minPreviewHeight := 1 + borderLines(t.previewOpts.border)
		minPreviewWidth := 5
		switch t.previewOpts.position {
		case posUp, posDown:
			minAreaHeight += minPreviewHeight
			minAreaWidth = util.Max(minPreviewWidth, minAreaWidth)
		case posLeft, posRight:
			minAreaWidth += minPreviewWidth
			minAreaHeight = util.Max(minPreviewHeight, minAreaHeight)
		}
	}
	adjust(1, 3, screenWidth, minAreaWidth)
	adjust(0, 2, screenHeight, minAreaHeight)

	return screenWidth, screenHeight, marginInt, paddingInt
}

func (t *Terminal) resizeWindows(forcePreview bool) {
	screenWidth, screenHeight, marginInt, paddingInt := t.adjustMarginAndPadding()
	width := screenWidth - marginInt[1] - marginInt[3]
	height := screenHeight - marginInt[0] - marginInt[2]

	t.prevLines = make([]itemLine, screenHeight)
	if t.border != nil {
		t.border.Close()
	}
	if t.window != nil {
		t.window.Close()
		t.window = nil
	}
	if t.pborder != nil {
		t.pborder.Close()
		t.pborder = nil
	}
	if t.pwindow != nil {
		t.pwindow.Close()
		t.pwindow = nil
	}
	// Reset preview version so that full redraw occurs
	t.previewed.version = 0

	bw := t.borderWidth
	switch t.borderShape {
	case tui.BorderHorizontal:
		t.border = t.tui.NewWindow(
			marginInt[0]-1, marginInt[3], width, height+2,
			false, tui.MakeBorderStyle(tui.BorderHorizontal, t.unicode))
	case tui.BorderVertical:
		t.border = t.tui.NewWindow(
			marginInt[0], marginInt[3]-(1+bw), width+(1+bw)*2, height,
			false, tui.MakeBorderStyle(tui.BorderVertical, t.unicode))
	case tui.BorderTop:
		t.border = t.tui.NewWindow(
			marginInt[0]-1, marginInt[3], width, height+1,
			false, tui.MakeBorderStyle(tui.BorderTop, t.unicode))
	case tui.BorderBottom:
		t.border = t.tui.NewWindow(
			marginInt[0], marginInt[3], width, height+1,
			false, tui.MakeBorderStyle(tui.BorderBottom, t.unicode))
	case tui.BorderLeft:
		t.border = t.tui.NewWindow(
			marginInt[0], marginInt[3]-(1+bw), width+(1+bw), height,
			false, tui.MakeBorderStyle(tui.BorderLeft, t.unicode))
	case tui.BorderRight:
		t.border = t.tui.NewWindow(
			marginInt[0], marginInt[3], width+(1+bw), height,
			false, tui.MakeBorderStyle(tui.BorderRight, t.unicode))
	case tui.BorderRounded, tui.BorderSharp, tui.BorderBold, tui.BorderBlock, tui.BorderThinBlock, tui.BorderDouble:
		t.border = t.tui.NewWindow(
			marginInt[0]-1, marginInt[3]-(1+bw), width+(1+bw)*2, height+2,
			false, tui.MakeBorderStyle(t.borderShape, t.unicode))
	}

	// Add padding to margin
	for idx, val := range paddingInt {
		marginInt[idx] += val
	}
	width -= paddingInt[1] + paddingInt[3]
	height -= paddingInt[0] + paddingInt[2]

	// Set up preview window
	noBorder := tui.MakeBorderStyle(tui.BorderNone, t.unicode)
	if forcePreview || t.needPreviewWindow() {
		var resizePreviewWindows func(previewOpts *previewOpts)
		resizePreviewWindows = func(previewOpts *previewOpts) {
			t.activePreviewOpts = previewOpts
			if previewOpts.size.size == 0 {
				return
			}
			hasThreshold := previewOpts.threshold > 0 && previewOpts.alternative != nil
			createPreviewWindow := func(y int, x int, w int, h int) {
				pwidth := w
				pheight := h
				var previewBorder tui.BorderStyle
				if previewOpts.border == tui.BorderNone {
					previewBorder = tui.MakeTransparentBorder()
				} else {
					previewBorder = tui.MakeBorderStyle(previewOpts.border, t.unicode)
				}
				t.pborder = t.tui.NewWindow(y, x, w, h, true, previewBorder)
				switch previewOpts.border {
				case tui.BorderSharp, tui.BorderRounded, tui.BorderBold, tui.BorderBlock, tui.BorderThinBlock, tui.BorderDouble:
					pwidth -= (1 + bw) * 2
					pheight -= 2
					x += 1 + bw
					y += 1
				case tui.BorderLeft:
					pwidth -= 1 + bw
					x += 1 + bw
				case tui.BorderRight:
					pwidth -= 1 + bw
				case tui.BorderTop:
					pheight -= 1
					y += 1
				case tui.BorderBottom:
					pheight -= 1
				case tui.BorderHorizontal:
					pheight -= 2
					y += 1
				case tui.BorderVertical:
					pwidth -= (1 + bw) * 2
					x += 1 + bw
				}
				if len(t.scrollbar) > 0 && !previewOpts.border.HasRight() {
					// Need a column to show scrollbar
					pwidth -= 1
				}
				pwidth = util.Max(0, pwidth)
				pheight = util.Max(0, pheight)
				t.pwindow = t.tui.NewWindow(y, x, pwidth, pheight, true, noBorder)
			}
			verticalPad := 2
			minPreviewHeight := 3
			switch previewOpts.border {
			case tui.BorderNone, tui.BorderVertical, tui.BorderLeft, tui.BorderRight:
				verticalPad = 0
				minPreviewHeight = 1
			case tui.BorderTop, tui.BorderBottom:
				verticalPad = 1
				minPreviewHeight = 2
			}
			switch previewOpts.position {
			case posUp, posDown:
				pheight := calculateSize(height, previewOpts.size, minHeight, minPreviewHeight, verticalPad)
				if hasThreshold && pheight < previewOpts.threshold {
					t.activePreviewOpts = previewOpts.alternative
					if forcePreview {
						previewOpts.alternative.hidden = false
					}
					if !previewOpts.alternative.hidden {
						resizePreviewWindows(previewOpts.alternative)
					}
					return
				}
				if forcePreview {
					previewOpts.hidden = false
				}
				if previewOpts.hidden {
					return
				}
				// Put scrollbar closer to the right border for consistent look
				if t.borderShape.HasRight() {
					width++
				}
				if previewOpts.position == posUp {
					t.window = t.tui.NewWindow(
						marginInt[0]+pheight, marginInt[3], width, height-pheight, false, noBorder)
					createPreviewWindow(marginInt[0], marginInt[3], width, pheight)
				} else {
					t.window = t.tui.NewWindow(
						marginInt[0], marginInt[3], width, height-pheight, false, noBorder)
					createPreviewWindow(marginInt[0]+height-pheight, marginInt[3], width, pheight)
				}
			case posLeft, posRight:
				pwidth := calculateSize(width, previewOpts.size, minWidth, 5, 4)
				if hasThreshold && pwidth < previewOpts.threshold {
					t.activePreviewOpts = previewOpts.alternative
					if forcePreview {
						previewOpts.alternative.hidden = false
					}
					if !previewOpts.alternative.hidden {
						resizePreviewWindows(previewOpts.alternative)
					}
					return
				}
				if forcePreview {
					previewOpts.hidden = false
				}
				if previewOpts.hidden {
					return
				}
				if previewOpts.position == posLeft {
					// Put scrollbar closer to the right border for consistent look
					if t.borderShape.HasRight() {
						width++
					}
					// Add a 1-column margin between the preview window and the main window
					t.window = t.tui.NewWindow(
						marginInt[0], marginInt[3]+pwidth+1, width-pwidth-1, height, false, noBorder)
					createPreviewWindow(marginInt[0], marginInt[3], pwidth, height)
				} else {
					t.window = t.tui.NewWindow(
						marginInt[0], marginInt[3], width-pwidth, height, false, noBorder)
					// NOTE: fzf --preview 'cat {}' --preview-window border-left --border
					x := marginInt[3] + width - pwidth
					if !previewOpts.border.HasRight() && t.borderShape.HasRight() {
						pwidth++
					}
					createPreviewWindow(marginInt[0], x, pwidth, height)
				}
			}
		}
		resizePreviewWindows(&t.previewOpts)
	} else {
		t.activePreviewOpts = &t.previewOpts
	}

	// Without preview window
	if t.window == nil {
		if t.borderShape.HasRight() {
			// Put scrollbar closer to the right border for consistent look
			width++
		}
		t.window = t.tui.NewWindow(
			marginInt[0],
			marginInt[3],
			width,
			height, false, noBorder)
	}

	// Print border label
	t.printLabel(t.border, t.borderLabel, t.borderLabelOpts, t.borderLabelLen, t.borderShape, false)
	t.printLabel(t.pborder, t.previewLabel, t.previewLabelOpts, t.previewLabelLen, t.previewOpts.border, false)

	for i := 0; i < t.window.Height(); i++ {
		t.window.MoveAndClear(i, 0)
	}
}

func (t *Terminal) printLabel(window tui.Window, render labelPrinter, opts labelOpts, length int, borderShape tui.BorderShape, redrawBorder bool) {
	if window == nil {
		return
	}

	switch borderShape {
	case tui.BorderHorizontal, tui.BorderTop, tui.BorderBottom, tui.BorderRounded, tui.BorderSharp, tui.BorderBold, tui.BorderBlock, tui.BorderThinBlock, tui.BorderDouble:
		if redrawBorder {
			window.DrawHBorder()
		}
		if render == nil {
			return
		}
		var col int
		if opts.column == 0 {
			col = util.Max(0, (window.Width()-length)/2)
		} else if opts.column < 0 {
			col = util.Max(0, window.Width()+opts.column+1-length)
		} else {
			col = util.Min(opts.column-1, window.Width()-length)
		}
		row := 0
		if borderShape == tui.BorderBottom || opts.bottom {
			row = window.Height() - 1
		}
		window.Move(row, col)
		render(window, window.Width())
	}
}

func (t *Terminal) move(y int, x int, clear bool) {
	h := t.window.Height()

	switch t.layout {
	case layoutDefault:
		y = h - y - 1
	case layoutReverseList:
		n := 2 + len(t.header0) + len(t.header)
		if t.noInfoLine() {
			n--
		}
		if y < n {
			y = h - y - 1
		} else {
			y -= n
		}
	}

	if clear {
		t.window.MoveAndClear(y, x)
	} else {
		t.window.Move(y, x)
	}
}

func (t *Terminal) truncateQuery() {
	t.input, _ = t.trimRight(t.input, maxPatternLength)
	t.cx = util.Constrain(t.cx, 0, len(t.input))
}

func (t *Terminal) updatePromptOffset() ([]rune, []rune) {
	maxWidth := util.Max(1, t.window.Width()-t.promptLen-1)

	_, overflow := t.trimLeft(t.input[:t.cx], maxWidth)
	minOffset := int(overflow)
	maxOffset := minOffset + (maxWidth-util.Max(0, maxWidth-t.cx))/2
	t.xoffset = util.Constrain(t.xoffset, minOffset, maxOffset)
	before, _ := t.trimLeft(t.input[t.xoffset:t.cx], maxWidth)
	beforeLen := t.displayWidth(before)
	after, _ := t.trimRight(t.input[t.cx:], maxWidth-beforeLen)
	afterLen := t.displayWidth(after)
	t.queryLen = [2]int{beforeLen, afterLen}
	return before, after
}

func (t *Terminal) promptLine() int {
	if t.headerFirst {
		max := t.window.Height() - 1
		if !t.noInfoLine() {
			max--
		}
		return util.Min(len(t.header0)+t.headerLines, max)
	}
	return 0
}

func (t *Terminal) placeCursor() {
	t.move(t.promptLine(), t.promptLen+t.queryLen[0], false)
}

func (t *Terminal) printPrompt() {
	t.move(t.promptLine(), 0, true)
	t.prompt()

	before, after := t.updatePromptOffset()
	color := tui.ColInput
	if t.paused {
		color = tui.ColDisabled
	}
	t.window.CPrint(color, string(before))
	t.window.CPrint(color, string(after))
}

func (t *Terminal) trimMessage(message string, maxWidth int) string {
	if len(message) <= maxWidth {
		return message
	}
	runes, _ := t.trimRight([]rune(message), maxWidth-2)
	return string(runes) + strings.Repeat(".", util.Constrain(maxWidth, 0, 2))
}

func (t *Terminal) printInfo() {
	pos := 0
	line := t.promptLine()
	printSpinner := func() {
		if t.reading {
			duration := int64(spinnerDuration)
			idx := (time.Now().UnixNano() % (duration * int64(len(t.spinner)))) / duration
			t.window.CPrint(tui.ColSpinner, t.spinner[idx])
		} else {
			t.window.Print(" ") // Clear spinner
		}
	}
	switch t.infoStyle {
	case infoDefault:
		t.move(line+1, 0, t.separatorLen == 0)
		printSpinner()
		t.move(line+1, 2, false)
		pos = 2
	case infoRight:
		t.move(line+1, 0, false)
	case infoInlineRight:
		pos = t.promptLen + t.queryLen[0] + t.queryLen[1] + 1
		t.move(line, pos, true)
	case infoInline:
		pos = t.promptLen + t.queryLen[0] + t.queryLen[1] + 1
		str := t.infoSep
		maxWidth := t.window.Width() - pos
		width := util.StringWidth(str)
		if width > maxWidth {
			trimmed, _ := t.trimRight([]rune(str), maxWidth)
			str = string(trimmed)
			width = maxWidth
		}
		t.move(line, pos, t.separatorLen == 0)
		if t.reading {
			t.window.CPrint(tui.ColSpinner, str)
		} else {
			t.window.CPrint(tui.ColPrompt, str)
		}
		pos += width
	case infoHidden:
		return
	}

	found := t.merger.Length()
	total := util.Max(found, t.count)
	output := fmt.Sprintf("%d/%d", found, total)
	if t.toggleSort {
		if t.sort {
			output += " +S"
		} else {
			output += " -S"
		}
	}
	if t.track != trackDisabled {
		output += " +T"
	}
	if t.multi > 0 {
		if t.multi == maxMulti {
			output += fmt.Sprintf(" (%d)", len(t.selected))
		} else {
			output += fmt.Sprintf(" (%d/%d)", len(t.selected), t.multi)
		}
	}
	if t.progress > 0 && t.progress < 100 {
		output += fmt.Sprintf(" (%d%%)", t.progress)
	}
	if t.failed != nil && t.count == 0 {
		output = fmt.Sprintf("[Command failed: %s]", *t.failed)
	}

	printSeparator := func(fillLength int, pad bool) {
		// --------_
		if t.separatorLen > 0 {
			t.separator(t.window, fillLength)
			t.window.Print(" ")
		} else if pad {
			t.window.Print(strings.Repeat(" ", fillLength+1))
		}
	}
	if t.infoStyle == infoRight {
		maxWidth := t.window.Width()
		if t.reading {
			// Need space for spinner and a margin column
			maxWidth -= 2
		}
		output = t.trimMessage(output, maxWidth)
		fillLength := t.window.Width() - len(output) - 2
		if t.reading {
			if fillLength >= 2 {
				printSeparator(fillLength-2, true)
			}
			printSpinner()
			t.window.Print(" ")
		} else if fillLength >= 0 {
			printSeparator(fillLength, true)
		}
		t.window.CPrint(tui.ColInfo, output)
		return
	}

	if t.infoStyle == infoInlineRight {
		pos = util.Max(pos, t.window.Width()-util.StringWidth(output)-3)
		if pos >= t.window.Width() {
			return
		}
		t.move(line, pos, false)
		printSpinner()
		t.window.Print(" ")
		pos += 2
	}

	maxWidth := t.window.Width() - pos
	output = t.trimMessage(output, maxWidth)
	t.window.CPrint(tui.ColInfo, output)
	fillLength := maxWidth - len(output) - 2
	if fillLength > 0 {
		t.window.CPrint(tui.ColSeparator, " ")
		printSeparator(fillLength, false)
	}
}

func (t *Terminal) printHeader() {
	if len(t.header0)+len(t.header) == 0 {
		return
	}
	max := t.window.Height()
	if t.headerFirst {
		max--
		if !t.noInfoLine() {
			max--
		}
	}
	var state *ansiState
	for idx, lineStr := range append(append([]string{}, t.header0...), t.header...) {
		line := idx
		if !t.headerFirst {
			line++
			if !t.noInfoLine() {
				line++
			}
		}
		if line >= max {
			continue
		}
		trimmed, colors, newState := extractColor(lineStr, state, nil)
		state = newState
		item := &Item{
			text:   util.ToChars([]byte(trimmed)),
			colors: colors}

		t.move(line, 2, true)
		t.printHighlighted(Result{item: item},
			tui.ColHeader, tui.ColHeader, false, false)
	}
}

func (t *Terminal) printList() {
	t.constrain()
	barLength, barStart := t.getScrollbar()

	maxy := t.maxItems()
	count := t.merger.Length() - t.offset
	for j := 0; j < maxy; j++ {
		i := j
		if t.layout == layoutDefault {
			i = maxy - 1 - j
		}
		line := i + 2 + len(t.header0) + len(t.header)
		if t.noInfoLine() {
			line--
		}
		if i < count {
			t.printItem(t.merger.Get(i+t.offset), line, i, i == t.cy-t.offset, i >= barStart && i < barStart+barLength)
		} else if t.prevLines[i] != emptyLine {
			t.prevLines[i] = emptyLine
			t.move(line, 0, true)
		}
	}
}

func (t *Terminal) printItem(result Result, line int, i int, current bool, bar bool) {
	item := result.item
	_, selected := t.selected[item.Index()]
	label := ""
	if t.jumping != jumpDisabled {
		if i < len(t.jumpLabels) {
			// Striped
			current = i%2 == 0
			label = t.jumpLabels[i:i+1] + strings.Repeat(" ", t.pointerLen-1)
		}
	} else if current {
		label = t.pointer
	}

	// Avoid unnecessary redraw
	newLine := itemLine{current: current, selected: selected, label: label,
		result: result, queryLen: len(t.input), width: 0, bar: bar}
	prevLine := t.prevLines[i]
	printBar := func() {
		if len(t.scrollbar) > 0 && bar != prevLine.bar {
			t.prevLines[i].bar = bar
			t.move(line, t.window.Width()-1, true)
			if bar {
				t.window.CPrint(tui.ColScrollbar, t.scrollbar)
			}
		}
	}

	if prevLine.current == newLine.current &&
		prevLine.selected == newLine.selected &&
		prevLine.label == newLine.label &&
		prevLine.queryLen == newLine.queryLen &&
		prevLine.result == newLine.result {
		printBar()
		return
	}

	t.move(line, 0, false)
	if current {
		if len(label) == 0 {
			t.window.CPrint(tui.ColCurrentCursorEmpty, t.pointerEmpty)
		} else {
			t.window.CPrint(tui.ColCurrentCursor, label)
		}
		if selected {
			t.window.CPrint(tui.ColCurrentSelected, t.marker)
		} else {
			t.window.CPrint(tui.ColCurrentSelectedEmpty, t.markerEmpty)
		}
		newLine.width = t.printHighlighted(result, tui.ColCurrent, tui.ColCurrentMatch, true, true)
	} else {
		if len(label) == 0 {
			t.window.CPrint(tui.ColCursorEmpty, t.pointerEmpty)
		} else {
			t.window.CPrint(tui.ColCursor, label)
		}
		if selected {
			t.window.CPrint(tui.ColSelected, t.marker)
		} else {
			t.window.Print(t.markerEmpty)
		}
		newLine.width = t.printHighlighted(result, tui.ColNormal, tui.ColMatch, false, true)
	}
	fillSpaces := prevLine.width - newLine.width
	if fillSpaces > 0 {
		t.window.Print(strings.Repeat(" ", fillSpaces))
	}
	printBar()
	t.prevLines[i] = newLine
}

func (t *Terminal) trimRight(runes []rune, width int) ([]rune, bool) {
	// We start from the beginning to handle tab characters
	_, overflowIdx := util.RunesWidth(runes, 0, t.tabstop, width)
	if overflowIdx >= 0 {
		return runes[:overflowIdx], true
	}
	return runes, false
}

func (t *Terminal) displayWidthWithLimit(runes []rune, prefixWidth int, limit int) int {
	width, _ := util.RunesWidth(runes, prefixWidth, t.tabstop, limit)
	return width
}

func (t *Terminal) trimLeft(runes []rune, width int) ([]rune, int32) {
	width = util.Max(0, width)
	var trimmed int32
	// Assume that each rune takes at least one column on screen
	if len(runes) > width+2 {
		diff := len(runes) - width - 2
		trimmed = int32(diff)
		runes = runes[diff:]
	}

	currentWidth := t.displayWidth(runes)

	for currentWidth > width && len(runes) > 0 {
		runes = runes[1:]
		trimmed++
		currentWidth = t.displayWidthWithLimit(runes, 2, width)
	}
	return runes, trimmed
}

func (t *Terminal) overflow(runes []rune, max int) bool {
	return t.displayWidthWithLimit(runes, 0, max) > max
}

func (t *Terminal) printHighlighted(result Result, colBase tui.ColorPair, colMatch tui.ColorPair, current bool, match bool) int {
	item := result.item

	// Overflow
	text := make([]rune, item.text.Length())
	copy(text, item.text.ToRunes())
	matchOffsets := []Offset{}
	var pos *[]int
	if match && t.merger.pattern != nil {
		_, matchOffsets, pos = t.merger.pattern.MatchItem(item, true, t.slab)
	}
	charOffsets := matchOffsets
	if pos != nil {
		charOffsets = make([]Offset, len(*pos))
		for idx, p := range *pos {
			offset := Offset{int32(p), int32(p + 1)}
			charOffsets[idx] = offset
		}
		sort.Sort(ByOrder(charOffsets))
	}
	var maxe int
	for _, offset := range charOffsets {
		maxe = util.Max(maxe, int(offset[1]))
	}

	offsets := result.colorOffsets(charOffsets, t.theme, colBase, colMatch, current)
	maxWidth := t.window.Width() - (t.pointerLen + t.markerLen + 1)
	ellipsis, ellipsisWidth := util.Truncate(t.ellipsis, maxWidth/2)
	maxe = util.Constrain(maxe+util.Min(maxWidth/2-ellipsisWidth, t.hscrollOff), 0, len(text))
	displayWidth := t.displayWidthWithLimit(text, 0, maxWidth)
	if displayWidth > maxWidth {
		transformOffsets := func(diff int32, rightTrim bool) {
			for idx, offset := range offsets {
				b, e := offset.offset[0], offset.offset[1]
				el := int32(len(ellipsis))
				b += el - diff
				e += el - diff
				b = util.Max32(b, el)
				if rightTrim {
					e = util.Min32(e, int32(maxWidth-ellipsisWidth))
				}
				offsets[idx].offset[0] = b
				offsets[idx].offset[1] = util.Max32(b, e)
			}
		}
		if t.hscroll {
			if t.keepRight && pos == nil {
				trimmed, diff := t.trimLeft(text, maxWidth-ellipsisWidth)
				transformOffsets(diff, false)
				text = append(ellipsis, trimmed...)
			} else if !t.overflow(text[:maxe], maxWidth-ellipsisWidth) {
				// Stri..
				text, _ = t.trimRight(text, maxWidth-ellipsisWidth)
				text = append(text, ellipsis...)
			} else {
				// Stri..
				rightTrim := false
				if t.overflow(text[maxe:], ellipsisWidth) {
					text = append(text[:maxe], ellipsis...)
					rightTrim = true
				}
				// ..ri..
				var diff int32
				text, diff = t.trimLeft(text, maxWidth-ellipsisWidth)

				// Transform offsets
				transformOffsets(diff, rightTrim)
				text = append(ellipsis, text...)
			}
		} else {
			text, _ = t.trimRight(text, maxWidth-ellipsisWidth)
			text = append(text, ellipsis...)

			for idx, offset := range offsets {
				offsets[idx].offset[0] = util.Min32(offset.offset[0], int32(maxWidth-len(ellipsis)))
				offsets[idx].offset[1] = util.Min32(offset.offset[1], int32(maxWidth))
			}
		}
		displayWidth = t.displayWidthWithLimit(text, 0, displayWidth)
	}

	t.printColoredString(t.window, text, offsets, colBase)
	return displayWidth
}

func (t *Terminal) printColoredString(window tui.Window, text []rune, offsets []colorOffset, colBase tui.ColorPair) {
	var index int32
	var substr string
	var prefixWidth int
	maxOffset := int32(len(text))
	for _, offset := range offsets {
		b := util.Constrain32(offset.offset[0], index, maxOffset)
		e := util.Constrain32(offset.offset[1], index, maxOffset)

		substr, prefixWidth = t.processTabs(text[index:b], prefixWidth)
		window.CPrint(colBase, substr)

		if b < e {
			substr, prefixWidth = t.processTabs(text[b:e], prefixWidth)
			window.CPrint(offset.color, substr)
		}

		index = e
		if index >= maxOffset {
			break
		}
	}
	if index < maxOffset {
		substr, _ = t.processTabs(text[index:], prefixWidth)
		window.CPrint(colBase, substr)
	}
}

func (t *Terminal) renderPreviewSpinner() {
	numLines := len(t.previewer.lines)
	spin := t.previewer.spinner
	if len(spin) > 0 || t.previewer.scrollable {
		maxWidth := t.pwindow.Width()
		if !t.previewer.scrollable {
			if maxWidth > 0 {
				t.pwindow.Move(0, maxWidth-1)
				t.pwindow.CPrint(tui.ColPreviewSpinner, spin)
			}
		} else {
			offsetString := fmt.Sprintf("%d/%d", t.previewer.offset+1, numLines)
			if len(spin) > 0 {
				spin += " "
				maxWidth -= 2
			}
			offsetRunes, _ := t.trimRight([]rune(offsetString), maxWidth)
			pos := maxWidth - t.displayWidth(offsetRunes)
			t.pwindow.Move(0, pos)
			if maxWidth > 0 {
				t.pwindow.CPrint(tui.ColPreviewSpinner, spin)
				t.pwindow.CPrint(tui.ColInfo.WithAttr(tui.Reverse), string(offsetRunes))
			}
		}
	}
}

func (t *Terminal) renderPreviewArea(unchanged bool) {
	if unchanged {
		t.pwindow.MoveAndClear(0, 0) // Clear scroll offset display
	} else {
		t.previewed.filled = false
		t.pwindow.Erase()
	}

	height := t.pwindow.Height()
	header := []string{}
	body := t.previewer.lines
	headerLines := t.previewOpts.headerLines
	// Do not enable preview header lines if it's value is too large
	if headerLines > 0 && headerLines < util.Min(len(body), height) {
		header = t.previewer.lines[0:headerLines]
		body = t.previewer.lines[headerLines:]
		// Always redraw header
		t.renderPreviewText(height, header, 0, false)
		t.pwindow.MoveAndClear(t.pwindow.Y(), 0)
	}
	t.renderPreviewText(height, body, -t.previewer.offset+headerLines, unchanged)

	if !unchanged {
		t.pwindow.FinishFill()
	}

	if len(t.scrollbar) == 0 {
		return
	}

	effectiveHeight := height - headerLines
	barLength, barStart := getScrollbar(len(body), effectiveHeight, util.Min(len(body)-effectiveHeight, t.previewer.offset-headerLines))
	t.renderPreviewScrollbar(headerLines, barLength, barStart)
}

func (t *Terminal) renderPreviewText(height int, lines []string, lineNo int, unchanged bool) {
	maxWidth := t.pwindow.Width()
	var ansi *ansiState
	spinnerRedraw := t.pwindow.Y() == 0
	for _, line := range lines {
		var lbg tui.Color = -1
		if ansi != nil {
			ansi.lbg = -1
		}
		line = strings.TrimRight(line, "\r\n")
		if lineNo >= height || t.pwindow.Y() == height-1 && t.pwindow.X() > 0 {
			t.previewed.filled = true
			t.previewer.scrollable = true
			break
		} else if lineNo >= 0 {
			if spinnerRedraw && lineNo > 0 {
				spinnerRedraw = false
				y := t.pwindow.Y()
				x := t.pwindow.X()
				t.renderPreviewSpinner()
				t.pwindow.Move(y, x)
			}
			var fillRet tui.FillReturn
			prefixWidth := 0
			_, _, ansi = extractColor(line, ansi, func(str string, ansi *ansiState) bool {
				trimmed := []rune(str)
				isTrimmed := false
				if !t.previewOpts.wrap {
					trimmed, isTrimmed = t.trimRight(trimmed, maxWidth-t.pwindow.X())
				}
				str, width := t.processTabs(trimmed, prefixWidth)
				if width > prefixWidth {
					prefixWidth = width
					if t.theme.Colored && ansi != nil && ansi.colored() {
						lbg = ansi.lbg
						fillRet = t.pwindow.CFill(ansi.fg, ansi.bg, ansi.attr, str)
					} else {
						fillRet = t.pwindow.CFill(tui.ColPreview.Fg(), tui.ColPreview.Bg(), tui.AttrRegular, str)
					}
				}
				return !isTrimmed &&
					(fillRet == tui.FillContinue || t.previewOpts.wrap && fillRet == tui.FillNextLine)
			})
			t.previewer.scrollable = t.previewer.scrollable || t.pwindow.Y() == height-1 && t.pwindow.X() == t.pwindow.Width()
			if fillRet == tui.FillNextLine {
				continue
			} else if fillRet == tui.FillSuspend {
				t.previewed.filled = true
				break
			}
			if unchanged && lineNo == 0 {
				break
			}
			if lbg >= 0 {
				t.pwindow.CFill(-1, lbg, tui.AttrRegular,
					strings.Repeat(" ", t.pwindow.Width()-t.pwindow.X())+"\n")
			} else {
				t.pwindow.Fill("\n")
			}
		}
		lineNo++
	}
}

func (t *Terminal) renderPreviewScrollbar(yoff int, barLength int, barStart int) {
	height := t.pwindow.Height()
	w := t.pborder.Width()
	redraw := false
	if len(t.previewer.bar) != height {
		redraw = true
		t.previewer.bar = make([]bool, height)
	}
	xshift := -1 - t.borderWidth
	if !t.previewOpts.border.HasRight() {
		xshift = -1
	}
	yshift := 1
	if !t.previewOpts.border.HasTop() {
		yshift = 0
	}
	for i := yoff; i < height; i++ {
		x := w + xshift
		y := i + yshift

		// Avoid unnecessary redraws
		bar := i >= yoff+barStart && i < yoff+barStart+barLength
		if !redraw && bar == t.previewer.bar[i] && !t.tui.NeedScrollbarRedraw() {
			continue
		}

		t.previewer.bar[i] = bar
		t.pborder.Move(y, x)
		if i >= yoff+barStart && i < yoff+barStart+barLength {
			t.pborder.CPrint(tui.ColPreviewScrollbar, t.previewScrollbar)
		} else {
			t.pborder.CPrint(tui.ColPreviewScrollbar, " ")
		}
	}
}

func (t *Terminal) printPreview() {
	if !t.hasPreviewWindow() || t.pwindow.Height() == 0 {
		return
	}
	numLines := len(t.previewer.lines)
	height := t.pwindow.Height()
	unchanged := (t.previewed.filled || numLines == t.previewed.numLines) &&
		t.previewer.version == t.previewed.version &&
		t.previewer.offset == t.previewed.offset
	t.previewer.scrollable = t.previewer.offset > 0 || numLines > height
	t.renderPreviewArea(unchanged)
	t.renderPreviewSpinner()
	t.previewed.numLines = numLines
	t.previewed.version = t.previewer.version
	t.previewed.offset = t.previewer.offset
}

func (t *Terminal) printPreviewDelayed() {
	if !t.hasPreviewWindow() || len(t.previewer.lines) > 0 && t.previewed.version == t.previewer.version {
		return
	}

	t.previewer.scrollable = false
	t.renderPreviewArea(true)

	message := t.trimMessage("Loading ..", t.pwindow.Width())
	pos := t.pwindow.Width() - len(message)
	t.pwindow.Move(0, pos)
	t.pwindow.CPrint(tui.ColInfo.WithAttr(tui.Reverse), message)
}

func (t *Terminal) processTabs(runes []rune, prefixWidth int) (string, int) {
	var strbuf strings.Builder
	l := prefixWidth
	gr := uniseg.NewGraphemes(string(runes))
	for gr.Next() {
		rs := gr.Runes()
		str := string(rs)
		var w int
		if len(rs) == 1 && rs[0] == '\t' {
			w = t.tabstop - l%t.tabstop
			strbuf.WriteString(strings.Repeat(" ", w))
		} else {
			w = util.StringWidth(str)
			strbuf.WriteString(str)
		}
		l += w
	}
	return strbuf.String(), l
}

func (t *Terminal) printAll() {
	t.resizeWindows(false)
	t.printList()
	t.printPrompt()
	t.printInfo()
	t.printHeader()
	t.printPreview()
}

func (t *Terminal) refresh() {
	t.placeCursor()
	if !t.suppress {
		windows := make([]tui.Window, 0, 4)
		if t.borderShape != tui.BorderNone {
			windows = append(windows, t.border)
		}
		if t.hasPreviewWindow() {
			if t.pborder != nil {
				windows = append(windows, t.pborder)
			}
			windows = append(windows, t.pwindow)
		}
		windows = append(windows, t.window)
		t.tui.RefreshWindows(windows)
	}
}

func (t *Terminal) delChar() bool {
	if len(t.input) > 0 && t.cx < len(t.input) {
		t.input = append(t.input[:t.cx], t.input[t.cx+1:]...)
		return true
	}
	return false
}

func findLastMatch(pattern string, str string) int {
	rx, err := regexp.Compile(pattern)
	if err != nil {
		return -1
	}
	locs := rx.FindAllStringIndex(str, -1)
	if locs == nil {
		return -1
	}
	prefix := []rune(str[:locs[len(locs)-1][0]])
	return len(prefix)
}

func findFirstMatch(pattern string, str string) int {
	rx, err := regexp.Compile(pattern)
	if err != nil {
		return -1
	}
	loc := rx.FindStringIndex(str)
	if loc == nil {
		return -1
	}
	prefix := []rune(str[:loc[0]])
	return len(prefix)
}

func copySlice(slice []rune) []rune {
	ret := make([]rune, len(slice))
	copy(ret, slice)
	return ret
}

func (t *Terminal) rubout(pattern string) {
	pcx := t.cx
	after := t.input[t.cx:]
	t.cx = findLastMatch(pattern, string(t.input[:t.cx])) + 1
	t.yanked = copySlice(t.input[t.cx:pcx])
	t.input = append(t.input[:t.cx], after...)
}

func keyMatch(key tui.Event, event tui.Event) bool {
	return event.Type == key.Type && event.Char == key.Char ||
		key.Type == tui.DoubleClick && event.Type == tui.Mouse && event.MouseEvent.Double
}

func parsePlaceholder(match string) (bool, string, placeholderFlags) {
	flags := placeholderFlags{}

	if match[0] == '\\' {
		// Escaped placeholder pattern
		return true, match[1:], flags
	}

	skipChars := 1
	for _, char := range match[1:] {
		switch char {
		case '+':
			flags.plus = true
			skipChars++
		case 's':
			flags.preserveSpace = true
			skipChars++
		case 'n':
			flags.number = true
			skipChars++
		case 'f':
			flags.file = true
			skipChars++
		case 'q':
			flags.query = true
			// query flag is not skipped
		default:
			break
		}
	}

	matchWithoutFlags := "{" + match[skipChars:]

	return false, matchWithoutFlags, flags
}

func hasPreviewFlags(template string) (slot bool, plus bool, query bool) {
	for _, match := range placeholder.FindAllString(template, -1) {
		_, _, flags := parsePlaceholder(match)
		if flags.plus {
			plus = true
		}
		if flags.query {
			query = true
		}
		slot = true
	}
	return
}

func writeTemporaryFile(data []string, printSep string) string {
	f, err := ioutil.TempFile("", "fzf-preview-*")
	if err != nil {
		errorExit("Unable to create temporary file")
	}
	defer f.Close()

	f.WriteString(strings.Join(data, printSep))
	f.WriteString(printSep)
	activeTempFiles = append(activeTempFiles, f.Name())
	return f.Name()
}

func cleanTemporaryFiles() {
	for _, filename := range activeTempFiles {
		os.Remove(filename)
	}
	activeTempFiles = []string{}
}

func (t *Terminal) replacePlaceholder(template string, forcePlus bool, input string, list []*Item) string {
	return replacePlaceholder(
		template, t.ansi, t.delimiter, t.printsep, forcePlus, input, list)
}

func (t *Terminal) evaluateScrollOffset() int {
	if t.pwindow == nil {
		return 0
	}

	// We only need the current item to calculate the scroll offset
	offsetExpr := offsetTrimCharsRegex.ReplaceAllString(
		t.replacePlaceholder(t.previewOpts.scroll, false, "", []*Item{t.currentItem(), nil}), "")

	atoi := func(s string) int {
		n, e := strconv.Atoi(s)
		if e != nil {
			return 0
		}
		return n
	}

	base := -1
	height := util.Max(0, t.pwindow.Height()-t.previewOpts.headerLines)
	for _, component := range offsetComponentRegex.FindAllString(offsetExpr, -1) {
		if strings.HasPrefix(component, "-/") {
			component = component[1:]
		}
		if component[0] == '/' {
			denom := atoi(component[1:])
			if denom != 0 {
				base -= height / denom
			}
			break
		}
		base += atoi(component)
	}
	return util.Max(0, base)
}

func replacePlaceholder(template string, stripAnsi bool, delimiter Delimiter, printsep string, forcePlus bool, query string, allItems []*Item) string {
	current := allItems[:1]
	selected := allItems[1:]
	if current[0] == nil {
		current = []*Item{}
	}
	if selected[0] == nil {
		selected = []*Item{}
	}

	// replace placeholders one by one
	return placeholder.ReplaceAllStringFunc(template, func(match string) string {
		escaped, match, flags := parsePlaceholder(match)

		// this function implements the effects a placeholder has on items
		var replace func(*Item) string

		// placeholder types (escaped, query type, item type, token type)
		switch {
		case escaped:
			return match
		case match == "{q}":
			return quoteEntry(query)
		case match == "{}":
			replace = func(item *Item) string {
				switch {
				case flags.number:
					n := int(item.text.Index)
					if n < 0 {
						return ""
					}
					return strconv.Itoa(n)
				case flags.file:
					return item.AsString(stripAnsi)
				default:
					return quoteEntry(item.AsString(stripAnsi))
				}
			}
		default:
			// token type and also failover (below)
			rangeExpressions := strings.Split(match[1:len(match)-1], ",")
			ranges := make([]Range, len(rangeExpressions))
			for idx, s := range rangeExpressions {
				r, ok := ParseRange(&s) // ellipsis (x..y) and shorthand (x..x) range syntax
				if !ok {
					// Invalid expression, just return the original string in the template
					return match
				}
				ranges[idx] = r
			}

			replace = func(item *Item) string {
				tokens := Tokenize(item.AsString(stripAnsi), delimiter)
				trans := Transform(tokens, ranges)
				str := joinTokens(trans)

				// trim the last delimiter
				if delimiter.str != nil {
					str = strings.TrimSuffix(str, *delimiter.str)
				} else if delimiter.regex != nil {
					delims := delimiter.regex.FindAllStringIndex(str, -1)
					// make sure the delimiter is at the very end of the string
					if len(delims) > 0 && delims[len(delims)-1][1] == len(str) {
						str = str[:delims[len(delims)-1][0]]
					}
				}

				if !flags.preserveSpace {
					str = strings.TrimSpace(str)
				}
				if !flags.file {
					str = quoteEntry(str)
				}
				return str
			}
		}

		// apply 'replace' function over proper set of items and return result

		items := current
		if flags.plus || forcePlus {
			items = selected
		}
		replacements := make([]string, len(items))

		for idx, item := range items {
			replacements[idx] = replace(item)
		}

		if flags.file {
			return writeTemporaryFile(replacements, printsep)
		}
		return strings.Join(replacements, " ")
	})
}

func (t *Terminal) redraw() {
	t.tui.Clear()
	t.tui.Refresh()
	t.printAll()
}

func (t *Terminal) executeCommand(template string, forcePlus bool, background bool, capture bool, firstLineOnly bool) string {
	line := ""
	valid, list := t.buildPlusList(template, forcePlus)
	// 'capture' is used for transform-* and we don't want to
	// return an empty string in those cases
	if !valid && !capture {
		return line
	}
	command := t.replacePlaceholder(template, forcePlus, string(t.input), list)
	cmd := util.ExecCommand(command, false)
	cmd.Env = t.environ()
	t.executing.Set(true)
	if !background {
		cmd.Stdin = tui.TtyIn()
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		t.tui.Pause(true)
		cmd.Run()
		t.tui.Resume(true, false)
		t.redraw()
		t.refresh()
	} else {
		if capture {
			out, _ := cmd.StdoutPipe()
			reader := bufio.NewReader(out)
			cmd.Start()
			if firstLineOnly {
				line, _ = reader.ReadString('\n')
				line = strings.TrimRight(line, "\r\n")
			} else {
				bytes, _ := io.ReadAll(reader)
				line = string(bytes)
			}
			cmd.Wait()
		} else {
			cmd.Run()
		}
	}
	t.executing.Set(false)
	cleanTemporaryFiles()
	return line
}

func (t *Terminal) hasPreviewer() bool {
	return t.previewBox != nil
}

func (t *Terminal) needPreviewWindow() bool {
	return t.hasPreviewer() && len(t.previewOpts.command) > 0 && t.previewOpts.Visible()
}

// Check if previewer is currently in action (invisible previewer with size 0 or visible previewer)
func (t *Terminal) canPreview() bool {
	return t.hasPreviewer() && (!t.previewOpts.Visible() && !t.previewOpts.hidden || t.hasPreviewWindow())
}

func (t *Terminal) hasPreviewWindow() bool {
	return t.pwindow != nil
}

func (t *Terminal) currentItem() *Item {
	cnt := t.merger.Length()
	if t.cy >= 0 && cnt > 0 && cnt > t.cy {
		return t.merger.Get(t.cy).item
	}
	return nil
}

func (t *Terminal) buildPlusList(template string, forcePlus bool) (bool, []*Item) {
	current := t.currentItem()
	slot, plus, query := hasPreviewFlags(template)
	if !(!slot || query || (forcePlus || plus) && len(t.selected) > 0) {
		return current != nil, []*Item{current, current}
	}

	// We would still want to update preview window even if there is no match if
	//   1. command template contains {q} and the query string is not empty
	//   2. or it contains {+} and we have more than one item already selected.
	// To do so, we pass an empty Item instead of nil to trigger an update.
	if current == nil {
		current = &minItem
	}

	var sels []*Item
	if len(t.selected) == 0 {
		sels = []*Item{current, current}
	} else {
		sels = make([]*Item, len(t.selected)+1)
		sels[0] = current
		for i, sel := range t.sortSelected() {
			sels[i+1] = sel.item
		}
	}
	return true, sels
}

func (t *Terminal) selectItem(item *Item) bool {
	if len(t.selected) >= t.multi {
		return false
	}
	if _, found := t.selected[item.Index()]; found {
		return true
	}

	t.selected[item.Index()] = selectedItem{time.Now(), item}
	t.version++

	return true
}

func (t *Terminal) selectItemChanged(item *Item) bool {
	if _, found := t.selected[item.Index()]; found {
		return false
	}
	return t.selectItem(item)
}

func (t *Terminal) deselectItem(item *Item) {
	delete(t.selected, item.Index())
	t.version++
}

func (t *Terminal) deselectItemChanged(item *Item) bool {
	if _, found := t.selected[item.Index()]; found {
		t.deselectItem(item)
		return true
	}
	return false
}

func (t *Terminal) toggleItem(item *Item) bool {
	if _, found := t.selected[item.Index()]; !found {
		return t.selectItem(item)
	}
	t.deselectItem(item)
	return true
}

func (t *Terminal) killPreview(code int) {
	select {
	case t.killChan <- code:
	default:
		if code != exitCancel {
			t.eventBox.Set(EvtQuit, code)
		}
	}
}

func (t *Terminal) cancelPreview() {
	t.killPreview(exitCancel)
}

// Loop is called to start Terminal I/O
func (t *Terminal) Loop() {
	// prof := profile.Start(profile.ProfilePath("/tmp/"))
	fitpad := <-t.startChan
	fit := fitpad.fit
	if fit >= 0 {
		pad := fitpad.pad
		t.tui.Resize(func(termHeight int) int {
			contentHeight := fit + t.extraLines()
			if t.needPreviewWindow() {
				if t.previewOpts.aboveOrBelow() {
					if t.previewOpts.size.percent {
						newContentHeight := int(float64(contentHeight) * 100. / (100. - t.previewOpts.size.size))
						contentHeight = util.Max(contentHeight+1+borderLines(t.previewOpts.border), newContentHeight)
					} else {
						contentHeight += int(t.previewOpts.size.size) + borderLines(t.previewOpts.border)
					}
				} else {
					// Minimum height if preview window can appear
					contentHeight = util.Max(contentHeight, 1+borderLines(t.previewOpts.border))
				}
			}
			return util.Min(termHeight, contentHeight+pad)
		})
	}
	{ // Late initialization
		intChan := make(chan os.Signal, 1)
		signal.Notify(intChan, os.Interrupt, syscall.SIGTERM)
		go func() {
			for s := range intChan {
				// Don't quit by SIGINT while executing because it should be for the executing command and not for fzf itself
				if !(s == os.Interrupt && t.executing.Get()) {
					t.reqBox.Set(reqQuit, nil)
				}
			}
		}()

		contChan := make(chan os.Signal, 1)
		notifyOnCont(contChan)
		go func() {
			for {
				<-contChan
				t.reqBox.Set(reqReinit, nil)
			}
		}()

		resizeChan := make(chan os.Signal, 1)
		notifyOnResize(resizeChan) // Non-portable
		go func() {
			for {
				<-resizeChan
				t.reqBox.Set(reqFullRedraw, nil)
			}
		}()

		t.mutex.Lock()
		t.initFunc()
		t.resizeWindows(false)
		t.printPrompt()
		t.printInfo()
		t.printHeader()
		t.refresh()
		t.mutex.Unlock()
		go func() {
			timer := time.NewTimer(t.initDelay)
			<-timer.C
			t.reqBox.Set(reqRefresh, nil)
		}()

		// Keep the spinner spinning
		go func() {
			for {
				t.mutex.Lock()
				reading := t.reading
				t.mutex.Unlock()
				time.Sleep(spinnerDuration)
				if reading {
					t.reqBox.Set(reqInfo, nil)
				}
			}
		}()
	}

	if t.hasPreviewer() {
		go func() {
			var version int64
			for {
				var items []*Item
				var commandTemplate string
				var pwindow tui.Window
				initialOffset := 0
				t.previewBox.Wait(func(events *util.Events) {
					for req, value := range *events {
						switch req {
						case reqPreviewEnqueue:
							request := value.(previewRequest)
							commandTemplate = request.template
							initialOffset = request.scrollOffset
							items = request.list
							pwindow = request.pwindow
						}
					}
					events.Clear()
				})
				version++
				// We don't display preview window if no match
				if items[0] != nil {
					_, query := t.Input()
					command := t.replacePlaceholder(commandTemplate, false, string(query), items)
					cmd := util.ExecCommand(command, true)
					env := t.environ()
					if pwindow != nil {
						height := pwindow.Height()
						lines := fmt.Sprintf("LINES=%d", height)
						columns := fmt.Sprintf("COLUMNS=%d", pwindow.Width())
						env = append(env, lines)
						env = append(env, "FZF_PREVIEW_"+lines)
						env = append(env, columns)
						env = append(env, "FZF_PREVIEW_"+columns)
					}
					cmd.Env = env

					out, _ := cmd.StdoutPipe()
					cmd.Stderr = cmd.Stdout
					reader := bufio.NewReader(out)
					eofChan := make(chan bool)
					finishChan := make(chan bool, 1)
					err := cmd.Start()
					if err == nil {
						reapChan := make(chan bool)
						lineChan := make(chan eachLine)
						// Goroutine 1 reads process output
						go func() {
							for {
								line, err := reader.ReadString('\n')
								lineChan <- eachLine{line, err}
								if err != nil {
									break
								}
							}
							eofChan <- true
						}()

						// Goroutine 2 periodically requests rendering
						rendered := util.NewAtomicBool(false)
						go func(version int64) {
							lines := []string{}
							spinner := makeSpinner(t.unicode)
							spinnerIndex := -1 // Delay initial rendering by an extra tick
							ticker := time.NewTicker(previewChunkDelay)
							offset := initialOffset
						Loop:
							for {
								select {
								case <-ticker.C:
									if len(lines) > 0 && len(lines) >= initialOffset {
										if spinnerIndex >= 0 {
											spin := spinner[spinnerIndex%len(spinner)]
											t.reqBox.Set(reqPreviewDisplay, previewResult{version, lines, offset, spin})
											rendered.Set(true)
											offset = -1
										}
										spinnerIndex++
									}
								case eachLine := <-lineChan:
									line := eachLine.line
									err := eachLine.err
									if len(line) > 0 {
										clearIndex := strings.Index(line, clearCode)
										if clearIndex >= 0 {
											lines = []string{}
											line = line[clearIndex+len(clearCode):]
											version--
											offset = 0
										}
										lines = append(lines, line)
									}
									if err != nil {
										t.reqBox.Set(reqPreviewDisplay, previewResult{version, lines, offset, ""})
										rendered.Set(true)
										break Loop
									}
								}
							}
							ticker.Stop()
							reapChan <- true
						}(version)

						// Goroutine 3 is responsible for cancelling running preview command
						go func(version int64) {
							timer := time.NewTimer(previewDelayed)
						Loop:
							for {
								select {
								case <-timer.C:
									t.reqBox.Set(reqPreviewDelayed, version)
								case code := <-t.killChan:
									if code != exitCancel {
										util.KillCommand(cmd)
										t.eventBox.Set(EvtQuit, code)
									} else {
										// We can immediately kill a long-running preview program
										// once we started rendering its partial output
										delay := previewCancelWait
										if rendered.Get() {
											delay = 0
										}
										timer := time.NewTimer(delay)
										select {
										case <-timer.C:
											util.KillCommand(cmd)
										case <-finishChan:
										}
										timer.Stop()
									}
									break Loop
								case <-finishChan:
									break Loop
								}
							}
							timer.Stop()
							reapChan <- true
						}(version)

						<-eofChan          // Goroutine 1 finished
						cmd.Wait()         // NOTE: We should not call Wait before EOF
						finishChan <- true // Tell Goroutine 3 to stop
						<-reapChan         // Goroutine 2 and 3 finished
						<-reapChan
					} else {
						// Failed to start the command. Report the error immediately.
						t.reqBox.Set(reqPreviewDisplay, previewResult{version, []string{err.Error()}, 0, ""})
					}

					cleanTemporaryFiles()
				} else {
					t.reqBox.Set(reqPreviewDisplay, previewResult{version, nil, 0, ""})
				}
			}
		}()
	}

	refreshPreview := func(command string) {
		if len(command) > 0 && t.canPreview() {
			_, list := t.buildPlusList(command, false)
			t.cancelPreview()
			t.previewBox.Set(reqPreviewEnqueue, previewRequest{command, t.pwindow, t.evaluateScrollOffset(), list})
		}
	}

	go func() {
		var focusedIndex int32 = minItem.Index()
		var version int64 = -1
		running := true
		code := exitError
		exit := func(getCode func() int) {
			t.tui.Close()
			code = getCode()
			if code <= exitNoMatch && t.history != nil {
				t.history.append(string(t.input))
			}
			running = false
			t.mutex.Unlock()
		}

		for running {
			t.reqBox.Wait(func(events *util.Events) {
				defer events.Clear()
				t.mutex.Lock()
				for req, value := range *events {
					switch req {
					case reqPrompt:
						t.printPrompt()
						if t.noInfoLine() {
							t.printInfo()
						}
					case reqInfo:
						t.printInfo()
					case reqList:
						t.printList()
						var currentIndex int32 = minItem.Index()
						currentItem := t.currentItem()
						if currentItem != nil {
							currentIndex = currentItem.Index()
						}
						focusChanged := focusedIndex != currentIndex
						if focusChanged && t.track == trackCurrent {
							t.track = trackDisabled
							t.printInfo()
						}
						if onFocus, prs := t.keymap[tui.Focus.AsEvent()]; prs && focusChanged {
							t.serverChan <- onFocus
						}
						if focusChanged || version != t.version {
							version = t.version
							focusedIndex = currentIndex
							refreshPreview(t.previewOpts.command)
						}
					case reqJump:
						if t.merger.Length() == 0 {
							t.jumping = jumpDisabled
						}
						t.printList()
					case reqHeader:
						t.printHeader()
					case reqRefresh:
						t.suppress = false
					case reqRedrawBorderLabel:
						t.printLabel(t.border, t.borderLabel, t.borderLabelOpts, t.borderLabelLen, t.borderShape, true)
					case reqRedrawPreviewLabel:
						t.printLabel(t.pborder, t.previewLabel, t.previewLabelOpts, t.previewLabelLen, t.previewOpts.border, true)
					case reqReinit:
						t.tui.Resume(t.fullscreen, t.sigstop)
						t.redraw()
					case reqFullRedraw:
						wasHidden := t.pwindow == nil
						t.redraw()
						if wasHidden && t.hasPreviewWindow() {
							refreshPreview(t.previewOpts.command)
						}
					case reqClose:
						exit(func() int {
							if t.output() {
								return exitOk
							}
							return exitNoMatch
						})
						return
					case reqPreviewDisplay:
						result := value.(previewResult)
						if t.previewer.version != result.version {
							t.previewer.version = result.version
							t.previewer.following.Force(t.previewOpts.follow)
							if t.previewer.following.Enabled() {
								t.previewer.offset = 0
							}
						}
						t.previewer.lines = result.lines
						t.previewer.spinner = result.spinner
						if t.previewer.following.Enabled() {
							t.previewer.offset = util.Max(t.previewer.offset, len(t.previewer.lines)-(t.pwindow.Height()-t.previewOpts.headerLines))
						} else if result.offset >= 0 {
							t.previewer.offset = util.Constrain(result.offset, t.previewOpts.headerLines, len(t.previewer.lines)-1)
						}
						t.printPreview()
					case reqPreviewRefresh:
						t.printPreview()
					case reqPreviewDelayed:
						t.previewer.version = value.(int64)
						t.printPreviewDelayed()
					case reqPrintQuery:
						exit(func() int {
							t.printer(string(t.input))
							return exitOk
						})
						return
					case reqQuit:
						exit(func() int { return exitInterrupt })
						return
					}
				}
				t.refresh()
				t.mutex.Unlock()
			})
		}
		// prof.Stop()
		t.killPreview(code)
	}()

	looping := true
	_, startEvent := t.keymap[tui.Start.AsEvent()]

	needBarrier := true
	barrier := make(chan bool)
	go func() {
		for {
			<-barrier
			t.eventChan <- t.tui.GetChar()
		}
	}()
	previewDraggingPos := -1
	barDragging := false
	pbarDragging := false
	wasDown := false
	for looping {
		var newCommand *string
		var reloadSync bool
		changed := false
		beof := false
		queryChanged := false

		var event tui.Event
		actions := []*action{}
		if startEvent {
			event = tui.Start.AsEvent()
			startEvent = false
		} else {
			if needBarrier {
				barrier <- true
			}
			select {
			case event = <-t.eventChan:
				needBarrier = !event.Is(tui.Load, tui.One, tui.Zero)
			case actions = <-t.serverChan:
				event = tui.Invalid.AsEvent()
				needBarrier = false
			}
		}

		t.mutex.Lock()
		previousInput := t.input
		previousCx := t.cx
		events := []util.EventType{}
		req := func(evts ...util.EventType) {
			for _, event := range evts {
				events = append(events, event)
				if event == reqClose || event == reqQuit {
					looping = false
				}
			}
		}
		updatePreviewWindow := func(forcePreview bool) {
			t.resizeWindows(forcePreview)
			req(reqPrompt, reqList, reqInfo, reqHeader)
		}
		toggle := func() bool {
			current := t.currentItem()
			if current != nil && t.toggleItem(current) {
				req(reqInfo)
				return true
			}
			return false
		}
		scrollPreviewTo := func(newOffset int) {
			if !t.previewer.scrollable {
				return
			}
			numLines := len(t.previewer.lines)
			headerLines := t.previewOpts.headerLines
			if t.previewOpts.cycle {
				offsetRange := numLines - headerLines
				newOffset = ((newOffset-headerLines)+offsetRange)%offsetRange + headerLines
			}
			newOffset = util.Constrain(newOffset, headerLines, numLines-1)
			if t.previewer.offset != newOffset {
				t.previewer.offset = newOffset
				t.previewer.following.Set(t.previewer.offset >= numLines-(t.pwindow.Height()-headerLines))
				req(reqPreviewRefresh)
			}
		}
		scrollPreviewBy := func(amount int) {
			scrollPreviewTo(t.previewer.offset + amount)
		}
		for key, ret := range t.expect {
			if keyMatch(key, event) {
				t.pressed = ret
				t.reqBox.Set(reqClose, nil)
				t.mutex.Unlock()
				return
			}
		}

		actionsFor := func(eventType tui.EventType) []*action {
			return t.keymap[eventType.AsEvent()]
		}

		var doAction func(*action) bool
		doActions := func(actions []*action) bool {
			for _, action := range actions {
				if !doAction(action) {
					return false
				}
			}
			return true
		}
		doAction = func(a *action) bool {
			switch a.t {
			case actIgnore:
			case actBecome:
				valid, list := t.buildPlusList(a.a, false)
				if valid {
					command := t.replacePlaceholder(a.a, false, string(t.input), list)
					shell := os.Getenv("SHELL")
					if len(shell) == 0 {
						shell = "sh"
					}
					shellPath, err := exec.LookPath(shell)
					if err == nil {
						t.tui.Close()
						if t.history != nil {
							t.history.append(string(t.input))
						}
						/*
							FIXME: It is not at all clear why this is required.
							The following command will report 'not a tty', unless we open
							/dev/tty *twice* after closing the standard input for 'reload'
							in Reader.terminate().
								: | fzf --bind 'start:reload:ls' --bind 'enter:become:tty'
						*/
						tui.TtyIn()
						util.SetStdin(tui.TtyIn())
						syscall.Exec(shellPath, []string{shell, "-c", command}, os.Environ())
					}
				}
			case actExecute, actExecuteSilent:
				t.executeCommand(a.a, false, a.t == actExecuteSilent, false, false)
			case actExecuteMulti:
				t.executeCommand(a.a, true, false, false, false)
			case actInvalid:
				t.mutex.Unlock()
				return false
			case actTogglePreview, actShowPreview, actHidePreview:
				var act bool
				switch a.t {
				case actShowPreview:
					act = !t.hasPreviewWindow() && len(t.previewOpts.command) > 0
				case actHidePreview:
					act = t.hasPreviewWindow()
				case actTogglePreview:
					act = t.hasPreviewWindow() || len(t.previewOpts.command) > 0
				}
				if act {
					t.activePreviewOpts.Toggle()
					updatePreviewWindow(false)
					if t.canPreview() {
						valid, list := t.buildPlusList(t.previewOpts.command, false)
						if valid {
							t.cancelPreview()
							t.previewBox.Set(reqPreviewEnqueue,
								previewRequest{t.previewOpts.command, t.pwindow, t.evaluateScrollOffset(), list})
						}
					}
				}
			case actTogglePreviewWrap:
				if t.hasPreviewWindow() {
					t.previewOpts.wrap = !t.previewOpts.wrap
					// Reset preview version so that full redraw occurs
					t.previewed.version = 0
					req(reqPreviewRefresh)
				}
			case actTransformPrompt:
				prompt := t.executeCommand(a.a, false, true, true, true)
				t.prompt, t.promptLen = t.parsePrompt(prompt)
				req(reqPrompt)
			case actTransformQuery:
				query := t.executeCommand(a.a, false, true, true, true)
				t.input = []rune(query)
				t.cx = len(t.input)
			case actToggleSort:
				t.sort = !t.sort
				changed = true
			case actPreviewTop:
				if t.hasPreviewWindow() {
					scrollPreviewTo(0)
				}
			case actPreviewBottom:
				if t.hasPreviewWindow() {
					scrollPreviewTo(len(t.previewer.lines) - t.pwindow.Height())
				}
			case actPreviewUp:
				if t.hasPreviewWindow() {
					scrollPreviewBy(-1)
				}
			case actPreviewDown:
				if t.hasPreviewWindow() {
					scrollPreviewBy(1)
				}
			case actPreviewPageUp:
				if t.hasPreviewWindow() {
					scrollPreviewBy(-t.pwindow.Height())
				}
			case actPreviewPageDown:
				if t.hasPreviewWindow() {
					scrollPreviewBy(t.pwindow.Height())
				}
			case actPreviewHalfPageUp:
				if t.hasPreviewWindow() {
					scrollPreviewBy(-t.pwindow.Height() / 2)
				}
			case actPreviewHalfPageDown:
				if t.hasPreviewWindow() {
					scrollPreviewBy(t.pwindow.Height() / 2)
				}
			case actBeginningOfLine:
				t.cx = 0
			case actBackwardChar:
				if t.cx > 0 {
					t.cx--
				}
			case actPrintQuery:
				req(reqPrintQuery)
			case actChangeQuery:
				t.input = []rune(a.a)
				t.cx = len(t.input)
			case actTransformHeader:
				header := t.executeCommand(a.a, false, true, true, false)
				if t.changeHeader(header) {
					req(reqFullRedraw)
				} else {
					req(reqHeader)
				}
			case actChangeHeader:
				if t.changeHeader(a.a) {
					req(reqFullRedraw)
				} else {
					req(reqHeader)
				}
			case actChangeBorderLabel:
				if t.border != nil {
					t.borderLabel, t.borderLabelLen = t.ansiLabelPrinter(a.a, &tui.ColBorderLabel, false)
					req(reqRedrawBorderLabel)
				}
			case actChangePreviewLabel:
				if t.pborder != nil {
					t.previewLabel, t.previewLabelLen = t.ansiLabelPrinter(a.a, &tui.ColPreviewLabel, false)
					req(reqRedrawPreviewLabel)
				}
			case actTransformBorderLabel:
				if t.border != nil {
					label := t.executeCommand(a.a, false, true, true, true)
					t.borderLabel, t.borderLabelLen = t.ansiLabelPrinter(label, &tui.ColBorderLabel, false)
					req(reqRedrawBorderLabel)
				}
			case actTransformPreviewLabel:
				if t.pborder != nil {
					label := t.executeCommand(a.a, false, true, true, true)
					t.previewLabel, t.previewLabelLen = t.ansiLabelPrinter(label, &tui.ColPreviewLabel, false)
					req(reqRedrawPreviewLabel)
				}
			case actChangePrompt:
				t.prompt, t.promptLen = t.parsePrompt(a.a)
				req(reqPrompt)
			case actPreview:
				updatePreviewWindow(true)
				refreshPreview(a.a)
			case actRefreshPreview:
				refreshPreview(t.previewOpts.command)
			case actReplaceQuery:
				current := t.currentItem()
				if current != nil {
					t.input = current.text.ToRunes()
					t.cx = len(t.input)
				}
			case actAbort:
				req(reqQuit)
			case actDeleteChar:
				t.delChar()
			case actDeleteCharEOF:
				if !t.delChar() && t.cx == 0 {
					req(reqQuit)
				}
			case actEndOfLine:
				t.cx = len(t.input)
			case actCancel:
				if len(t.input) == 0 {
					req(reqQuit)
				} else {
					t.yanked = t.input
					t.input = []rune{}
					t.cx = 0
				}
			case actBackwardDeleteCharEOF:
				if len(t.input) == 0 {
					req(reqQuit)
				} else if t.cx > 0 {
					t.input = append(t.input[:t.cx-1], t.input[t.cx:]...)
					t.cx--
				}
			case actForwardChar:
				if t.cx < len(t.input) {
					t.cx++
				}
			case actBackwardDeleteChar:
				beof = len(t.input) == 0
				if t.cx > 0 {
					t.input = append(t.input[:t.cx-1], t.input[t.cx:]...)
					t.cx--
				}
			case actSelectAll:
				if t.multi > 0 {
					for i := 0; i < t.merger.Length(); i++ {
						if !t.selectItem(t.merger.Get(i).item) {
							break
						}
					}
					req(reqList, reqInfo)
				}
			case actDeselectAll:
				if t.multi > 0 {
					for i := 0; i < t.merger.Length() && len(t.selected) > 0; i++ {
						t.deselectItem(t.merger.Get(i).item)
					}
					req(reqList, reqInfo)
				}
			case actClose:
				if t.hasPreviewWindow() {
					t.activePreviewOpts.Toggle()
					updatePreviewWindow(false)
				} else {
					req(reqQuit)
				}
			case actSelect:
				current := t.currentItem()
				if t.multi > 0 && current != nil && t.selectItemChanged(current) {
					req(reqList, reqInfo)
				}
			case actDeselect:
				current := t.currentItem()
				if t.multi > 0 && current != nil && t.deselectItemChanged(current) {
					req(reqList, reqInfo)
				}
			case actToggle:
				if t.multi > 0 && t.merger.Length() > 0 && toggle() {
					req(reqList)
				}
			case actToggleAll:
				if t.multi > 0 {
					prevIndexes := make(map[int]struct{})
					for i := 0; i < t.merger.Length() && len(t.selected) > 0; i++ {
						item := t.merger.Get(i).item
						if _, found := t.selected[item.Index()]; found {
							prevIndexes[i] = struct{}{}
							t.deselectItem(item)
						}
					}

					for i := 0; i < t.merger.Length(); i++ {
						if _, found := prevIndexes[i]; !found {
							item := t.merger.Get(i).item
							if !t.selectItem(item) {
								break
							}
						}
					}
					req(reqList, reqInfo)
				}
			case actToggleIn:
				if t.layout != layoutDefault {
					return doAction(&action{t: actToggleUp})
				}
				return doAction(&action{t: actToggleDown})
			case actToggleOut:
				if t.layout != layoutDefault {
					return doAction(&action{t: actToggleDown})
				}
				return doAction(&action{t: actToggleUp})
			case actToggleDown:
				if t.multi > 0 && t.merger.Length() > 0 && toggle() {
					t.vmove(-1, true)
					req(reqList)
				}
			case actToggleUp:
				if t.multi > 0 && t.merger.Length() > 0 && toggle() {
					t.vmove(1, true)
					req(reqList)
				}
			case actDown:
				t.vmove(-1, true)
				req(reqList)
			case actUp:
				t.vmove(1, true)
				req(reqList)
			case actAccept:
				req(reqClose)
			case actAcceptNonEmpty:
				if len(t.selected) > 0 || t.merger.Length() > 0 || !t.reading && t.count == 0 {
					req(reqClose)
				}
			case actClearScreen:
				req(reqFullRedraw)
			case actClearQuery:
				t.input = []rune{}
				t.cx = 0
			case actClearSelection:
				if t.multi > 0 {
					t.selected = make(map[int32]selectedItem)
					t.version++
					req(reqList, reqInfo)
				}
			case actFirst:
				t.vset(0)
				req(reqList)
			case actLast:
				t.vset(t.merger.Length() - 1)
				req(reqList)
			case actPosition:
				if n, e := strconv.Atoi(a.a); e == nil {
					if n > 0 {
						n--
					} else if n < 0 {
						n += t.merger.Length()
					}
					t.vset(n)
					req(reqList)
				}
			case actPut:
				str := []rune(a.a)
				suffix := copySlice(t.input[t.cx:])
				t.input = append(append(t.input[:t.cx], str...), suffix...)
				t.cx += len(str)
			case actUnixLineDiscard:
				beof = len(t.input) == 0
				if t.cx > 0 {
					t.yanked = copySlice(t.input[:t.cx])
					t.input = t.input[t.cx:]
					t.cx = 0
				}
			case actUnixWordRubout:
				beof = len(t.input) == 0
				if t.cx > 0 {
					t.rubout("\\s\\S")
				}
			case actBackwardKillWord:
				beof = len(t.input) == 0
				if t.cx > 0 {
					t.rubout(t.wordRubout)
				}
			case actYank:
				suffix := copySlice(t.input[t.cx:])
				t.input = append(append(t.input[:t.cx], t.yanked...), suffix...)
				t.cx += len(t.yanked)
			case actPageUp:
				t.vmove(t.maxItems()-1, false)
				req(reqList)
			case actPageDown:
				t.vmove(-(t.maxItems() - 1), false)
				req(reqList)
			case actHalfPageUp:
				t.vmove(t.maxItems()/2, false)
				req(reqList)
			case actHalfPageDown:
				t.vmove(-(t.maxItems() / 2), false)
				req(reqList)
			case actJump:
				t.jumping = jumpEnabled
				req(reqJump)
			case actJumpAccept:
				t.jumping = jumpAcceptEnabled
				req(reqJump)
			case actBackwardWord:
				t.cx = findLastMatch(t.wordRubout, string(t.input[:t.cx])) + 1
			case actForwardWord:
				t.cx += findFirstMatch(t.wordNext, string(t.input[t.cx:])) + 1
			case actKillWord:
				ncx := t.cx +
					findFirstMatch(t.wordNext, string(t.input[t.cx:])) + 1
				if ncx > t.cx {
					t.yanked = copySlice(t.input[t.cx:ncx])
					t.input = append(t.input[:t.cx], t.input[ncx:]...)
				}
			case actKillLine:
				if t.cx < len(t.input) {
					t.yanked = copySlice(t.input[t.cx:])
					t.input = t.input[:t.cx]
				}
			case actRune:
				prefix := copySlice(t.input[:t.cx])
				t.input = append(append(prefix, event.Char), t.input[t.cx:]...)
				t.cx++
			case actPrevHistory:
				if t.history != nil {
					t.history.override(string(t.input))
					t.input = trimQuery(t.history.previous())
					t.cx = len(t.input)
				}
			case actNextHistory:
				if t.history != nil {
					t.history.override(string(t.input))
					t.input = trimQuery(t.history.next())
					t.cx = len(t.input)
				}
			case actToggleSearch:
				t.paused = !t.paused
				changed = !t.paused
				req(reqPrompt)
			case actToggleTrack:
				switch t.track {
				case trackEnabled:
					t.track = trackDisabled
				case trackDisabled:
					t.track = trackEnabled
				}
				req(reqInfo)
			case actTrack:
				if t.track == trackDisabled {
					t.track = trackCurrent
				}
				req(reqInfo)
			case actEnableSearch:
				t.paused = false
				changed = true
				req(reqPrompt)
			case actDisableSearch:
				t.paused = true
				req(reqPrompt)
			case actSigStop:
				p, err := os.FindProcess(os.Getpid())
				if err == nil {
					t.sigstop = true
					t.tui.Clear()
					t.tui.Pause(t.fullscreen)
					notifyStop(p)
					t.mutex.Unlock()
					return false
				}
			case actMouse:
				me := event.MouseEvent
				mx, my := me.X, me.Y
				clicked := !wasDown && me.Down
				wasDown = me.Down
				if !me.Down {
					barDragging = false
					pbarDragging = false
					previewDraggingPos = -1
				}

				// Scrolling
				if me.S != 0 {
					if t.window.Enclose(my, mx) && t.merger.Length() > 0 {
						if t.multi > 0 && me.Mod {
							toggle()
						}
						t.vmove(me.S, true)
						req(reqList)
					} else if t.hasPreviewWindow() && t.pwindow.Enclose(my, mx) {
						scrollPreviewBy(-me.S)
					}
					break
				}

				// Preview dragging
				if me.Down && (previewDraggingPos >= 0 || clicked && t.hasPreviewWindow() && t.pwindow.Enclose(my, mx)) {
					if previewDraggingPos > 0 {
						scrollPreviewBy(previewDraggingPos - my)
					}
					previewDraggingPos = my
					break
				}

				// Preview scrollbar dragging
				headerLines := t.previewOpts.headerLines
				pbarDragging = me.Down && (pbarDragging || clicked && t.hasPreviewWindow() && my >= t.pwindow.Top()+headerLines && my < t.pwindow.Top()+t.pwindow.Height() && mx == t.pwindow.Left()+t.pwindow.Width())
				if pbarDragging {
					effectiveHeight := t.pwindow.Height() - headerLines
					numLines := len(t.previewer.lines) - headerLines
					barLength, _ := getScrollbar(numLines, effectiveHeight, util.Min(numLines-effectiveHeight, t.previewer.offset-headerLines))
					if barLength > 0 {
						y := my - t.pwindow.Top() - headerLines - barLength/2
						y = util.Constrain(y, 0, effectiveHeight-barLength)
						// offset = (total - maxItems) * barStart / (maxItems - barLength)
						t.previewer.offset = headerLines + int(math.Ceil(float64(y)*float64(numLines-effectiveHeight)/float64(effectiveHeight-barLength)))
						t.previewer.following.Set(t.previewer.offset >= numLines-effectiveHeight)
						req(reqPreviewRefresh)
					}
					break
				}

				// Ignored
				if !t.window.Enclose(my, mx) && !barDragging {
					break
				}

				// Translate coordinates
				mx -= t.window.Left()
				my -= t.window.Top()
				min := 2 + len(t.header0) + len(t.header)
				if t.noInfoLine() {
					min--
				}
				h := t.window.Height()
				switch t.layout {
				case layoutDefault:
					my = h - my - 1
				case layoutReverseList:
					if my < h-min {
						my += min
					} else {
						my = h - my - 1
					}
				}

				// Scrollbar dragging
				barDragging = me.Down && (barDragging || clicked && my >= min && mx == t.window.Width()-1)
				if barDragging {
					barLength, barStart := t.getScrollbar()
					if barLength > 0 {
						maxItems := t.maxItems()
						if newBarStart := util.Constrain(my-min-barLength/2, 0, maxItems-barLength); newBarStart != barStart {
							total := t.merger.Length()
							prevOffset := t.offset
							// barStart = (maxItems - barLength) * t.offset / (total - maxItems)
							t.offset = int(math.Ceil(float64(newBarStart) * float64(total-maxItems) / float64(maxItems-barLength)))
							t.cy = t.offset + t.cy - prevOffset
							req(reqList)
						}
					}
					break
				}

				// Double-click on an item
				if me.Double && mx < t.window.Width()-1 {
					// Double-click
					if my >= min {
						if t.vset(t.offset+my-min) && t.cy < t.merger.Length() {
							return doActions(actionsFor(tui.DoubleClick))
						}
					}
					break
				}

				if me.Down {
					mx = util.Constrain(mx-t.promptLen, 0, len(t.input))
					if my == t.promptLine() && mx >= 0 {
						// Prompt
						t.cx = mx + t.xoffset
					} else if my >= min {
						// List
						if t.vset(t.offset+my-min) && t.multi > 0 && me.Mod {
							toggle()
						}
						req(reqList)
						if me.Left {
							return doActions(actionsFor(tui.LeftClick))
						}
						return doActions(actionsFor(tui.RightClick))
					}
				}
			case actReload, actReloadSync:
				t.failed = nil

				valid, list := t.buildPlusList(a.a, false)
				if !valid {
					// We run the command even when there's no match
					// 1. If the template doesn't have any slots
					// 2. If the template has {q}
					slot, _, query := hasPreviewFlags(a.a)
					valid = !slot || query
				}
				if valid {
					command := t.replacePlaceholder(a.a, false, string(t.input), list)
					newCommand = &command
					reloadSync = a.t == actReloadSync
					t.reading = true
				}
			case actUnbind:
				keys := parseKeyChords(a.a, "PANIC")
				for key := range keys {
					delete(t.keymap, key)
				}
			case actRebind:
				keys := parseKeyChords(a.a, "PANIC")
				for key := range keys {
					if originalAction, found := t.keymapOrg[key]; found {
						t.keymap[key] = originalAction
					}
				}
			case actChangePreview:
				if t.previewOpts.command != a.a {
					t.previewOpts.command = a.a
					updatePreviewWindow(false)
					refreshPreview(t.previewOpts.command)
				}
			case actChangePreviewWindow:
				currentPreviewOpts := t.previewOpts

				// Reset preview options and apply the additional options
				t.previewOpts = t.initialPreviewOpts

				// Split window options
				tokens := strings.Split(a.a, "|")
				if len(tokens[0]) > 0 && t.initialPreviewOpts.hidden {
					t.previewOpts.hidden = false
				}
				parsePreviewWindow(&t.previewOpts, tokens[0])
				if len(tokens) > 1 {
					a.a = strings.Join(append(tokens[1:], tokens[0]), "|")
				}

				// Full redraw
				if !currentPreviewOpts.sameLayout(t.previewOpts) {
					wasHidden := t.pwindow == nil
					updatePreviewWindow(false)
					if wasHidden && t.hasPreviewWindow() {
						refreshPreview(t.previewOpts.command)
					} else {
						req(reqPreviewRefresh)
					}
				} else if !currentPreviewOpts.sameContentLayout(t.previewOpts) {
					t.previewed.version = 0
					req(reqPreviewRefresh)
				}

				// Adjust scroll offset
				if t.hasPreviewWindow() && currentPreviewOpts.scroll != t.previewOpts.scroll {
					scrollPreviewTo(t.evaluateScrollOffset())
				}

				// Resume following
				t.previewer.following.Force(t.previewOpts.follow)
			case actNextSelected, actPrevSelected:
				if len(t.selected) > 0 {
					total := t.merger.Length()
					for i := 1; i < total; i++ {
						y := (t.cy + i) % total
						if t.layout == layoutDefault && a.t == actNextSelected ||
							t.layout != layoutDefault && a.t == actPrevSelected {
							y = (t.cy - i + total) % total
						}
						if _, found := t.selected[t.merger.Get(y).item.Index()]; found {
							t.vset(y)
							req(reqList)
							break
						}
					}
				}
			}
			return true
		}

		if t.jumping == jumpDisabled || len(actions) > 0 {
			// Break out of jump mode if any action is submitted to the server
			if t.jumping != jumpDisabled {
				t.jumping = jumpDisabled
				req(reqList)
			}
			if len(actions) == 0 {
				actions = t.keymap[event.Comparable()]
			}
			if len(actions) == 0 && event.Type == tui.Rune {
				doAction(&action{t: actRune})
			} else if !doActions(actions) {
				continue
			}
			t.truncateQuery()
			queryChanged = string(previousInput) != string(t.input)
			changed = changed || queryChanged
			if onChanges, prs := t.keymap[tui.Change.AsEvent()]; queryChanged && prs {
				if !doActions(onChanges) {
					continue
				}
			}
			if onEOFs, prs := t.keymap[tui.BackwardEOF.AsEvent()]; beof && prs {
				if !doActions(onEOFs) {
					continue
				}
			}
		} else {
			if event.Type == tui.Rune {
				if idx := strings.IndexRune(t.jumpLabels, event.Char); idx >= 0 && idx < t.maxItems() && idx < t.merger.Length() {
					t.cy = idx + t.offset
					if t.jumping == jumpAcceptEnabled {
						req(reqClose)
					}
				}
			}
			t.jumping = jumpDisabled
			req(reqList)
		}

		if queryChanged && t.canPreview() && len(t.previewOpts.command) > 0 {
			_, _, q := hasPreviewFlags(t.previewOpts.command)
			if q {
				t.version++
			}
		}

		if queryChanged || t.cx != previousCx {
			req(reqPrompt)
		}

		t.mutex.Unlock() // Must be unlocked before touching reqBox

		if changed || newCommand != nil {
			t.eventBox.Set(EvtSearchNew, searchRequest{sort: t.sort, sync: reloadSync, command: newCommand, changed: changed})
		}
		for _, event := range events {
			t.reqBox.Set(event, nil)
		}
	}
}

func (t *Terminal) constrain() {
	// count of items to display allowed by filtering
	count := t.merger.Length()
	// count of lines can be displayed
	height := t.maxItems()

	t.cy = util.Constrain(t.cy, 0, count-1)

	minOffset := util.Max(t.cy-height+1, 0)
	maxOffset := util.Max(util.Min(count-height, t.cy), 0)
	t.offset = util.Constrain(t.offset, minOffset, maxOffset)
	if t.scrollOff == 0 {
		return
	}

	scrollOff := util.Min(height/2, t.scrollOff)
	for {
		prevOffset := t.offset
		if t.cy-t.offset < scrollOff {
			t.offset = util.Max(minOffset, t.offset-1)
		}
		if t.cy-t.offset >= height-scrollOff {
			t.offset = util.Min(maxOffset, t.offset+1)
		}
		if t.offset == prevOffset {
			break
		}
	}
}

func (t *Terminal) vmove(o int, allowCycle bool) {
	if t.layout != layoutDefault {
		o *= -1
	}
	dest := t.cy + o
	if t.cycle && allowCycle {
		max := t.merger.Length() - 1
		if dest > max {
			if t.cy == max {
				dest = 0
			}
		} else if dest < 0 {
			if t.cy == 0 {
				dest = max
			}
		}
	}
	t.vset(dest)
}

func (t *Terminal) vset(o int) bool {
	t.cy = util.Constrain(o, 0, t.merger.Length()-1)
	return t.cy == o
}

func (t *Terminal) maxItems() int {
	max := t.window.Height() - 2 - len(t.header0) - len(t.header)
	if t.noInfoLine() {
		max++
	}
	return util.Max(max, 0)
}
./src/terminal_test.go	[[[1
638
package fzf

import (
	"bytes"
	"io"
	"os"
	"regexp"
	"strings"
	"testing"
	"text/template"

	"github.com/junegunn/fzf/src/util"
)

func TestReplacePlaceholder(t *testing.T) {
	item1 := newItem("  foo'bar \x1b[31mbaz\x1b[m")
	items1 := []*Item{item1, item1}
	items2 := []*Item{
		newItem("foo'bar \x1b[31mbaz\x1b[m"),
		newItem("foo'bar \x1b[31mbaz\x1b[m"),
		newItem("FOO'BAR \x1b[31mBAZ\x1b[m")}

	delim := "'"
	var regex *regexp.Regexp

	var result string
	check := func(expected string) {
		if result != expected {
			t.Errorf("expected: %s, actual: %s", expected, result)
		}
	}
	// helper function that converts template format into string and carries out the check()
	checkFormat := func(format string) {
		type quotes struct{ O, I, S string } // outer, inner quotes, print separator
		unixStyle := quotes{`'`, `'\''`, "\n"}
		windowsStyle := quotes{`^"`, `'`, "\n"}
		var effectiveStyle quotes

		if util.IsWindows() {
			effectiveStyle = windowsStyle
		} else {
			effectiveStyle = unixStyle
		}

		expected := templateToString(format, effectiveStyle)
		check(expected)
	}
	printsep := "\n"

	/*
		Test multiple placeholders and the function parameters.
	*/

	// {}, preserve ansi
	result = replacePlaceholder("echo {}", false, Delimiter{}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}  foo{{.I}}bar \x1b[31mbaz\x1b[m{{.O}}")

	// {}, strip ansi
	result = replacePlaceholder("echo {}", true, Delimiter{}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}  foo{{.I}}bar baz{{.O}}")

	// {}, with multiple items
	result = replacePlaceholder("echo {}", true, Delimiter{}, printsep, false, "query", items2)
	checkFormat("echo {{.O}}foo{{.I}}bar baz{{.O}}")

	// {..}, strip leading whitespaces, preserve ansi
	result = replacePlaceholder("echo {..}", false, Delimiter{}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}foo{{.I}}bar \x1b[31mbaz\x1b[m{{.O}}")

	// {..}, strip leading whitespaces, strip ansi
	result = replacePlaceholder("echo {..}", true, Delimiter{}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}foo{{.I}}bar baz{{.O}}")

	// {q}
	result = replacePlaceholder("echo {} {q}", true, Delimiter{}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}  foo{{.I}}bar baz{{.O}} {{.O}}query{{.O}}")

	// {q}, multiple items
	result = replacePlaceholder("echo {+}{q}{+}", true, Delimiter{}, printsep, false, "query 'string'", items2)
	checkFormat("echo {{.O}}foo{{.I}}bar baz{{.O}} {{.O}}FOO{{.I}}BAR BAZ{{.O}}{{.O}}query {{.I}}string{{.I}}{{.O}}{{.O}}foo{{.I}}bar baz{{.O}} {{.O}}FOO{{.I}}BAR BAZ{{.O}}")

	result = replacePlaceholder("echo {}{q}{}", true, Delimiter{}, printsep, false, "query 'string'", items2)
	checkFormat("echo {{.O}}foo{{.I}}bar baz{{.O}}{{.O}}query {{.I}}string{{.I}}{{.O}}{{.O}}foo{{.I}}bar baz{{.O}}")

	result = replacePlaceholder("echo {1}/{2}/{2,1}/{-1}/{-2}/{}/{..}/{n.t}/\\{}/\\{1}/\\{q}/{3}", true, Delimiter{}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}foo{{.I}}bar{{.O}}/{{.O}}baz{{.O}}/{{.O}}bazfoo{{.I}}bar{{.O}}/{{.O}}baz{{.O}}/{{.O}}foo{{.I}}bar{{.O}}/{{.O}}  foo{{.I}}bar baz{{.O}}/{{.O}}foo{{.I}}bar baz{{.O}}/{n.t}/{}/{1}/{q}/{{.O}}{{.O}}")

	result = replacePlaceholder("echo {1}/{2}/{-1}/{-2}/{..}/{n.t}/\\{}/\\{1}/\\{q}/{3}", true, Delimiter{}, printsep, false, "query", items2)
	checkFormat("echo {{.O}}foo{{.I}}bar{{.O}}/{{.O}}baz{{.O}}/{{.O}}baz{{.O}}/{{.O}}foo{{.I}}bar{{.O}}/{{.O}}foo{{.I}}bar baz{{.O}}/{n.t}/{}/{1}/{q}/{{.O}}{{.O}}")

	result = replacePlaceholder("echo {+1}/{+2}/{+-1}/{+-2}/{+..}/{n.t}/\\{}/\\{1}/\\{q}/{+3}", true, Delimiter{}, printsep, false, "query", items2)
	checkFormat("echo {{.O}}foo{{.I}}bar{{.O}} {{.O}}FOO{{.I}}BAR{{.O}}/{{.O}}baz{{.O}} {{.O}}BAZ{{.O}}/{{.O}}baz{{.O}} {{.O}}BAZ{{.O}}/{{.O}}foo{{.I}}bar{{.O}} {{.O}}FOO{{.I}}BAR{{.O}}/{{.O}}foo{{.I}}bar baz{{.O}} {{.O}}FOO{{.I}}BAR BAZ{{.O}}/{n.t}/{}/{1}/{q}/{{.O}}{{.O}} {{.O}}{{.O}}")

	// forcePlus
	result = replacePlaceholder("echo {1}/{2}/{-1}/{-2}/{..}/{n.t}/\\{}/\\{1}/\\{q}/{3}", true, Delimiter{}, printsep, true, "query", items2)
	checkFormat("echo {{.O}}foo{{.I}}bar{{.O}} {{.O}}FOO{{.I}}BAR{{.O}}/{{.O}}baz{{.O}} {{.O}}BAZ{{.O}}/{{.O}}baz{{.O}} {{.O}}BAZ{{.O}}/{{.O}}foo{{.I}}bar{{.O}} {{.O}}FOO{{.I}}BAR{{.O}}/{{.O}}foo{{.I}}bar baz{{.O}} {{.O}}FOO{{.I}}BAR BAZ{{.O}}/{n.t}/{}/{1}/{q}/{{.O}}{{.O}} {{.O}}{{.O}}")

	// Whitespace preserving flag with "'" delimiter
	result = replacePlaceholder("echo {s1}", true, Delimiter{str: &delim}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}  foo{{.O}}")

	result = replacePlaceholder("echo {s2}", true, Delimiter{str: &delim}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}bar baz{{.O}}")

	result = replacePlaceholder("echo {s}", true, Delimiter{str: &delim}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}  foo{{.I}}bar baz{{.O}}")

	result = replacePlaceholder("echo {s..}", true, Delimiter{str: &delim}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}  foo{{.I}}bar baz{{.O}}")

	// Whitespace preserving flag with regex delimiter
	regex = regexp.MustCompile(`\w+`)

	result = replacePlaceholder("echo {s1}", true, Delimiter{regex: regex}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}  {{.O}}")

	result = replacePlaceholder("echo {s2}", true, Delimiter{regex: regex}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}{{.I}}{{.O}}")

	result = replacePlaceholder("echo {s3}", true, Delimiter{regex: regex}, printsep, false, "query", items1)
	checkFormat("echo {{.O}} {{.O}}")

	// No match
	result = replacePlaceholder("echo {}/{+}", true, Delimiter{}, printsep, false, "query", []*Item{nil, nil})
	check("echo /")

	// No match, but with selections
	result = replacePlaceholder("echo {}/{+}", true, Delimiter{}, printsep, false, "query", []*Item{nil, item1})
	checkFormat("echo /{{.O}}  foo{{.I}}bar baz{{.O}}")

	// String delimiter
	result = replacePlaceholder("echo {}/{1}/{2}", true, Delimiter{str: &delim}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}  foo{{.I}}bar baz{{.O}}/{{.O}}foo{{.O}}/{{.O}}bar baz{{.O}}")

	// Regex delimiter
	regex = regexp.MustCompile("[oa]+")
	// foo'bar baz
	result = replacePlaceholder("echo {}/{1}/{3}/{2..3}", true, Delimiter{regex: regex}, printsep, false, "query", items1)
	checkFormat("echo {{.O}}  foo{{.I}}bar baz{{.O}}/{{.O}}f{{.O}}/{{.O}}r b{{.O}}/{{.O}}{{.I}}bar b{{.O}}")

	/*
		Test single placeholders, but focus on the placeholders' parameters (e.g. flags).
		see: TestParsePlaceholder
	*/
	items3 := []*Item{
		// single line
		newItem("1a 1b 1c 1d 1e 1f"),
		// multi line
		newItem("1a 1b 1c 1d 1e 1f"),
		newItem("2a 2b 2c 2d 2e 2f"),
		newItem("3a 3b 3c 3d 3e 3f"),
		newItem("4a 4b 4c 4d 4e 4f"),
		newItem("5a 5b 5c 5d 5e 5f"),
		newItem("6a 6b 6c 6d 6e 6f"),
		newItem("7a 7b 7c 7d 7e 7f"),
	}
	stripAnsi := false
	printsep = "\n"
	forcePlus := false
	query := "sample query"

	templateToOutput := make(map[string]string)
	templateToFile := make(map[string]string) // same as above, but the file contents will be matched
	// I. item type placeholder
	templateToOutput[`{}`] = `{{.O}}1a 1b 1c 1d 1e 1f{{.O}}`
	templateToOutput[`{+}`] = `{{.O}}1a 1b 1c 1d 1e 1f{{.O}} {{.O}}2a 2b 2c 2d 2e 2f{{.O}} {{.O}}3a 3b 3c 3d 3e 3f{{.O}} {{.O}}4a 4b 4c 4d 4e 4f{{.O}} {{.O}}5a 5b 5c 5d 5e 5f{{.O}} {{.O}}6a 6b 6c 6d 6e 6f{{.O}} {{.O}}7a 7b 7c 7d 7e 7f{{.O}}`
	templateToOutput[`{n}`] = `0`
	templateToOutput[`{+n}`] = `0 0 0 0 0 0 0`
	templateToFile[`{f}`] = `1a 1b 1c 1d 1e 1f{{.S}}`
	templateToFile[`{+f}`] = `1a 1b 1c 1d 1e 1f{{.S}}2a 2b 2c 2d 2e 2f{{.S}}3a 3b 3c 3d 3e 3f{{.S}}4a 4b 4c 4d 4e 4f{{.S}}5a 5b 5c 5d 5e 5f{{.S}}6a 6b 6c 6d 6e 6f{{.S}}7a 7b 7c 7d 7e 7f{{.S}}`
	templateToFile[`{nf}`] = `0{{.S}}`
	templateToFile[`{+nf}`] = `0{{.S}}0{{.S}}0{{.S}}0{{.S}}0{{.S}}0{{.S}}0{{.S}}`

	// II. token type placeholders
	templateToOutput[`{..}`] = templateToOutput[`{}`]
	templateToOutput[`{1..}`] = templateToOutput[`{}`]
	templateToOutput[`{..2}`] = `{{.O}}1a 1b{{.O}}`
	templateToOutput[`{1..2}`] = templateToOutput[`{..2}`]
	templateToOutput[`{-2..-1}`] = `{{.O}}1e 1f{{.O}}`
	// shorthand for x..x range
	templateToOutput[`{1}`] = `{{.O}}1a{{.O}}`
	templateToOutput[`{1..1}`] = templateToOutput[`{1}`]
	templateToOutput[`{-6}`] = templateToOutput[`{1}`]
	// multiple ranges
	templateToOutput[`{1,2}`] = templateToOutput[`{1..2}`]
	templateToOutput[`{1,2,4}`] = `{{.O}}1a 1b 1d{{.O}}`
	templateToOutput[`{1,2..4}`] = `{{.O}}1a 1b 1c 1d{{.O}}`
	templateToOutput[`{1..2,-4..-3}`] = `{{.O}}1a 1b 1c 1d{{.O}}`
	// flags
	templateToOutput[`{+1}`] = `{{.O}}1a{{.O}} {{.O}}2a{{.O}} {{.O}}3a{{.O}} {{.O}}4a{{.O}} {{.O}}5a{{.O}} {{.O}}6a{{.O}} {{.O}}7a{{.O}}`
	templateToOutput[`{+-1}`] = `{{.O}}1f{{.O}} {{.O}}2f{{.O}} {{.O}}3f{{.O}} {{.O}}4f{{.O}} {{.O}}5f{{.O}} {{.O}}6f{{.O}} {{.O}}7f{{.O}}`
	templateToOutput[`{s1}`] = `{{.O}}1a {{.O}}`
	templateToFile[`{f1}`] = `1a{{.S}}`
	templateToOutput[`{+s1..2}`] = `{{.O}}1a 1b {{.O}} {{.O}}2a 2b {{.O}} {{.O}}3a 3b {{.O}} {{.O}}4a 4b {{.O}} {{.O}}5a 5b {{.O}} {{.O}}6a 6b {{.O}} {{.O}}7a 7b {{.O}}`
	templateToFile[`{+sf1..2}`] = `1a 1b {{.S}}2a 2b {{.S}}3a 3b {{.S}}4a 4b {{.S}}5a 5b {{.S}}6a 6b {{.S}}7a 7b {{.S}}`

	// III. query type placeholder
	// query flag is not removed after parsing, so it gets doubled
	// while the double q is invalid, it is useful here for testing purposes
	templateToOutput[`{q}`] = "{{.O}}" + query + "{{.O}}"

	// IV. escaping placeholder
	templateToOutput[`\{}`] = `{}`
	templateToOutput[`\{++}`] = `{++}`
	templateToOutput[`{++}`] = templateToOutput[`{+}`]

	for giveTemplate, wantOutput := range templateToOutput {
		result = replacePlaceholder(giveTemplate, stripAnsi, Delimiter{}, printsep, forcePlus, query, items3)
		checkFormat(wantOutput)
	}
	for giveTemplate, wantOutput := range templateToFile {
		path := replacePlaceholder(giveTemplate, stripAnsi, Delimiter{}, printsep, forcePlus, query, items3)

		data, err := readFile(path)
		if err != nil {
			t.Errorf("Cannot read the content of the temp file %s.", path)
		}
		result = string(data)

		checkFormat(wantOutput)
	}
}

func TestQuoteEntry(t *testing.T) {
	type quotes struct{ E, O, SQ, DQ, BS string } // standalone escape, outer, single and double quotes, backslash
	unixStyle := quotes{``, `'`, `'\''`, `"`, `\`}
	windowsStyle := quotes{`^`, `^"`, `'`, `\^"`, `\\`}
	var effectiveStyle quotes

	if util.IsWindows() {
		effectiveStyle = windowsStyle
	} else {
		effectiveStyle = unixStyle
	}

	tests := map[string]string{
		`'`:     `{{.O}}{{.SQ}}{{.O}}`,
		`"`:     `{{.O}}{{.DQ}}{{.O}}`,
		`\`:     `{{.O}}{{.BS}}{{.O}}`,
		`\"`:    `{{.O}}{{.BS}}{{.DQ}}{{.O}}`,
		`"\\\"`: `{{.O}}{{.DQ}}{{.BS}}{{.BS}}{{.BS}}{{.DQ}}{{.O}}`,

		`$`:       `{{.O}}${{.O}}`,
		`$HOME`:   `{{.O}}$HOME{{.O}}`,
		`'$HOME'`: `{{.O}}{{.SQ}}$HOME{{.SQ}}{{.O}}`,

		`&`:                       `{{.O}}{{.E}}&{{.O}}`,
		`|`:                       `{{.O}}{{.E}}|{{.O}}`,
		`<`:                       `{{.O}}{{.E}}<{{.O}}`,
		`>`:                       `{{.O}}{{.E}}>{{.O}}`,
		`(`:                       `{{.O}}{{.E}}({{.O}}`,
		`)`:                       `{{.O}}{{.E}}){{.O}}`,
		`@`:                       `{{.O}}{{.E}}@{{.O}}`,
		`^`:                       `{{.O}}{{.E}}^{{.O}}`,
		`%`:                       `{{.O}}{{.E}}%{{.O}}`,
		`!`:                       `{{.O}}{{.E}}!{{.O}}`,
		`%USERPROFILE%`:           `{{.O}}{{.E}}%USERPROFILE{{.E}}%{{.O}}`,
		`C:\Program Files (x86)\`: `{{.O}}C:{{.BS}}Program Files {{.E}}(x86{{.E}}){{.BS}}{{.O}}`,
		`"C:\Program Files"`:      `{{.O}}{{.DQ}}C:{{.BS}}Program Files{{.DQ}}{{.O}}`,
	}

	for input, expected := range tests {
		escaped := quoteEntry(input)
		expected = templateToString(expected, effectiveStyle)
		if escaped != expected {
			t.Errorf("Input: %s, expected: %s, actual %s", input, expected, escaped)
		}
	}
}

// purpose of this test is to demonstrate some shortcomings of fzf's templating system on Unix
func TestUnixCommands(t *testing.T) {
	if util.IsWindows() {
		t.SkipNow()
	}
	tests := []testCase{
		// reference: give{template, query, items}, want{output OR match}

		// 1) working examples

		// paths that does not have to evaluated will work fine, when quoted
		{give{`grep foo {}`, ``, newItems(`test`)}, want{output: `grep foo 'test'`}},
		{give{`grep foo {}`, ``, newItems(`/home/user/test`)}, want{output: `grep foo '/home/user/test'`}},
		{give{`grep foo {}`, ``, newItems(`./test`)}, want{output: `grep foo './test'`}},

		// only placeholders are escaped as data, this will lookup tilde character in a test file in your home directory
		// quoting the tilde is required (to be treated as string)
		{give{`grep {} ~/test`, ``, newItems(`~`)}, want{output: `grep '~' ~/test`}},

		// 2) problematic examples
		// (not necessarily unexpected)

		// paths that need to expand some part of it won't work (special characters and variables)
		{give{`cat {}`, ``, newItems(`~/test`)}, want{output: `cat '~/test'`}},
		{give{`cat {}`, ``, newItems(`$HOME/test`)}, want{output: `cat '$HOME/test'`}},
	}
	testCommands(t, tests)
}

// purpose of this test is to demonstrate some shortcomings of fzf's templating system on Windows
func TestWindowsCommands(t *testing.T) {
	if !util.IsWindows() {
		t.SkipNow()
	}
	tests := []testCase{
		// reference: give{template, query, items}, want{output OR match}

		// 1) working examples

		// example of redundantly escaped backslash in the output, besides looking bit ugly, it won't cause any issue
		{give{`type {}`, ``, newItems(`C:\test.txt`)}, want{output: `type ^"C:\\test.txt^"`}},
		{give{`rg -- "package" {}`, ``, newItems(`.\test.go`)}, want{output: `rg -- "package" ^".\\test.go^"`}},
		// example of mandatorily escaped backslash in the output, otherwise `rg -- "C:\test.txt"` is matching for tabulator
		{give{`rg -- {}`, ``, newItems(`C:\test.txt`)}, want{output: `rg -- ^"C:\\test.txt^"`}},
		// example of mandatorily escaped double quote in the output, otherwise `rg -- ""C:\\test.txt""` is not matching for the double quotes around the path
		{give{`rg -- {}`, ``, newItems(`"C:\test.txt"`)}, want{output: `rg -- ^"\^"C:\\test.txt\^"^"`}},

		// 2) problematic examples
		// (not necessarily unexpected)

		// notepad++'s parser can't handle `-n"12"` generate by fzf, expects `-n12`
		{give{`notepad++ -n{1} {2}`, ``, newItems(`12	C:\Work\Test Folder\File.txt`)}, want{output: `notepad++ -n^"12^" ^"C:\\Work\\Test Folder\\File.txt^"`}},

		// cat is parsing `\"` as a part of the file path, double quote is illegal character for paths on Windows
		// cat: "C:\\test.txt: Invalid argument
		{give{`cat {}`, ``, newItems(`"C:\test.txt"`)}, want{output: `cat ^"\^"C:\\test.txt\^"^"`}},
		// cat: "C:\\test.txt": Invalid argument
		{give{`cmd /c {}`, ``, newItems(`cat "C:\test.txt"`)}, want{output: `cmd /c ^"cat \^"C:\\test.txt\^"^"`}},

		// the "file" flag in the pattern won't create *.bat or *.cmd file so the command in the output tries to edit the file, instead of executing it
		// the temp file contains: `cat "C:\test.txt"`
		// TODO this should actually work
		{give{`cmd /c {f}`, ``, newItems(`cat "C:\test.txt"`)}, want{match: `^cmd /c .*\fzf-preview-[0-9]{9}$`}},
	}
	testCommands(t, tests)
}

// purpose of this test is to demonstrate some shortcomings of fzf's templating system on Windows in Powershell
func TestPowershellCommands(t *testing.T) {
	if !util.IsWindows() {
		t.SkipNow()
	}

	tests := []testCase{
		// reference: give{template, query, items}, want{output OR match}

		/*
			You can read each line in the following table as a pipeline that
			consist of series of parsers that act upon your input (col. 1) and
			each cell represents the output value.

			For example:
			 - exec.Command("program.exe", `\''`)
			   - goes to win32 api which will process it transparently as it contains no special characters, see [CommandLineToArgvW][].
			     - powershell command will receive it as is, that is two arguments: a literal backslash and empty string in single quotes
			     - native command run via/from powershell will receive only one argument: a literal backslash. Because extra parsing rules apply, see [NativeCallsFromPowershell][].
			       - some¹ apps have internal parser, that requires one more level of escaping (yes, this is completely application-specific, but see terminal_test.go#TestWindowsCommands)

			Character⁰   CommandLineToArgvW   Powershell commands              Native commands from Powershell   Apps requiring escapes¹    | Being tested below
			----------   ------------------   ------------------------------   -------------------------------   -------------------------- | ------------------
			"            empty string²        missing argument error           ...                               ...                        |
			\"           literal "            unbalanced quote error           ...                               ...                        |
			'\"'         literal '"'          literal "                        empty string                      empty string (match all)   | yes
			'\\\"'       literal '\"'         literal \"                       literal "                         literal "                  |
			----------   ------------------   ------------------------------   -------------------------------   -------------------------- | ------------------
			\            transparent          transparent                      transparent                       regex error                |
			'\'          transparent          literal \                        literal \                         regex error                | yes
			\\           transparent          transparent                      transparent                       literal \                  |
			'\\'         transparent          literal \\                       literal \\                        literal \                  |
			----------   ------------------   ------------------------------   -------------------------------   -------------------------- | ------------------
			'            transparent          unbalanced quote error           ...                               ...                        |
			\'           transparent          literal \ and unb. quote error   ...                               ...                        |
			\''          transparent          literal \ and empty string       literal \                         regex error                | no, but given as example above
			'''          transparent          unbalanced quote error           ...                               ...                        |
			''''         transparent          literal '                        literal '                         literal '                  | yes
			----------   ------------------   ------------------------------   -------------------------------   -------------------------- | ------------------

			⁰: charatecter or characters 'x' as an argument to a program in go's call: exec.Command("program.exe", `x`)
			¹: native commands like grep, git grep, ripgrep
			²: interpreted as a grouping quote, affects argument parser and gets removed from the result

			[CommandLineToArgvW]: https://docs.microsoft.com/en-gb/windows/win32/api/shellapi/nf-shellapi-commandlinetoargvw#remarks
			[NativeCallsFromPowershell]: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_parsing?view=powershell-7.1#passing-arguments-that-contain-quote-characters
		*/

		// 1) working examples

		{give{`Get-Content {}`, ``, newItems(`C:\test.txt`)}, want{output: `Get-Content 'C:\test.txt'`}},
		{give{`rg -- "package" {}`, ``, newItems(`.\test.go`)}, want{output: `rg -- "package" '.\test.go'`}},

		// example of escaping single quotes
		{give{`rg -- {}`, ``, newItems(`'foobar'`)}, want{output: `rg -- '''foobar'''`}},

		// chaining powershells
		{give{`powershell -NoProfile -Command {}`, ``, newItems(`cat "C:\test.txt"`)}, want{output: `powershell -NoProfile -Command 'cat \"C:\test.txt\"'`}},

		// 2) problematic examples
		// (not necessarily unexpected)

		// looking for a path string will only work with escaped backslashes
		{give{`rg -- {}`, ``, newItems(`C:\test.txt`)}, want{output: `rg -- 'C:\test.txt'`}},
		// looking for a literal double quote will only work with triple escaped double quotes
		{give{`rg -- {}`, ``, newItems(`"C:\test.txt"`)}, want{output: `rg -- '\"C:\test.txt\"'`}},

		// Get-Content (i.e. cat alias) is parsing `"` as a part of the file path, returns an error:
		// Get-Content : Cannot find drive. A drive with the name '"C:' does not exist.
		{give{`cat {}`, ``, newItems(`"C:\test.txt"`)}, want{output: `cat '\"C:\test.txt\"'`}},

		// the "file" flag in the pattern won't create *.ps1 file so the powershell will offload this "unknown" filetype
		// to explorer, which will prompt user to pick editing program for the fzf-preview file
		// the temp file contains: `cat "C:\test.txt"`
		// TODO this should actually work
		{give{`powershell -NoProfile -Command {f}`, ``, newItems(`cat "C:\test.txt"`)}, want{match: `^powershell -NoProfile -Command .*\fzf-preview-[0-9]{9}$`}},
	}

	// to force powershell-style escaping we temporarily set environment variable that fzf honors
	shellBackup := os.Getenv("SHELL")
	os.Setenv("SHELL", "powershell")
	testCommands(t, tests)
	os.Setenv("SHELL", shellBackup)
}

/*
Test typical valid placeholders and parsing of them.

Also since the parser assumes the input is matched with `placeholder` regex,
the regex is tested here as well.
*/
func TestParsePlaceholder(t *testing.T) {
	// give, want pairs
	templates := map[string]string{
		// I. item type placeholder
		`{}`:    `{}`,
		`{+}`:   `{+}`,
		`{n}`:   `{n}`,
		`{+n}`:  `{+n}`,
		`{f}`:   `{f}`,
		`{+nf}`: `{+nf}`,

		// II. token type placeholders
		`{..}`:     `{..}`,
		`{1..}`:    `{1..}`,
		`{..2}`:    `{..2}`,
		`{1..2}`:   `{1..2}`,
		`{-2..-1}`: `{-2..-1}`,
		// shorthand for x..x range
		`{1}`:    `{1}`,
		`{1..1}`: `{1..1}`,
		`{-6}`:   `{-6}`,
		// multiple ranges
		`{1,2}`:         `{1,2}`,
		`{1,2,4}`:       `{1,2,4}`,
		`{1,2..4}`:      `{1,2..4}`,
		`{1..2,-4..-3}`: `{1..2,-4..-3}`,
		// flags
		`{+1}`:      `{+1}`,
		`{+-1}`:     `{+-1}`,
		`{s1}`:      `{s1}`,
		`{f1}`:      `{f1}`,
		`{+s1..2}`:  `{+s1..2}`,
		`{+sf1..2}`: `{+sf1..2}`,

		// III. query type placeholder
		// query flag is not removed after parsing, so it gets doubled
		// while the double q is invalid, it is useful here for testing purposes
		`{q}`: `{qq}`,

		// IV. escaping placeholder
		`\{}`:   `{}`,
		`\{++}`: `{++}`,
		`{++}`:  `{+}`,
	}

	for giveTemplate, wantTemplate := range templates {
		if !placeholder.MatchString(giveTemplate) {
			t.Errorf(`given placeholder %s does not match placeholder regex, so attempt to parse it is unexpected`, giveTemplate)
			continue
		}

		_, placeholderWithoutFlags, flags := parsePlaceholder(giveTemplate)
		gotTemplate := placeholderWithoutFlags[:1] + flags.encodePlaceholder() + placeholderWithoutFlags[1:]

		if gotTemplate != wantTemplate {
			t.Errorf(`parsed placeholder "%s" into "%s", but want "%s"`, giveTemplate, gotTemplate, wantTemplate)
		}
	}
}

/* utilities section */

// Item represents one line in fzf UI. Usually it is relative path to files and folders.
func newItem(str string) *Item {
	bytes := []byte(str)
	trimmed, _, _ := extractColor(str, nil, nil)
	return &Item{origText: &bytes, text: util.ToChars([]byte(trimmed))}
}

// Functions tested in this file require array of items (allItems). The array needs
// to consist of at least two nils. This is helper function.
func newItems(str ...string) []*Item {
	result := make([]*Item, util.Max(len(str), 2))
	for i, s := range str {
		result[i] = newItem(s)
	}
	return result
}

// (for logging purposes)
func (item *Item) String() string {
	return item.AsString(true)
}

// Helper function to parse, execute and convert "text/template" to string. Panics on error.
func templateToString(format string, data interface{}) string {
	bb := &bytes.Buffer{}

	err := template.Must(template.New("").Parse(format)).Execute(bb, data)
	if err != nil {
		panic(err)
	}

	return bb.String()
}

// ad hoc types for test cases
type give struct {
	template string
	query    string
	allItems []*Item
}
type want struct {
	/*
		Unix:
		The `want.output` string is supposed to be formatted for evaluation by
		`sh -c command` system call.

		Windows:
		The `want.output` string is supposed to be formatted for evaluation by
		`cmd.exe /s /c "command"` system call. The `/s` switch enables so called old
		behaviour, which is more favourable for nesting (possibly escaped)
		special characters. This is the relevant section of `help cmd`:

		...old behavior is to see if the first character is
		a quote character and if so, strip the leading character and
		remove the last quote character on the command line, preserving
		any text after the last quote character.
	*/
	output string // literal output
	match  string // output is matched against this regex (when output is empty string)
}
type testCase struct {
	give
	want
}

func testCommands(t *testing.T, tests []testCase) {
	// common test parameters
	delim := "\t"
	delimiter := Delimiter{str: &delim}
	printsep := ""
	stripAnsi := false
	forcePlus := false

	// evaluate the test cases
	for idx, test := range tests {
		gotOutput := replacePlaceholder(
			test.give.template, stripAnsi, delimiter, printsep, forcePlus,
			test.give.query,
			test.give.allItems)
		switch {
		case test.want.output != "":
			if gotOutput != test.want.output {
				t.Errorf("tests[%v]:\ngave{\n\ttemplate: '%s',\n\tquery: '%s',\n\tallItems: %s}\nand got '%s',\nbut want '%s'",
					idx,
					test.give.template, test.give.query, test.give.allItems,
					gotOutput, test.want.output)
			}
		case test.want.match != "":
			wantMatch := strings.ReplaceAll(test.want.match, `\`, `\\`)
			wantRegex := regexp.MustCompile(wantMatch)
			if !wantRegex.MatchString(gotOutput) {
				t.Errorf("tests[%v]:\ngave{\n\ttemplate: '%s',\n\tquery: '%s',\n\tallItems: %s}\nand got '%s',\nbut want '%s'",
					idx,
					test.give.template, test.give.query, test.give.allItems,
					gotOutput, test.want.match)
			}
		default:
			t.Errorf("tests[%v]: test case does not describe 'want' property", idx)
		}
	}
}

// naive encoder of placeholder flags
func (flags placeholderFlags) encodePlaceholder() string {
	encoded := ""
	if flags.plus {
		encoded += "+"
	}
	if flags.preserveSpace {
		encoded += "s"
	}
	if flags.number {
		encoded += "n"
	}
	if flags.file {
		encoded += "f"
	}
	if flags.query {
		encoded += "q"
	}
	return encoded
}

// can be replaced with os.ReadFile() in go 1.16+
func readFile(path string) ([]byte, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	data := make([]byte, 0, 128)
	for {
		if len(data) >= cap(data) {
			d := append(data[:cap(data)], 0)
			data = d[:len(data)]
		}

		n, err := file.Read(data[len(data):cap(data)])
		data = data[:len(data)+n]
		if err != nil {
			if err == io.EOF {
				err = nil
			}
			return data, err
		}
	}
}
./src/terminal_unix.go	[[[1
26
//go:build !windows

package fzf

import (
	"os"
	"os/signal"
	"strings"
	"syscall"
)

func notifyOnResize(resizeChan chan<- os.Signal) {
	signal.Notify(resizeChan, syscall.SIGWINCH)
}

func notifyStop(p *os.Process) {
	p.Signal(syscall.SIGSTOP)
}

func notifyOnCont(resizeChan chan<- os.Signal) {
	signal.Notify(resizeChan, syscall.SIGCONT)
}

func quoteEntry(entry string) string {
	return "'" + strings.Replace(entry, "'", "'\\''", -1) + "'"
}
./src/terminal_windows.go	[[[1
45
//go:build windows

package fzf

import (
	"os"
	"regexp"
	"strings"
)

func notifyOnResize(resizeChan chan<- os.Signal) {
	// TODO
}

func notifyStop(p *os.Process) {
	// NOOP
}

func notifyOnCont(resizeChan chan<- os.Signal) {
	// NOOP
}

func quoteEntry(entry string) string {
	shell := os.Getenv("SHELL")
	if len(shell) == 0 {
		shell = "cmd"
	}

	if strings.Contains(shell, "cmd") {
		// backslash escaping is done here for applications
		// (see ripgrep test case in terminal_test.go#TestWindowsCommands)
		escaped := strings.Replace(entry, `\`, `\\`, -1)
		escaped = `"` + strings.Replace(escaped, `"`, `\"`, -1) + `"`
		// caret is the escape character for cmd shell
		r, _ := regexp.Compile(`[&|<>()@^%!"]`)
		return r.ReplaceAllStringFunc(escaped, func(match string) string {
			return "^" + match
		})
	} else if strings.Contains(shell, "pwsh") || strings.Contains(shell, "powershell") {
		escaped := strings.Replace(entry, `"`, `\"`, -1)
		return "'" + strings.Replace(escaped, "'", "''", -1) + "'"
	} else {
		return "'" + strings.Replace(entry, "'", "'\\''", -1) + "'"
	}
}
./src/tokenizer.go	[[[1
253
package fzf

import (
	"bytes"
	"fmt"
	"regexp"
	"strconv"
	"strings"

	"github.com/junegunn/fzf/src/util"
)

const rangeEllipsis = 0

// Range represents nth-expression
type Range struct {
	begin int
	end   int
}

// Token contains the tokenized part of the strings and its prefix length
type Token struct {
	text         *util.Chars
	prefixLength int32
}

// String returns the string representation of a Token.
func (t Token) String() string {
	return fmt.Sprintf("Token{text: %s, prefixLength: %d}", t.text, t.prefixLength)
}

// Delimiter for tokenizing the input
type Delimiter struct {
	regex *regexp.Regexp
	str   *string
}

// String returns the string representation of a Delimiter.
func (d Delimiter) String() string {
	return fmt.Sprintf("Delimiter{regex: %v, str: &%q}", d.regex, *d.str)
}

func newRange(begin int, end int) Range {
	if begin == 1 {
		begin = rangeEllipsis
	}
	if end == -1 {
		end = rangeEllipsis
	}
	return Range{begin, end}
}

// ParseRange parses nth-expression and returns the corresponding Range object
func ParseRange(str *string) (Range, bool) {
	if (*str) == ".." {
		return newRange(rangeEllipsis, rangeEllipsis), true
	} else if strings.HasPrefix(*str, "..") {
		end, err := strconv.Atoi((*str)[2:])
		if err != nil || end == 0 {
			return Range{}, false
		}
		return newRange(rangeEllipsis, end), true
	} else if strings.HasSuffix(*str, "..") {
		begin, err := strconv.Atoi((*str)[:len(*str)-2])
		if err != nil || begin == 0 {
			return Range{}, false
		}
		return newRange(begin, rangeEllipsis), true
	} else if strings.Contains(*str, "..") {
		ns := strings.Split(*str, "..")
		if len(ns) != 2 {
			return Range{}, false
		}
		begin, err1 := strconv.Atoi(ns[0])
		end, err2 := strconv.Atoi(ns[1])
		if err1 != nil || err2 != nil || begin == 0 || end == 0 {
			return Range{}, false
		}
		return newRange(begin, end), true
	}

	n, err := strconv.Atoi(*str)
	if err != nil || n == 0 {
		return Range{}, false
	}
	return newRange(n, n), true
}

func withPrefixLengths(tokens []string, begin int) []Token {
	ret := make([]Token, len(tokens))

	prefixLength := begin
	for idx := range tokens {
		chars := util.ToChars([]byte(tokens[idx]))
		ret[idx] = Token{&chars, int32(prefixLength)}
		prefixLength += chars.Length()
	}
	return ret
}

const (
	awkNil = iota
	awkBlack
	awkWhite
)

func awkTokenizer(input string) ([]string, int) {
	// 9, 32
	ret := []string{}
	prefixLength := 0
	state := awkNil
	begin := 0
	end := 0
	for idx := 0; idx < len(input); idx++ {
		r := input[idx]
		white := r == 9 || r == 32
		switch state {
		case awkNil:
			if white {
				prefixLength++
			} else {
				state, begin, end = awkBlack, idx, idx+1
			}
		case awkBlack:
			end = idx + 1
			if white {
				state = awkWhite
			}
		case awkWhite:
			if white {
				end = idx + 1
			} else {
				ret = append(ret, input[begin:end])
				state, begin, end = awkBlack, idx, idx+1
			}
		}
	}
	if begin < end {
		ret = append(ret, input[begin:end])
	}
	return ret, prefixLength
}

// Tokenize tokenizes the given string with the delimiter
func Tokenize(text string, delimiter Delimiter) []Token {
	if delimiter.str == nil && delimiter.regex == nil {
		// AWK-style (\S+\s*)
		tokens, prefixLength := awkTokenizer(text)
		return withPrefixLengths(tokens, prefixLength)
	}

	if delimiter.str != nil {
		return withPrefixLengths(strings.SplitAfter(text, *delimiter.str), 0)
	}

	// FIXME performance
	var tokens []string
	if delimiter.regex != nil {
		locs := delimiter.regex.FindAllStringIndex(text, -1)
		begin := 0
		for _, loc := range locs {
			tokens = append(tokens, text[begin:loc[1]])
			begin = loc[1]
		}
		if begin < len(text) {
			tokens = append(tokens, text[begin:])
		}
	}
	return withPrefixLengths(tokens, 0)
}

func joinTokens(tokens []Token) string {
	var output bytes.Buffer
	for _, token := range tokens {
		output.WriteString(token.text.ToString())
	}
	return output.String()
}

// Transform is used to transform the input when --with-nth option is given
func Transform(tokens []Token, withNth []Range) []Token {
	transTokens := make([]Token, len(withNth))
	numTokens := len(tokens)
	for idx, r := range withNth {
		parts := []*util.Chars{}
		minIdx := 0
		if r.begin == r.end {
			idx := r.begin
			if idx == rangeEllipsis {
				chars := util.ToChars([]byte(joinTokens(tokens)))
				parts = append(parts, &chars)
			} else {
				if idx < 0 {
					idx += numTokens + 1
				}
				if idx >= 1 && idx <= numTokens {
					minIdx = idx - 1
					parts = append(parts, tokens[idx-1].text)
				}
			}
		} else {
			var begin, end int
			if r.begin == rangeEllipsis { // ..N
				begin, end = 1, r.end
				if end < 0 {
					end += numTokens + 1
				}
			} else if r.end == rangeEllipsis { // N..
				begin, end = r.begin, numTokens
				if begin < 0 {
					begin += numTokens + 1
				}
			} else {
				begin, end = r.begin, r.end
				if begin < 0 {
					begin += numTokens + 1
				}
				if end < 0 {
					end += numTokens + 1
				}
			}
			minIdx = util.Max(0, begin-1)
			for idx := begin; idx <= end; idx++ {
				if idx >= 1 && idx <= numTokens {
					parts = append(parts, tokens[idx-1].text)
				}
			}
		}
		// Merge multiple parts
		var merged util.Chars
		switch len(parts) {
		case 0:
			merged = util.ToChars([]byte{})
		case 1:
			merged = *parts[0]
		default:
			var output bytes.Buffer
			for _, part := range parts {
				output.WriteString(part.ToString())
			}
			merged = util.ToChars(output.Bytes())
		}

		var prefixLength int32
		if minIdx < numTokens {
			prefixLength = tokens[minIdx].prefixLength
		} else {
			prefixLength = 0
		}
		transTokens[idx] = Token{&merged, prefixLength}
	}
	return transTokens
}
./src/tokenizer_test.go	[[[1
112
package fzf

import (
	"testing"
)

func TestParseRange(t *testing.T) {
	{
		i := ".."
		r, _ := ParseRange(&i)
		if r.begin != rangeEllipsis || r.end != rangeEllipsis {
			t.Errorf("%v", r)
		}
	}
	{
		i := "3.."
		r, _ := ParseRange(&i)
		if r.begin != 3 || r.end != rangeEllipsis {
			t.Errorf("%v", r)
		}
	}
	{
		i := "3..5"
		r, _ := ParseRange(&i)
		if r.begin != 3 || r.end != 5 {
			t.Errorf("%v", r)
		}
	}
	{
		i := "-3..-5"
		r, _ := ParseRange(&i)
		if r.begin != -3 || r.end != -5 {
			t.Errorf("%v", r)
		}
	}
	{
		i := "3"
		r, _ := ParseRange(&i)
		if r.begin != 3 || r.end != 3 {
			t.Errorf("%v", r)
		}
	}
}

func TestTokenize(t *testing.T) {
	// AWK-style
	input := "  abc:  def:  ghi  "
	tokens := Tokenize(input, Delimiter{})
	if tokens[0].text.ToString() != "abc:  " || tokens[0].prefixLength != 2 {
		t.Errorf("%s", tokens)
	}

	// With delimiter
	tokens = Tokenize(input, delimiterRegexp(":"))
	if tokens[0].text.ToString() != "  abc:" || tokens[0].prefixLength != 0 {
		t.Error(tokens[0].text.ToString(), tokens[0].prefixLength)
	}

	// With delimiter regex
	tokens = Tokenize(input, delimiterRegexp("\\s+"))
	if tokens[0].text.ToString() != "  " || tokens[0].prefixLength != 0 ||
		tokens[1].text.ToString() != "abc:  " || tokens[1].prefixLength != 2 ||
		tokens[2].text.ToString() != "def:  " || tokens[2].prefixLength != 8 ||
		tokens[3].text.ToString() != "ghi  " || tokens[3].prefixLength != 14 {
		t.Errorf("%s", tokens)
	}
}

func TestTransform(t *testing.T) {
	input := "  abc:  def:  ghi:  jkl"
	{
		tokens := Tokenize(input, Delimiter{})
		{
			ranges := splitNth("1,2,3")
			tx := Transform(tokens, ranges)
			if joinTokens(tx) != "abc:  def:  ghi:  " {
				t.Errorf("%s", tx)
			}
		}
		{
			ranges := splitNth("1..2,3,2..,1")
			tx := Transform(tokens, ranges)
			if string(joinTokens(tx)) != "abc:  def:  ghi:  def:  ghi:  jklabc:  " ||
				len(tx) != 4 ||
				tx[0].text.ToString() != "abc:  def:  " || tx[0].prefixLength != 2 ||
				tx[1].text.ToString() != "ghi:  " || tx[1].prefixLength != 14 ||
				tx[2].text.ToString() != "def:  ghi:  jkl" || tx[2].prefixLength != 8 ||
				tx[3].text.ToString() != "abc:  " || tx[3].prefixLength != 2 {
				t.Errorf("%s", tx)
			}
		}
	}
	{
		tokens := Tokenize(input, delimiterRegexp(":"))
		{
			ranges := splitNth("1..2,3,2..,1")
			tx := Transform(tokens, ranges)
			if joinTokens(tx) != "  abc:  def:  ghi:  def:  ghi:  jkl  abc:" ||
				len(tx) != 4 ||
				tx[0].text.ToString() != "  abc:  def:" || tx[0].prefixLength != 0 ||
				tx[1].text.ToString() != "  ghi:" || tx[1].prefixLength != 12 ||
				tx[2].text.ToString() != "  def:  ghi:  jkl" || tx[2].prefixLength != 6 ||
				tx[3].text.ToString() != "  abc:" || tx[3].prefixLength != 0 {
				t.Errorf("%s", tx)
			}
		}
	}
}

func TestTransformIndexOutOfBounds(t *testing.T) {
	Transform([]Token{}, splitNth("1"))
}
./src/tui/dummy.go	[[[1
49
//go:build !tcell && !windows

package tui

type Attr int32

func HasFullscreenRenderer() bool {
	return false
}

var DefaultBorderShape BorderShape = BorderRounded

func (a Attr) Merge(b Attr) Attr {
	return a | b
}

const (
	AttrUndefined = Attr(0)
	AttrRegular   = Attr(1 << 8)
	AttrClear     = Attr(1 << 9)

	Bold          = Attr(1)
	Dim           = Attr(1 << 1)
	Italic        = Attr(1 << 2)
	Underline     = Attr(1 << 3)
	Blink         = Attr(1 << 4)
	Blink2        = Attr(1 << 5)
	Reverse       = Attr(1 << 6)
	StrikeThrough = Attr(1 << 7)
)

func (r *FullscreenRenderer) Init()                              {}
func (r *FullscreenRenderer) Resize(maxHeightFunc func(int) int) {}
func (r *FullscreenRenderer) Pause(bool)                         {}
func (r *FullscreenRenderer) Resume(bool, bool)                  {}
func (r *FullscreenRenderer) Clear()                             {}
func (r *FullscreenRenderer) NeedScrollbarRedraw() bool          { return false }
func (r *FullscreenRenderer) Refresh()                           {}
func (r *FullscreenRenderer) Close()                             {}

func (r *FullscreenRenderer) GetChar() Event { return Event{} }
func (r *FullscreenRenderer) MaxX() int      { return 0 }
func (r *FullscreenRenderer) MaxY() int      { return 0 }

func (r *FullscreenRenderer) RefreshWindows(windows []Window) {}

func (r *FullscreenRenderer) NewWindow(top int, left int, width int, height int, preview bool, borderStyle BorderStyle) Window {
	return nil
}
./src/tui/light.go	[[[1
1096
package tui

import (
	"bytes"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
	"time"
	"unicode/utf8"

	"github.com/mattn/go-runewidth"
	"github.com/rivo/uniseg"

	"golang.org/x/term"
)

const (
	defaultWidth  = 80
	defaultHeight = 24

	defaultEscDelay = 100
	escPollInterval = 5
	offsetPollTries = 10
	maxInputBuffer  = 1024 * 1024
)

const consoleDevice string = "/dev/tty"

var offsetRegexp *regexp.Regexp = regexp.MustCompile("(.*)\x1b\\[([0-9]+);([0-9]+)R")
var offsetRegexpBegin *regexp.Regexp = regexp.MustCompile("^\x1b\\[[0-9]+;[0-9]+R")

func (r *LightRenderer) stderr(str string) {
	r.stderrInternal(str, true, "")
}

const CR string = "\x1b[2m␍"
const LF string = "\x1b[2m␊"

func (r *LightRenderer) stderrInternal(str string, allowNLCR bool, resetCode string) {
	bytes := []byte(str)
	runes := []rune{}
	for len(bytes) > 0 {
		r, sz := utf8.DecodeRune(bytes)
		nlcr := r == '\n' || r == '\r'
		if r >= 32 || r == '\x1b' || nlcr {
			if nlcr && !allowNLCR {
				if r == '\r' {
					runes = append(runes, []rune(CR+resetCode)...)
				} else {
					runes = append(runes, []rune(LF+resetCode)...)
				}
			} else if r != utf8.RuneError {
				runes = append(runes, r)
			}
		}
		bytes = bytes[sz:]
	}
	r.queued.WriteString(string(runes))
}

func (r *LightRenderer) csi(code string) string {
	fullcode := "\x1b[" + code
	r.stderr(fullcode)
	return fullcode
}

func (r *LightRenderer) flush() {
	if r.queued.Len() > 0 {
		fmt.Fprint(os.Stderr, "\x1b[?25l"+r.queued.String()+"\x1b[?25h")
		r.queued.Reset()
	}
}

// Light renderer
type LightRenderer struct {
	theme         *ColorTheme
	mouse         bool
	forceBlack    bool
	clearOnExit   bool
	prevDownTime  time.Time
	clicks        [][2]int
	ttyin         *os.File
	buffer        []byte
	origState     *term.State
	width         int
	height        int
	yoffset       int
	tabstop       int
	escDelay      int
	fullscreen    bool
	upOneLine     bool
	queued        strings.Builder
	y             int
	x             int
	maxHeightFunc func(int) int

	// Windows only
	ttyinChannel    chan byte
	inHandle        uintptr
	outHandle       uintptr
	origStateInput  uint32
	origStateOutput uint32
}

type LightWindow struct {
	renderer *LightRenderer
	colored  bool
	preview  bool
	border   BorderStyle
	top      int
	left     int
	width    int
	height   int
	posx     int
	posy     int
	tabstop  int
	fg       Color
	bg       Color
}

func NewLightRenderer(theme *ColorTheme, forceBlack bool, mouse bool, tabstop int, clearOnExit bool, fullscreen bool, maxHeightFunc func(int) int) Renderer {
	r := LightRenderer{
		theme:         theme,
		forceBlack:    forceBlack,
		mouse:         mouse,
		clearOnExit:   clearOnExit,
		ttyin:         openTtyIn(),
		yoffset:       0,
		tabstop:       tabstop,
		fullscreen:    fullscreen,
		upOneLine:     false,
		maxHeightFunc: maxHeightFunc}
	return &r
}

func repeat(r rune, times int) string {
	if times > 0 {
		return strings.Repeat(string(r), times)
	}
	return ""
}

func atoi(s string, defaultValue int) int {
	value, err := strconv.Atoi(s)
	if err != nil {
		return defaultValue
	}
	return value
}

func (r *LightRenderer) Init() {
	r.escDelay = atoi(os.Getenv("ESCDELAY"), defaultEscDelay)

	if err := r.initPlatform(); err != nil {
		errorExit(err.Error())
	}
	r.updateTerminalSize()
	initTheme(r.theme, r.defaultTheme(), r.forceBlack)

	if r.fullscreen {
		r.smcup()
	} else {
		// We assume that --no-clear is used for repetitive relaunching of fzf.
		// So we do not clear the lower bottom of the screen.
		if r.clearOnExit {
			r.csi("J")
		}
		y, x := r.findOffset()
		r.mouse = r.mouse && y >= 0
		// When --no-clear is used for repetitive relaunching, there is a small
		// time frame between fzf processes where the user keystrokes are not
		// captured by either of fzf process which can cause x offset to be
		// increased and we're left with unwanted extra new line.
		if x > 0 && r.clearOnExit {
			r.upOneLine = true
			r.makeSpace()
		}
		for i := 1; i < r.MaxY(); i++ {
			r.makeSpace()
		}
	}

	r.enableMouse()
	r.csi(fmt.Sprintf("%dA", r.MaxY()-1))
	r.csi("G")
	r.csi("K")
	if !r.clearOnExit && !r.fullscreen {
		r.csi("s")
	}
	if !r.fullscreen && r.mouse {
		r.yoffset, _ = r.findOffset()
	}
}

func (r *LightRenderer) Resize(maxHeightFunc func(int) int) {
	r.maxHeightFunc = maxHeightFunc
}

func (r *LightRenderer) makeSpace() {
	r.stderr("\n")
	r.csi("G")
}

func (r *LightRenderer) move(y int, x int) {
	// w.csi("u")
	if r.y < y {
		r.csi(fmt.Sprintf("%dB", y-r.y))
	} else if r.y > y {
		r.csi(fmt.Sprintf("%dA", r.y-y))
	}
	r.stderr("\r")
	if x > 0 {
		r.csi(fmt.Sprintf("%dC", x))
	}
	r.y = y
	r.x = x
}

func (r *LightRenderer) origin() {
	r.move(0, 0)
}

func getEnv(name string, defaultValue int) int {
	env := os.Getenv(name)
	if len(env) == 0 {
		return defaultValue
	}
	return atoi(env, defaultValue)
}

func (r *LightRenderer) getBytes() []byte {
	return r.getBytesInternal(r.buffer, false)
}

func (r *LightRenderer) getBytesInternal(buffer []byte, nonblock bool) []byte {
	c, ok := r.getch(nonblock)
	if !nonblock && !ok {
		r.Close()
		errorExit("Failed to read " + consoleDevice)
	}

	retries := 0
	if c == ESC.Int() || nonblock {
		retries = r.escDelay / escPollInterval
	}
	buffer = append(buffer, byte(c))

	pc := c
	for {
		c, ok = r.getch(true)
		if !ok {
			if retries > 0 {
				retries--
				time.Sleep(escPollInterval * time.Millisecond)
				continue
			}
			break
		} else if c == ESC.Int() && pc != c {
			retries = r.escDelay / escPollInterval
		} else {
			retries = 0
		}
		buffer = append(buffer, byte(c))
		pc = c

		// This should never happen under normal conditions,
		// so terminate fzf immediately.
		if len(buffer) > maxInputBuffer {
			r.Close()
			panic(fmt.Sprintf("Input buffer overflow (%d): %v", len(buffer), buffer))
		}
	}

	return buffer
}

func (r *LightRenderer) GetChar() Event {
	if len(r.buffer) == 0 {
		r.buffer = r.getBytes()
	}
	if len(r.buffer) == 0 {
		panic("Empty buffer")
	}

	sz := 1
	defer func() {
		r.buffer = r.buffer[sz:]
	}()

	switch r.buffer[0] {
	case CtrlC.Byte():
		return Event{CtrlC, 0, nil}
	case CtrlG.Byte():
		return Event{CtrlG, 0, nil}
	case CtrlQ.Byte():
		return Event{CtrlQ, 0, nil}
	case 127:
		return Event{BSpace, 0, nil}
	case 0:
		return Event{CtrlSpace, 0, nil}
	case 28:
		return Event{CtrlBackSlash, 0, nil}
	case 29:
		return Event{CtrlRightBracket, 0, nil}
	case 30:
		return Event{CtrlCaret, 0, nil}
	case 31:
		return Event{CtrlSlash, 0, nil}
	case ESC.Byte():
		ev := r.escSequence(&sz)
		// Second chance
		if ev.Type == Invalid {
			r.buffer = r.getBytes()
			ev = r.escSequence(&sz)
		}
		return ev
	}

	// CTRL-A ~ CTRL-Z
	if r.buffer[0] <= CtrlZ.Byte() {
		return Event{EventType(r.buffer[0]), 0, nil}
	}
	char, rsz := utf8.DecodeRune(r.buffer)
	if char == utf8.RuneError {
		return Event{ESC, 0, nil}
	}
	sz = rsz
	return Event{Rune, char, nil}
}

func (r *LightRenderer) escSequence(sz *int) Event {
	if len(r.buffer) < 2 {
		return Event{ESC, 0, nil}
	}

	loc := offsetRegexpBegin.FindIndex(r.buffer)
	if loc != nil && loc[0] == 0 {
		*sz = loc[1]
		return Event{Invalid, 0, nil}
	}

	*sz = 2
	if r.buffer[1] >= 1 && r.buffer[1] <= 'z'-'a'+1 {
		return CtrlAltKey(rune(r.buffer[1] + 'a' - 1))
	}
	alt := false
	if len(r.buffer) > 2 && r.buffer[1] == ESC.Byte() {
		r.buffer = r.buffer[1:]
		alt = true
	}
	switch r.buffer[1] {
	case ESC.Byte():
		return Event{ESC, 0, nil}
	case 127:
		return Event{AltBS, 0, nil}
	case '[', 'O':
		if len(r.buffer) < 3 {
			return Event{Invalid, 0, nil}
		}
		*sz = 3
		switch r.buffer[2] {
		case 'D':
			if alt {
				return Event{AltLeft, 0, nil}
			}
			return Event{Left, 0, nil}
		case 'C':
			if alt {
				// Ugh..
				return Event{AltRight, 0, nil}
			}
			return Event{Right, 0, nil}
		case 'B':
			if alt {
				return Event{AltDown, 0, nil}
			}
			return Event{Down, 0, nil}
		case 'A':
			if alt {
				return Event{AltUp, 0, nil}
			}
			return Event{Up, 0, nil}
		case 'Z':
			return Event{BTab, 0, nil}
		case 'H':
			return Event{Home, 0, nil}
		case 'F':
			return Event{End, 0, nil}
		case '<':
			return r.mouseSequence(sz)
		case 'P':
			return Event{F1, 0, nil}
		case 'Q':
			return Event{F2, 0, nil}
		case 'R':
			return Event{F3, 0, nil}
		case 'S':
			return Event{F4, 0, nil}
		case '1', '2', '3', '4', '5', '6':
			if len(r.buffer) < 4 {
				return Event{Invalid, 0, nil}
			}
			*sz = 4
			switch r.buffer[2] {
			case '2':
				if r.buffer[3] == '~' {
					return Event{Insert, 0, nil}
				}
				if len(r.buffer) > 4 && r.buffer[4] == '~' {
					*sz = 5
					switch r.buffer[3] {
					case '0':
						return Event{F9, 0, nil}
					case '1':
						return Event{F10, 0, nil}
					case '3':
						return Event{F11, 0, nil}
					case '4':
						return Event{F12, 0, nil}
					}
				}
				// Bracketed paste mode: \e[200~ ... \e[201~
				if len(r.buffer) > 5 && r.buffer[3] == '0' && (r.buffer[4] == '0' || r.buffer[4] == '1') && r.buffer[5] == '~' {
					// Immediately discard the sequence from the buffer and reread input
					r.buffer = r.buffer[6:]
					*sz = 0
					return r.GetChar()
				}
				return Event{Invalid, 0, nil} // INS
			case '3':
				if r.buffer[3] == '~' {
					return Event{Del, 0, nil}
				}
				if len(r.buffer) == 6 && r.buffer[5] == '~' {
					*sz = 6
					switch r.buffer[4] {
					case '5':
						return Event{CtrlDelete, 0, nil}
					case '2':
						return Event{SDelete, 0, nil}
					}
				}
				return Event{Invalid, 0, nil}
			case '4':
				return Event{End, 0, nil}
			case '5':
				return Event{PgUp, 0, nil}
			case '6':
				return Event{PgDn, 0, nil}
			case '1':
				switch r.buffer[3] {
				case '~':
					return Event{Home, 0, nil}
				case '1', '2', '3', '4', '5', '7', '8', '9':
					if len(r.buffer) == 5 && r.buffer[4] == '~' {
						*sz = 5
						switch r.buffer[3] {
						case '1':
							return Event{F1, 0, nil}
						case '2':
							return Event{F2, 0, nil}
						case '3':
							return Event{F3, 0, nil}
						case '4':
							return Event{F4, 0, nil}
						case '5':
							return Event{F5, 0, nil}
						case '7':
							return Event{F6, 0, nil}
						case '8':
							return Event{F7, 0, nil}
						case '9':
							return Event{F8, 0, nil}
						}
					}
					return Event{Invalid, 0, nil}
				case ';':
					if len(r.buffer) < 6 {
						return Event{Invalid, 0, nil}
					}
					*sz = 6
					switch r.buffer[4] {
					case '1', '2', '3', '5':
						alt := r.buffer[4] == '3'
						altShift := r.buffer[4] == '1' && r.buffer[5] == '0'
						char := r.buffer[5]
						if altShift {
							if len(r.buffer) < 7 {
								return Event{Invalid, 0, nil}
							}
							*sz = 7
							char = r.buffer[6]
						}
						switch char {
						case 'A':
							if alt {
								return Event{AltUp, 0, nil}
							}
							if altShift {
								return Event{AltSUp, 0, nil}
							}
							return Event{SUp, 0, nil}
						case 'B':
							if alt {
								return Event{AltDown, 0, nil}
							}
							if altShift {
								return Event{AltSDown, 0, nil}
							}
							return Event{SDown, 0, nil}
						case 'C':
							if alt {
								return Event{AltRight, 0, nil}
							}
							if altShift {
								return Event{AltSRight, 0, nil}
							}
							return Event{SRight, 0, nil}
						case 'D':
							if alt {
								return Event{AltLeft, 0, nil}
							}
							if altShift {
								return Event{AltSLeft, 0, nil}
							}
							return Event{SLeft, 0, nil}
						}
					} // r.buffer[4]
				} // r.buffer[3]
			} // r.buffer[2]
		} // r.buffer[2]
	} // r.buffer[1]
	rest := bytes.NewBuffer(r.buffer[1:])
	c, size, err := rest.ReadRune()
	if err == nil {
		*sz = 1 + size
		return AltKey(c)
	}
	return Event{Invalid, 0, nil}
}

// https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-Mouse-Tracking
func (r *LightRenderer) mouseSequence(sz *int) Event {
	// "\e[<0;0;0M"
	if len(r.buffer) < 9 || !r.mouse {
		return Event{Invalid, 0, nil}
	}

	rest := r.buffer[*sz:]
	end := bytes.IndexAny(rest, "mM")
	if end == -1 {
		return Event{Invalid, 0, nil}
	}

	elems := strings.SplitN(string(rest[:end]), ";", 3)
	if len(elems) != 3 {
		return Event{Invalid, 0, nil}
	}

	t := atoi(elems[0], -1)
	x := atoi(elems[1], -1) - 1
	y := atoi(elems[2], -1) - 1 - r.yoffset
	if t < 0 || x < 0 {
		return Event{Invalid, 0, nil}
	}
	*sz += end + 1

	down := rest[end] == 'M'

	scroll := 0
	if t >= 64 {
		t -= 64
		if t&0b1 == 1 {
			scroll = -1
		} else {
			scroll = 1
		}
	}

	// middle := t & 0b1
	left := t&0b11 == 0

	// shift := t & 0b100
	// ctrl := t & 0b1000
	mod := t&0b1100 > 0

	drag := t&0b100000 > 0

	if scroll != 0 {
		return Event{Mouse, 0, &MouseEvent{y, x, scroll, false, false, false, mod}}
	}

	double := false
	if down && !drag {
		now := time.Now()
		if !left { // Right double click is not allowed
			r.clicks = [][2]int{}
		} else if now.Sub(r.prevDownTime) < doubleClickDuration {
			r.clicks = append(r.clicks, [2]int{x, y})
		} else {
			r.clicks = [][2]int{{x, y}}
		}
		r.prevDownTime = now
	} else {
		n := len(r.clicks)
		if len(r.clicks) > 1 && r.clicks[n-2][0] == r.clicks[n-1][0] && r.clicks[n-2][1] == r.clicks[n-1][1] &&
			time.Since(r.prevDownTime) < doubleClickDuration {
			double = true
			if double {
				r.clicks = [][2]int{}
			}
		}
	}
	return Event{Mouse, 0, &MouseEvent{y, x, 0, left, down, double, mod}}
}

func (r *LightRenderer) smcup() {
	r.csi("?1049h")
}

func (r *LightRenderer) rmcup() {
	r.csi("?1049l")
}

func (r *LightRenderer) Pause(clear bool) {
	r.disableMouse()
	r.restoreTerminal()
	if clear {
		if r.fullscreen {
			r.rmcup()
		} else {
			r.smcup()
			r.csi("H")
		}
		r.flush()
	}
}

func (r *LightRenderer) enableMouse() {
	if r.mouse {
		r.csi("?1000h")
		r.csi("?1002h")
		r.csi("?1006h")
	}
}

func (r *LightRenderer) disableMouse() {
	if r.mouse {
		r.csi("?1000l")
		r.csi("?1002l")
		r.csi("?1006l")
	}
}

func (r *LightRenderer) Resume(clear bool, sigcont bool) {
	r.setupTerminal()
	if clear {
		if r.fullscreen {
			r.smcup()
		} else {
			r.rmcup()
		}
		r.enableMouse()
		r.flush()
	} else if sigcont && !r.fullscreen && r.mouse {
		// NOTE: SIGCONT (Coming back from CTRL-Z):
		// It's highly likely that the offset we obtained at the beginning is
		// no longer correct, so we simply disable mouse input.
		r.disableMouse()
		r.mouse = false
	}
}

func (r *LightRenderer) Clear() {
	if r.fullscreen {
		r.csi("H")
	}
	// r.csi("u")
	r.origin()
	r.csi("J")
	r.flush()
}

func (r *LightRenderer) NeedScrollbarRedraw() bool {
	return false
}

func (r *LightRenderer) RefreshWindows(windows []Window) {
	r.flush()
}

func (r *LightRenderer) Refresh() {
	r.updateTerminalSize()
}

func (r *LightRenderer) Close() {
	// r.csi("u")
	if r.clearOnExit {
		if r.fullscreen {
			r.rmcup()
		} else {
			r.origin()
			if r.upOneLine {
				r.csi("A")
			}
			r.csi("J")
		}
	} else if !r.fullscreen {
		r.csi("u")
	}
	r.disableMouse()
	r.flush()
	r.closePlatform()
	r.restoreTerminal()
}

func (r *LightRenderer) MaxX() int {
	return r.width
}

func (r *LightRenderer) MaxY() int {
	if r.height == 0 {
		r.updateTerminalSize()
	}
	return r.height
}

func (r *LightRenderer) NewWindow(top int, left int, width int, height int, preview bool, borderStyle BorderStyle) Window {
	w := &LightWindow{
		renderer: r,
		colored:  r.theme.Colored,
		preview:  preview,
		border:   borderStyle,
		top:      top,
		left:     left,
		width:    width,
		height:   height,
		tabstop:  r.tabstop,
		fg:       colDefault,
		bg:       colDefault}
	if preview {
		w.fg = r.theme.PreviewFg.Color
		w.bg = r.theme.PreviewBg.Color
	} else {
		w.fg = r.theme.Fg.Color
		w.bg = r.theme.Bg.Color
	}
	w.drawBorder(false)
	return w
}

func (w *LightWindow) DrawHBorder() {
	w.drawBorder(true)
}

func (w *LightWindow) drawBorder(onlyHorizontal bool) {
	switch w.border.shape {
	case BorderRounded, BorderSharp, BorderBold, BorderBlock, BorderThinBlock, BorderDouble:
		w.drawBorderAround(onlyHorizontal)
	case BorderHorizontal:
		w.drawBorderHorizontal(true, true)
	case BorderVertical:
		if onlyHorizontal {
			return
		}
		w.drawBorderVertical(true, true)
	case BorderTop:
		w.drawBorderHorizontal(true, false)
	case BorderBottom:
		w.drawBorderHorizontal(false, true)
	case BorderLeft:
		if onlyHorizontal {
			return
		}
		w.drawBorderVertical(true, false)
	case BorderRight:
		if onlyHorizontal {
			return
		}
		w.drawBorderVertical(false, true)
	}
}

func (w *LightWindow) drawBorderHorizontal(top, bottom bool) {
	color := ColBorder
	if w.preview {
		color = ColPreviewBorder
	}
	hw := runewidth.RuneWidth(w.border.top)
	if top {
		w.Move(0, 0)
		w.CPrint(color, repeat(w.border.top, w.width/hw))
	}
	if bottom {
		w.Move(w.height-1, 0)
		w.CPrint(color, repeat(w.border.bottom, w.width/hw))
	}
}

func (w *LightWindow) drawBorderVertical(left, right bool) {
	width := w.width - 2
	if !left || !right {
		width++
	}
	color := ColBorder
	if w.preview {
		color = ColPreviewBorder
	}
	for y := 0; y < w.height; y++ {
		w.Move(y, 0)
		if left {
			w.CPrint(color, string(w.border.left))
		}
		w.CPrint(color, repeat(' ', width))
		if right {
			w.CPrint(color, string(w.border.right))
		}
	}
}

func (w *LightWindow) drawBorderAround(onlyHorizontal bool) {
	w.Move(0, 0)
	color := ColBorder
	if w.preview {
		color = ColPreviewBorder
	}
	hw := runewidth.RuneWidth(w.border.top)
	tcw := runewidth.RuneWidth(w.border.topLeft) + runewidth.RuneWidth(w.border.topRight)
	bcw := runewidth.RuneWidth(w.border.bottomLeft) + runewidth.RuneWidth(w.border.bottomRight)
	rem := (w.width - tcw) % hw
	w.CPrint(color, string(w.border.topLeft)+repeat(w.border.top, (w.width-tcw)/hw)+repeat(' ', rem)+string(w.border.topRight))
	if !onlyHorizontal {
		vw := runewidth.RuneWidth(w.border.left)
		for y := 1; y < w.height-1; y++ {
			w.Move(y, 0)
			w.CPrint(color, string(w.border.left))
			w.CPrint(color, repeat(' ', w.width-vw*2))
			w.CPrint(color, string(w.border.right))
		}
	}
	w.Move(w.height-1, 0)
	rem = (w.width - bcw) % hw
	w.CPrint(color, string(w.border.bottomLeft)+repeat(w.border.bottom, (w.width-bcw)/hw)+repeat(' ', rem)+string(w.border.bottomRight))
}

func (w *LightWindow) csi(code string) string {
	return w.renderer.csi(code)
}

func (w *LightWindow) stderrInternal(str string, allowNLCR bool, resetCode string) {
	w.renderer.stderrInternal(str, allowNLCR, resetCode)
}

func (w *LightWindow) Top() int {
	return w.top
}

func (w *LightWindow) Left() int {
	return w.left
}

func (w *LightWindow) Width() int {
	return w.width
}

func (w *LightWindow) Height() int {
	return w.height
}

func (w *LightWindow) Refresh() {
}

func (w *LightWindow) Close() {
}

func (w *LightWindow) X() int {
	return w.posx
}

func (w *LightWindow) Y() int {
	return w.posy
}

func (w *LightWindow) Enclose(y int, x int) bool {
	return x >= w.left && x < (w.left+w.width) &&
		y >= w.top && y < (w.top+w.height)
}

func (w *LightWindow) Move(y int, x int) {
	w.posx = x
	w.posy = y

	w.renderer.move(w.Top()+y, w.Left()+x)
}

func (w *LightWindow) MoveAndClear(y int, x int) {
	w.Move(y, x)
	// We should not delete preview window on the right
	// csi("K")
	w.Print(repeat(' ', w.width-x))
	w.Move(y, x)
}

func attrCodes(attr Attr) []string {
	codes := []string{}
	if (attr & AttrClear) > 0 {
		return codes
	}
	if (attr & Bold) > 0 {
		codes = append(codes, "1")
	}
	if (attr & Dim) > 0 {
		codes = append(codes, "2")
	}
	if (attr & Italic) > 0 {
		codes = append(codes, "3")
	}
	if (attr & Underline) > 0 {
		codes = append(codes, "4")
	}
	if (attr & Blink) > 0 {
		codes = append(codes, "5")
	}
	if (attr & Reverse) > 0 {
		codes = append(codes, "7")
	}
	if (attr & StrikeThrough) > 0 {
		codes = append(codes, "9")
	}
	return codes
}

func colorCodes(fg Color, bg Color) []string {
	codes := []string{}
	appendCode := func(c Color, offset int) {
		if c == colDefault {
			return
		}
		if c.is24() {
			r := (c >> 16) & 0xff
			g := (c >> 8) & 0xff
			b := (c) & 0xff
			codes = append(codes, fmt.Sprintf("%d;2;%d;%d;%d", 38+offset, r, g, b))
		} else if c >= colBlack && c <= colWhite {
			codes = append(codes, fmt.Sprintf("%d", int(c)+30+offset))
		} else if c > colWhite && c < 16 {
			codes = append(codes, fmt.Sprintf("%d", int(c)+90+offset-8))
		} else if c >= 16 && c < 256 {
			codes = append(codes, fmt.Sprintf("%d;5;%d", 38+offset, c))
		}
	}
	appendCode(fg, 0)
	appendCode(bg, 10)
	return codes
}

func (w *LightWindow) csiColor(fg Color, bg Color, attr Attr) (bool, string) {
	codes := append(attrCodes(attr), colorCodes(fg, bg)...)
	code := w.csi(";" + strings.Join(codes, ";") + "m")
	return len(codes) > 0, code
}

func (w *LightWindow) Print(text string) {
	w.cprint2(colDefault, w.bg, AttrRegular, text)
}

func cleanse(str string) string {
	return strings.Replace(str, "\x1b", "", -1)
}

func (w *LightWindow) CPrint(pair ColorPair, text string) {
	_, code := w.csiColor(pair.Fg(), pair.Bg(), pair.Attr())
	w.stderrInternal(cleanse(text), false, code)
	w.csi("m")
}

func (w *LightWindow) cprint2(fg Color, bg Color, attr Attr, text string) {
	hasColors, code := w.csiColor(fg, bg, attr)
	if hasColors {
		defer w.csi("m")
	}
	w.stderrInternal(cleanse(text), false, code)
}

type wrappedLine struct {
	text         string
	displayWidth int
}

func wrapLine(input string, prefixLength int, max int, tabstop int) []wrappedLine {
	lines := []wrappedLine{}
	width := 0
	line := ""
	gr := uniseg.NewGraphemes(input)
	for gr.Next() {
		rs := gr.Runes()
		str := string(rs)
		var w int
		if len(rs) == 1 && rs[0] == '\t' {
			w = tabstop - (prefixLength+width)%tabstop
			str = repeat(' ', w)
		} else if rs[0] == '\r' {
			w++
		} else {
			w = runewidth.StringWidth(str)
		}
		width += w

		if prefixLength+width <= max {
			line += str
		} else {
			lines = append(lines, wrappedLine{string(line), width - w})
			line = str
			prefixLength = 0
			width = w
		}
	}
	lines = append(lines, wrappedLine{string(line), width})
	return lines
}

func (w *LightWindow) fill(str string, resetCode string) FillReturn {
	allLines := strings.Split(str, "\n")
	for i, line := range allLines {
		lines := wrapLine(line, w.posx, w.width, w.tabstop)
		for j, wl := range lines {
			w.stderrInternal(wl.text, false, resetCode)
			w.posx += wl.displayWidth

			// Wrap line
			if j < len(lines)-1 || i < len(allLines)-1 {
				if w.posy+1 >= w.height {
					return FillSuspend
				}
				w.MoveAndClear(w.posy, w.posx)
				w.Move(w.posy+1, 0)
				w.renderer.stderr(resetCode)
			}
		}
	}
	if w.posx+1 >= w.Width() {
		if w.posy+1 >= w.height {
			return FillSuspend
		}
		w.Move(w.posy+1, 0)
		w.renderer.stderr(resetCode)
		return FillNextLine
	}
	return FillContinue
}

func (w *LightWindow) setBg() string {
	if w.bg != colDefault {
		_, code := w.csiColor(colDefault, w.bg, AttrRegular)
		return code
	}
	// Should clear dim attribute after ␍ in the preview window
	// e.g. printf "foo\rbar" | fzf --ansi --preview 'printf "foo\rbar"'
	return "\x1b[m"
}

func (w *LightWindow) Fill(text string) FillReturn {
	w.Move(w.posy, w.posx)
	code := w.setBg()
	return w.fill(text, code)
}

func (w *LightWindow) CFill(fg Color, bg Color, attr Attr, text string) FillReturn {
	w.Move(w.posy, w.posx)
	if fg == colDefault {
		fg = w.fg
	}
	if bg == colDefault {
		bg = w.bg
	}
	if hasColors, resetCode := w.csiColor(fg, bg, attr); hasColors {
		defer w.csi("m")
		return w.fill(text, resetCode)
	}
	return w.fill(text, w.setBg())
}

func (w *LightWindow) FinishFill() {
	w.MoveAndClear(w.posy, w.posx)
	for y := w.posy + 1; y < w.height; y++ {
		w.MoveAndClear(y, 0)
	}
}

func (w *LightWindow) Erase() {
	w.drawBorder(false)
	// We don't erase the window here to avoid flickering during scroll
	w.Move(0, 0)
}
./src/tui/light_unix.go	[[[1
110
//go:build !windows

package tui

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
	"syscall"

	"github.com/junegunn/fzf/src/util"
	"golang.org/x/term"
)

func IsLightRendererSupported() bool {
	return true
}

func (r *LightRenderer) defaultTheme() *ColorTheme {
	if strings.Contains(os.Getenv("TERM"), "256") {
		return Dark256
	}
	colors, err := exec.Command("tput", "colors").Output()
	if err == nil && atoi(strings.TrimSpace(string(colors)), 16) > 16 {
		return Dark256
	}
	return Default16
}

func (r *LightRenderer) fd() int {
	return int(r.ttyin.Fd())
}

func (r *LightRenderer) initPlatform() error {
	fd := r.fd()
	origState, err := term.GetState(fd)
	if err != nil {
		return err
	}
	r.origState = origState
	term.MakeRaw(fd)
	return nil
}

func (r *LightRenderer) closePlatform() {
	// NOOP
}

func openTtyIn() *os.File {
	in, err := os.OpenFile(consoleDevice, syscall.O_RDONLY, 0)
	if err != nil {
		tty := ttyname()
		if len(tty) > 0 {
			if in, err := os.OpenFile(tty, syscall.O_RDONLY, 0); err == nil {
				return in
			}
		}
		fmt.Fprintln(os.Stderr, "Failed to open "+consoleDevice)
		os.Exit(2)
	}
	return in
}

func (r *LightRenderer) setupTerminal() {
	term.MakeRaw(r.fd())
}

func (r *LightRenderer) restoreTerminal() {
	term.Restore(r.fd(), r.origState)
}

func (r *LightRenderer) updateTerminalSize() {
	width, height, err := term.GetSize(r.fd())

	if err == nil {
		r.width = width
		r.height = r.maxHeightFunc(height)
	} else {
		r.width = getEnv("COLUMNS", defaultWidth)
		r.height = r.maxHeightFunc(getEnv("LINES", defaultHeight))
	}
}

func (r *LightRenderer) findOffset() (row int, col int) {
	r.csi("6n")
	r.flush()
	bytes := []byte{}
	for tries := 0; tries < offsetPollTries; tries++ {
		bytes = r.getBytesInternal(bytes, tries > 0)
		offsets := offsetRegexp.FindSubmatch(bytes)
		if len(offsets) > 3 {
			// Add anything we skipped over to the input buffer
			r.buffer = append(r.buffer, offsets[1]...)
			return atoi(string(offsets[2]), 0) - 1, atoi(string(offsets[3]), 0) - 1
		}
	}
	return -1, -1
}

func (r *LightRenderer) getch(nonblock bool) (int, bool) {
	b := make([]byte, 1)
	fd := r.fd()
	util.SetNonblock(r.ttyin, nonblock)
	_, err := util.Read(fd, b)
	if err != nil {
		return 0, false
	}
	return int(b[0]), true
}
./src/tui/light_windows.go	[[[1
145
//go:build windows

package tui

import (
	"os"
	"syscall"
	"time"

	"github.com/junegunn/fzf/src/util"
	"golang.org/x/sys/windows"
)

const (
	timeoutInterval = 10
)

var (
	consoleFlagsInput  = uint32(windows.ENABLE_VIRTUAL_TERMINAL_INPUT | windows.ENABLE_PROCESSED_INPUT | windows.ENABLE_EXTENDED_FLAGS)
	consoleFlagsOutput = uint32(windows.ENABLE_VIRTUAL_TERMINAL_PROCESSING | windows.ENABLE_PROCESSED_OUTPUT | windows.DISABLE_NEWLINE_AUTO_RETURN)
)

// IsLightRendererSupported checks to see if the Light renderer is supported
func IsLightRendererSupported() bool {
	var oldState uint32
	// enable vt100 emulation (https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences)
	if windows.GetConsoleMode(windows.Stderr, &oldState) != nil {
		return false
	}
	// attempt to set mode to determine if we support VT 100 codes. This will work on newer Windows 10
	// version:
	canSetVt100 := windows.SetConsoleMode(windows.Stderr, oldState|windows.ENABLE_VIRTUAL_TERMINAL_PROCESSING) == nil
	var checkState uint32
	if windows.GetConsoleMode(windows.Stderr, &checkState) != nil ||
		(checkState&windows.ENABLE_VIRTUAL_TERMINAL_PROCESSING) != windows.ENABLE_VIRTUAL_TERMINAL_PROCESSING {
		return false
	}
	windows.SetConsoleMode(windows.Stderr, oldState)
	return canSetVt100
}

func (r *LightRenderer) defaultTheme() *ColorTheme {
	// the getenv check is borrowed from here: https://github.com/gdamore/tcell/commit/0c473b86d82f68226a142e96cc5a34c5a29b3690#diff-b008fcd5e6934bf31bc3d33bf49f47d8R178:
	if !IsLightRendererSupported() || os.Getenv("ConEmuPID") != "" || os.Getenv("TCELL_TRUECOLOR") == "disable" {
		return Default16
	}
	return Dark256
}

func (r *LightRenderer) initPlatform() error {
	//outHandle := windows.Stdout
	outHandle, _ := syscall.Open("CONOUT$", syscall.O_RDWR, 0)
	// enable vt100 emulation (https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences)
	if err := windows.GetConsoleMode(windows.Handle(outHandle), &r.origStateOutput); err != nil {
		return err
	}
	r.outHandle = uintptr(outHandle)
	inHandle, _ := syscall.Open("CONIN$", syscall.O_RDWR, 0)
	if err := windows.GetConsoleMode(windows.Handle(inHandle), &r.origStateInput); err != nil {
		return err
	}
	r.inHandle = uintptr(inHandle)

	r.setupTerminal()

	// channel for non-blocking reads. Buffer to make sure
	// we get the ESC sets:
	r.ttyinChannel = make(chan byte, 1024)

	// the following allows for non-blocking IO.
	// syscall.SetNonblock() is a NOOP under Windows.
	go func() {
		fd := int(r.inHandle)
		b := make([]byte, 1)
		for {
			// HACK: if run from PSReadline, something resets ConsoleMode to remove ENABLE_VIRTUAL_TERMINAL_INPUT.
			_ = windows.SetConsoleMode(windows.Handle(r.inHandle), consoleFlagsInput)

			_, err := util.Read(fd, b)
			if err == nil {
				r.ttyinChannel <- b[0]
			}
		}
	}()

	return nil
}

func (r *LightRenderer) closePlatform() {
	windows.SetConsoleMode(windows.Handle(r.outHandle), r.origStateOutput)
	windows.SetConsoleMode(windows.Handle(r.inHandle), r.origStateInput)
}

func openTtyIn() *os.File {
	// not used
	return nil
}

func (r *LightRenderer) setupTerminal() error {
	if err := windows.SetConsoleMode(windows.Handle(r.outHandle), consoleFlagsOutput); err != nil {
		return err
	}
	return windows.SetConsoleMode(windows.Handle(r.inHandle), consoleFlagsInput)
}

func (r *LightRenderer) restoreTerminal() error {
	if err := windows.SetConsoleMode(windows.Handle(r.inHandle), r.origStateInput); err != nil {
		return err
	}
	return windows.SetConsoleMode(windows.Handle(r.outHandle), r.origStateOutput)
}

func (r *LightRenderer) updateTerminalSize() {
	var bufferInfo windows.ConsoleScreenBufferInfo
	if err := windows.GetConsoleScreenBufferInfo(windows.Handle(r.outHandle), &bufferInfo); err != nil {
		r.width = getEnv("COLUMNS", defaultWidth)
		r.height = r.maxHeightFunc(getEnv("LINES", defaultHeight))

	} else {
		r.width = int(bufferInfo.Window.Right - bufferInfo.Window.Left)
		r.height = r.maxHeightFunc(int(bufferInfo.Window.Bottom - bufferInfo.Window.Top))
	}
}

func (r *LightRenderer) findOffset() (row int, col int) {
	var bufferInfo windows.ConsoleScreenBufferInfo
	if err := windows.GetConsoleScreenBufferInfo(windows.Handle(r.outHandle), &bufferInfo); err != nil {
		return -1, -1
	}
	return int(bufferInfo.CursorPosition.X), int(bufferInfo.CursorPosition.Y)
}

func (r *LightRenderer) getch(nonblock bool) (int, bool) {
	if nonblock {
		select {
		case bc := <-r.ttyinChannel:
			return int(bc), true
		case <-time.After(timeoutInterval * time.Millisecond):
			return 0, false
		}
	} else {
		bc := <-r.ttyinChannel
		return int(bc), true
	}
}
./src/tui/tcell.go	[[[1
764
//go:build tcell || windows

package tui

import (
	"os"
	"time"

	"github.com/gdamore/tcell/v2"
	"github.com/gdamore/tcell/v2/encoding"
	"github.com/junegunn/fzf/src/util"

	"github.com/mattn/go-runewidth"
	"github.com/rivo/uniseg"
)

func HasFullscreenRenderer() bool {
	return true
}

var DefaultBorderShape BorderShape = BorderSharp

func asTcellColor(color Color) tcell.Color {
	if color == colDefault {
		return tcell.ColorDefault
	}

	value := uint64(tcell.ColorValid) + uint64(color)
	if color.is24() {
		value = value | uint64(tcell.ColorIsRGB)
	}
	return tcell.Color(value)
}

func (p ColorPair) style() tcell.Style {
	style := tcell.StyleDefault
	return style.Foreground(asTcellColor(p.Fg())).Background(asTcellColor(p.Bg()))
}

type Attr int32

type TcellWindow struct {
	color       bool
	preview     bool
	top         int
	left        int
	width       int
	height      int
	normal      ColorPair
	lastX       int
	lastY       int
	moveCursor  bool
	borderStyle BorderStyle
}

func (w *TcellWindow) Top() int {
	return w.top
}

func (w *TcellWindow) Left() int {
	return w.left
}

func (w *TcellWindow) Width() int {
	return w.width
}

func (w *TcellWindow) Height() int {
	return w.height
}

func (w *TcellWindow) Refresh() {
	if w.moveCursor {
		_screen.ShowCursor(w.left+w.lastX, w.top+w.lastY)
		w.moveCursor = false
	}
	w.lastX = 0
	w.lastY = 0
}

func (w *TcellWindow) FinishFill() {
	// NO-OP
}

const (
	Bold          Attr = Attr(tcell.AttrBold)
	Dim                = Attr(tcell.AttrDim)
	Blink              = Attr(tcell.AttrBlink)
	Reverse            = Attr(tcell.AttrReverse)
	Underline          = Attr(tcell.AttrUnderline)
	StrikeThrough      = Attr(tcell.AttrStrikeThrough)
	Italic             = Attr(tcell.AttrItalic)
)

const (
	AttrUndefined = Attr(0)
	AttrRegular   = Attr(1 << 7)
	AttrClear     = Attr(1 << 8)
)

func (r *FullscreenRenderer) Resize(maxHeightFunc func(int) int) {}

func (r *FullscreenRenderer) defaultTheme() *ColorTheme {
	if _screen.Colors() >= 256 {
		return Dark256
	}
	return Default16
}

var (
	_colorToAttribute = []tcell.Color{
		tcell.ColorBlack,
		tcell.ColorRed,
		tcell.ColorGreen,
		tcell.ColorYellow,
		tcell.ColorBlue,
		tcell.ColorDarkMagenta,
		tcell.ColorLightCyan,
		tcell.ColorWhite,
	}
)

func (c Color) Style() tcell.Color {
	if c <= colDefault {
		return tcell.ColorDefault
	} else if c >= colBlack && c <= colWhite {
		return _colorToAttribute[int(c)]
	} else {
		return tcell.Color(c)
	}
}

func (a Attr) Merge(b Attr) Attr {
	return a | b
}

// handle the following as private members of FullscreenRenderer instance
// they are declared here to prevent introducing tcell library in non-windows builds
var (
	_screen          tcell.Screen
	_prevMouseButton tcell.ButtonMask
)

func (r *FullscreenRenderer) initScreen() {
	s, e := tcell.NewScreen()
	if e != nil {
		errorExit(e.Error())
	}
	if e = s.Init(); e != nil {
		errorExit(e.Error())
	}
	if r.mouse {
		s.EnableMouse()
	} else {
		s.DisableMouse()
	}
	_screen = s
}

func (r *FullscreenRenderer) Init() {
	if os.Getenv("TERM") == "cygwin" {
		os.Setenv("TERM", "")
	}
	encoding.Register()

	r.initScreen()
	initTheme(r.theme, r.defaultTheme(), r.forceBlack)
}

func (r *FullscreenRenderer) MaxX() int {
	ncols, _ := _screen.Size()
	return int(ncols)
}

func (r *FullscreenRenderer) MaxY() int {
	_, nlines := _screen.Size()
	return int(nlines)
}

func (w *TcellWindow) X() int {
	return w.lastX
}

func (w *TcellWindow) Y() int {
	return w.lastY
}

func (r *FullscreenRenderer) Clear() {
	_screen.Sync()
	_screen.Clear()
}

func (r *FullscreenRenderer) NeedScrollbarRedraw() bool {
	return true
}

func (r *FullscreenRenderer) Refresh() {
	// noop
}

func (r *FullscreenRenderer) GetChar() Event {
	ev := _screen.PollEvent()
	switch ev := ev.(type) {
	case *tcell.EventResize:
		return Event{Resize, 0, nil}

	// process mouse events:
	case *tcell.EventMouse:
		// mouse down events have zeroed buttons, so we can't use them
		// mouse up event consists of two events, 1. (main) event with modifier and other metadata, 2. event with zeroed buttons
		// so mouse click is three consecutive events, but the first and last are indistinguishable from movement events (with released buttons)
		// dragging has same structure, it only repeats the middle (main) event appropriately
		x, y := ev.Position()
		mod := ev.Modifiers() != 0

		// since we dont have mouse down events (unlike LightRenderer), we need to track state in prevButton
		prevButton, button := _prevMouseButton, ev.Buttons()
		_prevMouseButton = button
		drag := prevButton == button

		switch {
		case button&tcell.WheelDown != 0:
			return Event{Mouse, 0, &MouseEvent{y, x, -1, false, false, false, mod}}
		case button&tcell.WheelUp != 0:
			return Event{Mouse, 0, &MouseEvent{y, x, +1, false, false, false, mod}}
		case button&tcell.Button1 != 0:
			double := false
			if !drag {
				// all potential double click events put their coordinates in the clicks array
				// double click event has two conditions, temporal and spatial, the first is checked here
				now := time.Now()
				if now.Sub(r.prevDownTime) < doubleClickDuration {
					r.clicks = append(r.clicks, [2]int{x, y})
				} else {
					r.clicks = [][2]int{{x, y}}
				}
				r.prevDownTime = now

				// detect double clicks (also check for spatial condition)
				n := len(r.clicks)
				double = n > 1 && r.clicks[n-2][0] == r.clicks[n-1][0] && r.clicks[n-2][1] == r.clicks[n-1][1]
				if double {
					// make sure two consecutive double clicks require four clicks
					r.clicks = [][2]int{}
				}
			}
			// fire single or double click event
			return Event{Mouse, 0, &MouseEvent{y, x, 0, true, !double, double, mod}}
		case button&tcell.Button2 != 0:
			return Event{Mouse, 0, &MouseEvent{y, x, 0, false, true, false, mod}}
		default:
			// double and single taps on Windows don't quite work due to
			// the console acting on the events and not allowing us
			// to consume them.
			left := button&tcell.Button1 != 0
			down := left || button&tcell.Button3 != 0
			double := false

			return Event{Mouse, 0, &MouseEvent{y, x, 0, left, down, double, mod}}
		}

		// process keyboard:
	case *tcell.EventKey:
		mods := ev.Modifiers()
		none := mods == tcell.ModNone
		alt := (mods & tcell.ModAlt) > 0
		ctrl := (mods & tcell.ModCtrl) > 0
		shift := (mods & tcell.ModShift) > 0
		ctrlAlt := ctrl && alt
		altShift := alt && shift

		keyfn := func(r rune) Event {
			if alt {
				return CtrlAltKey(r)
			}
			return EventType(CtrlA.Int() - 'a' + int(r)).AsEvent()
		}
		switch ev.Key() {
		// section 1: Ctrl+(Alt)+[a-z]
		case tcell.KeyCtrlA:
			return keyfn('a')
		case tcell.KeyCtrlB:
			return keyfn('b')
		case tcell.KeyCtrlC:
			return keyfn('c')
		case tcell.KeyCtrlD:
			return keyfn('d')
		case tcell.KeyCtrlE:
			return keyfn('e')
		case tcell.KeyCtrlF:
			return keyfn('f')
		case tcell.KeyCtrlG:
			return keyfn('g')
		case tcell.KeyCtrlH:
			switch ev.Rune() {
			case 0:
				if ctrl {
					return Event{BSpace, 0, nil}
				}
			case rune(tcell.KeyCtrlH):
				switch {
				case ctrl:
					return keyfn('h')
				case alt:
					return Event{AltBS, 0, nil}
				case none, shift:
					return Event{BSpace, 0, nil}
				}
			}
		case tcell.KeyCtrlI:
			return keyfn('i')
		case tcell.KeyCtrlJ:
			return keyfn('j')
		case tcell.KeyCtrlK:
			return keyfn('k')
		case tcell.KeyCtrlL:
			return keyfn('l')
		case tcell.KeyCtrlM:
			return keyfn('m')
		case tcell.KeyCtrlN:
			return keyfn('n')
		case tcell.KeyCtrlO:
			return keyfn('o')
		case tcell.KeyCtrlP:
			return keyfn('p')
		case tcell.KeyCtrlQ:
			return keyfn('q')
		case tcell.KeyCtrlR:
			return keyfn('r')
		case tcell.KeyCtrlS:
			return keyfn('s')
		case tcell.KeyCtrlT:
			return keyfn('t')
		case tcell.KeyCtrlU:
			return keyfn('u')
		case tcell.KeyCtrlV:
			return keyfn('v')
		case tcell.KeyCtrlW:
			return keyfn('w')
		case tcell.KeyCtrlX:
			return keyfn('x')
		case tcell.KeyCtrlY:
			return keyfn('y')
		case tcell.KeyCtrlZ:
			return keyfn('z')
		// section 2: Ctrl+[ \]_]
		case tcell.KeyCtrlSpace:
			return Event{CtrlSpace, 0, nil}
		case tcell.KeyCtrlBackslash:
			return Event{CtrlBackSlash, 0, nil}
		case tcell.KeyCtrlRightSq:
			return Event{CtrlRightBracket, 0, nil}
		case tcell.KeyCtrlCarat:
			return Event{CtrlCaret, 0, nil}
		case tcell.KeyCtrlUnderscore:
			return Event{CtrlSlash, 0, nil}
		// section 3: (Alt)+Backspace2
		case tcell.KeyBackspace2:
			if alt {
				return Event{AltBS, 0, nil}
			}
			return Event{BSpace, 0, nil}

		// section 4: (Alt+Shift)+Key(Up|Down|Left|Right)
		case tcell.KeyUp:
			if altShift {
				return Event{AltSUp, 0, nil}
			}
			if shift {
				return Event{SUp, 0, nil}
			}
			if alt {
				return Event{AltUp, 0, nil}
			}
			return Event{Up, 0, nil}
		case tcell.KeyDown:
			if altShift {
				return Event{AltSDown, 0, nil}
			}
			if shift {
				return Event{SDown, 0, nil}
			}
			if alt {
				return Event{AltDown, 0, nil}
			}
			return Event{Down, 0, nil}
		case tcell.KeyLeft:
			if altShift {
				return Event{AltSLeft, 0, nil}
			}
			if shift {
				return Event{SLeft, 0, nil}
			}
			if alt {
				return Event{AltLeft, 0, nil}
			}
			return Event{Left, 0, nil}
		case tcell.KeyRight:
			if altShift {
				return Event{AltSRight, 0, nil}
			}
			if shift {
				return Event{SRight, 0, nil}
			}
			if alt {
				return Event{AltRight, 0, nil}
			}
			return Event{Right, 0, nil}

		// section 5: (Insert|Home|Delete|End|PgUp|PgDn|BackTab|F1-F12)
		case tcell.KeyInsert:
			return Event{Insert, 0, nil}
		case tcell.KeyHome:
			return Event{Home, 0, nil}
		case tcell.KeyDelete:
			if ctrl {
				return Event{CtrlDelete, 0, nil}
			}
			if shift {
				return Event{SDelete, 0, nil}
			}
			return Event{Del, 0, nil}
		case tcell.KeyEnd:
			return Event{End, 0, nil}
		case tcell.KeyPgUp:
			return Event{PgUp, 0, nil}
		case tcell.KeyPgDn:
			return Event{PgDn, 0, nil}
		case tcell.KeyBacktab:
			return Event{BTab, 0, nil}
		case tcell.KeyF1:
			return Event{F1, 0, nil}
		case tcell.KeyF2:
			return Event{F2, 0, nil}
		case tcell.KeyF3:
			return Event{F3, 0, nil}
		case tcell.KeyF4:
			return Event{F4, 0, nil}
		case tcell.KeyF5:
			return Event{F5, 0, nil}
		case tcell.KeyF6:
			return Event{F6, 0, nil}
		case tcell.KeyF7:
			return Event{F7, 0, nil}
		case tcell.KeyF8:
			return Event{F8, 0, nil}
		case tcell.KeyF9:
			return Event{F9, 0, nil}
		case tcell.KeyF10:
			return Event{F10, 0, nil}
		case tcell.KeyF11:
			return Event{F11, 0, nil}
		case tcell.KeyF12:
			return Event{F12, 0, nil}

		// section 6: (Ctrl+Alt)+'rune'
		case tcell.KeyRune:
			r := ev.Rune()

			switch {
			// translate native key events to ascii control characters
			case r == ' ' && ctrl:
				return Event{CtrlSpace, 0, nil}
			// handle AltGr characters
			case ctrlAlt:
				return Event{Rune, r, nil} // dropping modifiers
			// simple characters (possibly with modifier)
			case alt:
				return AltKey(r)
			default:
				return Event{Rune, r, nil}
			}

		// section 7: Esc
		case tcell.KeyEsc:
			return Event{ESC, 0, nil}
		}
	}

	// section 8: Invalid
	return Event{Invalid, 0, nil}
}

func (r *FullscreenRenderer) Pause(clear bool) {
	if clear {
		_screen.Fini()
	}
}

func (r *FullscreenRenderer) Resume(clear bool, sigcont bool) {
	if clear {
		r.initScreen()
	}
}

func (r *FullscreenRenderer) Close() {
	_screen.Fini()
}

func (r *FullscreenRenderer) RefreshWindows(windows []Window) {
	// TODO
	for _, w := range windows {
		w.Refresh()
	}
	_screen.Show()
}

func (r *FullscreenRenderer) NewWindow(top int, left int, width int, height int, preview bool, borderStyle BorderStyle) Window {
	normal := ColNormal
	if preview {
		normal = ColPreview
	}
	w := &TcellWindow{
		color:       r.theme.Colored,
		preview:     preview,
		top:         top,
		left:        left,
		width:       width,
		height:      height,
		normal:      normal,
		borderStyle: borderStyle}
	w.drawBorder(false)
	return w
}

func (w *TcellWindow) Close() {
	// TODO
}

func fill(x, y, w, h int, n ColorPair, r rune) {
	for ly := 0; ly <= h; ly++ {
		for lx := 0; lx <= w; lx++ {
			_screen.SetContent(x+lx, y+ly, r, nil, n.style())
		}
	}
}

func (w *TcellWindow) Erase() {
	fill(w.left-1, w.top, w.width+1, w.height-1, w.normal, ' ')
}

func (w *TcellWindow) Enclose(y int, x int) bool {
	return x >= w.left && x < (w.left+w.width) &&
		y >= w.top && y < (w.top+w.height)
}

func (w *TcellWindow) Move(y int, x int) {
	w.lastX = x
	w.lastY = y
	w.moveCursor = true
}

func (w *TcellWindow) MoveAndClear(y int, x int) {
	w.Move(y, x)
	for i := w.lastX; i < w.width; i++ {
		_screen.SetContent(i+w.left, w.lastY+w.top, rune(' '), nil, w.normal.style())
	}
	w.lastX = x
}

func (w *TcellWindow) Print(text string) {
	w.printString(text, w.normal)
}

func (w *TcellWindow) printString(text string, pair ColorPair) {
	lx := 0
	a := pair.Attr()

	style := pair.style()
	if a&AttrClear == 0 {
		style = style.
			Reverse(a&Attr(tcell.AttrReverse) != 0).
			Underline(a&Attr(tcell.AttrUnderline) != 0).
			StrikeThrough(a&Attr(tcell.AttrStrikeThrough) != 0).
			Italic(a&Attr(tcell.AttrItalic) != 0).
			Blink(a&Attr(tcell.AttrBlink) != 0).
			Dim(a&Attr(tcell.AttrDim) != 0)
	}

	gr := uniseg.NewGraphemes(text)
	for gr.Next() {
		st := style
		rs := gr.Runes()

		if len(rs) == 1 {
			r := rs[0]
			if r == '\r' {
				st = style.Dim(true)
				rs[0] = '␍'
			} else if r == '\n' {
				st = style.Dim(true)
				rs[0] = '␊'
			} else if r < rune(' ') { // ignore control characters
				continue
			}
		}
		var xPos = w.left + w.lastX + lx
		var yPos = w.top + w.lastY
		if xPos < (w.left+w.width) && yPos < (w.top+w.height) {
			_screen.SetContent(xPos, yPos, rs[0], rs[1:], st)
		}
		lx += util.StringWidth(string(rs))
	}
	w.lastX += lx
}

func (w *TcellWindow) CPrint(pair ColorPair, text string) {
	w.printString(text, pair)
}

func (w *TcellWindow) fillString(text string, pair ColorPair) FillReturn {
	lx := 0
	a := pair.Attr()

	var style tcell.Style
	if w.color {
		style = pair.style()
	} else {
		style = w.normal.style()
	}
	style = style.
		Blink(a&Attr(tcell.AttrBlink) != 0).
		Bold(a&Attr(tcell.AttrBold) != 0).
		Dim(a&Attr(tcell.AttrDim) != 0).
		Reverse(a&Attr(tcell.AttrReverse) != 0).
		Underline(a&Attr(tcell.AttrUnderline) != 0).
		StrikeThrough(a&Attr(tcell.AttrStrikeThrough) != 0).
		Italic(a&Attr(tcell.AttrItalic) != 0)

	gr := uniseg.NewGraphemes(text)
Loop:
	for gr.Next() {
		st := style
		rs := gr.Runes()
		if len(rs) == 1 {
			r := rs[0]
			switch r {
			case '\r':
				st = style.Dim(true)
				rs[0] = '␍'
			case '\n':
				w.lastY++
				w.lastX = 0
				lx = 0
				continue Loop
			}
		}

		// word wrap:
		xPos := w.left + w.lastX + lx
		if xPos >= (w.left + w.width) {
			w.lastY++
			w.lastX = 0
			lx = 0
			xPos = w.left
		}

		yPos := w.top + w.lastY
		if yPos >= (w.top + w.height) {
			return FillSuspend
		}

		_screen.SetContent(xPos, yPos, rs[0], rs[1:], st)
		lx += util.StringWidth(string(rs))
	}
	w.lastX += lx
	if w.lastX == w.width {
		w.lastY++
		w.lastX = 0
		return FillNextLine
	}

	return FillContinue
}

func (w *TcellWindow) Fill(str string) FillReturn {
	return w.fillString(str, w.normal)
}

func (w *TcellWindow) CFill(fg Color, bg Color, a Attr, str string) FillReturn {
	if fg == colDefault {
		fg = w.normal.Fg()
	}
	if bg == colDefault {
		bg = w.normal.Bg()
	}
	return w.fillString(str, NewColorPair(fg, bg, a))
}

func (w *TcellWindow) DrawHBorder() {
	w.drawBorder(true)
}

func (w *TcellWindow) drawBorder(onlyHorizontal bool) {
	shape := w.borderStyle.shape
	if shape == BorderNone {
		return
	}

	left := w.left
	right := left + w.width
	top := w.top
	bot := top + w.height

	var style tcell.Style
	if w.color {
		if w.preview {
			style = ColPreviewBorder.style()
		} else {
			style = ColBorder.style()
		}
	} else {
		style = w.normal.style()
	}

	hw := runewidth.RuneWidth(w.borderStyle.top)
	switch shape {
	case BorderRounded, BorderSharp, BorderBold, BorderBlock, BorderThinBlock, BorderDouble, BorderHorizontal, BorderTop:
		max := right - 2*hw
		if shape == BorderHorizontal || shape == BorderTop {
			max = right - hw
		}
		// tcell has an issue displaying two overlapping wide runes
		// e.g.  SetContent(  HH  )
		//       SetContent(   TR )
		//       ==================
		//                 (  HH  ) => TR is ignored
		for x := left; x <= max; x += hw {
			_screen.SetContent(x, top, w.borderStyle.top, nil, style)
		}
	}
	switch shape {
	case BorderRounded, BorderSharp, BorderBold, BorderBlock, BorderThinBlock, BorderDouble, BorderHorizontal, BorderBottom:
		max := right - 2*hw
		if shape == BorderHorizontal || shape == BorderBottom {
			max = right - hw
		}
		for x := left; x <= max; x += hw {
			_screen.SetContent(x, bot-1, w.borderStyle.bottom, nil, style)
		}
	}
	if !onlyHorizontal {
		switch shape {
		case BorderRounded, BorderSharp, BorderBold, BorderBlock, BorderThinBlock, BorderDouble, BorderVertical, BorderLeft:
			for y := top; y < bot; y++ {
				_screen.SetContent(left, y, w.borderStyle.left, nil, style)
			}
		}
		switch shape {
		case BorderRounded, BorderSharp, BorderBold, BorderBlock, BorderThinBlock, BorderDouble, BorderVertical, BorderRight:
			vw := runewidth.RuneWidth(w.borderStyle.right)
			for y := top; y < bot; y++ {
				_screen.SetContent(right-vw, y, w.borderStyle.right, nil, style)
			}
		}
	}
	switch shape {
	case BorderRounded, BorderSharp, BorderBold, BorderBlock, BorderThinBlock, BorderDouble:
		_screen.SetContent(left, top, w.borderStyle.topLeft, nil, style)
		_screen.SetContent(right-runewidth.RuneWidth(w.borderStyle.topRight), top, w.borderStyle.topRight, nil, style)
		_screen.SetContent(left, bot-1, w.borderStyle.bottomLeft, nil, style)
		_screen.SetContent(right-runewidth.RuneWidth(w.borderStyle.bottomRight), bot-1, w.borderStyle.bottomRight, nil, style)
	}
}
./src/tui/tcell_test.go	[[[1
392
//go:build tcell || windows

package tui

import (
	"testing"

	"github.com/gdamore/tcell/v2"
	"github.com/junegunn/fzf/src/util"
)

func assert(t *testing.T, context string, got interface{}, want interface{}) bool {
	if got == want {
		return true
	} else {
		t.Errorf("%s = (%T)%v, want (%T)%v", context, got, got, want, want)
		return false
	}
}

// Test the handling of the tcell keyboard events.
func TestGetCharEventKey(t *testing.T) {
	if util.ToTty() {
		// This test is skipped when output goes to terminal, because it causes
		// some glitches:
		// - output lines may not start at the beginning of a row which makes
		//   the output unreadable
		// - terminal may get cleared which prevents you from seeing results of
		//   previous tests
		// Good ways to prevent the glitches are piping the output to a pager
		// or redirecting to a file. I've found `less +G` to be trouble-free.
		t.Skip("Skipped because this test misbehaves in terminal, pipe to a pager or redirect output to a file to run it safely.")
	} else if testing.Verbose() {
		// I have observed a behaviour when this test outputted more than 8192
		// bytes (32*256) into the 'less' pager, both the go's test executable
		// and the pager hanged. The go's executable was blocking on printing.
		// I was able to create minimal working example of that behaviour, but
		// that example hanged after 12256 bytes (32*(256+127)).
		t.Log("If you are piping this test to a pager and it hangs, make the pager greedy for input, e.g. 'less +G'.")
	}

	if !HasFullscreenRenderer() {
		t.Skip("Can't test FullscreenRenderer.")
	}

	// construct test cases
	type giveKey struct {
		Type tcell.Key
		Char rune
		Mods tcell.ModMask
	}
	type wantKey = Event
	type testCase struct {
		giveKey
		wantKey
	}
	/*
		Some test cases are marked "fabricated". It means that giveKey value
		is valid, but it is not what you get when you press the keys. For
		example Ctrl+C will NOT give you tcell.KeyCtrlC, but tcell.KeyETX
		(End-Of-Text character, causing SIGINT).
		I was trying to accompany the fabricated test cases with real ones.

		Some test cases are marked "unhandled". It means that giveKey.Type
		is not present in tcell.go source code. It can still be handled via
		implicit or explicit alias.

		If not said otherwise, test cases are for US keyboard.

		(tabstop=44)
	*/
	tests := []testCase{

		// section 1: Ctrl+(Alt)+[a-z]
		{giveKey{tcell.KeyCtrlA, rune(tcell.KeyCtrlA), tcell.ModCtrl}, wantKey{CtrlA, 0, nil}},
		{giveKey{tcell.KeyCtrlC, rune(tcell.KeyCtrlC), tcell.ModCtrl}, wantKey{CtrlC, 0, nil}}, // fabricated
		{giveKey{tcell.KeyETX, rune(tcell.KeyETX), tcell.ModCtrl}, wantKey{CtrlC, 0, nil}},     // this is SIGINT (Ctrl+C)
		{giveKey{tcell.KeyCtrlZ, rune(tcell.KeyCtrlZ), tcell.ModCtrl}, wantKey{CtrlZ, 0, nil}}, // fabricated
		// KeyTab is alias for KeyTAB
		{giveKey{tcell.KeyCtrlI, rune(tcell.KeyCtrlI), tcell.ModCtrl}, wantKey{Tab, 0, nil}}, // fabricated
		{giveKey{tcell.KeyTab, rune(tcell.KeyTab), tcell.ModNone}, wantKey{Tab, 0, nil}},     // unhandled, actual "Tab" keystroke
		{giveKey{tcell.KeyTAB, rune(tcell.KeyTAB), tcell.ModNone}, wantKey{Tab, 0, nil}},     // fabricated, unhandled
		// KeyEnter is alias for KeyCR
		{giveKey{tcell.KeyCtrlM, rune(tcell.KeyCtrlM), tcell.ModNone}, wantKey{CtrlM, 0, nil}}, // actual "Enter" keystroke
		{giveKey{tcell.KeyCR, rune(tcell.KeyCR), tcell.ModNone}, wantKey{CtrlM, 0, nil}},       // fabricated, unhandled
		{giveKey{tcell.KeyEnter, rune(tcell.KeyEnter), tcell.ModNone}, wantKey{CtrlM, 0, nil}}, // fabricated, unhandled
		// Ctrl+Alt keys
		{giveKey{tcell.KeyCtrlA, rune(tcell.KeyCtrlA), tcell.ModCtrl | tcell.ModAlt}, wantKey{CtrlAlt, 'a', nil}},                  // fabricated
		{giveKey{tcell.KeyCtrlA, rune(tcell.KeyCtrlA), tcell.ModCtrl | tcell.ModAlt | tcell.ModShift}, wantKey{CtrlAlt, 'a', nil}}, // fabricated

		// section 2: Ctrl+[ \]_]
		{giveKey{tcell.KeyCtrlSpace, rune(tcell.KeyCtrlSpace), tcell.ModCtrl}, wantKey{CtrlSpace, 0, nil}}, // fabricated
		{giveKey{tcell.KeyNUL, rune(tcell.KeyNUL), tcell.ModNone}, wantKey{CtrlSpace, 0, nil}},             // fabricated, unhandled
		{giveKey{tcell.KeyRune, ' ', tcell.ModCtrl}, wantKey{CtrlSpace, 0, nil}},                           // actual Ctrl+' '
		{giveKey{tcell.KeyCtrlBackslash, rune(tcell.KeyCtrlBackslash), tcell.ModCtrl}, wantKey{CtrlBackSlash, 0, nil}},
		{giveKey{tcell.KeyCtrlRightSq, rune(tcell.KeyCtrlRightSq), tcell.ModCtrl}, wantKey{CtrlRightBracket, 0, nil}},
		{giveKey{tcell.KeyCtrlCarat, rune(tcell.KeyCtrlCarat), tcell.ModShift | tcell.ModCtrl}, wantKey{CtrlCaret, 0, nil}}, // fabricated
		{giveKey{tcell.KeyRS, rune(tcell.KeyRS), tcell.ModShift | tcell.ModCtrl}, wantKey{CtrlCaret, 0, nil}},               // actual Ctrl+Shift+6 (i.e. Ctrl+^) keystroke
		{giveKey{tcell.KeyCtrlUnderscore, rune(tcell.KeyCtrlUnderscore), tcell.ModShift | tcell.ModCtrl}, wantKey{CtrlSlash, 0, nil}},

		// section 3: (Alt)+Backspace2
		// KeyBackspace2 is alias for KeyDEL = 0x7F (ASCII) (allegedly unused by Windows)
		// KeyDelete = 0x2E (VK_DELETE constant in Windows)
		// KeyBackspace is alias for KeyBS = 0x08 (ASCII) (implicit alias with KeyCtrlH)
		{giveKey{tcell.KeyBackspace2, 0, tcell.ModNone}, wantKey{BSpace, 0, nil}}, // fabricated
		{giveKey{tcell.KeyBackspace2, 0, tcell.ModAlt}, wantKey{AltBS, 0, nil}},   // fabricated
		{giveKey{tcell.KeyDEL, 0, tcell.ModNone}, wantKey{BSpace, 0, nil}},        // fabricated, unhandled
		{giveKey{tcell.KeyDelete, 0, tcell.ModNone}, wantKey{Del, 0, nil}},
		{giveKey{tcell.KeyDelete, 0, tcell.ModAlt}, wantKey{Del, 0, nil}},
		{giveKey{tcell.KeyBackspace, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},                                                  // fabricated, unhandled
		{giveKey{tcell.KeyBS, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},                                                         // fabricated, unhandled
		{giveKey{tcell.KeyCtrlH, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},                                                      // fabricated, unhandled
		{giveKey{tcell.KeyCtrlH, rune(tcell.KeyCtrlH), tcell.ModNone}, wantKey{BSpace, 0, nil}},                                    // actual "Backspace" keystroke
		{giveKey{tcell.KeyCtrlH, rune(tcell.KeyCtrlH), tcell.ModAlt}, wantKey{AltBS, 0, nil}},                                      // actual "Alt+Backspace" keystroke
		{giveKey{tcell.KeyDEL, rune(tcell.KeyDEL), tcell.ModCtrl}, wantKey{BSpace, 0, nil}},                                        // actual "Ctrl+Backspace" keystroke
		{giveKey{tcell.KeyCtrlH, rune(tcell.KeyCtrlH), tcell.ModShift}, wantKey{BSpace, 0, nil}},                                   // actual "Shift+Backspace" keystroke
		{giveKey{tcell.KeyCtrlH, 0, tcell.ModCtrl | tcell.ModAlt}, wantKey{BSpace, 0, nil}},                                        // actual "Ctrl+Alt+Backspace" keystroke
		{giveKey{tcell.KeyCtrlH, 0, tcell.ModCtrl | tcell.ModShift}, wantKey{BSpace, 0, nil}},                                      // actual "Ctrl+Shift+Backspace" keystroke
		{giveKey{tcell.KeyCtrlH, rune(tcell.KeyCtrlH), tcell.ModShift | tcell.ModAlt}, wantKey{AltBS, 0, nil}},                     // actual "Shift+Alt+Backspace" keystroke
		{giveKey{tcell.KeyCtrlH, 0, tcell.ModCtrl | tcell.ModAlt | tcell.ModShift}, wantKey{BSpace, 0, nil}},                       // actual "Ctrl+Shift+Alt+Backspace" keystroke
		{giveKey{tcell.KeyCtrlH, rune(tcell.KeyCtrlH), tcell.ModCtrl}, wantKey{CtrlH, 0, nil}},                                     // actual "Ctrl+H" keystroke
		{giveKey{tcell.KeyCtrlH, rune(tcell.KeyCtrlH), tcell.ModCtrl | tcell.ModAlt}, wantKey{CtrlAlt, 'h', nil}},                  // fabricated "Ctrl+Alt+H" keystroke
		{giveKey{tcell.KeyCtrlH, rune(tcell.KeyCtrlH), tcell.ModCtrl | tcell.ModShift}, wantKey{CtrlH, 0, nil}},                    // actual "Ctrl+Shift+H" keystroke
		{giveKey{tcell.KeyCtrlH, rune(tcell.KeyCtrlH), tcell.ModCtrl | tcell.ModAlt | tcell.ModShift}, wantKey{CtrlAlt, 'h', nil}}, // fabricated "Ctrl+Shift+Alt+H" keystroke

		// section 4: (Alt+Shift)+Key(Up|Down|Left|Right)
		{giveKey{tcell.KeyUp, 0, tcell.ModNone}, wantKey{Up, 0, nil}},
		{giveKey{tcell.KeyDown, 0, tcell.ModAlt}, wantKey{AltDown, 0, nil}},
		{giveKey{tcell.KeyLeft, 0, tcell.ModShift}, wantKey{SLeft, 0, nil}},
		{giveKey{tcell.KeyRight, 0, tcell.ModShift | tcell.ModAlt}, wantKey{AltSRight, 0, nil}},
		{giveKey{tcell.KeyUpLeft, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},    // fabricated, unhandled
		{giveKey{tcell.KeyUpRight, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},   // fabricated, unhandled
		{giveKey{tcell.KeyDownLeft, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},  // fabricated, unhandled
		{giveKey{tcell.KeyDownRight, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}}, // fabricated, unhandled
		{giveKey{tcell.KeyCenter, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},    // fabricated, unhandled
		// section 5: (Insert|Home|Delete|End|PgUp|PgDn|BackTab|F1-F12)
		{giveKey{tcell.KeyInsert, 0, tcell.ModNone}, wantKey{Insert, 0, nil}},
		{giveKey{tcell.KeyF1, 0, tcell.ModNone}, wantKey{F1, 0, nil}},
		// section 6: (Ctrl+Alt)+'rune'
		{giveKey{tcell.KeyRune, 'a', tcell.ModNone}, wantKey{Rune, 'a', nil}},
		{giveKey{tcell.KeyRune, 'a', tcell.ModCtrl}, wantKey{Rune, 'a', nil}}, // fabricated
		{giveKey{tcell.KeyRune, 'a', tcell.ModAlt}, wantKey{Alt, 'a', nil}},
		{giveKey{tcell.KeyRune, 'A', tcell.ModAlt}, wantKey{Alt, 'A', nil}},
		{giveKey{tcell.KeyRune, '`', tcell.ModAlt}, wantKey{Alt, '`', nil}},
		/*
			"Input method" in Windows Language options:
			US: "US Keyboard" does not generate any characters (and thus any events) in Ctrl+Alt+[a-z] range
			CS: "Czech keyboard"
			DE: "German keyboard"

			Note that right Alt is not just `tcell.ModAlt` on foreign language keyboards, but it is the AltGr `tcell.ModCtrl|tcell.ModAlt`.
		*/
		{giveKey{tcell.KeyRune, '{', tcell.ModCtrl | tcell.ModAlt}, wantKey{Rune, '{', nil}}, // CS: Ctrl+Alt+b = "{" // Note that this does not interfere with CtrlB, since the "b" is replaced with "{" on OS level
		{giveKey{tcell.KeyRune, '$', tcell.ModCtrl | tcell.ModAlt}, wantKey{Rune, '$', nil}}, // CS: Ctrl+Alt+ů = "$"
		{giveKey{tcell.KeyRune, '~', tcell.ModCtrl | tcell.ModAlt}, wantKey{Rune, '~', nil}}, // CS: Ctrl+Alt++ = "~"
		{giveKey{tcell.KeyRune, '`', tcell.ModCtrl | tcell.ModAlt}, wantKey{Rune, '`', nil}}, // CS: Ctrl+Alt+ý,Space = "`" // this is dead key, space is required to emit the char

		{giveKey{tcell.KeyRune, '{', tcell.ModCtrl | tcell.ModAlt}, wantKey{Rune, '{', nil}}, // DE: Ctrl+Alt+7 = "{"
		{giveKey{tcell.KeyRune, '@', tcell.ModCtrl | tcell.ModAlt}, wantKey{Rune, '@', nil}}, // DE: Ctrl+Alt+q = "@"
		{giveKey{tcell.KeyRune, 'µ', tcell.ModCtrl | tcell.ModAlt}, wantKey{Rune, 'µ', nil}}, // DE: Ctrl+Alt+m = "µ"

		// section 7: Esc
		// KeyEsc and KeyEscape are aliases for KeyESC
		{giveKey{tcell.KeyEsc, rune(tcell.KeyEsc), tcell.ModNone}, wantKey{ESC, 0, nil}},               // fabricated
		{giveKey{tcell.KeyESC, rune(tcell.KeyESC), tcell.ModNone}, wantKey{ESC, 0, nil}},               // unhandled
		{giveKey{tcell.KeyEscape, rune(tcell.KeyEscape), tcell.ModNone}, wantKey{ESC, 0, nil}},         // fabricated, unhandled
		{giveKey{tcell.KeyESC, rune(tcell.KeyESC), tcell.ModCtrl}, wantKey{ESC, 0, nil}},               // actual Ctrl+[ keystroke
		{giveKey{tcell.KeyCtrlLeftSq, rune(tcell.KeyCtrlLeftSq), tcell.ModCtrl}, wantKey{ESC, 0, nil}}, // fabricated, unhandled

		// section 8: Invalid
		{giveKey{tcell.KeyRune, 'a', tcell.ModMeta}, wantKey{Rune, 'a', nil}}, // fabricated
		{giveKey{tcell.KeyF24, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},
		{giveKey{tcell.KeyHelp, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},   // fabricated, unhandled
		{giveKey{tcell.KeyExit, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},   // fabricated, unhandled
		{giveKey{tcell.KeyClear, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},  // unhandled, actual keystroke Numpad_5 with Numlock OFF
		{giveKey{tcell.KeyCancel, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}}, // fabricated, unhandled
		{giveKey{tcell.KeyPrint, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},  // fabricated, unhandled
		{giveKey{tcell.KeyPause, 0, tcell.ModNone}, wantKey{Invalid, 0, nil}},  // unhandled

	}
	r := NewFullscreenRenderer(&ColorTheme{}, false, false)
	r.Init()

	// run and evaluate the tests
	for _, test := range tests {
		// generate key event
		giveEvent := tcell.NewEventKey(test.giveKey.Type, test.giveKey.Char, test.giveKey.Mods)
		_screen.PostEventWait(giveEvent)
		t.Logf("giveEvent = %T{key: %v, ch: %q (%[3]v), mod: %#04b}\n", giveEvent, giveEvent.Key(), giveEvent.Rune(), giveEvent.Modifiers())

		// process the event in fzf and evaluate the test
		gotEvent := r.GetChar()
		// skip Resize events, those are sometimes put in the buffer outside of this test
		for gotEvent.Type == Resize {
			t.Logf("Resize swallowed")
			gotEvent = r.GetChar()
		}
		t.Logf("wantEvent = %T{Type: %v, Char: %q (%[3]v)}\n", test.wantKey, test.wantKey.Type, test.wantKey.Char)
		t.Logf("gotEvent = %T{Type: %v, Char: %q (%[3]v)}\n", gotEvent, gotEvent.Type, gotEvent.Char)

		assert(t, "r.GetChar().Type", gotEvent.Type, test.wantKey.Type)
		assert(t, "r.GetChar().Char", gotEvent.Char, test.wantKey.Char)
	}

	r.Close()
}

/*
Quick reference
---------------

(tabstop=18)
(this is not mapping table, it merely puts multiple constants ranges in one table)

¹) the two columns are each other implicit alias
²) explicit aliases here

%v	section #	tcell ctrl key¹	tcell ctrl char¹	tcell alias²	tui constants	tcell named keys	tcell mods
--	---------	--------------	---------------	-----------	-------------	----------------	----------
0	2	KeyCtrlSpace	KeyNUL = ^@ 		Rune		ModNone
1	1	KeyCtrlA	KeySOH = ^A		CtrlA		ModShift
2	1	KeyCtrlB	KeySTX = ^B		CtrlB		ModCtrl
3	1	KeyCtrlC	KeyETX = ^C		CtrlC
4	1	KeyCtrlD	KeyEOT = ^D		CtrlD		ModAlt
5	1	KeyCtrlE	KeyENQ = ^E		CtrlE
6	1	KeyCtrlF	KeyACK = ^F		CtrlF
7	1	KeyCtrlG	KeyBEL = ^G		CtrlG
8	1	KeyCtrlH	KeyBS = ^H	KeyBackspace	CtrlH		ModMeta
9	1	KeyCtrlI	KeyTAB = ^I	KeyTab	Tab
10	1	KeyCtrlJ	KeyLF = ^J		CtrlJ
11	1	KeyCtrlK	KeyVT = ^K		CtrlK
12	1	KeyCtrlL	KeyFF = ^L		CtrlL
13	1	KeyCtrlM	KeyCR = ^M	KeyEnter	CtrlM
14	1	KeyCtrlN	KeySO = ^N		CtrlN
15	1	KeyCtrlO	KeySI = ^O		CtrlO
16	1	KeyCtrlP	KeyDLE = ^P		CtrlP
17	1	KeyCtrlQ	KeyDC1 = ^Q		CtrlQ
18	1	KeyCtrlR	KeyDC2 = ^R		CtrlR
19	1	KeyCtrlS	KeyDC3 = ^S		CtrlS
20	1	KeyCtrlT	KeyDC4 = ^T		CtrlT
21	1	KeyCtrlU	KeyNAK = ^U		CtrlU
22	1	KeyCtrlV	KeySYN = ^V		CtrlV
23	1	KeyCtrlW	KeyETB = ^W		CtrlW
24	1	KeyCtrlX	KeyCAN = ^X		CtrlX
25	1	KeyCtrlY	KeyEM = ^Y		CtrlY
26	1	KeyCtrlZ	KeySUB = ^Z		CtrlZ
27	7	KeyCtrlLeftSq	KeyESC = ^[	KeyEsc, KeyEscape	ESC
28	2	KeyCtrlBackslash	KeyFS = ^\		CtrlSpace
29	2	KeyCtrlRightSq	KeyGS = ^]		CtrlBackSlash
30	2	KeyCtrlCarat	KeyRS = ^^		CtrlRightBracket
31	2	KeyCtrlUnderscore	KeyUS = ^_		CtrlCaret
32					CtrlSlash
33					Invalid
34					Resize
35					Mouse
36					DoubleClick
37					LeftClick
38					RightClick
39					BTab
40					BSpace
41					Del
42					PgUp
43					PgDn
44					Up
45					Down
46					Left
47					Right
48					Home
49					End
50					Insert
51					SUp
52					SDown
53					SLeft
54					SRight
55					F1
56					F2
57					F3
58					F4
59					F5
60					F6
61					F7
62					F8
63					F9
64					F10
65					F11
66					F12
67					Change
68					BackwardEOF
69					AltBS
70					AltUp
71					AltDown
72					AltLeft
73					AltRight
74					AltSUp
75					AltSDown
76					AltSLeft
77					AltSRight
78					Alt
79					CtrlAlt
..
127	3		  KeyDEL	KeyBackspace2
..
256	6					KeyRune
257	4					KeyUp
258	4					KeyDown
259	4					KeyRight
260	4					KeyLeft
261	8					KeyUpLeft
262	8					KeyUpRight
263	8					KeyDownLeft
264	8					KeyDownRight
265	8					KeyCenter
266	5					KeyPgUp
267	5					KeyPgDn
268	5					KeyHome
269	5					KeyEnd
270	5					KeyInsert
271	5					KeyDelete
272	8					KeyHelp
273	8					KeyExit
274	8					KeyClear
275	8		  			KeyCancel
276	8				  	KeyPrint
277	8					KeyPause
278	5					KeyBacktab
279	5					KeyF1
280	5					KeyF2
281	5					KeyF3
282	5					KeyF4
283	5					KeyF5
284	5					KeyF6
285	5					KeyF7
286	5					KeyF8
287	5					KeyF9
288	5					KeyF10
289	5					KeyF11
290	5					KeyF12
291	8					KeyF13
292	8					KeyF14
293	8					KeyF15
294	8					KeyF16
295	8					KeyF17
296	8					KeyF18
297	8					KeyF19
298	8					KeyF20
299	8					KeyF21
300	8					KeyF22
301	8					KeyF23
302	8					KeyF24
303	8					KeyF25
304	8					KeyF26
305	8					KeyF27
306	8					KeyF28
307	8					KeyF29
308	8					KeyF30
309	8					KeyF31
310	8					KeyF32
311	8					KeyF33
312	8					KeyF34
313	8					KeyF35
314	8					KeyF36
315	8					KeyF37
316	8					KeyF38
317	8					KeyF39
318	8					KeyF40
319	8					KeyF41
320	8					KeyF42
321	8					KeyF43
322	8					KeyF44
323	8					KeyF45
324	8					KeyF46
325	8					KeyF47
326	8					KeyF48
327	8					KeyF49
328	8					KeyF50
329	8					KeyF51
330	8					KeyF52
331	8					KeyF53
332	8					KeyF54
333	8					KeyF55
334	8					KeyF56
335	8					KeyF57
336	8					KeyF58
337	8					KeyF59
338	8					KeyF60
339	8					KeyF61
340	8					KeyF62
341	8					KeyF63
342	8					KeyF64
--	---------	--------------	---------------	-----------	-------------	----------------	----------
%v	section #	tcell ctrl key	tcell ctrl char	tcell alias	tui constants	tcell named keys	tcell mods
*/
./src/tui/ttyname_unix.go	[[[1
47
//go:build !windows

package tui

import (
	"io/ioutil"
	"os"
	"syscall"
)

var devPrefixes = [...]string{"/dev/pts/", "/dev/"}

func ttyname() string {
	var stderr syscall.Stat_t
	if syscall.Fstat(2, &stderr) != nil {
		return ""
	}

	for _, prefix := range devPrefixes {
		files, err := ioutil.ReadDir(prefix)
		if err != nil {
			continue
		}

		for _, file := range files {
			if stat, ok := file.Sys().(*syscall.Stat_t); ok && stat.Rdev == stderr.Rdev {
				return prefix + file.Name()
			}
		}
	}
	return ""
}

// TtyIn returns terminal device to be used as STDIN, falls back to os.Stdin
func TtyIn() *os.File {
	in, err := os.OpenFile(consoleDevice, syscall.O_RDONLY, 0)
	if err != nil {
		tty := ttyname()
		if len(tty) > 0 {
			if in, err := os.OpenFile(tty, syscall.O_RDONLY, 0); err == nil {
				return in
			}
		}
		return os.Stdin
	}
	return in
}
./src/tui/ttyname_windows.go	[[[1
14
//go:build windows

package tui

import "os"

func ttyname() string {
	return ""
}

// TtyIn on Windows returns os.Stdin
func TtyIn() *os.File {
	return os.Stdin
}
./src/tui/tui.go	[[[1
792
package tui

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

// Types of user action
type EventType int

const (
	Rune EventType = iota

	CtrlA
	CtrlB
	CtrlC
	CtrlD
	CtrlE
	CtrlF
	CtrlG
	CtrlH
	Tab
	CtrlJ
	CtrlK
	CtrlL
	CtrlM
	CtrlN
	CtrlO
	CtrlP
	CtrlQ
	CtrlR
	CtrlS
	CtrlT
	CtrlU
	CtrlV
	CtrlW
	CtrlX
	CtrlY
	CtrlZ
	ESC
	CtrlSpace
	CtrlDelete

	// https://apple.stackexchange.com/questions/24261/how-do-i-send-c-that-is-control-slash-to-the-terminal
	CtrlBackSlash
	CtrlRightBracket
	CtrlCaret
	CtrlSlash

	Invalid
	Resize
	Mouse
	DoubleClick
	LeftClick
	RightClick

	BTab
	BSpace

	Del
	PgUp
	PgDn

	Up
	Down
	Left
	Right
	Home
	End
	Insert

	SUp
	SDown
	SLeft
	SRight
	SDelete

	F1
	F2
	F3
	F4
	F5
	F6
	F7
	F8
	F9
	F10
	F11
	F12

	Change
	BackwardEOF
	Start
	Load
	Focus
	One
	Zero

	AltBS

	AltUp
	AltDown
	AltLeft
	AltRight

	AltSUp
	AltSDown
	AltSLeft
	AltSRight

	Alt
	CtrlAlt
)

func (t EventType) AsEvent() Event {
	return Event{t, 0, nil}
}

func (t EventType) Int() int {
	return int(t)
}

func (t EventType) Byte() byte {
	return byte(t)
}

func (e Event) Comparable() Event {
	// Ignore MouseEvent pointer
	return Event{e.Type, e.Char, nil}
}

func Key(r rune) Event {
	return Event{Rune, r, nil}
}

func AltKey(r rune) Event {
	return Event{Alt, r, nil}
}

func CtrlAltKey(r rune) Event {
	return Event{CtrlAlt, r, nil}
}

const (
	doubleClickDuration = 500 * time.Millisecond
)

type Color int32

func (c Color) IsDefault() bool {
	return c == colDefault
}

func (c Color) is24() bool {
	return c > 0 && (c&(1<<24)) > 0
}

type ColorAttr struct {
	Color Color
	Attr  Attr
}

func NewColorAttr() ColorAttr {
	return ColorAttr{Color: colUndefined, Attr: AttrUndefined}
}

const (
	colUndefined Color = -2
	colDefault   Color = -1
)

const (
	colBlack Color = iota
	colRed
	colGreen
	colYellow
	colBlue
	colMagenta
	colCyan
	colWhite
)

type FillReturn int

const (
	FillContinue FillReturn = iota
	FillNextLine
	FillSuspend
)

type ColorPair struct {
	fg   Color
	bg   Color
	attr Attr
}

func HexToColor(rrggbb string) Color {
	r, _ := strconv.ParseInt(rrggbb[1:3], 16, 0)
	g, _ := strconv.ParseInt(rrggbb[3:5], 16, 0)
	b, _ := strconv.ParseInt(rrggbb[5:7], 16, 0)
	return Color((1 << 24) + (r << 16) + (g << 8) + b)
}

func NewColorPair(fg Color, bg Color, attr Attr) ColorPair {
	return ColorPair{fg, bg, attr}
}

func (p ColorPair) Fg() Color {
	return p.fg
}

func (p ColorPair) Bg() Color {
	return p.bg
}

func (p ColorPair) Attr() Attr {
	return p.attr
}

func (p ColorPair) HasBg() bool {
	return p.attr&Reverse == 0 && p.bg != colDefault ||
		p.attr&Reverse > 0 && p.fg != colDefault
}

func (p ColorPair) merge(other ColorPair, except Color) ColorPair {
	dup := p
	dup.attr = dup.attr.Merge(other.attr)
	if other.fg != except {
		dup.fg = other.fg
	}
	if other.bg != except {
		dup.bg = other.bg
	}
	return dup
}

func (p ColorPair) WithAttr(attr Attr) ColorPair {
	dup := p
	dup.attr = dup.attr.Merge(attr)
	return dup
}

func (p ColorPair) MergeAttr(other ColorPair) ColorPair {
	return p.WithAttr(other.attr)
}

func (p ColorPair) Merge(other ColorPair) ColorPair {
	return p.merge(other, colUndefined)
}

func (p ColorPair) MergeNonDefault(other ColorPair) ColorPair {
	return p.merge(other, colDefault)
}

type ColorTheme struct {
	Colored          bool
	Input            ColorAttr
	Disabled         ColorAttr
	Fg               ColorAttr
	Bg               ColorAttr
	PreviewFg        ColorAttr
	PreviewBg        ColorAttr
	DarkBg           ColorAttr
	Gutter           ColorAttr
	Prompt           ColorAttr
	Match            ColorAttr
	Current          ColorAttr
	CurrentMatch     ColorAttr
	Spinner          ColorAttr
	Info             ColorAttr
	Cursor           ColorAttr
	Selected         ColorAttr
	Header           ColorAttr
	Separator        ColorAttr
	Scrollbar        ColorAttr
	Border           ColorAttr
	PreviewBorder    ColorAttr
	PreviewScrollbar ColorAttr
	BorderLabel      ColorAttr
	PreviewLabel     ColorAttr
}

type Event struct {
	Type       EventType
	Char       rune
	MouseEvent *MouseEvent
}

func (e Event) Is(types ...EventType) bool {
	for _, t := range types {
		if e.Type == t {
			return true
		}
	}
	return false
}

type MouseEvent struct {
	Y      int
	X      int
	S      int
	Left   bool
	Down   bool
	Double bool
	Mod    bool
}

type BorderShape int

const (
	BorderNone BorderShape = iota
	BorderRounded
	BorderSharp
	BorderBold
	BorderBlock
	BorderThinBlock
	BorderDouble
	BorderHorizontal
	BorderVertical
	BorderTop
	BorderBottom
	BorderLeft
	BorderRight
)

func (s BorderShape) HasRight() bool {
	switch s {
	case BorderNone, BorderLeft, BorderTop, BorderBottom, BorderHorizontal: // No right
		return false
	}
	return true
}

func (s BorderShape) HasTop() bool {
	switch s {
	case BorderNone, BorderLeft, BorderRight, BorderBottom, BorderVertical: // No top
		return false
	}
	return true
}

type BorderStyle struct {
	shape       BorderShape
	top         rune
	bottom      rune
	left        rune
	right       rune
	topLeft     rune
	topRight    rune
	bottomLeft  rune
	bottomRight rune
}

type BorderCharacter int

func MakeBorderStyle(shape BorderShape, unicode bool) BorderStyle {
	if !unicode {
		return BorderStyle{
			shape:       shape,
			top:         '-',
			bottom:      '-',
			left:        '|',
			right:       '|',
			topLeft:     '+',
			topRight:    '+',
			bottomLeft:  '+',
			bottomRight: '+',
		}
	}
	switch shape {
	case BorderSharp:
		return BorderStyle{
			shape:       shape,
			top:         '─',
			bottom:      '─',
			left:        '│',
			right:       '│',
			topLeft:     '┌',
			topRight:    '┐',
			bottomLeft:  '└',
			bottomRight: '┘',
		}
	case BorderBold:
		return BorderStyle{
			shape:       shape,
			top:         '━',
			bottom:      '━',
			left:        '┃',
			right:       '┃',
			topLeft:     '┏',
			topRight:    '┓',
			bottomLeft:  '┗',
			bottomRight: '┛',
		}
	case BorderBlock:
		// ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
		// ▌                  ▐
		// ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟
		return BorderStyle{
			shape:       shape,
			top:         '▀',
			bottom:      '▄',
			left:        '▌',
			right:       '▐',
			topLeft:     '▛',
			topRight:    '▜',
			bottomLeft:  '▙',
			bottomRight: '▟',
		}

	case BorderThinBlock:
		// 🭽▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔🭾
		// ▏                  ▕
		// 🭼▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁🭿
		return BorderStyle{
			shape:       shape,
			top:         '▔',
			bottom:      '▁',
			left:        '▏',
			right:       '▕',
			topLeft:     '🭽',
			topRight:    '🭾',
			bottomLeft:  '🭼',
			bottomRight: '🭿',
		}

	case BorderDouble:
		return BorderStyle{
			shape:       shape,
			top:         '═',
			bottom:      '═',
			left:        '║',
			right:       '║',
			topLeft:     '╔',
			topRight:    '╗',
			bottomLeft:  '╚',
			bottomRight: '╝',
		}
	}
	return BorderStyle{
		shape:       shape,
		top:         '─',
		bottom:      '─',
		left:        '│',
		right:       '│',
		topLeft:     '╭',
		topRight:    '╮',
		bottomLeft:  '╰',
		bottomRight: '╯',
	}
}

func MakeTransparentBorder() BorderStyle {
	return BorderStyle{
		shape:       BorderRounded,
		top:         ' ',
		bottom:      ' ',
		left:        ' ',
		right:       ' ',
		topLeft:     ' ',
		topRight:    ' ',
		bottomLeft:  ' ',
		bottomRight: ' '}
}

type Renderer interface {
	Init()
	Resize(maxHeightFunc func(int) int)
	Pause(clear bool)
	Resume(clear bool, sigcont bool)
	Clear()
	RefreshWindows(windows []Window)
	Refresh()
	Close()
	NeedScrollbarRedraw() bool

	GetChar() Event

	MaxX() int
	MaxY() int

	NewWindow(top int, left int, width int, height int, preview bool, borderStyle BorderStyle) Window
}

type Window interface {
	Top() int
	Left() int
	Width() int
	Height() int

	DrawHBorder()
	Refresh()
	FinishFill()
	Close()

	X() int
	Y() int
	Enclose(y int, x int) bool

	Move(y int, x int)
	MoveAndClear(y int, x int)
	Print(text string)
	CPrint(color ColorPair, text string)
	Fill(text string) FillReturn
	CFill(fg Color, bg Color, attr Attr, text string) FillReturn
	Erase()
}

type FullscreenRenderer struct {
	theme        *ColorTheme
	mouse        bool
	forceBlack   bool
	prevDownTime time.Time
	clicks       [][2]int
}

func NewFullscreenRenderer(theme *ColorTheme, forceBlack bool, mouse bool) Renderer {
	r := &FullscreenRenderer{
		theme:        theme,
		mouse:        mouse,
		forceBlack:   forceBlack,
		prevDownTime: time.Unix(0, 0),
		clicks:       [][2]int{}}
	return r
}

var (
	Default16 *ColorTheme
	Dark256   *ColorTheme
	Light256  *ColorTheme

	ColPrompt               ColorPair
	ColNormal               ColorPair
	ColInput                ColorPair
	ColDisabled             ColorPair
	ColMatch                ColorPair
	ColCursor               ColorPair
	ColCursorEmpty          ColorPair
	ColSelected             ColorPair
	ColCurrent              ColorPair
	ColCurrentMatch         ColorPair
	ColCurrentCursor        ColorPair
	ColCurrentCursorEmpty   ColorPair
	ColCurrentSelected      ColorPair
	ColCurrentSelectedEmpty ColorPair
	ColSpinner              ColorPair
	ColInfo                 ColorPair
	ColHeader               ColorPair
	ColSeparator            ColorPair
	ColScrollbar            ColorPair
	ColBorder               ColorPair
	ColPreview              ColorPair
	ColPreviewBorder        ColorPair
	ColBorderLabel          ColorPair
	ColPreviewLabel         ColorPair
	ColPreviewScrollbar     ColorPair
	ColPreviewSpinner       ColorPair
)

func EmptyTheme() *ColorTheme {
	return &ColorTheme{
		Colored:          true,
		Input:            ColorAttr{colUndefined, AttrUndefined},
		Fg:               ColorAttr{colUndefined, AttrUndefined},
		Bg:               ColorAttr{colUndefined, AttrUndefined},
		DarkBg:           ColorAttr{colUndefined, AttrUndefined},
		Prompt:           ColorAttr{colUndefined, AttrUndefined},
		Match:            ColorAttr{colUndefined, AttrUndefined},
		Current:          ColorAttr{colUndefined, AttrUndefined},
		CurrentMatch:     ColorAttr{colUndefined, AttrUndefined},
		Spinner:          ColorAttr{colUndefined, AttrUndefined},
		Info:             ColorAttr{colUndefined, AttrUndefined},
		Cursor:           ColorAttr{colUndefined, AttrUndefined},
		Selected:         ColorAttr{colUndefined, AttrUndefined},
		Header:           ColorAttr{colUndefined, AttrUndefined},
		Border:           ColorAttr{colUndefined, AttrUndefined},
		BorderLabel:      ColorAttr{colUndefined, AttrUndefined},
		Disabled:         ColorAttr{colUndefined, AttrUndefined},
		PreviewFg:        ColorAttr{colUndefined, AttrUndefined},
		PreviewBg:        ColorAttr{colUndefined, AttrUndefined},
		Gutter:           ColorAttr{colUndefined, AttrUndefined},
		PreviewBorder:    ColorAttr{colUndefined, AttrUndefined},
		PreviewScrollbar: ColorAttr{colUndefined, AttrUndefined},
		PreviewLabel:     ColorAttr{colUndefined, AttrUndefined},
		Separator:        ColorAttr{colUndefined, AttrUndefined},
		Scrollbar:        ColorAttr{colUndefined, AttrUndefined},
	}
}

func NoColorTheme() *ColorTheme {
	return &ColorTheme{
		Colored:          false,
		Input:            ColorAttr{colDefault, AttrUndefined},
		Fg:               ColorAttr{colDefault, AttrUndefined},
		Bg:               ColorAttr{colDefault, AttrUndefined},
		DarkBg:           ColorAttr{colDefault, AttrUndefined},
		Prompt:           ColorAttr{colDefault, AttrUndefined},
		Match:            ColorAttr{colDefault, Underline},
		Current:          ColorAttr{colDefault, Reverse},
		CurrentMatch:     ColorAttr{colDefault, Reverse | Underline},
		Spinner:          ColorAttr{colDefault, AttrUndefined},
		Info:             ColorAttr{colDefault, AttrUndefined},
		Cursor:           ColorAttr{colDefault, AttrUndefined},
		Selected:         ColorAttr{colDefault, AttrUndefined},
		Header:           ColorAttr{colDefault, AttrUndefined},
		Border:           ColorAttr{colDefault, AttrUndefined},
		BorderLabel:      ColorAttr{colDefault, AttrUndefined},
		Disabled:         ColorAttr{colDefault, AttrUndefined},
		PreviewFg:        ColorAttr{colDefault, AttrUndefined},
		PreviewBg:        ColorAttr{colDefault, AttrUndefined},
		Gutter:           ColorAttr{colDefault, AttrUndefined},
		PreviewBorder:    ColorAttr{colDefault, AttrUndefined},
		PreviewScrollbar: ColorAttr{colDefault, AttrUndefined},
		PreviewLabel:     ColorAttr{colDefault, AttrUndefined},
		Separator:        ColorAttr{colDefault, AttrUndefined},
		Scrollbar:        ColorAttr{colDefault, AttrUndefined},
	}
}

func errorExit(message string) {
	fmt.Fprintln(os.Stderr, message)
	os.Exit(2)
}

func init() {
	Default16 = &ColorTheme{
		Colored:          true,
		Input:            ColorAttr{colDefault, AttrUndefined},
		Fg:               ColorAttr{colDefault, AttrUndefined},
		Bg:               ColorAttr{colDefault, AttrUndefined},
		DarkBg:           ColorAttr{colBlack, AttrUndefined},
		Prompt:           ColorAttr{colBlue, AttrUndefined},
		Match:            ColorAttr{colGreen, AttrUndefined},
		Current:          ColorAttr{colYellow, AttrUndefined},
		CurrentMatch:     ColorAttr{colGreen, AttrUndefined},
		Spinner:          ColorAttr{colGreen, AttrUndefined},
		Info:             ColorAttr{colWhite, AttrUndefined},
		Cursor:           ColorAttr{colRed, AttrUndefined},
		Selected:         ColorAttr{colMagenta, AttrUndefined},
		Header:           ColorAttr{colCyan, AttrUndefined},
		Border:           ColorAttr{colBlack, AttrUndefined},
		BorderLabel:      ColorAttr{colWhite, AttrUndefined},
		Disabled:         ColorAttr{colUndefined, AttrUndefined},
		PreviewFg:        ColorAttr{colUndefined, AttrUndefined},
		PreviewBg:        ColorAttr{colUndefined, AttrUndefined},
		Gutter:           ColorAttr{colUndefined, AttrUndefined},
		PreviewBorder:    ColorAttr{colUndefined, AttrUndefined},
		PreviewScrollbar: ColorAttr{colUndefined, AttrUndefined},
		PreviewLabel:     ColorAttr{colUndefined, AttrUndefined},
		Separator:        ColorAttr{colUndefined, AttrUndefined},
		Scrollbar:        ColorAttr{colUndefined, AttrUndefined},
	}
	Dark256 = &ColorTheme{
		Colored:          true,
		Input:            ColorAttr{colDefault, AttrUndefined},
		Fg:               ColorAttr{colDefault, AttrUndefined},
		Bg:               ColorAttr{colDefault, AttrUndefined},
		DarkBg:           ColorAttr{236, AttrUndefined},
		Prompt:           ColorAttr{110, AttrUndefined},
		Match:            ColorAttr{108, AttrUndefined},
		Current:          ColorAttr{254, AttrUndefined},
		CurrentMatch:     ColorAttr{151, AttrUndefined},
		Spinner:          ColorAttr{148, AttrUndefined},
		Info:             ColorAttr{144, AttrUndefined},
		Cursor:           ColorAttr{161, AttrUndefined},
		Selected:         ColorAttr{168, AttrUndefined},
		Header:           ColorAttr{109, AttrUndefined},
		Border:           ColorAttr{59, AttrUndefined},
		BorderLabel:      ColorAttr{145, AttrUndefined},
		Disabled:         ColorAttr{colUndefined, AttrUndefined},
		PreviewFg:        ColorAttr{colUndefined, AttrUndefined},
		PreviewBg:        ColorAttr{colUndefined, AttrUndefined},
		Gutter:           ColorAttr{colUndefined, AttrUndefined},
		PreviewBorder:    ColorAttr{colUndefined, AttrUndefined},
		PreviewScrollbar: ColorAttr{colUndefined, AttrUndefined},
		PreviewLabel:     ColorAttr{colUndefined, AttrUndefined},
		Separator:        ColorAttr{colUndefined, AttrUndefined},
		Scrollbar:        ColorAttr{colUndefined, AttrUndefined},
	}
	Light256 = &ColorTheme{
		Colored:          true,
		Input:            ColorAttr{colDefault, AttrUndefined},
		Fg:               ColorAttr{colDefault, AttrUndefined},
		Bg:               ColorAttr{colDefault, AttrUndefined},
		DarkBg:           ColorAttr{251, AttrUndefined},
		Prompt:           ColorAttr{25, AttrUndefined},
		Match:            ColorAttr{66, AttrUndefined},
		Current:          ColorAttr{237, AttrUndefined},
		CurrentMatch:     ColorAttr{23, AttrUndefined},
		Spinner:          ColorAttr{65, AttrUndefined},
		Info:             ColorAttr{101, AttrUndefined},
		Cursor:           ColorAttr{161, AttrUndefined},
		Selected:         ColorAttr{168, AttrUndefined},
		Header:           ColorAttr{31, AttrUndefined},
		Border:           ColorAttr{145, AttrUndefined},
		BorderLabel:      ColorAttr{59, AttrUndefined},
		Disabled:         ColorAttr{colUndefined, AttrUndefined},
		PreviewFg:        ColorAttr{colUndefined, AttrUndefined},
		PreviewBg:        ColorAttr{colUndefined, AttrUndefined},
		Gutter:           ColorAttr{colUndefined, AttrUndefined},
		PreviewBorder:    ColorAttr{colUndefined, AttrUndefined},
		PreviewScrollbar: ColorAttr{colUndefined, AttrUndefined},
		PreviewLabel:     ColorAttr{colUndefined, AttrUndefined},
		Separator:        ColorAttr{colUndefined, AttrUndefined},
		Scrollbar:        ColorAttr{colUndefined, AttrUndefined},
	}
}

func initTheme(theme *ColorTheme, baseTheme *ColorTheme, forceBlack bool) {
	if forceBlack {
		theme.Bg = ColorAttr{colBlack, AttrUndefined}
	}

	o := func(a ColorAttr, b ColorAttr) ColorAttr {
		c := a
		if b.Color != colUndefined {
			c.Color = b.Color
		}
		if b.Attr != AttrUndefined {
			c.Attr = b.Attr
		}
		return c
	}
	theme.Input = o(baseTheme.Input, theme.Input)
	theme.Fg = o(baseTheme.Fg, theme.Fg)
	theme.Bg = o(baseTheme.Bg, theme.Bg)
	theme.DarkBg = o(baseTheme.DarkBg, theme.DarkBg)
	theme.Prompt = o(baseTheme.Prompt, theme.Prompt)
	theme.Match = o(baseTheme.Match, theme.Match)
	theme.Current = o(baseTheme.Current, theme.Current)
	theme.CurrentMatch = o(baseTheme.CurrentMatch, theme.CurrentMatch)
	theme.Spinner = o(baseTheme.Spinner, theme.Spinner)
	theme.Info = o(baseTheme.Info, theme.Info)
	theme.Cursor = o(baseTheme.Cursor, theme.Cursor)
	theme.Selected = o(baseTheme.Selected, theme.Selected)
	theme.Header = o(baseTheme.Header, theme.Header)
	theme.Border = o(baseTheme.Border, theme.Border)
	theme.BorderLabel = o(baseTheme.BorderLabel, theme.BorderLabel)

	// These colors are not defined in the base themes
	theme.Disabled = o(theme.Input, theme.Disabled)
	theme.Gutter = o(theme.DarkBg, theme.Gutter)
	theme.PreviewFg = o(theme.Fg, theme.PreviewFg)
	theme.PreviewBg = o(theme.Bg, theme.PreviewBg)
	theme.PreviewLabel = o(theme.BorderLabel, theme.PreviewLabel)
	theme.PreviewBorder = o(theme.Border, theme.PreviewBorder)
	theme.Separator = o(theme.Border, theme.Separator)
	theme.Scrollbar = o(theme.Border, theme.Scrollbar)
	theme.PreviewScrollbar = o(theme.PreviewBorder, theme.PreviewScrollbar)

	initPalette(theme)
}

func initPalette(theme *ColorTheme) {
	pair := func(fg, bg ColorAttr) ColorPair {
		if fg.Color == colDefault && (fg.Attr&Reverse) > 0 {
			bg.Color = colDefault
		}
		return ColorPair{fg.Color, bg.Color, fg.Attr}
	}
	blank := theme.Fg
	blank.Attr = AttrRegular

	ColPrompt = pair(theme.Prompt, theme.Bg)
	ColNormal = pair(theme.Fg, theme.Bg)
	ColInput = pair(theme.Input, theme.Bg)
	ColDisabled = pair(theme.Disabled, theme.Bg)
	ColMatch = pair(theme.Match, theme.Bg)
	ColCursor = pair(theme.Cursor, theme.Gutter)
	ColCursorEmpty = pair(blank, theme.Gutter)
	ColSelected = pair(theme.Selected, theme.Gutter)
	ColCurrent = pair(theme.Current, theme.DarkBg)
	ColCurrentMatch = pair(theme.CurrentMatch, theme.DarkBg)
	ColCurrentCursor = pair(theme.Cursor, theme.DarkBg)
	ColCurrentCursorEmpty = pair(blank, theme.DarkBg)
	ColCurrentSelected = pair(theme.Selected, theme.DarkBg)
	ColCurrentSelectedEmpty = pair(blank, theme.DarkBg)
	ColSpinner = pair(theme.Spinner, theme.Bg)
	ColInfo = pair(theme.Info, theme.Bg)
	ColHeader = pair(theme.Header, theme.Bg)
	ColSeparator = pair(theme.Separator, theme.Bg)
	ColScrollbar = pair(theme.Scrollbar, theme.Bg)
	ColBorder = pair(theme.Border, theme.Bg)
	ColBorderLabel = pair(theme.BorderLabel, theme.Bg)
	ColPreviewLabel = pair(theme.PreviewLabel, theme.PreviewBg)
	ColPreview = pair(theme.PreviewFg, theme.PreviewBg)
	ColPreviewBorder = pair(theme.PreviewBorder, theme.PreviewBg)
	ColPreviewScrollbar = pair(theme.PreviewScrollbar, theme.PreviewBg)
	ColPreviewSpinner = pair(theme.Spinner, theme.PreviewBg)
}
./src/tui/tui_test.go	[[[1
20
package tui

import "testing"

func TestHexToColor(t *testing.T) {
	assert := func(expr string, r, g, b int) {
		color := HexToColor(expr)
		if !color.is24() ||
			int((color>>16)&0xff) != r ||
			int((color>>8)&0xff) != g ||
			int((color)&0xff) != b {
			t.Fail()
		}
	}

	assert("#ff0000", 255, 0, 0)
	assert("#010203", 1, 2, 3)
	assert("#102030", 16, 32, 48)
	assert("#ffffff", 255, 255, 255)
}
./src/util/atomicbool.go	[[[1
34
package util

import (
	"sync/atomic"
)

func convertBoolToInt32(b bool) int32 {
	if b {
		return 1
	}
	return 0
}

// AtomicBool is a boxed-class that provides synchronized access to the
// underlying boolean value
type AtomicBool struct {
	state int32 // "1" is true, "0" is false
}

// NewAtomicBool returns a new AtomicBool
func NewAtomicBool(initialState bool) *AtomicBool {
	return &AtomicBool{state: convertBoolToInt32(initialState)}
}

// Get returns the current boolean value synchronously
func (a *AtomicBool) Get() bool {
	return atomic.LoadInt32(&a.state) == 1
}

// Set updates the boolean value synchronously
func (a *AtomicBool) Set(newState bool) bool {
	atomic.StoreInt32(&a.state, convertBoolToInt32(newState))
	return newState
}
./src/util/atomicbool_test.go	[[[1
17
package util

import "testing"

func TestAtomicBool(t *testing.T) {
	if !NewAtomicBool(true).Get() || NewAtomicBool(false).Get() {
		t.Error("Invalid initial value")
	}

	ab := NewAtomicBool(true)
	if ab.Set(false) {
		t.Error("Invalid return value")
	}
	if ab.Get() {
		t.Error("Invalid state")
	}
}
./src/util/chars.go	[[[1
198
package util

import (
	"fmt"
	"unicode"
	"unicode/utf8"
	"unsafe"
)

const (
	overflow64 uint64 = 0x8080808080808080
	overflow32 uint32 = 0x80808080
)

type Chars struct {
	slice           []byte // or []rune
	inBytes         bool
	trimLengthKnown bool
	trimLength      uint16

	// XXX Piggybacking item index here is a horrible idea. But I'm trying to
	// minimize the memory footprint by not wasting padded spaces.
	Index int32
}

func checkAscii(bytes []byte) (bool, int) {
	i := 0
	for ; i <= len(bytes)-8; i += 8 {
		if (overflow64 & *(*uint64)(unsafe.Pointer(&bytes[i]))) > 0 {
			return false, i
		}
	}
	for ; i <= len(bytes)-4; i += 4 {
		if (overflow32 & *(*uint32)(unsafe.Pointer(&bytes[i]))) > 0 {
			return false, i
		}
	}
	for ; i < len(bytes); i++ {
		if bytes[i] >= utf8.RuneSelf {
			return false, i
		}
	}
	return true, 0
}

// ToChars converts byte array into rune array
func ToChars(bytes []byte) Chars {
	inBytes, bytesUntil := checkAscii(bytes)
	if inBytes {
		return Chars{slice: bytes, inBytes: inBytes}
	}

	runes := make([]rune, bytesUntil, len(bytes))
	for i := 0; i < bytesUntil; i++ {
		runes[i] = rune(bytes[i])
	}
	for i := bytesUntil; i < len(bytes); {
		r, sz := utf8.DecodeRune(bytes[i:])
		i += sz
		runes = append(runes, r)
	}
	return RunesToChars(runes)
}

func RunesToChars(runes []rune) Chars {
	return Chars{slice: *(*[]byte)(unsafe.Pointer(&runes)), inBytes: false}
}

func (chars *Chars) IsBytes() bool {
	return chars.inBytes
}

func (chars *Chars) Bytes() []byte {
	return chars.slice
}

func (chars *Chars) optionalRunes() []rune {
	if chars.inBytes {
		return nil
	}
	return *(*[]rune)(unsafe.Pointer(&chars.slice))
}

func (chars *Chars) Get(i int) rune {
	if runes := chars.optionalRunes(); runes != nil {
		return runes[i]
	}
	return rune(chars.slice[i])
}

func (chars *Chars) Length() int {
	if runes := chars.optionalRunes(); runes != nil {
		return len(runes)
	}
	return len(chars.slice)
}

// String returns the string representation of a Chars object.
func (chars *Chars) String() string {
	return fmt.Sprintf("Chars{slice: []byte(%q), inBytes: %v, trimLengthKnown: %v, trimLength: %d, Index: %d}", chars.slice, chars.inBytes, chars.trimLengthKnown, chars.trimLength, chars.Index)
}

// TrimLength returns the length after trimming leading and trailing whitespaces
func (chars *Chars) TrimLength() uint16 {
	if chars.trimLengthKnown {
		return chars.trimLength
	}
	chars.trimLengthKnown = true
	var i int
	len := chars.Length()
	for i = len - 1; i >= 0; i-- {
		char := chars.Get(i)
		if !unicode.IsSpace(char) {
			break
		}
	}
	// Completely empty
	if i < 0 {
		return 0
	}

	var j int
	for j = 0; j < len; j++ {
		char := chars.Get(j)
		if !unicode.IsSpace(char) {
			break
		}
	}
	chars.trimLength = AsUint16(i - j + 1)
	return chars.trimLength
}

func (chars *Chars) LeadingWhitespaces() int {
	whitespaces := 0
	for i := 0; i < chars.Length(); i++ {
		char := chars.Get(i)
		if !unicode.IsSpace(char) {
			break
		}
		whitespaces++
	}
	return whitespaces
}

func (chars *Chars) TrailingWhitespaces() int {
	whitespaces := 0
	for i := chars.Length() - 1; i >= 0; i-- {
		char := chars.Get(i)
		if !unicode.IsSpace(char) {
			break
		}
		whitespaces++
	}
	return whitespaces
}

func (chars *Chars) TrimTrailingWhitespaces() {
	whitespaces := chars.TrailingWhitespaces()
	chars.slice = chars.slice[0 : len(chars.slice)-whitespaces]
}

func (chars *Chars) ToString() string {
	if runes := chars.optionalRunes(); runes != nil {
		return string(runes)
	}
	return string(chars.slice)
}

func (chars *Chars) ToRunes() []rune {
	if runes := chars.optionalRunes(); runes != nil {
		return runes
	}
	bytes := chars.slice
	runes := make([]rune, len(bytes))
	for idx, b := range bytes {
		runes[idx] = rune(b)
	}
	return runes
}

func (chars *Chars) CopyRunes(dest []rune) {
	if runes := chars.optionalRunes(); runes != nil {
		copy(dest, runes)
		return
	}
	for idx, b := range chars.slice[:len(dest)] {
		dest[idx] = rune(b)
	}
}

func (chars *Chars) Prepend(prefix string) {
	if runes := chars.optionalRunes(); runes != nil {
		runes = append([]rune(prefix), runes...)
		chars.slice = *(*[]byte)(unsafe.Pointer(&runes))
	} else {
		chars.slice = append([]byte(prefix), chars.slice...)
	}
}
./src/util/chars_test.go	[[[1
46
package util

import "testing"

func TestToCharsAscii(t *testing.T) {
	chars := ToChars([]byte("foobar"))
	if !chars.inBytes || chars.ToString() != "foobar" || !chars.inBytes {
		t.Error()
	}
}

func TestCharsLength(t *testing.T) {
	chars := ToChars([]byte("\tabc한글  "))
	if chars.inBytes || chars.Length() != 8 || chars.TrimLength() != 5 {
		t.Error()
	}
}

func TestCharsToString(t *testing.T) {
	text := "\tabc한글  "
	chars := ToChars([]byte(text))
	if chars.ToString() != text {
		t.Error()
	}
}

func TestTrimLength(t *testing.T) {
	check := func(str string, exp uint16) {
		chars := ToChars([]byte(str))
		trimmed := chars.TrimLength()
		if trimmed != exp {
			t.Errorf("Invalid TrimLength result for '%s': %d (expected %d)",
				str, trimmed, exp)
		}
	}
	check("hello", 5)
	check("hello ", 5)
	check("hello  ", 5)
	check(" hello", 5)
	check("  hello", 5)
	check(" hello ", 5)
	check("  hello  ", 5)
	check("h   o", 5)
	check("  h   o  ", 5)
	check("         ", 0)
}
./src/util/eventbox.go	[[[1
96
package util

import "sync"

// EventType is the type for fzf events
type EventType int

// Events is a type that associates EventType to any data
type Events map[EventType]interface{}

// EventBox is used for coordinating events
type EventBox struct {
	events Events
	cond   *sync.Cond
	ignore map[EventType]bool
}

// NewEventBox returns a new EventBox
func NewEventBox() *EventBox {
	return &EventBox{
		events: make(Events),
		cond:   sync.NewCond(&sync.Mutex{}),
		ignore: make(map[EventType]bool)}
}

// Wait blocks the goroutine until signaled
func (b *EventBox) Wait(callback func(*Events)) {
	b.cond.L.Lock()

	if len(b.events) == 0 {
		b.cond.Wait()
	}

	callback(&b.events)
	b.cond.L.Unlock()
}

// Set turns on the event type on the box
func (b *EventBox) Set(event EventType, value interface{}) {
	b.cond.L.Lock()
	b.events[event] = value
	if _, found := b.ignore[event]; !found {
		b.cond.Broadcast()
	}
	b.cond.L.Unlock()
}

// Clear clears the events
// Unsynchronized; should be called within Wait routine
func (events *Events) Clear() {
	for event := range *events {
		delete(*events, event)
	}
}

// Peek peeks at the event box if the given event is set
func (b *EventBox) Peek(event EventType) bool {
	b.cond.L.Lock()
	_, ok := b.events[event]
	b.cond.L.Unlock()
	return ok
}

// Watch deletes the events from the ignore list
func (b *EventBox) Watch(events ...EventType) {
	b.cond.L.Lock()
	for _, event := range events {
		delete(b.ignore, event)
	}
	b.cond.L.Unlock()
}

// Unwatch adds the events to the ignore list
func (b *EventBox) Unwatch(events ...EventType) {
	b.cond.L.Lock()
	for _, event := range events {
		b.ignore[event] = true
	}
	b.cond.L.Unlock()
}

// WaitFor blocks the execution until the event is received
func (b *EventBox) WaitFor(event EventType) {
	looping := true
	for looping {
		b.Wait(func(events *Events) {
			for evt := range *events {
				switch evt {
				case event:
					looping = false
					return
				}
			}
		})
	}
}
./src/util/eventbox_test.go	[[[1
60
package util

import "testing"

// fzf events
const (
	EvtReadNew EventType = iota
	EvtReadFin
	EvtSearchNew
	EvtSearchProgress
	EvtSearchFin
)

func TestEventBox(t *testing.T) {
	eb := NewEventBox()

	// Wait should return immediately
	ch := make(chan bool)

	go func() {
		eb.Set(EvtReadNew, 10)
		ch <- true
		<-ch
		eb.Set(EvtSearchNew, 10)
		eb.Set(EvtSearchNew, 15)
		eb.Set(EvtSearchNew, 20)
		eb.Set(EvtSearchProgress, 30)
		ch <- true
		<-ch
		eb.Set(EvtSearchFin, 40)
		ch <- true
		<-ch
	}()

	count := 0
	sum := 0
	looping := true
	for looping {
		<-ch
		eb.Wait(func(events *Events) {
			for _, value := range *events {
				switch val := value.(type) {
				case int:
					sum += val
					looping = sum < 100
				}
			}
			events.Clear()
		})
		ch <- true
		count++
	}

	if count != 3 {
		t.Error("Invalid number of events", count)
	}
	if sum != 100 {
		t.Error("Invalid sum", sum)
	}
}
./src/util/slab.go	[[[1
12
package util

type Slab struct {
	I16 []int16
	I32 []int32
}

func MakeSlab(size16 int, size32 int) *Slab {
	return &Slab{
		I16: make([]int16, size16),
		I32: make([]int32, size32)}
}
./src/util/util.go	[[[1
179
package util

import (
	"math"
	"os"
	"strings"
	"time"

	"github.com/mattn/go-isatty"
	"github.com/mattn/go-runewidth"
	"github.com/rivo/uniseg"
)

// StringWidth returns string width where each CR/LF character takes 1 column
func StringWidth(s string) int {
	return runewidth.StringWidth(s) + strings.Count(s, "\n") + strings.Count(s, "\r")
}

// RunesWidth returns runes width
func RunesWidth(runes []rune, prefixWidth int, tabstop int, limit int) (int, int) {
	width := 0
	gr := uniseg.NewGraphemes(string(runes))
	idx := 0
	for gr.Next() {
		rs := gr.Runes()
		var w int
		if len(rs) == 1 && rs[0] == '\t' {
			w = tabstop - (prefixWidth+width)%tabstop
		} else {
			w = StringWidth(string(rs))
		}
		width += w
		if width > limit {
			return width, idx
		}
		idx += len(rs)
	}
	return width, -1
}

// Truncate returns the truncated runes and its width
func Truncate(input string, limit int) ([]rune, int) {
	runes := []rune{}
	width := 0
	gr := uniseg.NewGraphemes(input)
	for gr.Next() {
		rs := gr.Runes()
		w := StringWidth(string(rs))
		if width+w > limit {
			return runes, width
		}
		width += w
		runes = append(runes, rs...)
	}
	return runes, width
}

// Max returns the largest integer
func Max(first int, second int) int {
	if first >= second {
		return first
	}
	return second
}

// Max16 returns the largest integer
func Max16(first int16, second int16) int16 {
	if first >= second {
		return first
	}
	return second
}

// Max32 returns the largest 32-bit integer
func Max32(first int32, second int32) int32 {
	if first > second {
		return first
	}
	return second
}

// Min returns the smallest integer
func Min(first int, second int) int {
	if first <= second {
		return first
	}
	return second
}

// Min32 returns the smallest 32-bit integer
func Min32(first int32, second int32) int32 {
	if first <= second {
		return first
	}
	return second
}

// Constrain32 limits the given 32-bit integer with the upper and lower bounds
func Constrain32(val int32, min int32, max int32) int32 {
	if val < min {
		return min
	}
	if val > max {
		return max
	}
	return val
}

// Constrain limits the given integer with the upper and lower bounds
func Constrain(val int, min int, max int) int {
	if val < min {
		return min
	}
	if val > max {
		return max
	}
	return val
}

func AsUint16(val int) uint16 {
	if val > math.MaxUint16 {
		return math.MaxUint16
	} else if val < 0 {
		return 0
	}
	return uint16(val)
}

// DurWithin limits the given time.Duration with the upper and lower bounds
func DurWithin(
	val time.Duration, min time.Duration, max time.Duration) time.Duration {
	if val < min {
		return min
	}
	if val > max {
		return max
	}
	return val
}

// IsTty returns true if stdin is a terminal
func IsTty() bool {
	return isatty.IsTerminal(os.Stdin.Fd())
}

// ToTty returns true if stdout is a terminal
func ToTty() bool {
	return isatty.IsTerminal(os.Stdout.Fd())
}

// Once returns a function that returns the specified boolean value only once
func Once(nextResponse bool) func() bool {
	state := nextResponse
	return func() bool {
		prevState := state
		state = false
		return prevState
	}
}

// RepeatToFill repeats the given string to fill the given width
func RepeatToFill(str string, length int, limit int) string {
	times := limit / length
	rest := limit % length
	output := strings.Repeat(str, times)
	if rest > 0 {
		for _, r := range str {
			rest -= runewidth.RuneWidth(r)
			if rest < 0 {
				break
			}
			output += string(r)
			if rest == 0 {
				break
			}
		}
	}
	return output
}
./src/util/util_test.go	[[[1
186
package util

import (
	"math"
	"strings"
	"testing"
	"time"
)

func TestMax(t *testing.T) {
	if Max(10, 1) != 10 {
		t.Error("Expected", 10)
	}
	if Max(-2, 5) != 5 {
		t.Error("Expected", 5)
	}
}

func TestMax16(t *testing.T) {
	if Max16(10, 1) != 10 {
		t.Error("Expected", 10)
	}
	if Max16(-2, 5) != 5 {
		t.Error("Expected", 5)
	}
	if Max16(math.MaxInt16, 0) != math.MaxInt16 {
		t.Error("Expected", math.MaxInt16)
	}
	if Max16(0, math.MinInt16) != 0 {
		t.Error("Expected", 0)
	}
}

func TestMax32(t *testing.T) {
	if Max32(10, 1) != 10 {
		t.Error("Expected", 10)
	}
	if Max32(-2, 5) != 5 {
		t.Error("Expected", 5)
	}
	if Max32(math.MaxInt32, 0) != math.MaxInt32 {
		t.Error("Expected", math.MaxInt32)
	}
	if Max32(0, math.MinInt32) != 0 {
		t.Error("Expected", 0)
	}
}

func TestMin(t *testing.T) {
	if Min(10, 1) != 1 {
		t.Error("Expected", 1)
	}
	if Min(-2, 5) != -2 {
		t.Error("Expected", -2)
	}
}

func TestMin32(t *testing.T) {
	if Min32(10, 1) != 1 {
		t.Error("Expected", 1)
	}
	if Min32(-2, 5) != -2 {
		t.Error("Expected", -2)
	}
	if Min32(math.MaxInt32, 0) != 0 {
		t.Error("Expected", 0)
	}
	if Min32(0, math.MinInt32) != math.MinInt32 {
		t.Error("Expected", math.MinInt32)
	}
}

func TestConstrain(t *testing.T) {
	if Constrain(-3, -1, 3) != -1 {
		t.Error("Expected", -1)
	}
	if Constrain(2, -1, 3) != 2 {
		t.Error("Expected", 2)
	}

	if Constrain(5, -1, 3) != 3 {
		t.Error("Expected", 3)
	}
}

func TestConstrain32(t *testing.T) {
	if Constrain32(-3, -1, 3) != -1 {
		t.Error("Expected", -1)
	}
	if Constrain32(2, -1, 3) != 2 {
		t.Error("Expected", 2)
	}

	if Constrain32(5, -1, 3) != 3 {
		t.Error("Expected", 3)
	}
	if Constrain32(0, math.MinInt32, math.MaxInt32) != 0 {
		t.Error("Expected", 0)
	}
}

func TestAsUint16(t *testing.T) {
	if AsUint16(5) != 5 {
		t.Error("Expected", 5)
	}
	if AsUint16(-10) != 0 {
		t.Error("Expected", 0)
	}
	if AsUint16(math.MaxUint16) != math.MaxUint16 {
		t.Error("Expected", math.MaxUint16)
	}
	if AsUint16(math.MinInt32) != 0 {
		t.Error("Expected", 0)
	}
	if AsUint16(math.MinInt16) != 0 {
		t.Error("Expected", 0)
	}
	if AsUint16(math.MaxUint16+1) != math.MaxUint16 {
		t.Error("Expected", math.MaxUint16)
	}
}

func TestDurWithIn(t *testing.T) {
	if DurWithin(time.Duration(5), time.Duration(1), time.Duration(8)) != time.Duration(5) {
		t.Error("Expected", time.Duration(0))
	}
	if DurWithin(time.Duration(0)*time.Second, time.Second, time.Duration(3)*time.Second) != time.Second {
		t.Error("Expected", time.Second)
	}
	if DurWithin(time.Duration(10)*time.Second, time.Duration(0), time.Second) != time.Second {
		t.Error("Expected", time.Second)
	}
}

func TestOnce(t *testing.T) {
	o := Once(false)
	if o() {
		t.Error("Expected: false")
	}
	if o() {
		t.Error("Expected: false")
	}

	o = Once(true)
	if !o() {
		t.Error("Expected: true")
	}
	if o() {
		t.Error("Expected: false")
	}
}

func TestRunesWidth(t *testing.T) {
	for _, args := range [][]int{
		{100, 5, -1},
		{3, 4, 3},
		{0, 1, 0},
	} {
		width, overflowIdx := RunesWidth([]rune("hello"), 0, 0, args[0])
		if width != args[1] {
			t.Errorf("Expected width: %d, actual: %d", args[1], width)
		}
		if overflowIdx != args[2] {
			t.Errorf("Expected overflow index: %d, actual: %d", args[2], overflowIdx)
		}
	}
}

func TestTruncate(t *testing.T) {
	truncated, width := Truncate("가나다라마", 7)
	if string(truncated) != "가나다" {
		t.Errorf("Expected: 가나다, actual: %s", string(truncated))
	}
	if width != 6 {
		t.Errorf("Expected: 6, actual: %d", width)
	}
}

func TestRepeatToFill(t *testing.T) {
	if RepeatToFill("abcde", 10, 50) != strings.Repeat("abcde", 5) {
		t.Error("Expected:", strings.Repeat("abcde", 5))
	}
	if RepeatToFill("abcde", 10, 42) != strings.Repeat("abcde", 4)+"abcde"[:2] {
		t.Error("Expected:", strings.Repeat("abcde", 4)+"abcde"[:2])
	}
}
./src/util/util_unix.go	[[[1
53
//go:build !windows

package util

import (
	"os"
	"os/exec"
	"syscall"

	"golang.org/x/sys/unix"
)

// ExecCommand executes the given command with $SHELL
func ExecCommand(command string, setpgid bool) *exec.Cmd {
	shell := os.Getenv("SHELL")
	if len(shell) == 0 {
		shell = "sh"
	}
	return ExecCommandWith(shell, command, setpgid)
}

// ExecCommandWith executes the given command with the specified shell
func ExecCommandWith(shell string, command string, setpgid bool) *exec.Cmd {
	cmd := exec.Command(shell, "-c", command)
	if setpgid {
		cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
	}
	return cmd
}

// KillCommand kills the process for the given command
func KillCommand(cmd *exec.Cmd) error {
	return syscall.Kill(-cmd.Process.Pid, syscall.SIGKILL)
}

// IsWindows returns true on Windows
func IsWindows() bool {
	return false
}

// SetNonblock executes syscall.SetNonblock on file descriptor
func SetNonblock(file *os.File, nonblock bool) {
	syscall.SetNonblock(int(file.Fd()), nonblock)
}

// Read executes syscall.Read on file descriptor
func Read(fd int, b []byte) (int, error) {
	return syscall.Read(int(fd), b)
}

func SetStdin(file *os.File) {
	unix.Dup2(int(file.Fd()), 0)
}
./src/util/util_windows.go	[[[1
87
//go:build windows

package util

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
	"sync/atomic"
	"syscall"
)

var shellPath atomic.Value

// ExecCommand executes the given command with $SHELL
func ExecCommand(command string, setpgid bool) *exec.Cmd {
	var shell string
	if cached := shellPath.Load(); cached != nil {
		shell = cached.(string)
	} else {
		shell = os.Getenv("SHELL")
		if len(shell) == 0 {
			shell = "cmd"
		} else if strings.Contains(shell, "/") {
			out, err := exec.Command("cygpath", "-w", shell).Output()
			if err == nil {
				shell = strings.Trim(string(out), "\n")
			}
		}
		shellPath.Store(shell)
	}
	return ExecCommandWith(shell, command, setpgid)
}

// ExecCommandWith executes the given command with the specified shell
// FIXME: setpgid is unused. We set it in the Unix implementation so that we
// can kill preview process with its child processes at once.
// NOTE: For "powershell", we should ideally set output encoding to UTF8,
// but it is left as is now because no adverse effect has been observed.
func ExecCommandWith(shell string, command string, setpgid bool) *exec.Cmd {
	var cmd *exec.Cmd
	if strings.Contains(shell, "cmd") {
		cmd = exec.Command(shell)
		cmd.SysProcAttr = &syscall.SysProcAttr{
			HideWindow:    false,
			CmdLine:       fmt.Sprintf(` /v:on/s/c "%s"`, command),
			CreationFlags: 0,
		}
		return cmd
	}

	if strings.Contains(shell, "pwsh") || strings.Contains(shell, "powershell") {
		cmd = exec.Command(shell, "-NoProfile", "-Command", command)
	} else {
		cmd = exec.Command(shell, "-c", command)
	}
	cmd.SysProcAttr = &syscall.SysProcAttr{
		HideWindow:    false,
		CreationFlags: 0,
	}
	return cmd
}

// KillCommand kills the process for the given command
func KillCommand(cmd *exec.Cmd) error {
	return cmd.Process.Kill()
}

// IsWindows returns true on Windows
func IsWindows() bool {
	return true
}

// SetNonblock executes syscall.SetNonblock on file descriptor
func SetNonblock(file *os.File, nonblock bool) {
	syscall.SetNonblock(syscall.Handle(file.Fd()), nonblock)
}

// Read executes syscall.Read on file descriptor
func Read(fd int, b []byte) (int, error) {
	return syscall.Read(syscall.Handle(fd), b)
}

func SetStdin(file *os.File) {
	// No-op
}
./test/fzf.vader	[[[1
175
Execute (Setup):
  let g:dir = fnamemodify(g:vader_file, ':p:h')
  unlet! g:fzf_layout g:fzf_action g:fzf_history_dir
  Log 'Test directory: ' . g:dir
  Save &acd

Execute (fzf#run with dir option):
  let cwd = getcwd()
  let result = fzf#run({ 'source': 'git ls-files', 'options': '--filter=vdr', 'dir': g:dir })
  AssertEqual ['fzf.vader'], result
  AssertEqual 0, haslocaldir()
  AssertEqual getcwd(), cwd

  execute 'lcd' fnameescape(cwd)
  let result = sort(fzf#run({ 'source': 'git ls-files', 'options': '--filter e', 'dir': g:dir }))
  AssertEqual ['fzf.vader', 'test_go.rb'], result
  AssertEqual 1, haslocaldir()
  AssertEqual getcwd(), cwd

Execute (fzf#run with Funcref command):
  let g:ret = []
  function! g:FzfTest(e)
    call add(g:ret, a:e)
  endfunction
  let result = sort(fzf#run({ 'source': 'git ls-files', 'sink': function('g:FzfTest'), 'options': '--filter e', 'dir': g:dir }))
  AssertEqual ['fzf.vader', 'test_go.rb'], result
  AssertEqual ['fzf.vader', 'test_go.rb'], sort(g:ret)

Execute (fzf#run with string source):
  let result = sort(fzf#run({ 'source': 'echo hi', 'options': '-f i' }))
  AssertEqual ['hi'], result

Execute (fzf#run with list source):
  let result = sort(fzf#run({ 'source': ['hello', 'world'], 'options': '-f e' }))
  AssertEqual ['hello'], result
  let result = sort(fzf#run({ 'source': ['hello', 'world'], 'options': '-f o' }))
  AssertEqual ['hello', 'world'], result

Execute (fzf#run with string source):
  let result = sort(fzf#run({ 'source': 'echo hi', 'options': '-f i' }))
  AssertEqual ['hi'], result

Execute (fzf#run with dir option and noautochdir):
  set noacd
  let cwd = getcwd()
  call fzf#run({'source': ['/foobar'], 'sink': 'e', 'dir': '/tmp', 'options': '-1'})
  " No change in working directory
  AssertEqual cwd, getcwd()

  call fzf#run({'source': ['/foobar'], 'sink': 'tabe', 'dir': '/tmp', 'options': '-1'})
  AssertEqual cwd, getcwd()
  tabclose
  AssertEqual cwd, getcwd()

Execute (Incomplete fzf#run with dir option and autochdir):
  set acd
  let cwd = getcwd()
  call fzf#run({'source': [], 'sink': 'e', 'dir': '/tmp', 'options': '-0'})
  " No change in working directory even if &acd is set
  AssertEqual cwd, getcwd()

Execute (FIXME: fzf#run with dir option and autochdir):
  set acd
  call fzf#run({'source': ['/foobar'], 'sink': 'e', 'dir': '/tmp', 'options': '-1'})
  " Working directory changed due to &acd
  AssertEqual '/foobar', expand('%')
  AssertEqual '/', getcwd()

Execute (fzf#run with dir option and autochdir when final cwd is same as dir):
  set acd
  cd /tmp
  call fzf#run({'source': ['/foobar'], 'sink': 'e', 'dir': '/', 'options': '-1'})
  " Working directory changed due to &acd
  AssertEqual '/', getcwd()

Execute (fzf#wrap):
  AssertThrows fzf#wrap({'foo': 'bar'})

  let opts = fzf#wrap('foobar')
  Log opts
  AssertEqual '~40%', opts.down
  Assert opts.options =~ '--expect='
  Assert !has_key(opts, 'sink')
  Assert has_key(opts, 'sink*')

  let opts = fzf#wrap('foobar', {}, 0)
  Log opts
  AssertEqual '~40%', opts.down

  let opts = fzf#wrap('foobar', {}, 1)
  Log opts
  Assert !has_key(opts, 'down')

  let opts = fzf#wrap('foobar', {'down': '50%'})
  Log opts
  AssertEqual '50%', opts.down

  let opts = fzf#wrap('foobar', {'down': '50%'}, 1)
  Log opts
  Assert !has_key(opts, 'down')

  let opts = fzf#wrap('foobar', {'sink': 'e'})
  Log opts
  AssertEqual 'e', opts.sink
  Assert !has_key(opts, 'sink*')

  let opts = fzf#wrap('foobar', {'options': '--reverse'})
  Log opts
  Assert opts.options =~ '--expect='
  Assert opts.options =~ '--reverse'

  let g:fzf_layout = {'window': 'enew'}
  let opts = fzf#wrap('foobar')
  Log opts
  AssertEqual 'enew', opts.window

  let opts = fzf#wrap('foobar', {}, 1)
  Log opts
  Assert !has_key(opts, 'window')

  let opts = fzf#wrap('foobar', {'right': '50%'})
  Log opts
  Assert !has_key(opts, 'window')
  AssertEqual '50%', opts.right

  let opts = fzf#wrap('foobar', {'right': '50%'}, 1)
  Log opts
  Assert !has_key(opts, 'window')
  Assert !has_key(opts, 'right')

  let g:fzf_action = {'a': 'tabe'}
  let opts = fzf#wrap('foobar')
  Log opts
  Assert opts.options =~ '--expect=a'
  Assert !has_key(opts, 'sink')
  Assert has_key(opts, 'sink*')

  let opts = fzf#wrap('foobar', {'sink': 'e'})
  Log opts
  AssertEqual 'e', opts.sink
  Assert !has_key(opts, 'sink*')

  let g:fzf_history_dir = '/tmp'
  let opts = fzf#wrap('foobar', {'options': '--color light'})
  Log opts
  Assert opts.options =~ "--history '/tmp/foobar'"
  Assert opts.options =~ '--color light'

  let g:fzf_colors = { 'fg': ['fg', 'Error'] }
  let opts = fzf#wrap({})
  Assert opts.options =~ '^--color=fg:'

Execute (fzf#shellescape with sh):
  AssertEqual '''''', fzf#shellescape('', 'sh')
  AssertEqual '''\''', fzf#shellescape('\', 'sh')
  AssertEqual '''""''', fzf#shellescape('""', 'sh')
  AssertEqual '''foobar>''', fzf#shellescape('foobar>', 'sh')
  AssertEqual '''\\\"\\\''', fzf#shellescape('\\\"\\\', 'sh')
  AssertEqual '''echo ''\''''a''\'''' && echo ''\''''b''\''''''', fzf#shellescape('echo ''a'' && echo ''b''', 'sh')

Execute (fzf#shellescape with cmd.exe):
  AssertEqual '^"^"', fzf#shellescape('', 'cmd.exe')
  AssertEqual '^"\\^"', fzf#shellescape('\', 'cmd.exe')
  AssertEqual '^"\^"\^"^"', fzf#shellescape('""', 'cmd.exe')
  AssertEqual '^"foobar^>^"', fzf#shellescape('foobar>', 'cmd.exe')
  AssertEqual '^"\\\\\\\^"\\\\\\^"', fzf#shellescape('\\\"\\\', 'cmd.exe')
  AssertEqual '^"echo ''a'' ^&^& echo ''b''^"', fzf#shellescape('echo ''a'' && echo ''b''', 'cmd.exe')

  AssertEqual '^"C:\Program Files ^(x86^)\\^"', fzf#shellescape('C:\Program Files (x86)\', 'cmd.exe')
  AssertEqual '^"C:/Program Files ^(x86^)/^"', fzf#shellescape('C:/Program Files (x86)/', 'cmd.exe')
  AssertEqual '^"%%USERPROFILE%%^"', fzf#shellescape('%USERPROFILE%', 'cmd.exe')

Execute (Cleanup):
  unlet g:dir
  Restore
./test/test_go.rb	[[[1
3440
#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require 'English'
require 'shellwords'
require 'erb'
require 'tempfile'
require 'net/http'

TEMPLATE = DATA.read
UNSETS = %w[
  FZF_DEFAULT_COMMAND FZF_DEFAULT_OPTS
  FZF_TMUX FZF_TMUX_OPTS
  FZF_CTRL_T_COMMAND FZF_CTRL_T_OPTS
  FZF_ALT_C_COMMAND
  FZF_ALT_C_OPTS FZF_CTRL_R_OPTS
  fish_history
].freeze
DEFAULT_TIMEOUT = 10

FILE = File.expand_path(__FILE__)
BASE = File.expand_path('..', __dir__)
Dir.chdir(BASE)
FZF = "FZF_DEFAULT_OPTS=--no-scrollbar FZF_DEFAULT_COMMAND= #{BASE}/bin/fzf"

def wait
  since = Time.now
  begin
    yield or raise Minitest::Assertion, 'Assertion failure'
  rescue Minitest::Assertion
    raise if Time.now - since > DEFAULT_TIMEOUT

    sleep(0.05)
    retry
  end
end

class Shell
  class << self
    def bash
      @bash ||=
        begin
          bashrc = '/tmp/fzf.bash'
          File.open(bashrc, 'w') do |f|
            f.puts ERB.new(TEMPLATE).result(binding)
          end

          "bash --rcfile #{bashrc}"
        end
    end

    def zsh
      @zsh ||=
        begin
          zdotdir = '/tmp/fzf-zsh'
          FileUtils.rm_rf(zdotdir)
          FileUtils.mkdir_p(zdotdir)
          File.open("#{zdotdir}/.zshrc", 'w') do |f|
            f.puts ERB.new(TEMPLATE).result(binding)
          end
          "ZDOTDIR=#{zdotdir} zsh"
        end
    end

    def fish
      UNSETS.map { |v| v + '= ' }.join + ' FZF_DEFAULT_OPTS=--no-scrollbar fish'
    end
  end
end

class Tmux
  attr_reader :win

  def initialize(shell = :bash)
    @win = go(%W[new-window -d -P -F #I #{Shell.send(shell)}]).first
    go(%W[set-window-option -t #{@win} pane-base-index 0])
    return unless shell == :fish

    send_keys 'function fish_prompt; end; clear', :Enter
    self.until(&:empty?)
  end

  def kill
    go(%W[kill-window -t #{win}])
  end

  def focus
    go(%W[select-window -t #{win}])
  end

  def send_keys(*args)
    go(%W[send-keys -t #{win}] + args.map(&:to_s))
  end

  def paste(str)
    system('tmux', 'setb', str, ';', 'pasteb', '-t', win, ';', 'send-keys', '-t', win, 'Enter')
  end

  def capture
    go(%W[capture-pane -p -J -t #{win}]).map(&:rstrip).reverse.drop_while(&:empty?).reverse
  end

  def until(refresh = false)
    lines = nil
    begin
      wait do
        lines = capture
        class << lines
          def counts
            lazy
              .map { |l| l.scan(%r{^. ([0-9]+)/([0-9]+)( \(([0-9]+)\))?}) }
              .reject(&:empty?)
              .first&.first&.map(&:to_i)&.values_at(0, 1, 3) || [0, 0, 0]
          end

          def match_count
            counts[0]
          end

          def item_count
            counts[1]
          end

          def select_count
            counts[2]
          end

          def any_include?(val)
            method = val.is_a?(Regexp) ? :match : :include?
            find { |line| line.send(method, val) }
          end
        end
        yield(lines).tap do |ok|
          send_keys 'C-l' if refresh && !ok
        end
      end
    rescue Minitest::Assertion
      puts $ERROR_INFO.backtrace
      puts '>' * 80
      puts lines
      puts '<' * 80
      raise
    end
    lines
  end

  def prepare
    tries = 0
    begin
      self.until(true) do |lines|
        message = "Prepare[#{tries}]"
        send_keys ' ', 'C-u', :Enter, message, :Left, :Right
        lines[-1] == message
      end
    rescue Minitest::Assertion
      (tries += 1) < 5 ? retry : raise
    end
    send_keys 'C-u', 'C-l'
  end

  private

  def go(args)
    IO.popen(%w[tmux] + args) { |io| io.readlines(chomp: true) }
  end
end

class TestBase < Minitest::Test
  TEMPNAME = '/tmp/output'

  attr_reader :tmux

  def tempname
    @temp_suffix ||= 0
    [TEMPNAME,
     caller_locations.map(&:label).find { |l| l.start_with?('test_') },
     @temp_suffix].join('-')
  end

  def writelines(path, lines)
    FileUtils.rm_f(path) while File.exist?(path)
    File.open(path, 'w') { |f| f.puts lines }
  end

  def readonce
    wait { assert_path_exists tempname }
    File.read(tempname)
  ensure
    FileUtils.rm_f(tempname) while File.exist?(tempname)
    @temp_suffix += 1
    tmux.prepare
  end

  alias assert_equal_org assert_equal
  def assert_equal(expected, actual)
    # Ignore info separator
    actual = actual&.sub(/\s*─+$/, '') if actual.is_a?(String) && actual&.match?(%r{\d+/\d+})
    assert_equal_org(expected, actual)
  end

  def fzf(*opts)
    fzf!(*opts) + " > #{tempname}.tmp; mv #{tempname}.tmp #{tempname}"
  end

  def fzf!(*opts)
    opts = opts.map do |o|
      case o
      when Symbol
        o = o.to_s
        o.length > 1 ? "--#{o.tr('_', '-')}" : "-#{o}"
      when String, Numeric
        o.to_s
      end
    end.compact
    "#{FZF} #{opts.join(' ')}"
  end
end

class TestGoFZF < TestBase
  def setup
    super
    @tmux = Tmux.new
  end

  def teardown
    @tmux.kill
  end

  def test_vanilla
    tmux.send_keys "seq 1 100000 | #{fzf}", :Enter
    tmux.until do |lines|
      assert_equal '>', lines.last
      assert_equal '  100000/100000', lines[-2]
    end
    lines = tmux.capture
    assert_equal '  2',             lines[-4]
    assert_equal '> 1',             lines[-3]
    assert_equal '  100000/100000', lines[-2]
    assert_equal '>',               lines[-1]

    # Testing basic key bindings
    tmux.send_keys '99', 'C-a', '1', 'C-f', '3', 'C-b', 'C-h', 'C-u', 'C-e', 'C-y', 'C-k', 'Tab', 'BTab'
    tmux.until do |lines|
      assert_equal '> 3910', lines[-4]
      assert_equal '  391', lines[-3]
      assert_equal '  856/100000', lines[-2]
      assert_equal '> 391', lines[-1]
    end

    tmux.send_keys :Enter
    assert_equal '3910', readonce.chomp
  end

  def test_fzf_default_command
    tmux.send_keys fzf.sub('FZF_DEFAULT_COMMAND=', "FZF_DEFAULT_COMMAND='echo hello'"), :Enter
    tmux.until { |lines| assert_equal '> hello', lines[-3] }

    tmux.send_keys :Enter
    assert_equal 'hello', readonce.chomp
  end

  def test_fzf_default_command_failure
    tmux.send_keys fzf.sub('FZF_DEFAULT_COMMAND=', 'FZF_DEFAULT_COMMAND=false'), :Enter
    tmux.until { |lines| assert_includes lines[-2], '  [Command failed: false] ─' }
    tmux.send_keys :Enter
  end

  def test_key_bindings
    tmux.send_keys "#{FZF} -q 'foo bar foo-bar'", :Enter
    tmux.until { |lines| assert_equal '> foo bar foo-bar', lines.last }

    # CTRL-A
    tmux.send_keys 'C-A', '('
    tmux.until { |lines| assert_equal '> (foo bar foo-bar', lines.last }

    # META-F
    tmux.send_keys :Escape, :f, ')'
    tmux.until { |lines| assert_equal '> (foo) bar foo-bar', lines.last }

    # CTRL-B
    tmux.send_keys 'C-B', 'var'
    tmux.until { |lines| assert_equal '> (foovar) bar foo-bar', lines.last }

    # Left, CTRL-D
    tmux.send_keys :Left, :Left, 'C-D'
    tmux.until { |lines| assert_equal '> (foovr) bar foo-bar', lines.last }

    # META-BS
    tmux.send_keys :Escape, :BSpace
    tmux.until { |lines| assert_equal '> (r) bar foo-bar', lines.last }

    # CTRL-Y
    tmux.send_keys 'C-Y', 'C-Y'
    tmux.until { |lines| assert_equal '> (foovfoovr) bar foo-bar', lines.last }

    # META-B
    tmux.send_keys :Escape, :b, :Space, :Space
    tmux.until { |lines| assert_equal '> (  foovfoovr) bar foo-bar', lines.last }

    # CTRL-F / Right
    tmux.send_keys 'C-F', :Right, '/'
    tmux.until { |lines| assert_equal '> (  fo/ovfoovr) bar foo-bar', lines.last }

    # CTRL-H / BS
    tmux.send_keys 'C-H', :BSpace
    tmux.until { |lines| assert_equal '> (  fovfoovr) bar foo-bar', lines.last }

    # CTRL-E
    tmux.send_keys 'C-E', 'baz'
    tmux.until { |lines| assert_equal '> (  fovfoovr) bar foo-barbaz', lines.last }

    # CTRL-U
    tmux.send_keys 'C-U'
    tmux.until { |lines| assert_equal '>', lines.last }

    # CTRL-Y
    tmux.send_keys 'C-Y'
    tmux.until { |lines| assert_equal '> (  fovfoovr) bar foo-barbaz', lines.last }

    # CTRL-W
    tmux.send_keys 'C-W', 'bar-foo'
    tmux.until { |lines| assert_equal '> (  fovfoovr) bar bar-foo', lines.last }

    # META-D
    tmux.send_keys :Escape, :b, :Escape, :b, :Escape, :d, 'C-A', 'C-Y'
    tmux.until { |lines| assert_equal '> bar(  fovfoovr) bar -foo', lines.last }

    # CTRL-M
    tmux.send_keys 'C-M'
    tmux.until { |lines| refute_equal '>', lines.last }
  end

  def test_file_word
    tmux.send_keys "#{FZF} -q '--/foo bar/foo-bar/baz' --filepath-word", :Enter
    tmux.until { |lines| assert_equal '> --/foo bar/foo-bar/baz', lines.last }

    tmux.send_keys :Escape, :b
    tmux.send_keys :Escape, :b
    tmux.send_keys :Escape, :b
    tmux.send_keys :Escape, :d
    tmux.send_keys :Escape, :f
    tmux.send_keys :Escape, :BSpace
    tmux.until { |lines| assert_equal '> --///baz', lines.last }
  end

  def test_multi_order
    tmux.send_keys "seq 1 10 | #{fzf(:multi)}", :Enter
    tmux.until { |lines| assert_equal '>', lines.last }

    tmux.send_keys :Tab, :Up, :Up, :Tab, :Tab, :Tab, # 3, 2
                   'C-K', 'C-K', 'C-K', 'C-K', :BTab, :BTab, # 5, 6
                   :PgUp, 'C-J', :Down, :Tab, :Tab # 8, 7
    tmux.until { |lines| assert_equal '  10/10 (6)', lines[-2] }
    tmux.send_keys 'C-M'
    assert_equal %w[3 2 5 6 8 7], readonce.lines(chomp: true)
  end

  def test_multi_max
    tmux.send_keys "seq 1 10 | #{FZF} -m 3 --bind A:select-all,T:toggle-all --preview 'echo [{+}]/{}'", :Enter

    tmux.until { |lines| assert_equal 10, lines.item_count }

    tmux.send_keys '1'
    tmux.until do |lines|
      assert_includes lines[1], ' [1]/1 '
      assert lines[-2]&.start_with?('  2/10 ')
    end

    tmux.send_keys 'A'
    tmux.until do |lines|
      assert_includes lines[1], ' [1 10]/1 '
      assert lines[-2]&.start_with?('  2/10 (2/3)')
    end

    tmux.send_keys :BSpace
    tmux.until { |lines| assert lines[-2]&.start_with?('  10/10 (2/3)') }

    tmux.send_keys 'T'
    tmux.until do |lines|
      assert_includes lines[1], ' [2 3 4]/1 '
      assert lines[-2]&.start_with?('  10/10 (3/3)')
    end

    %w[T A].each do |key|
      tmux.send_keys key
      tmux.until do |lines|
        assert_includes lines[1], ' [1 5 6]/1 '
        assert lines[-2]&.start_with?('  10/10 (3/3)')
      end
    end

    tmux.send_keys :BTab
    tmux.until do |lines|
      assert_includes lines[1], ' [5 6]/2 '
      assert lines[-2]&.start_with?('  10/10 (2/3)')
    end

    [:BTab, :BTab, 'A'].each do |key|
      tmux.send_keys key
      tmux.until do |lines|
        assert_includes lines[1], ' [5 6 2]/3 '
        assert lines[-2]&.start_with?('  10/10 (3/3)')
      end
    end

    tmux.send_keys '2'
    tmux.until { |lines| assert lines[-2]&.start_with?('  1/10 (3/3)') }

    tmux.send_keys 'T'
    tmux.until do |lines|
      assert_includes lines[1], ' [5 6]/2 '
      assert lines[-2]&.start_with?('  1/10 (2/3)')
    end

    tmux.send_keys :BSpace
    tmux.until { |lines| assert lines[-2]&.start_with?('  10/10 (2/3)') }

    tmux.send_keys 'A'
    tmux.until do |lines|
      assert_includes lines[1], ' [5 6 1]/1 '
      assert lines[-2]&.start_with?('  10/10 (3/3)')
    end
  end

  def test_with_nth
    [true, false].each do |multi|
      tmux.send_keys "(echo '  1st 2nd 3rd/';
                       echo '  first second third/') |
                       #{fzf(multi && :multi, :x, :nth, 2, :with_nth, '2,-1,1')}",
                     :Enter
      tmux.until { |lines| assert_equal multi ? '  2/2 (0)' : '  2/2', lines[-2] }

      # Transformed list
      lines = tmux.capture
      assert_equal '  second third/first', lines[-4]
      assert_equal '> 2nd 3rd/1st',        lines[-3]

      # However, the output must not be transformed
      if multi
        tmux.send_keys :BTab, :BTab
        tmux.until { |lines| assert_equal '  2/2 (2)', lines[-2] }
        tmux.send_keys :Enter
        assert_equal ['  1st 2nd 3rd/', '  first second third/'], readonce.lines(chomp: true)
      else
        tmux.send_keys '^', '3'
        tmux.until { |lines| assert_equal '  1/2', lines[-2] }
        tmux.send_keys :Enter
        assert_equal ['  1st 2nd 3rd/'], readonce.lines(chomp: true)
      end
    end
  end

  def test_scroll
    [true, false].each do |rev|
      tmux.send_keys "seq 1 100 | #{fzf(rev && :reverse)}", :Enter
      tmux.until { |lines| assert_equal '  100/100', lines[rev ? 1 : -2] }
      tmux.send_keys(*Array.new(110) { rev ? :Down : :Up })
      tmux.until { |lines| assert_includes lines, '> 100' }
      tmux.send_keys :Enter
      assert_equal '100', readonce.chomp
    end
  end

  def test_select_1
    tmux.send_keys "seq 1 100 | #{fzf(:with_nth, '..,..', :print_query, :q, 5555, :'1')}", :Enter
    assert_equal %w[5555 55], readonce.lines(chomp: true)
  end

  def test_exit_0
    tmux.send_keys "seq 1 100 | #{fzf(:with_nth, '..,..', :print_query, :q, 555_555, :'0')}", :Enter
    assert_equal %w[555555], readonce.lines(chomp: true)
  end

  def test_select_1_exit_0_fail
    [:'0', :'1', %i[1 0]].each do |opt|
      tmux.send_keys "seq 1 100 | #{fzf(:print_query, :multi, :q, 5, *opt)}", :Enter
      tmux.until { |lines| assert_equal '> 5', lines.last }
      tmux.send_keys :BTab, :BTab, :BTab
      tmux.until { |lines| assert_equal '  19/100 (3)', lines[-2] }
      tmux.send_keys :Enter
      assert_equal %w[5 5 50 51], readonce.lines(chomp: true)
    end
  end

  def test_query_unicode
    tmux.paste "(echo abc; echo $'\\352\\260\\200\\353\\202\\230\\353\\213\\244') | #{fzf(:query, "$'\\352\\260\\200\\353\\213\\244'")}"
    tmux.until { |lines| assert_equal '  1/2', lines[-2] }
    tmux.send_keys :Enter
    assert_equal %w[가나다], readonce.lines(chomp: true)
  end

  def test_sync
    tmux.send_keys "seq 1 100 | #{fzf!(:multi)} | awk '{print $1 $1}' | #{fzf(:sync)}", :Enter
    tmux.until { |lines| assert_equal '>', lines[-1] }
    tmux.send_keys 9
    tmux.until { |lines| assert_equal '  19/100 (0)', lines[-2] }
    tmux.send_keys :BTab, :BTab, :BTab
    tmux.until { |lines| assert_equal '  19/100 (3)', lines[-2] }
    tmux.send_keys :Enter
    tmux.until { |lines| assert_equal '>', lines[-1] }
    tmux.send_keys 'C-K', :Enter
    assert_equal %w[9090], readonce.lines(chomp: true)
  end

  def test_tac
    tmux.send_keys "seq 1 1000 | #{fzf(:tac, :multi)}", :Enter
    tmux.until { |lines| assert_equal '  1000/1000 (0)', lines[-2] }
    tmux.send_keys :BTab, :BTab, :BTab
    tmux.until { |lines| assert_equal '  1000/1000 (3)', lines[-2] }
    tmux.send_keys :Enter
    assert_equal %w[1000 999 998], readonce.lines(chomp: true)
  end

  def test_tac_sort
    tmux.send_keys "seq 1 1000 | #{fzf(:tac, :multi)}", :Enter
    tmux.until { |lines| assert_equal '  1000/1000 (0)', lines[-2] }
    tmux.send_keys '99'
    tmux.until { |lines| assert_equal '  28/1000 (0)', lines[-2] }
    tmux.send_keys :BTab, :BTab, :BTab
    tmux.until { |lines| assert_equal '  28/1000 (3)', lines[-2] }
    tmux.send_keys :Enter
    assert_equal %w[99 999 998], readonce.lines(chomp: true)
  end

  def test_tac_nosort
    tmux.send_keys "seq 1 1000 | #{fzf(:tac, :no_sort, :multi)}", :Enter
    tmux.until { |lines| assert_equal '  1000/1000 (0)', lines[-2] }
    tmux.send_keys '00'
    tmux.until { |lines| assert_equal '  10/1000 (0)', lines[-2] }
    tmux.send_keys :BTab, :BTab, :BTab
    tmux.until { |lines| assert_equal '  10/1000 (3)', lines[-2] }
    tmux.send_keys :Enter
    assert_equal %w[1000 900 800], readonce.lines(chomp: true)
  end

  def test_expect
    test = lambda do |key, feed, expected = key|
      tmux.send_keys "seq 1 100 | #{fzf(:expect, key)}", :Enter
      tmux.until { |lines| assert_equal '  100/100', lines[-2] }
      tmux.send_keys '55'
      tmux.until { |lines| assert_equal '  1/100', lines[-2] }
      tmux.send_keys(*feed)
      tmux.prepare
      assert_equal [expected, '55'], readonce.lines(chomp: true)
    end
    test.call('ctrl-t', 'C-T')
    test.call('ctrl-t', 'Enter', '')
    test.call('alt-c', %i[Escape c])
    test.call('f1', 'f1')
    test.call('f2', 'f2')
    test.call('f3', 'f3')
    test.call('f2,f4', 'f2', 'f2')
    test.call('f2,f4', 'f4', 'f4')
    test.call('alt-/', %i[Escape /])
    %w[f5 f6 f7 f8 f9 f10].each do |key|
      test.call('f5,f6,f7,f8,f9,f10', key, key)
    end
    test.call('@', '@')
  end

  def test_expect_print_query
    tmux.send_keys "seq 1 100 | #{fzf('--expect=alt-z', :print_query)}", :Enter
    tmux.until { |lines| assert_equal '  100/100', lines[-2] }
    tmux.send_keys '55'
    tmux.until { |lines| assert_equal '  1/100', lines[-2] }
    tmux.send_keys :Escape, :z
    assert_equal %w[55 alt-z 55], readonce.lines(chomp: true)
  end

  def test_expect_printable_character_print_query
    tmux.send_keys "seq 1 100 | #{fzf('--expect=z --print-query')}", :Enter
    tmux.until { |lines| assert_equal '  100/100', lines[-2] }
    tmux.send_keys '55'
    tmux.until { |lines| assert_equal '  1/100', lines[-2] }
    tmux.send_keys 'z'
    assert_equal %w[55 z 55], readonce.lines(chomp: true)
  end

  def test_expect_print_query_select_1
    tmux.send_keys "seq 1 100 | #{fzf('-q55 -1 --expect=alt-z --print-query')}", :Enter
    assert_equal ['55', '', '55'], readonce.lines(chomp: true)
  end

  def test_toggle_sort
    ['--toggle-sort=ctrl-r', '--bind=ctrl-r:toggle-sort'].each do |opt|
      tmux.send_keys "seq 1 111 | #{fzf("-m +s --tac #{opt} -q11")}", :Enter
      tmux.until { |lines| assert_equal '> 111', lines[-3] }
      tmux.send_keys :Tab
      tmux.until { |lines| assert_equal '  4/111 -S (1)', lines[-2] }
      tmux.send_keys 'C-R'
      tmux.until { |lines| assert_equal '> 11', lines[-3] }
      tmux.send_keys :Tab
      tmux.until { |lines| assert_equal '  4/111 +S (2)', lines[-2] }
      tmux.send_keys :Enter
      assert_equal %w[111 11], readonce.lines(chomp: true)
    end
  end

  def test_unicode_case
    writelines(tempname, %w[строКА1 СТРОКА2 строка3 Строка4])
    assert_equal %w[СТРОКА2 Строка4], `#{FZF} -fС < #{tempname}`.lines(chomp: true)
    assert_equal %w[строКА1 СТРОКА2 строка3 Строка4], `#{FZF} -fс < #{tempname}`.lines(chomp: true)
  end

  def test_tiebreak
    input = %w[
      --foobar--------
      -----foobar---
      ----foobar--
      -------foobar-
    ]
    writelines(tempname, input)

    assert_equal input, `#{FZF} -ffoobar --tiebreak=index < #{tempname}`.lines(chomp: true)

    by_length = %w[
      ----foobar--
      -----foobar---
      -------foobar-
      --foobar--------
    ]
    assert_equal by_length, `#{FZF} -ffoobar < #{tempname}`.lines(chomp: true)
    assert_equal by_length, `#{FZF} -ffoobar --tiebreak=length < #{tempname}`.lines(chomp: true)

    by_begin = %w[
      --foobar--------
      ----foobar--
      -----foobar---
      -------foobar-
    ]
    assert_equal by_begin, `#{FZF} -ffoobar --tiebreak=begin < #{tempname}`.lines(chomp: true)
    assert_equal by_begin, `#{FZF} -f"!z foobar" -x --tiebreak begin < #{tempname}`.lines(chomp: true)

    assert_equal %w[
      -------foobar-
      ----foobar--
      -----foobar---
      --foobar--------
    ], `#{FZF} -ffoobar --tiebreak end < #{tempname}`.lines(chomp: true)

    assert_equal input, `#{FZF} -f"!z" -x --tiebreak end < #{tempname}`.lines(chomp: true)
  end

  def test_tiebreak_index_begin
    writelines(tempname, [
                 'xoxxxxxoxx',
                 'xoxxxxxox',
                 'xxoxxxoxx',
                 'xxxoxoxxx',
                 'xxxxoxox',
                 '  xxoxoxxx'
               ])

    assert_equal [
      'xxxxoxox',
      '  xxoxoxxx',
      'xxxoxoxxx',
      'xxoxxxoxx',
      'xoxxxxxox',
      'xoxxxxxoxx'
    ], `#{FZF} -foo < #{tempname}`.lines(chomp: true)

    assert_equal [
      'xxxoxoxxx',
      'xxxxoxox',
      '  xxoxoxxx',
      'xxoxxxoxx',
      'xoxxxxxoxx',
      'xoxxxxxox'
    ], `#{FZF} -foo --tiebreak=index < #{tempname}`.lines(chomp: true)

    # Note that --tiebreak=begin is now based on the first occurrence of the
    # first character on the pattern
    assert_equal [
      '  xxoxoxxx',
      'xxxoxoxxx',
      'xxxxoxox',
      'xxoxxxoxx',
      'xoxxxxxoxx',
      'xoxxxxxox'
    ], `#{FZF} -foo --tiebreak=begin < #{tempname}`.lines(chomp: true)

    assert_equal [
      '  xxoxoxxx',
      'xxxoxoxxx',
      'xxxxoxox',
      'xxoxxxoxx',
      'xoxxxxxox',
      'xoxxxxxoxx'
    ], `#{FZF} -foo --tiebreak=begin,length < #{tempname}`.lines(chomp: true)
  end

  def test_tiebreak_begin_algo_v2
    writelines(tempname, [
                 'baz foo bar',
                 'foo bar baz'
               ])
    assert_equal [
      'foo bar baz',
      'baz foo bar'
    ], `#{FZF} -fbar --tiebreak=begin --algo=v2 < #{tempname}`.lines(chomp: true)
  end

  def test_tiebreak_end
    writelines(tempname, [
                 'xoxxxxxxxx',
                 'xxoxxxxxxx',
                 'xxxoxxxxxx',
                 'xxxxoxxxx',
                 'xxxxxoxxx',
                 '  xxxxoxxx'
               ])

    assert_equal [
      '  xxxxoxxx',
      'xxxxoxxxx',
      'xxxxxoxxx',
      'xoxxxxxxxx',
      'xxoxxxxxxx',
      'xxxoxxxxxx'
    ], `#{FZF} -fo < #{tempname}`.lines(chomp: true)

    assert_equal [
      'xxxxxoxxx',
      '  xxxxoxxx',
      'xxxxoxxxx',
      'xxxoxxxxxx',
      'xxoxxxxxxx',
      'xoxxxxxxxx'
    ], `#{FZF} -fo --tiebreak=end < #{tempname}`.lines(chomp: true)

    assert_equal [
      'xxxxxoxxx',
      '  xxxxoxxx',
      'xxxxoxxxx',
      'xxxoxxxxxx',
      'xxoxxxxxxx',
      'xoxxxxxxxx'
    ], `#{FZF} -fo --tiebreak=end,length,begin < #{tempname}`.lines(chomp: true)
  end

  def test_tiebreak_length_with_nth
    input = %w[
      1:hell
      123:hello
      12345:he
      1234567:h
    ]
    writelines(tempname, input)

    output = %w[
      1:hell
      12345:he
      123:hello
      1234567:h
    ]
    assert_equal output, `#{FZF} -fh < #{tempname}`.lines(chomp: true)

    # Since 0.16.8, --nth doesn't affect --tiebreak
    assert_equal output, `#{FZF} -fh -n2 -d: < #{tempname}`.lines(chomp: true)
  end

  def test_tiebreak_chunk
    writelines(tempname, [
                 '1 foobarbaz ba',
                 '2 foobar baz',
                 '3 foo barbaz'
               ])

    assert_equal [
      '3 foo barbaz',
      '2 foobar baz',
      '1 foobarbaz ba'
    ], `#{FZF} -fo --tiebreak=chunk < #{tempname}`.lines(chomp: true)

    assert_equal [
      '1 foobarbaz ba',
      '2 foobar baz',
      '3 foo barbaz'
    ], `#{FZF} -fba --tiebreak=chunk < #{tempname}`.lines(chomp: true)

    assert_equal [
      '3 foo barbaz'
    ], `#{FZF} -f'!foobar' --tiebreak=chunk < #{tempname}`.lines(chomp: true)
  end

  def test_invalid_cache
    tmux.send_keys "(echo d; echo D; echo x) | #{fzf('-q d')}", :Enter
    tmux.until { |lines| assert_equal '  2/3', lines[-2] }
    tmux.send_keys :BSpace
    tmux.until { |lines| assert_equal '  3/3', lines[-2] }
    tmux.send_keys :D
    tmux.until { |lines| assert_equal '  1/3', lines[-2] }
    tmux.send_keys :Enter
  end

  def test_invalid_cache_query_type
    command = %[(echo 'foo$bar'; echo 'barfoo'; echo 'foo^bar'; echo "foo'1-2"; seq 100) | #{fzf}]

    # Suffix match
    tmux.send_keys command, :Enter
    tmux.until { |lines| assert_equal 104, lines.match_count }
    tmux.send_keys 'foo$'
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys 'bar'
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys :Enter

    # Prefix match
    tmux.prepare
    tmux.send_keys command, :Enter
    tmux.until { |lines| assert_equal 104, lines.match_count }
    tmux.send_keys '^bar'
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys 'C-a', 'foo'
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys :Enter

    # Exact match
    tmux.prepare
    tmux.send_keys command, :Enter
    tmux.until { |lines| assert_equal 104, lines.match_count }
    tmux.send_keys "'12"
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys 'C-a', 'foo'
    tmux.until { |lines| assert_equal 1, lines.match_count }
  end

  def test_smart_case_for_each_term
    assert_equal 1, `echo Foo bar | #{FZF} -x -f "foo Fbar" | wc -l`.to_i
  end

  def test_bind
    tmux.send_keys "seq 1 1000 | #{fzf('-m --bind=ctrl-j:accept,u:up,T:toggle-up,t:toggle')}", :Enter
    tmux.until { |lines| assert_equal '  1000/1000 (0)', lines[-2] }
    tmux.send_keys 'uuu', 'TTT', 'tt', 'uu', 'ttt', 'C-j'
    assert_equal %w[4 5 6 9], readonce.lines(chomp: true)
  end

  def test_bind_print_query
    tmux.send_keys "seq 1 1000 | #{fzf('-m --bind=ctrl-j:print-query')}", :Enter
    tmux.until { |lines| assert_equal '  1000/1000 (0)', lines[-2] }
    tmux.send_keys 'print-my-query', 'C-j'
    assert_equal %w[print-my-query], readonce.lines(chomp: true)
  end

  def test_bind_replace_query
    tmux.send_keys "seq 1 1000 | #{fzf('--print-query --bind=ctrl-j:replace-query')}", :Enter
    tmux.send_keys '1'
    tmux.until { |lines| assert_equal '  272/1000', lines[-2] }
    tmux.send_keys 'C-k', 'C-j'
    tmux.until { |lines| assert_equal '  29/1000', lines[-2] }
    tmux.until { |lines| assert_equal '> 10', lines[-1] }
  end

  def test_long_line
    data = '.' * 256 * 1024
    File.open(tempname, 'w') do |f|
      f << data
    end
    assert_equal data, `#{FZF} -f . < #{tempname}`.chomp
  end

  def test_read0
    lines = `find .`.lines(chomp: true)
    assert_equal lines.last, `find . | #{FZF} -e -f "^#{lines.last}$"`.chomp
    assert_equal \
      lines.last,
      `find . -print0 | #{FZF} --read0 -e -f "^#{lines.last}$"`.chomp
  end

  def test_select_all_deselect_all_toggle_all
    tmux.send_keys "seq 100 | #{fzf('--bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all --multi')}", :Enter
    tmux.until { |lines| assert_equal '  100/100 (0)', lines[-2] }
    tmux.send_keys :BTab, :BTab, :BTab
    tmux.until { |lines| assert_equal '  100/100 (3)', lines[-2] }
    tmux.send_keys 'C-t'
    tmux.until { |lines| assert_equal '  100/100 (97)', lines[-2] }
    tmux.send_keys 'C-a'
    tmux.until { |lines| assert_equal '  100/100 (100)', lines[-2] }
    tmux.send_keys :Tab, :Tab
    tmux.until { |lines| assert_equal '  100/100 (98)', lines[-2] }
    tmux.send_keys '100'
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys 'C-d'
    tmux.until { |lines| assert_equal '  1/100 (97)', lines[-2] }
    tmux.send_keys 'C-u'
    tmux.until { |lines| assert_equal 100, lines.match_count }
    tmux.send_keys 'C-d'
    tmux.until { |lines| assert_equal '  100/100 (0)', lines[-2] }
    tmux.send_keys :BTab, :BTab
    tmux.until { |lines| assert_equal '  100/100 (2)', lines[-2] }
    tmux.send_keys 0
    tmux.until { |lines| assert_equal '  10/100 (2)', lines[-2] }
    tmux.send_keys 'C-a'
    tmux.until { |lines| assert_equal '  10/100 (12)', lines[-2] }
    tmux.send_keys :Enter
    assert_equal %w[1 2 10 20 30 40 50 60 70 80 90 100],
                 readonce.lines(chomp: true)
  end

  def test_history
    history_file = '/tmp/fzf-test-history'

    # History with limited number of entries
    FileUtils.rm_f(history_file)
    opts = "--history=#{history_file} --history-size=4"
    input = %w[00 11 22 33 44]
    input.each do |keys|
      tmux.prepare
      tmux.send_keys "seq 100 | #{fzf(opts)}", :Enter
      tmux.until { |lines| assert_equal '  100/100', lines[-2] }
      tmux.send_keys keys
      tmux.until { |lines| assert_equal '  1/100', lines[-2] }
      tmux.send_keys :Enter
    end
    wait do
      assert_path_exists history_file
      assert_equal input[1..], File.readlines(history_file, chomp: true)
    end

    # Update history entries (not changed on disk)
    tmux.send_keys "seq 100 | #{fzf(opts)}", :Enter
    tmux.until { |lines| assert_equal '  100/100', lines[-2] }
    tmux.send_keys 'C-p'
    tmux.until { |lines| assert_equal '> 44', lines[-1] }
    tmux.send_keys 'C-p'
    tmux.until { |lines| assert_equal '> 33', lines[-1] }
    tmux.send_keys :BSpace
    tmux.until { |lines| assert_equal '> 3', lines[-1] }
    tmux.send_keys 1
    tmux.until { |lines| assert_equal '> 31', lines[-1] }
    tmux.send_keys 'C-p'
    tmux.until { |lines| assert_equal '> 22', lines[-1] }
    tmux.send_keys 'C-n'
    tmux.until { |lines| assert_equal '> 31', lines[-1] }
    tmux.send_keys 0
    tmux.until { |lines| assert_equal '> 310', lines[-1] }
    tmux.send_keys :Enter
    wait do
      assert_path_exists history_file
      assert_equal %w[22 33 44 310], File.readlines(history_file, chomp: true)
    end

    # Respect --bind option
    tmux.send_keys "seq 100 | #{fzf(opts + ' --bind ctrl-p:next-history,ctrl-n:previous-history')}", :Enter
    tmux.until { |lines| assert_equal '  100/100', lines[-2] }
    tmux.send_keys 'C-n', 'C-n', 'C-n', 'C-n', 'C-p'
    tmux.until { |lines| assert_equal '> 33', lines[-1] }
    tmux.send_keys :Enter
  ensure
    FileUtils.rm_f(history_file)
  end

  def test_execute
    output = '/tmp/fzf-test-execute'
    opts = %[--bind "alt-a:execute(echo /{}/ >> #{output}),alt-b:execute[echo /{}{}/ >> #{output}],C:execute:echo /{}{}{}/ >> #{output}"]
    writelines(tempname, %w[foo'bar foo"bar foo$bar])
    tmux.send_keys "cat #{tempname} | #{fzf(opts)}", :Enter
    tmux.until { |lines| assert_equal '  3/3', lines[-2] }
    tmux.send_keys :Escape, :a
    tmux.send_keys :Escape, :a
    tmux.send_keys :Up
    tmux.send_keys :Escape, :b
    tmux.send_keys :Escape, :b
    tmux.send_keys :Up
    tmux.send_keys :C
    tmux.send_keys 'barfoo'
    tmux.until { |lines| assert_equal '  0/3', lines[-2] }
    tmux.send_keys :Escape, :a
    tmux.send_keys :Escape, :b
    wait do
      assert_path_exists output
      assert_equal %w[
        /foo'bar/ /foo'bar/
        /foo"barfoo"bar/ /foo"barfoo"bar/
        /foo$barfoo$barfoo$bar/
      ], File.readlines(output, chomp: true)
    end
  ensure
    FileUtils.rm_f(output)
  end

  def test_execute_multi
    output = '/tmp/fzf-test-execute-multi'
    opts = %[--multi --bind "alt-a:execute-multi(echo {}/{+} >> #{output})"]
    writelines(tempname, %w[foo'bar foo"bar foo$bar foobar])
    tmux.send_keys "cat #{tempname} | #{fzf(opts)}", :Enter
    tmux.until { |lines| assert_equal '  4/4 (0)', lines[-2] }
    tmux.send_keys :Escape, :a
    tmux.send_keys :BTab, :BTab, :BTab
    tmux.until { |lines| assert_equal '  4/4 (3)', lines[-2] }
    tmux.send_keys :Escape, :a
    tmux.send_keys :Tab, :Tab
    tmux.until { |lines| assert_equal '  4/4 (3)', lines[-2] }
    tmux.send_keys :Escape, :a
    wait do
      assert_path_exists output
      assert_equal [
        %(foo'bar/foo'bar),
        %(foo'bar foo"bar foo$bar/foo'bar foo"bar foo$bar),
        %(foo'bar foo"bar foobar/foo'bar foo"bar foobar)
      ], File.readlines(output, chomp: true)
    end
  ensure
    FileUtils.rm_f(output)
  end

  def test_execute_plus_flag
    output = tempname + '.tmp'
    FileUtils.rm_f(output)
    writelines(tempname, ['foo bar', '123 456'])

    tmux.send_keys "cat #{tempname} | #{FZF} --multi --bind 'x:execute-silent(echo {+}/{}/{+2}/{2} >> #{output})'", :Enter

    tmux.until { |lines| assert_equal '  2/2 (0)', lines[-2] }
    tmux.send_keys 'xy'
    tmux.until { |lines| assert_equal '  0/2 (0)', lines[-2] }
    tmux.send_keys :BSpace
    tmux.until { |lines| assert_equal '  2/2 (0)', lines[-2] }

    tmux.send_keys :Up
    tmux.send_keys :Tab
    tmux.send_keys 'xy'
    tmux.until { |lines| assert_equal '  0/2 (1)', lines[-2] }
    tmux.send_keys :BSpace
    tmux.until { |lines| assert_equal '  2/2 (1)', lines[-2] }

    tmux.send_keys :Tab
    tmux.send_keys 'xy'
    tmux.until { |lines| assert_equal '  0/2 (2)', lines[-2] }
    tmux.send_keys :BSpace
    tmux.until { |lines| assert_equal '  2/2 (2)', lines[-2] }

    wait do
      assert_path_exists output
      assert_equal [
        %(foo bar/foo bar/bar/bar),
        %(123 456/foo bar/456/bar),
        %(123 456 foo bar/foo bar/456 bar/bar)
      ], File.readlines(output, chomp: true)
    end
  rescue StandardError
    FileUtils.rm_f(output)
  end

  def test_execute_shell
    # Custom script to use as $SHELL
    output = tempname + '.out'
    FileUtils.rm_f(output)
    writelines(tempname,
               ['#!/usr/bin/env bash', "echo $1 / $2 > #{output}"])
    system("chmod +x #{tempname}")

    tmux.send_keys "echo foo | SHELL=#{tempname} fzf --bind 'enter:execute:{}bar'", :Enter
    tmux.until { |lines| assert_equal '  1/1', lines[-2] }
    tmux.send_keys :Enter
    tmux.until { |lines| assert_equal '  1/1', lines[-2] }
    wait do
      assert_path_exists output
      assert_equal ["-c / 'foo'bar"], File.readlines(output, chomp: true)
    end
  ensure
    FileUtils.rm_f(output)
  end

  def test_cycle
    tmux.send_keys "seq 8 | #{fzf(:cycle)}", :Enter
    tmux.until { |lines| assert_equal '  8/8', lines[-2] }
    tmux.send_keys :Down
    tmux.until { |lines| assert_equal '> 8', lines[-10] }
    tmux.send_keys :Down
    tmux.until { |lines| assert_equal '> 7', lines[-9] }
    tmux.send_keys :Up
    tmux.until { |lines| assert_equal '> 8', lines[-10] }
    tmux.send_keys :PgUp
    tmux.until { |lines| assert_equal '> 8', lines[-10] }
    tmux.send_keys :Up
    tmux.until { |lines| assert_equal '> 1', lines[-3] }
    tmux.send_keys :PgDn
    tmux.until { |lines| assert_equal '> 1', lines[-3] }
    tmux.send_keys :Down
    tmux.until { |lines| assert_equal '> 8', lines[-10] }
  end

  def test_header_lines
    tmux.send_keys "seq 100 | #{fzf('--header-lines=10 -q 5')}", :Enter
    2.times do
      tmux.until do |lines|
        assert_equal '  18/90', lines[-2]
        assert_equal '  1', lines[-3]
        assert_equal '  2', lines[-4]
        assert_equal '> 50', lines[-13]
      end
      tmux.send_keys :Down
    end
    tmux.send_keys :Enter
    assert_equal '50', readonce.chomp
  end

  def test_header_lines_reverse
    tmux.send_keys "seq 100 | #{fzf('--header-lines=10 -q 5 --reverse')}", :Enter
    2.times do
      tmux.until do |lines|
        assert_equal '  18/90', lines[1]
        assert_equal '  1', lines[2]
        assert_equal '  2', lines[3]
        assert_equal '> 50', lines[12]
      end
      tmux.send_keys :Up
    end
    tmux.send_keys :Enter
    assert_equal '50', readonce.chomp
  end

  def test_header_lines_reverse_list
    tmux.send_keys "seq 100 | #{fzf('--header-lines=10 -q 5 --layout=reverse-list')}", :Enter
    2.times do
      tmux.until do |lines|
        assert_equal '> 50', lines[0]
        assert_equal '  2', lines[-4]
        assert_equal '  1', lines[-3]
        assert_equal '  18/90', lines[-2]
      end
      tmux.send_keys :Up
    end
    tmux.send_keys :Enter
    assert_equal '50', readonce.chomp
  end

  def test_header_lines_overflow
    tmux.send_keys "seq 100 | #{fzf('--header-lines=200')}", :Enter
    tmux.until do |lines|
      assert_equal '  0/0', lines[-2]
      assert_equal '  1', lines[-3]
    end
    tmux.send_keys :Enter
    assert_equal '', readonce.chomp
  end

  def test_header_lines_with_nth
    tmux.send_keys "seq 100 | #{fzf('--header-lines 5 --with-nth 1,1,1,1,1')}", :Enter
    tmux.until do |lines|
      assert_equal '  95/95', lines[-2]
      assert_equal '  11111', lines[-3]
      assert_equal '  55555', lines[-7]
      assert_equal '> 66666', lines[-8]
    end
    tmux.send_keys :Enter
    assert_equal '6', readonce.chomp
  end

  def test_header
    tmux.send_keys "seq 100 | #{fzf("--header \"$(head -5 #{FILE})\"")}", :Enter
    header = File.readlines(FILE, chomp: true).take(5)
    tmux.until do |lines|
      assert_equal '  100/100', lines[-2]
      assert_equal header.map { |line| "  #{line}".rstrip }, lines[-7..-3]
      assert_equal '> 1', lines[-8]
    end
  end

  def test_header_reverse
    tmux.send_keys "seq 100 | #{fzf("--header \"$(head -5 #{FILE})\" --reverse")}", :Enter
    header = File.readlines(FILE, chomp: true).take(5)
    tmux.until do |lines|
      assert_equal '  100/100', lines[1]
      assert_equal header.map { |line| "  #{line}".rstrip }, lines[2..6]
      assert_equal '> 1', lines[7]
    end
  end

  def test_header_reverse_list
    tmux.send_keys "seq 100 | #{fzf("--header \"$(head -5 #{FILE})\" --layout=reverse-list")}", :Enter
    header = File.readlines(FILE, chomp: true).take(5)
    tmux.until do |lines|
      assert_equal '  100/100', lines[-2]
      assert_equal header.map { |line| "  #{line}".rstrip }, lines[-7..-3]
      assert_equal '> 1', lines[0]
    end
  end

  def test_header_and_header_lines
    tmux.send_keys "seq 100 | #{fzf("--header-lines 10 --header \"$(head -5 #{FILE})\"")}", :Enter
    header = File.readlines(FILE, chomp: true).take(5)
    tmux.until do |lines|
      assert_equal '  90/90', lines[-2]
      assert_equal header.map { |line| "  #{line}".rstrip }, lines[-7...-2]
      assert_equal ('  1'..'  10').to_a.reverse, lines[-17...-7]
    end
  end

  def test_header_and_header_lines_reverse
    tmux.send_keys "seq 100 | #{fzf("--reverse --header-lines 10 --header \"$(head -5 #{FILE})\"")}", :Enter
    header = File.readlines(FILE, chomp: true).take(5)
    tmux.until do |lines|
      assert_equal '  90/90', lines[1]
      assert_equal header.map { |line| "  #{line}".rstrip }, lines[2...7]
      assert_equal ('  1'..'  10').to_a, lines[7...17]
    end
  end

  def test_header_and_header_lines_reverse_list
    tmux.send_keys "seq 100 | #{fzf("--layout=reverse-list --header-lines 10 --header \"$(head -5 #{FILE})\"")}", :Enter
    header = File.readlines(FILE, chomp: true).take(5)
    tmux.until do |lines|
      assert_equal '  90/90', lines[-2]
      assert_equal header.map { |line| "  #{line}".rstrip }, lines[-7...-2]
      assert_equal ('  1'..'  10').to_a.reverse, lines[-17...-7]
    end
  end

  def test_cancel
    tmux.send_keys "seq 10 | #{fzf('--bind 2:cancel')}", :Enter
    tmux.until { |lines| assert_equal '  10/10', lines[-2] }
    tmux.send_keys '123'
    tmux.until do |lines|
      assert_equal '> 3', lines[-1]
      assert_equal '  1/10', lines[-2]
    end
    tmux.send_keys 'C-y', 'C-y'
    tmux.until { |lines| assert_equal '> 311', lines[-1] }
    tmux.send_keys 2
    tmux.until { |lines| assert_equal '>', lines[-1] }
    tmux.send_keys 2
    tmux.prepare
  end

  def test_margin
    tmux.send_keys "yes | head -1000 | #{fzf('--margin 5,3')}", :Enter
    tmux.until do |lines|
      assert_equal '', lines[4]
      assert_equal '     y', lines[5]
    end
    tmux.send_keys :Enter
  end

  def test_margin_reverse
    tmux.send_keys "seq 1000 | #{fzf('--margin 7,5 --reverse')}", :Enter
    tmux.until { |lines| assert_equal '       1000/1000', lines[1 + 7] }
    tmux.send_keys :Enter
  end

  def test_margin_reverse_list
    tmux.send_keys "yes | head -1000 | #{fzf('--margin 5,3 --layout=reverse-list')}", :Enter
    tmux.until do |lines|
      assert_equal '', lines[4]
      assert_equal '   > y', lines[5]
    end
    tmux.send_keys :Enter
  end

  def test_tabstop
    writelines(tempname, %W[f\too\tba\tr\tbaz\tbarfooq\tux])
    {
      1 => '> f oo ba r baz barfooq ux',
      2 => '> f oo  ba  r baz barfooq ux',
      3 => '> f  oo ba r  baz   barfooq  ux',
      4 => '> f   oo  ba  r   baz barfooq ux',
      5 => '> f    oo   ba   r    baz  barfooq   ux',
      6 => '> f     oo    ba    r     baz   barfooq     ux',
      7 => '> f      oo     ba     r      baz    barfooq       ux',
      8 => '> f       oo      ba      r       baz     barfooq ux',
      9 => '> f        oo       ba       r        baz      barfooq  ux'
    }.each do |ts, exp|
      tmux.prepare
      tmux.send_keys %(cat #{tempname} | fzf --tabstop=#{ts}), :Enter
      tmux.until(true) do |lines|
        assert_equal exp, lines[-3]
      end
      tmux.send_keys :Enter
    end
  end

  def test_with_nth_basic
    writelines(tempname, ['hello world ', 'byebye'])
    assert_equal \
      'hello world ',
      `#{FZF} -f"^he hehe" -x -n 2.. --with-nth 2,1,1 < #{tempname}`.chomp
  end

  def test_with_nth_ansi
    writelines(tempname, ["\x1b[33mhello \x1b[34;1mworld\x1b[m ", 'byebye'])
    assert_equal \
      'hello world ',
      `#{FZF} -f"^he hehe" -x -n 2.. --with-nth 2,1,1 --ansi < #{tempname}`.chomp
  end

  def test_with_nth_no_ansi
    src = "\x1b[33mhello \x1b[34;1mworld\x1b[m "
    writelines(tempname, [src, 'byebye'])
    assert_equal \
      src,
      `#{FZF} -fhehe -x -n 2.. --with-nth 2,1,1 --no-ansi < #{tempname}`.chomp
  end

  def test_exit_0_exit_code
    `echo foo | #{FZF} -q bar -0`
    assert_equal 1, $CHILD_STATUS.exitstatus
  end

  def test_invalid_option
    lines = `#{FZF} --foobar 2>&1`
    assert_equal 2, $CHILD_STATUS.exitstatus
    assert_includes lines, 'unknown option: --foobar'
  end

  def test_filter_exitstatus
    # filter / streaming filter
    ['', '--no-sort'].each do |opts|
      assert_includes `echo foo | #{FZF} -f foo #{opts}`, 'foo'
      assert_equal 0, $CHILD_STATUS.exitstatus

      assert_empty `echo foo | #{FZF} -f bar #{opts}`
      assert_equal 1, $CHILD_STATUS.exitstatus
    end
  end

  def test_exitstatus_empty
    { '99' => '0', '999' => '1' }.each do |query, status|
      tmux.send_keys "seq 100 | #{FZF} -q #{query}; echo --$?--", :Enter
      tmux.until { |lines| assert_match %r{ [10]/100}, lines[-2] }
      tmux.send_keys :Enter
      tmux.until { |lines| assert_equal "--#{status}--", lines.last }
    end
  end

  def test_default_extended
    assert_equal '100', `seq 100 | #{FZF} -f "1 00$"`.chomp
    assert_equal '', `seq 100 | #{FZF} -f "1 00$" +x`.chomp
  end

  def test_exact
    assert_equal 4, `seq 123 | #{FZF} -f 13`.lines.length
    assert_equal 2, `seq 123 | #{FZF} -f 13 -e`.lines.length
    assert_equal 4, `seq 123 | #{FZF} -f 13 +e`.lines.length
  end

  def test_or_operator
    assert_equal %w[1 5 10], `seq 10 | #{FZF} -f "1 | 5"`.lines(chomp: true)
    assert_equal %w[1 10 2 3 4 5 6 7 8 9],
                 `seq 10 | #{FZF} -f '1 | !1'`.lines(chomp: true)
  end

  def test_hscroll_off
    writelines(tempname, ['=' * 10_000 + '0123456789'])
    [0, 3, 6].each do |off|
      tmux.prepare
      tmux.send_keys "#{FZF} --hscroll-off=#{off} -q 0 < #{tempname}", :Enter
      tmux.until { |lines| assert lines[-3]&.end_with?((0..off).to_a.join + '..') }
      tmux.send_keys '9'
      tmux.until { |lines| assert lines[-3]&.end_with?('789') }
      tmux.send_keys :Enter
    end
  end

  def test_partial_caching
    tmux.send_keys 'seq 1000 | fzf -e', :Enter
    tmux.until { |lines| assert_equal '  1000/1000', lines[-2] }
    tmux.send_keys 11
    tmux.until { |lines| assert_equal '  19/1000', lines[-2] }
    tmux.send_keys 'C-a', "'"
    tmux.until { |lines| assert_equal '  28/1000', lines[-2] }
    tmux.send_keys :Enter
  end

  def test_jump
    tmux.send_keys "seq 1000 | #{fzf("--multi --jump-labels 12345 --bind 'ctrl-j:jump'")}", :Enter
    tmux.until { |lines| assert_equal '  1000/1000 (0)', lines[-2] }
    tmux.send_keys 'C-j'
    tmux.until { |lines| assert_equal '5 5', lines[-7] }
    tmux.until { |lines| assert_equal '  6', lines[-8] }
    tmux.send_keys '5'
    tmux.until { |lines| assert_equal '> 5', lines[-7] }
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal ' >5', lines[-7] }
    tmux.send_keys 'C-j'
    tmux.until { |lines| assert_equal '5>5', lines[-7] }
    tmux.send_keys '2'
    tmux.until { |lines| assert_equal '> 2', lines[-4] }
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal ' >2', lines[-4] }
    tmux.send_keys 'C-j'
    tmux.until { |lines| assert_equal '5>5', lines[-7] }

    # Press any key other than jump labels to cancel jump
    tmux.send_keys '6'
    tmux.until { |lines| assert_equal '> 1', lines[-3] }
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal '>>1', lines[-3] }
    tmux.send_keys :Enter
    assert_equal %w[5 2 1], readonce.lines(chomp: true)
  end

  def test_jump_accept
    tmux.send_keys "seq 1000 | #{fzf("--multi --jump-labels 12345 --bind 'ctrl-j:jump-accept'")}", :Enter
    tmux.until { |lines| assert_equal '  1000/1000 (0)', lines[-2] }
    tmux.send_keys 'C-j'
    tmux.until { |lines| assert_equal '5 5', lines[-7] }
    tmux.send_keys '3'
    assert_equal '3', readonce.chomp
  end

  def test_pointer
    tmux.send_keys "seq 10 | #{fzf("--pointer '>>'")}", :Enter
    # Assert that specified pointer is displayed
    tmux.until { |lines| assert_equal '>> 1', lines[-3] }
  end

  def test_pointer_with_jump
    tmux.send_keys "seq 10 | #{fzf("--multi --jump-labels 12345 --bind 'ctrl-j:jump' --pointer '>>'")}", :Enter
    tmux.until { |lines| assert_equal '  10/10 (0)', lines[-2] }
    tmux.send_keys 'C-j'
    # Correctly padded jump label should appear
    tmux.until { |lines| assert_equal '5  5', lines[-7] }
    tmux.until { |lines| assert_equal '   6', lines[-8] }
    tmux.send_keys '5'
    # Assert that specified pointer is displayed
    tmux.until { |lines| assert_equal '>> 5', lines[-7] }
  end

  def test_marker
    tmux.send_keys "seq 10 | #{fzf("--multi --marker '>>'")}", :Enter
    tmux.until { |lines| assert_equal '  10/10 (0)', lines[-2] }
    tmux.send_keys :BTab
    # Assert that specified marker is displayed
    tmux.until { |lines| assert_equal ' >>1', lines[-3] }
  end

  def test_preview
    tmux.send_keys %(seq 1000 | sed s/^2$// | #{FZF} -m --preview 'sleep 0.2; echo {{}-{+}}' --bind ?:toggle-preview), :Enter
    tmux.until { |lines| assert_includes lines[1], ' {1-1} ' }
    tmux.send_keys :Up
    tmux.until { |lines| assert_includes lines[1], ' {-} ' }
    tmux.send_keys '555'
    tmux.until { |lines| assert_includes lines[1], ' {555-555} ' }
    tmux.send_keys '?'
    tmux.until { |lines| refute_includes lines[1], ' {555-555} ' }
    tmux.send_keys '?'
    tmux.until { |lines| assert_includes lines[1], ' {555-555} ' }
    tmux.send_keys :BSpace
    tmux.until { |lines| assert lines[-2]&.start_with?('  28/1000 ') }
    tmux.send_keys 'foobar'
    tmux.until { |lines| refute_includes lines[1], ' {55-55} ' }
    tmux.send_keys 'C-u'
    tmux.until { |lines| assert_equal 1000, lines.match_count }
    tmux.until { |lines| assert_includes lines[1], ' {1-1} ' }
    tmux.send_keys :BTab
    tmux.until { |lines| assert_includes lines[1], ' {-1} ' }
    tmux.send_keys :BTab
    tmux.until { |lines| assert_includes lines[1], ' {3-1 } ' }
    tmux.send_keys :BTab
    tmux.until { |lines| assert_includes lines[1], ' {4-1  3} ' }
    tmux.send_keys :BTab
    tmux.until { |lines| assert_includes lines[1], ' {5-1  3 4} ' }
  end

  def test_toggle_preview_without_default_preview_command
    tmux.send_keys %(seq 100 | #{FZF} --bind 'space:preview(echo [{}]),enter:toggle-preview' --preview-window up,border-double), :Enter
    tmux.until do |lines|
      assert_equal 100, lines.match_count
      refute_includes lines[1], '║ [1]'
    end

    # toggle-preview should do nothing
    tmux.send_keys :Enter
    tmux.until { |lines| refute_includes lines[1], '║ [1]' }
    tmux.send_keys :Up
    tmux.until do |lines|
      refute_includes lines[1], '║ [1]'
      refute_includes lines[1], '║ [2]'
    end

    tmux.send_keys :Up
    tmux.until do |lines|
      assert_includes lines, '> 3'
      refute_includes lines[1], '║ [3]'
    end

    # One-off preview action
    tmux.send_keys :Space
    tmux.until { |lines| assert_includes lines[1], '║ [3]' }

    # toggle-preview to hide it
    tmux.send_keys :Enter
    tmux.until { |lines| refute_includes lines[1], '║ [3]' }

    # toggle-preview again does nothing
    tmux.send_keys :Enter, :Up
    tmux.until do |lines|
      assert_includes lines, '> 4'
      refute_includes lines[1], '║ [4]'
    end
  end

  def test_show_and_hide_preview
    tmux.send_keys %(seq 100 | #{FZF} --preview-window hidden,border-bold --preview 'echo [{}]' --bind 'a:show-preview,b:hide-preview'), :Enter

    # Hidden by default
    tmux.until do |lines|
      assert_equal 100, lines.match_count
      refute_includes lines[1], '┃ [1]'
    end

    # Show
    tmux.send_keys :a
    tmux.until { |lines| assert_includes lines[1], '┃ [1]' }

    # Already shown
    tmux.send_keys :a
    tmux.send_keys :Up
    tmux.until { |lines| assert_includes lines[1], '┃ [2]' }

    # Hide
    tmux.send_keys :b
    tmux.send_keys :Up
    tmux.until do |lines|
      assert_includes lines, '> 3'
      refute_includes lines[1], '┃ [3]'
    end

    # Already hidden
    tmux.send_keys :b
    tmux.send_keys :Up
    tmux.until do |lines|
      assert_includes lines, '> 4'
      refute_includes lines[1], '┃ [4]'
    end

    # Show it again
    tmux.send_keys :a
    tmux.until { |lines| assert_includes lines[1], '┃ [4]' }
  end

  def test_preview_hidden
    tmux.send_keys %(seq 1000 | #{FZF} --preview 'echo {{}-{}-$FZF_PREVIEW_LINES-$FZF_PREVIEW_COLUMNS}' --preview-window down:1:hidden --bind ?:toggle-preview), :Enter
    tmux.until { |lines| assert_equal '>', lines[-1] }
    tmux.send_keys '?'
    tmux.until { |lines| assert_match(/ {1-1-1-[0-9]+}/, lines[-2]) }
    tmux.send_keys '555'
    tmux.until { |lines| assert_match(/ {555-555-1-[0-9]+}/, lines[-2]) }
    tmux.send_keys '?'
    tmux.until { |lines| assert_equal '> 555', lines[-1] }
  end

  def test_preview_size_0
    FileUtils.rm_f(tempname)
    tmux.send_keys %(seq 100 | #{FZF} --reverse --preview 'echo {} >> #{tempname}; echo ' --preview-window 0 --bind space:toggle-preview), :Enter
    tmux.until do |lines|
      assert_equal 100, lines.item_count
      assert_equal '  100/100', lines[1]
      assert_equal '> 1', lines[2]
    end
    wait do
      assert_path_exists tempname
      assert_equal %w[1], File.readlines(tempname, chomp: true)
    end
    tmux.send_keys :Space, :Down, :Down
    tmux.until { |lines| assert_equal '> 3', lines[4] }
    wait do
      assert_path_exists tempname
      assert_equal %w[1], File.readlines(tempname, chomp: true)
    end
    tmux.send_keys :Space, :Down
    tmux.until { |lines| assert_equal '> 4', lines[5] }
    wait do
      assert_path_exists tempname
      assert_equal %w[1 3 4], File.readlines(tempname, chomp: true)
    end
  end

  def test_preview_size_0_hidden
    FileUtils.rm_f(tempname)
    tmux.send_keys %(seq 100 | #{FZF} --reverse --preview 'echo {} >> #{tempname}; echo ' --preview-window 0,hidden --bind space:toggle-preview), :Enter
    tmux.until { |lines| assert_equal 100, lines.item_count }
    tmux.send_keys :Down, :Down
    tmux.until { |lines| assert_includes lines, '> 3' }
    wait { refute_path_exists tempname }
    tmux.send_keys :Space
    wait do
      assert_path_exists tempname
      assert_equal %w[3], File.readlines(tempname, chomp: true)
    end
    tmux.send_keys :Down
    wait do
      assert_equal %w[3 4], File.readlines(tempname, chomp: true)
    end
    tmux.send_keys :Space, :Down
    tmux.until { |lines| assert_includes lines, '> 5' }
    tmux.send_keys :Down
    tmux.until { |lines| assert_includes lines, '> 6' }
    tmux.send_keys :Space
    wait do
      assert_equal %w[3 4 6], File.readlines(tempname, chomp: true)
    end
  end

  def test_preview_flags
    tmux.send_keys %(seq 10 | sed 's/^/:: /; s/$/  /' |
        #{FZF} --multi --preview 'echo {{2}/{s2}/{+2}/{+s2}/{q}/{n}/{+n}}'), :Enter
    tmux.until { |lines| assert_includes lines[1], ' {1/1  /1/1  //0/0} ' }
    tmux.send_keys '123'
    tmux.until { |lines| assert_includes lines[1], ' {////123//} ' }
    tmux.send_keys 'C-u', '1'
    tmux.until { |lines| assert_equal 2, lines.match_count }
    tmux.until { |lines| assert_includes lines[1], ' {1/1  /1/1  /1/0/0} ' }
    tmux.send_keys :BTab
    tmux.until { |lines| assert_includes lines[1], ' {10/10  /1/1  /1/9/0} ' }
    tmux.send_keys :BTab
    tmux.until { |lines| assert_includes lines[1], ' {10/10  /1 10/1   10  /1/9/0 9} ' }
    tmux.send_keys '2'
    tmux.until { |lines| assert_includes lines[1], ' {//1 10/1   10  /12//0 9} ' }
    tmux.send_keys '3'
    tmux.until { |lines| assert_includes lines[1], ' {//1 10/1   10  /123//0 9} ' }
  end

  def test_preview_file
    tmux.send_keys %[(echo foo bar; echo bar foo) | #{FZF} --multi --preview 'cat {+f} {+f2} {+nf} {+fn}' --print0], :Enter
    tmux.until { |lines| assert_includes lines[1], ' foo barbar00 ' }
    tmux.send_keys :BTab
    tmux.until { |lines| assert_includes lines[1], ' foo barbar00 ' }
    tmux.send_keys :BTab
    tmux.until { |lines| assert_includes lines[1], ' foo barbar foobarfoo0101 ' }
  end

  def test_preview_q_no_match
    tmux.send_keys %(: | #{FZF} --preview 'echo foo {q} foo'), :Enter
    tmux.until { |lines| assert_equal 0, lines.match_count }
    tmux.until { |lines| assert_includes lines[1], ' foo  foo' }
    tmux.send_keys 'bar'
    tmux.until { |lines| assert_includes lines[1], ' foo bar foo' }
    tmux.send_keys 'C-u'
    tmux.until { |lines| assert_includes lines[1], ' foo  foo' }
  end

  def test_preview_q_no_match_with_initial_query
    tmux.send_keys %(: | #{FZF} --preview 'echo foo {q}{q}' --query foo), :Enter
    tmux.until { |lines| assert_equal 0, lines.match_count }
    tmux.until { |lines| assert_includes lines[1], ' foofoo ' }
  end

  def test_no_clear
    tmux.send_keys "seq 10 | fzf --no-clear --inline-info --height 5 > #{tempname}", :Enter
    prompt = '>   < 10/10'
    tmux.until { |lines| assert_equal prompt, lines[-1] }
    tmux.send_keys :Enter
    wait do
      assert_path_exists tempname
      assert_equal %w[1], File.readlines(tempname, chomp: true)
    end
    tmux.until { |lines| assert_equal prompt, lines[-1] }
  end

  def test_info_hidden
    tmux.send_keys 'seq 10 | fzf --info=hidden', :Enter
    tmux.until { |lines| assert_equal '> 1', lines[-2] }
  end

  def test_info_inline_separator
    tmux.send_keys 'seq 10 | fzf --info=inline:___ --no-separator', :Enter
    tmux.until { |lines| assert_equal '>  ___10/10', lines[-1] }
  end

  def test_change_first_last
    tmux.send_keys %(seq 1000 | #{FZF} --bind change:first,alt-Z:last), :Enter
    tmux.until { |lines| assert_equal 1000, lines.match_count }
    tmux.send_keys :Up
    tmux.until { |lines| assert_equal '> 2', lines[-4] }
    tmux.send_keys 1
    tmux.until { |lines| assert_equal '> 1', lines[-3] }
    tmux.send_keys :Up
    tmux.until { |lines| assert_equal '> 10', lines[-4] }
    tmux.send_keys 1
    tmux.until { |lines| assert_equal '> 11', lines[-3] }
    tmux.send_keys 'C-u'
    tmux.until { |lines| assert_equal '> 1', lines[-3] }
    tmux.send_keys :Escape, 'Z'
    tmux.until { |lines| assert_equal '> 1000', lines[0] }
    tmux.send_keys :Enter
  end

  def test_pos
    tmux.send_keys %(seq 1000 | #{FZF} --bind 'a:pos(3),b:pos(-3),c:pos(1),d:pos(-1),e:pos(0)' --preview 'echo {}/{}'), :Enter
    tmux.until { |lines| assert_equal 1000, lines.match_count }
    tmux.send_keys :a
    tmux.until { |lines| assert_includes lines[1], ' 3/3' }
    tmux.send_keys :b
    tmux.until { |lines| assert_includes lines[1], ' 998/998' }
    tmux.send_keys :c
    tmux.until { |lines| assert_includes lines[1], ' 1/1' }
    tmux.send_keys :d
    tmux.until { |lines| assert_includes lines[1], ' 1000/1000' }
    tmux.send_keys :e
    tmux.until { |lines| assert_includes lines[1], ' 1/1' }
  end

  def test_put
    tmux.send_keys %(seq 1000 | #{FZF} --bind 'a:put+put,b:put+put(ravo)' --preview 'echo {q}/{q}'), :Enter
    tmux.until { |lines| assert_equal 1000, lines.match_count }
    tmux.send_keys :a
    tmux.until { |lines| assert_includes lines[1], ' aa/aa' }
    tmux.send_keys :b
    tmux.until { |lines| assert_includes lines[1], ' aabravo/aabravo' }
  end

  def test_accept_non_empty
    tmux.send_keys %(seq 1000 | #{fzf('--print-query --bind enter:accept-non-empty')}), :Enter
    tmux.until { |lines| assert_equal 1000, lines.match_count }
    tmux.send_keys 'foo'
    tmux.until { |lines| assert_equal '  0/1000', lines[-2] }
    # fzf doesn't exit since there's no selection
    tmux.send_keys :Enter
    tmux.until { |lines| assert_equal '  0/1000', lines[-2] }
    tmux.send_keys 'C-u'
    tmux.until { |lines| assert_equal '  1000/1000', lines[-2] }
    tmux.send_keys '999'
    tmux.until { |lines| assert_equal '  1/1000', lines[-2] }
    tmux.send_keys :Enter
    assert_equal %w[999 999], readonce.lines(chomp: true)
  end

  def test_accept_non_empty_with_multi_selection
    tmux.send_keys %(seq 1000 | #{fzf('-m --print-query --bind enter:accept-non-empty')}), :Enter
    tmux.until { |lines| assert_equal 1000, lines.match_count }
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal '  1000/1000 (1)', lines[-2] }
    tmux.send_keys 'foo'
    tmux.until { |lines| assert_equal '  0/1000 (1)', lines[-2] }
    # fzf will exit in this case even though there's no match for the current query
    tmux.send_keys :Enter
    assert_equal %w[foo 1], readonce.lines(chomp: true)
  end

  def test_accept_non_empty_with_empty_list
    tmux.send_keys %(: | #{fzf('-q foo --print-query --bind enter:accept-non-empty')}), :Enter
    tmux.until { |lines| assert_equal '  0/0', lines[-2] }
    tmux.send_keys :Enter
    # fzf will exit anyway since input list is empty
    assert_equal %w[foo], readonce.lines(chomp: true)
  end

  def test_preview_update_on_select
    tmux.send_keys %(seq 10 | fzf -m --preview 'echo {+}' --bind a:toggle-all),
                   :Enter
    tmux.until { |lines| assert_equal 10, lines.item_count }
    tmux.send_keys 'a'
    tmux.until { |lines| assert(lines.any? { |line| line.include?(' 1 2 3 4 5 ') }) }
    tmux.send_keys 'a'
    tmux.until { |lines| lines.each { |line| refute_includes line, ' 1 2 3 4 5 ' } }
  end

  def test_escaped_meta_characters
    input = [
      'foo^bar',
      'foo$bar',
      'foo!bar',
      "foo'bar",
      'foo bar',
      'bar foo'
    ]
    writelines(tempname, input)

    assert_equal input.length, `#{FZF} -f'foo bar' < #{tempname}`.lines.length
    assert_equal input.length - 1, `#{FZF} -f'^foo bar$' < #{tempname}`.lines.length
    assert_equal ['foo bar'], `#{FZF} -f'foo\\ bar' < #{tempname}`.lines(chomp: true)
    assert_equal ['foo bar'], `#{FZF} -f'^foo\\ bar$' < #{tempname}`.lines(chomp: true)
    assert_equal input.length - 1, `#{FZF} -f'!^foo\\ bar$' < #{tempname}`.lines.length
  end

  def test_inverse_only_search_should_not_sort_the_result
    # Filter
    assert_equal %w[aaaaa b ccc],
                 `printf '%s\n' aaaaa b ccc BAD | #{FZF} -f '!bad'`.lines(chomp: true)

    # Interactive
    tmux.send_keys %(printf '%s\n' aaaaa b ccc BAD | #{FZF} -q '!bad'), :Enter
    tmux.until do |lines|
      assert_equal 4, lines.item_count
      assert_equal 3, lines.match_count
    end
    tmux.until { |lines| assert_equal '> aaaaa', lines[-3] }
    tmux.until { |lines| assert_equal '  b', lines[-4] }
    tmux.until { |lines| assert_equal '  ccc', lines[-5] }
  end

  def test_preview_correct_tab_width_after_ansi_reset_code
    writelines(tempname, ["\x1b[31m+\x1b[m\t\x1b[32mgreen"])
    tmux.send_keys "#{FZF} --preview 'cat #{tempname}'", :Enter
    tmux.until { |lines| assert_includes lines[1], ' +       green ' }
  end

  def test_disabled
    tmux.send_keys %(seq 1000 | #{FZF} --query 333 --disabled --bind a:enable-search,b:disable-search,c:toggle-search --preview 'echo {} {q}'), :Enter
    tmux.until { |lines| assert_equal 1000, lines.match_count }
    tmux.until { |lines| assert_includes lines[1], ' 1 333 ' }
    tmux.send_keys 'foo'
    tmux.until { |lines| assert_equal 1000, lines.match_count }
    tmux.until { |lines| assert_includes lines[1], ' 1 333foo ' }

    # Already disabled, no change
    tmux.send_keys 'b'
    tmux.until { |lines| assert_equal 1000, lines.match_count }

    # Enable search
    tmux.send_keys 'a'
    tmux.until { |lines| assert_equal 0, lines.match_count }
    tmux.send_keys :BSpace, :BSpace, :BSpace
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.until { |lines| assert_includes lines[1], ' 333 333 ' }

    # Toggle search -> disabled again, but retains the previous result
    tmux.send_keys 'c'
    tmux.send_keys 'foo'
    tmux.until { |lines| assert_includes lines[1], ' 333 333foo ' }
    tmux.until { |lines| assert_equal 1, lines.match_count }

    # Enabled, no match
    tmux.send_keys 'c'
    tmux.until { |lines| assert_equal 0, lines.match_count }
    tmux.until { |lines| assert_includes lines[1], ' 333foo ' }
  end

  def test_reload
    tmux.send_keys %(seq 1000 | #{FZF} --bind 'change:reload(seq {q}),a:reload(seq 100),b:reload:seq 200' --header-lines 2 --multi 2), :Enter
    tmux.until { |lines| assert_equal 998, lines.match_count }
    tmux.send_keys 'a'
    tmux.until do |lines|
      assert_equal 98, lines.item_count
      assert_equal 98, lines.match_count
    end
    tmux.send_keys 'b'
    tmux.until do |lines|
      assert_equal 198, lines.item_count
      assert_equal 198, lines.match_count
    end
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal '  198/198 (1/2)', lines[-2] }
    tmux.send_keys '555'
    tmux.until { |lines| assert_equal '  1/553 (0/2)', lines[-2] }
  end

  def test_reload_even_when_theres_no_match
    tmux.send_keys %(: | #{FZF} --bind 'space:reload(seq 10)'), :Enter
    tmux.until { |lines| assert_equal 0, lines.item_count }
    tmux.send_keys :Space
    tmux.until { |lines| assert_equal 10, lines.item_count }
  end

  def test_clear_list_when_header_lines_changed_due_to_reload
    tmux.send_keys %(seq 10 | #{FZF} --header 0 --header-lines 3 --bind 'space:reload(seq 1)'), :Enter
    tmux.until { |lines| assert_includes lines, '  9' }
    tmux.send_keys :Space
    tmux.until { |lines| refute_includes lines, '  9' }
  end

  def test_clear_query
    tmux.send_keys %(: | #{FZF} --query foo --bind space:clear-query), :Enter
    tmux.until { |lines| assert_equal 0, lines.item_count }
    tmux.until { |lines| assert_equal '> foo', lines.last }
    tmux.send_keys 'C-a', 'bar'
    tmux.until { |lines| assert_equal '> barfoo', lines.last }
    tmux.send_keys :Space
    tmux.until { |lines| assert_equal '>', lines.last }
  end

  def test_change_and_transform_header
    [
      'space:change-header:$(seq 4)',
      'space:transform-header:seq 4'
    ].each_with_index do |binding, i|
      tmux.send_keys %(seq 3 | #{FZF} --header-lines 2 --header bar --bind "#{binding}"), :Enter
      expected = <<~OUTPUT
        > 3
          2
          1
          bar
          1/1
        >
      OUTPUT
      tmux.until { assert_block(expected, _1) }
      tmux.send_keys :Space
      expected = <<~OUTPUT
        > 3
          2
          1
          1
          2
          3
          4
          1/1
        >
      OUTPUT
      tmux.until { assert_block(expected, _1) }
      next unless i.zero?

      teardown
      setup
    end
  end

  def test_change_header
    tmux.send_keys %(seq 3 | #{FZF} --header-lines 2 --header bar --bind "space:change-header:$(seq 4)"), :Enter
    expected = <<~OUTPUT
      > 3
        2
        1
        bar
        1/1
      >
    OUTPUT
    tmux.until { assert_block(expected, _1) }
    tmux.send_keys :Space
    expected = <<~OUTPUT
      > 3
        2
        1
        1
        2
        3
        4
        1/1
      >
    OUTPUT
    tmux.until { assert_block(expected, _1) }
  end

  def test_change_query
    tmux.send_keys %(: | #{FZF} --query foo --bind space:change-query:foobar), :Enter
    tmux.until { |lines| assert_equal 0, lines.item_count }
    tmux.until { |lines| assert_equal '> foo', lines.last }
    tmux.send_keys :Space, 'baz'
    tmux.until { |lines| assert_equal '> foobarbaz', lines.last }
  end

  def test_transform_query
    tmux.send_keys %{#{FZF} --bind 'ctrl-r:transform-query(rev <<< {q}),ctrl-u:transform-query: tr "[:lower:]" "[:upper:]" <<< {q}' --query bar}, :Enter
    tmux.until { |lines| assert_equal '> bar', lines[-1] }
    tmux.send_keys 'C-r'
    tmux.until { |lines| assert_equal '> rab', lines[-1] }
    tmux.send_keys 'C-u'
    tmux.until { |lines| assert_equal '> RAB', lines[-1] }
  end

  def test_transform_prompt
    tmux.send_keys %{#{FZF} --bind 'ctrl-r:transform-query(rev <<< {q}),ctrl-u:transform-query: tr "[:lower:]" "[:upper:]" <<< {q}' --query bar}, :Enter
    tmux.until { |lines| assert_equal '> bar', lines[-1] }
    tmux.send_keys 'C-r'
    tmux.until { |lines| assert_equal '> rab', lines[-1] }
    tmux.send_keys 'C-u'
    tmux.until { |lines| assert_equal '> RAB', lines[-1] }
  end

  def test_clear_selection
    tmux.send_keys %(seq 100 | #{FZF} --multi --bind space:clear-selection), :Enter
    tmux.until { |lines| assert_equal 100, lines.match_count }
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal '  100/100 (1)', lines[-2] }
    tmux.send_keys 'foo'
    tmux.until { |lines| assert_equal '  0/100 (1)', lines[-2] }
    tmux.send_keys :Space
    tmux.until { |lines| assert_equal '  0/100 (0)', lines[-2] }
  end

  def test_backward_delete_char_eof
    tmux.send_keys "seq 1000 | #{fzf("--bind 'bs:backward-delete-char/eof'")}", :Enter
    tmux.until { |lines| assert_equal '  1000/1000', lines[-2] }
    tmux.send_keys '11'
    tmux.until { |lines| assert_equal '> 11', lines[-1] }
    tmux.send_keys :BSpace
    tmux.until { |lines| assert_equal '> 1', lines[-1] }
    tmux.send_keys :BSpace
    tmux.until { |lines| assert_equal '>', lines[-1] }
    tmux.send_keys :BSpace
    tmux.prepare
  end

  def test_strip_xterm_osc_sequence
    %W[\x07 \x1b\\].each do |esc|
      writelines(tempname, [%(printf $1"\e]4;3;rgb:aa/bb/cc#{esc} "$2)])
      File.chmod(0o755, tempname)
      tmux.prepare
      tmux.send_keys \
        %(echo foo bar | #{FZF} --preview '#{tempname} {2} {1}'), :Enter

      tmux.until { |lines| assert lines.any_include?('bar foo') }
      tmux.send_keys :Enter
    end
  end

  def test_keep_right
    tmux.send_keys "seq 10000 | #{FZF} --read0 --keep-right", :Enter
    tmux.until { |lines| assert lines.any_include?('9999␊10000') }
  end

  def test_backward_eof
    tmux.send_keys "echo foo | #{FZF} --bind 'backward-eof:reload(seq 100)'", :Enter
    tmux.until { |lines| lines.item_count == 1 && lines.match_count == 1 }
    tmux.send_keys 'x'
    tmux.until { |lines| lines.item_count == 1 && lines.match_count == 0 }
    tmux.send_keys :BSpace
    tmux.until { |lines| lines.item_count == 1 && lines.match_count == 1 }
    tmux.send_keys :BSpace
    tmux.until { |lines| lines.item_count == 100 && lines.match_count == 100 }
  end

  def test_preview_bindings_with_default_preview
    tmux.send_keys "seq 10 | #{FZF} --preview 'echo [{}]' --bind 'a:preview(echo [{}{}]),b:preview(echo [{}{}{}]),c:refresh-preview'", :Enter
    tmux.until { |lines| lines.item_count == 10 }
    tmux.until { |lines| assert_includes lines[1], '[1]' }
    tmux.send_keys 'a'
    tmux.until { |lines| assert_includes lines[1], '[11]' }
    tmux.send_keys 'c'
    tmux.until { |lines| assert_includes lines[1], '[1]' }
    tmux.send_keys 'b'
    tmux.until { |lines| assert_includes lines[1], '[111]' }
    tmux.send_keys :Up
    tmux.until { |lines| assert_includes lines[1], '[2]' }
  end

  def test_preview_bindings_without_default_preview
    tmux.send_keys "seq 10 | #{FZF} --bind 'a:preview(echo [{}{}]),b:preview(echo [{}{}{}]),c:refresh-preview'", :Enter
    tmux.until { |lines| lines.item_count == 10 }
    tmux.until { |lines| refute_includes lines[1], '1' }
    tmux.send_keys 'a'
    tmux.until { |lines| assert_includes lines[1], '[11]' }
    tmux.send_keys 'c' # does nothing
    tmux.until { |lines| assert_includes lines[1], '[11]' }
    tmux.send_keys 'b'
    tmux.until { |lines| assert_includes lines[1], '[111]' }
    tmux.send_keys 9
    tmux.until { |lines| lines.match_count == 1 }
    tmux.until { |lines| refute_includes lines[1], '2' }
    tmux.until { |lines| assert_includes lines[1], '[111]' }
  end

  def test_preview_scroll_begin_constant
    tmux.send_keys "echo foo 123 321 | #{FZF} --preview 'seq 1000' --preview-window left:+123", :Enter
    tmux.until { |lines| assert_match %r{1/1}, lines[-2] }
    tmux.until { |lines| assert_match %r{123.*123/1000}, lines[1] }
  end

  def test_preview_scroll_begin_expr
    tmux.send_keys "echo foo 123 321 | #{FZF} --preview 'seq 1000' --preview-window left:+{3}", :Enter
    tmux.until { |lines| assert_match %r{1/1}, lines[-2] }
    tmux.until { |lines| assert_match %r{321.*321/1000}, lines[1] }
  end

  def test_preview_scroll_begin_and_offset
    ['echo foo 123 321', 'echo foo :123: 321'].each do |input|
      tmux.send_keys "#{input} | #{FZF} --preview 'seq 1000' --preview-window left:+{2}-2", :Enter
      tmux.until { |lines| assert_match %r{1/1}, lines[-2] }
      tmux.until { |lines| assert_match %r{121.*121/1000}, lines[1] }
      tmux.send_keys 'C-c'
    end
  end

  def test_normalized_match
    echoes = '(echo a; echo á; echo A; echo Á;)'
    assert_equal %w[a á A Á], `#{echoes} | #{FZF} -f a`.lines.map(&:chomp)
    assert_equal %w[á Á], `#{echoes} | #{FZF} -f á`.lines.map(&:chomp)
    assert_equal %w[A Á], `#{echoes} | #{FZF} -f A`.lines.map(&:chomp)
    assert_equal %w[Á], `#{echoes} | #{FZF} -f Á`.lines.map(&:chomp)
  end

  def test_preview_clear_screen
    tmux.send_keys %{seq 100 | #{FZF} --preview 'for i in $(seq 300); do (( i % 200 == 0 )) && printf "\\033[2J"; echo "[$i]"; sleep 0.001; done'}, :Enter
    tmux.until { |lines| lines.item_count == 100 }
    tmux.until { |lines| lines[1]&.include?('[200]') }
  end

  def test_change_prompt
    tmux.send_keys "#{FZF} --bind 'a:change-prompt(a> ),b:change-prompt:b> ' --query foo", :Enter
    tmux.until { |lines| assert_equal '> foo', lines[-1] }
    tmux.send_keys 'a'
    tmux.until { |lines| assert_equal 'a> foo', lines[-1] }
    tmux.send_keys 'b'
    tmux.until { |lines| assert_equal 'b> foo', lines[-1] }
  end

  def test_preview_window_follow
    file = Tempfile.new('fzf-follow')
    file.sync = true

    tmux.send_keys %(seq 100 | #{FZF} --preview 'tail -f "#{file.path}"' --preview-window follow --bind 'up:preview-up,down:preview-down,space:change-preview-window:follow|nofollow' --preview-window '~3'), :Enter
    tmux.until { |lines| lines.item_count == 100 }

    # Write to the temporary file, and check if the preview window is showing
    # the last line of the file
    3.times { file.puts _1 } # header lines
    1000.times { file.puts _1 }
    tmux.until { |lines| assert_includes lines[1], '/1003' }
    tmux.until { |lines| assert_includes lines[-2], '999' }

    # Scroll the preview window and fzf should stop following the file content
    tmux.send_keys :Up
    tmux.until { |lines| assert_includes lines[-2], '998' }
    file.puts 'foo', 'bar'
    tmux.until do |lines|
      assert_includes lines[1], '/1005'
      assert_includes lines[-2], '998'
    end

    # Scroll back to the bottom and fzf should start following the file again
    %w[999 foo bar].each do |item|
      wait do
        tmux.send_keys :Down
        tmux.until { |lines| assert_includes lines[-2], item }
      end
    end
    file.puts 'baz'
    tmux.until do |lines|
      assert_includes lines[1], '/1006'
      assert_includes lines[-2], 'baz'
    end

    # Scroll upwards to stop following
    tmux.send_keys :Up
    wait { assert_includes lines[-2], 'bar' }
    file.puts 'aaa'
    tmux.until do |lines|
      assert_includes lines[1], '/1007'
      assert_includes lines[-2], 'bar'
    end

    # Manually enable following
    tmux.send_keys :Space
    tmux.until { |lines| assert_includes lines[-2], 'aaa' }
    file.puts 'bbb'
    tmux.until do |lines|
      assert_includes lines[1], '/1008'
      assert_includes lines[-2], 'bbb'
    end

    # Disable following
    tmux.send_keys :Space
    file.puts 'ccc', 'ddd'
    tmux.until do |lines|
      assert_includes lines[1], '/1010'
      assert_includes lines[-2], 'bbb'
    end
  rescue StandardError
    file.close
    file.unlink
  end

  def test_toggle_preview_wrap
    tmux.send_keys "#{FZF} --preview 'for i in $(seq $FZF_PREVIEW_COLUMNS); do echo -n .; done; echo wrapped; echo 2nd line' --bind ctrl-w:toggle-preview-wrap", :Enter
    2.times do
      tmux.until { |lines| assert_includes lines[2], '2nd line' }
      tmux.send_keys 'C-w'
      tmux.until do |lines|
        assert_includes lines[2], 'wrapped'
        assert_includes lines[3], '2nd line'
      end
      tmux.send_keys 'C-w'
    end
  end

  def test_close
    tmux.send_keys "seq 100 | #{FZF} --preview 'echo foo' --bind ctrl-c:close", :Enter
    tmux.until { |lines| assert_equal 100, lines.match_count }
    tmux.until { |lines| assert_includes lines[1], 'foo' }
    tmux.send_keys 'C-c'
    tmux.until { |lines| refute_includes lines[1], 'foo' }
    tmux.send_keys '10'
    tmux.until { |lines| assert_equal 2, lines.match_count }
    tmux.send_keys 'C-c'
    tmux.send_keys 'C-l', 'closed'
    tmux.until { |lines| assert_includes lines[0], 'closed' }
  end

  def test_select_deselect
    tmux.send_keys "seq 3 | #{FZF} --multi --bind up:deselect+up,down:select+down", :Enter
    tmux.until { |lines| assert_equal 3, lines.match_count }
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal 1, lines.select_count }
    tmux.send_keys :Up
    tmux.until { |lines| assert_equal 0, lines.select_count }
    tmux.send_keys :Down, :Down
    tmux.until { |lines| assert_equal 2, lines.select_count }
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal 1, lines.select_count }
    tmux.send_keys :Down, :Down
    tmux.until { |lines| assert_equal 2, lines.select_count }
    tmux.send_keys :Up
    tmux.until { |lines| assert_equal 1, lines.select_count }
    tmux.send_keys :Down
    tmux.until { |lines| assert_equal 1, lines.select_count }
    tmux.send_keys :Down
    tmux.until { |lines| assert_equal 2, lines.select_count }
  end

  def test_interrupt_execute
    tmux.send_keys "seq 100 | #{FZF} --bind 'ctrl-l:execute:echo executing {}; sleep 100'", :Enter
    tmux.until { |lines| assert_equal 100, lines.item_count }
    tmux.send_keys 'C-l'
    tmux.until { |lines| assert lines.any_include?('executing 1') }
    tmux.send_keys 'C-c'
    tmux.until { |lines| assert_equal 100, lines.item_count }
    tmux.send_keys 99
    tmux.until { |lines| assert_equal 1, lines.match_count }
  end

  def test_kill_default_command_on_abort
    script = tempname + '.sh'
    writelines(script,
               ['#!/usr/bin/env bash',
                "echo 'Started'",
                'while :; do sleep 1; done'])
    system("chmod +x #{script}")

    tmux.send_keys fzf.sub('FZF_DEFAULT_COMMAND=', "FZF_DEFAULT_COMMAND=#{script}"), :Enter
    tmux.until { |lines| assert_equal 1, lines.item_count }
    tmux.send_keys 'C-c'
    tmux.send_keys 'C-l', 'closed'
    tmux.until { |lines| assert_includes lines[0], 'closed' }
    wait { refute system("pgrep -f #{script}") }
  ensure
    system("pkill -9 -f #{script}")
    FileUtils.rm_f(script)
  end

  def test_kill_default_command_on_accept
    script = tempname + '.sh'
    writelines(script,
               ['#!/usr/bin/env bash',
                "echo 'Started'",
                'while :; do sleep 1; done'])
    system("chmod +x #{script}")

    tmux.send_keys fzf.sub('FZF_DEFAULT_COMMAND=', "FZF_DEFAULT_COMMAND=#{script}"), :Enter
    tmux.until { |lines| assert_equal 1, lines.item_count }
    tmux.send_keys :Enter
    assert_equal 'Started', readonce.chomp
    wait { refute system("pgrep -f #{script}") }
  ensure
    system("pkill -9 -f #{script}")
    FileUtils.rm_f(script)
  end

  def test_kill_reload_command_on_abort
    script = tempname + '.sh'
    writelines(script,
               ['#!/usr/bin/env bash',
                "echo 'Started'",
                'while :; do sleep 1; done'])
    system("chmod +x #{script}")

    tmux.send_keys "seq 1 3 | #{fzf("--bind 'ctrl-r:reload(#{script})'")}", :Enter
    tmux.until { |lines| assert_equal 3, lines.item_count }
    tmux.send_keys 'C-r'
    tmux.until { |lines| assert_equal 1, lines.item_count }
    tmux.send_keys 'C-c'
    tmux.send_keys 'C-l', 'closed'
    tmux.until { |lines| assert_includes lines[0], 'closed' }
    wait { refute system("pgrep -f #{script}") }
  ensure
    system("pkill -9 -f #{script}")
    FileUtils.rm_f(script)
  end

  def test_kill_reload_command_on_accept
    script = tempname + '.sh'
    writelines(script,
               ['#!/usr/bin/env bash',
                "echo 'Started'",
                'while :; do sleep 1; done'])
    system("chmod +x #{script}")

    tmux.send_keys "seq 1 3 | #{fzf("--bind 'ctrl-r:reload(#{script})'")}", :Enter
    tmux.until { |lines| assert_equal 3, lines.item_count }
    tmux.send_keys 'C-r'
    tmux.until { |lines| assert_equal 1, lines.item_count }
    tmux.send_keys :Enter
    assert_equal 'Started', readonce.chomp
    wait { refute system("pgrep -f #{script}") }
  ensure
    system("pkill -9 -f #{script}")
    FileUtils.rm_f(script)
  end

  def test_preview_header
    tmux.send_keys "seq 100 | #{FZF} --bind ctrl-k:preview-up+preview-up,ctrl-j:preview-down+preview-down+preview-down --preview 'seq 1000' --preview-window 'top:+{1}:~3'", :Enter
    tmux.until { |lines| assert_equal 100, lines.item_count }
    top5 = ->(lines) { lines.drop(1).take(5).map { |s| s[/[0-9]+/] } }
    tmux.until do |lines|
      assert_includes lines[1], '4/1000'
      assert_equal(%w[1 2 3 4 5], top5[lines])
    end
    tmux.send_keys '55'
    tmux.until do |lines|
      assert_equal 1, lines.match_count
      assert_equal(%w[1 2 3 55 56], top5[lines])
    end
    tmux.send_keys 'C-J'
    tmux.until do |lines|
      assert_equal(%w[1 2 3 58 59], top5[lines])
    end
    tmux.send_keys :BSpace
    tmux.until do |lines|
      assert_equal 19, lines.match_count
      assert_equal(%w[1 2 3 5 6], top5[lines])
    end
    tmux.send_keys 'C-K'
    tmux.until { |lines| assert_equal(%w[1 2 3 4 5], top5[lines]) }
  end

  def test_unbind_rebind
    tmux.send_keys "seq 100 | #{FZF} --bind 'c:clear-query,d:unbind(c,d),e:rebind(c,d)'", :Enter
    tmux.until { |lines| assert_equal 100, lines.item_count }
    tmux.send_keys 'ab'
    tmux.until { |lines| assert_equal '> ab', lines[-1] }
    tmux.send_keys 'c'
    tmux.until { |lines| assert_equal '>', lines[-1] }
    tmux.send_keys 'dabcd'
    tmux.until { |lines| assert_equal '> abcd', lines[-1] }
    tmux.send_keys 'ecabddc'
    tmux.until { |lines| assert_equal '> abdc', lines[-1] }
  end

  def test_item_index_reset_on_reload
    tmux.send_keys "seq 10 | #{FZF} --preview 'echo [[{n}]]' --bind 'up:last,down:first,space:reload:seq 100'", :Enter
    tmux.until { |lines| assert_includes lines[1], '[[0]]' }
    tmux.send_keys :Up
    tmux.until { |lines| assert_includes lines[1], '[[9]]' }
    tmux.send_keys :Down
    tmux.until { |lines| assert_includes lines[1], '[[0]]' }
    tmux.send_keys :Space
    tmux.until do |lines|
      assert_equal 100, lines.item_count
      assert_includes lines[1], '[[0]]'
    end
    tmux.send_keys :Up
    tmux.until { |lines| assert_includes lines[1], '[[99]]' }
  end

  def test_reload_should_update_preview
    tmux.send_keys "seq 3 | #{FZF} --bind 'ctrl-t:reload:echo 4' --preview 'echo {}' --preview-window 'nohidden'", :Enter
    tmux.until { |lines| assert_includes lines[1], '1' }
    tmux.send_keys 'C-t'
    tmux.until { |lines| assert_includes lines[1], '4' }
  end

  def test_reload_and_change_preview_should_update_preview
    tmux.send_keys "seq 3 | #{FZF} --bind 'ctrl-t:reload(echo 4)+change-preview(echo {})'", :Enter
    tmux.until { |lines| assert_equal 3, lines.item_count }
    tmux.until { |lines| refute_includes lines[1], '1' }
    tmux.send_keys 'C-t'
    tmux.until { |lines| assert_equal 1, lines.item_count }
    tmux.until { |lines| assert_includes lines[1], '4' }
  end

  def test_reload_sync
    tmux.send_keys "seq 100 | #{FZF} --bind 'load:reload-sync(sleep 1; seq 1000)+unbind(load)'", :Enter
    tmux.until { |lines| assert_equal 100, lines.item_count }
    tmux.send_keys '00'
    tmux.until { |lines| assert_equal 1, lines.match_count }
    # After 1 second
    tmux.until { |lines| assert_equal 10, lines.match_count }
  end

  def test_scroll_off
    tmux.send_keys "seq 1000 | #{FZF} --scroll-off=3 --bind l:last", :Enter
    tmux.until { |lines| assert_equal 1000, lines.item_count }
    height = tmux.until { |lines| lines }.first.to_i
    tmux.send_keys :PgUp
    tmux.until do |lines|
      assert_equal height + 3, lines.first.to_i
      assert_equal "> #{height}", lines[3].strip
    end
    tmux.send_keys :Up
    tmux.until { |lines| assert_equal "> #{height + 1}", lines[3].strip }
    tmux.send_keys 'l'
    tmux.until { |lines| assert_equal '> 1000', lines.first.strip }
    tmux.send_keys :PgDn
    tmux.until { |lines| assert_equal "> #{1000 - height + 1}", lines.reverse[5].strip }
    tmux.send_keys :Down
    tmux.until { |lines| assert_equal "> #{1000 - height}", lines.reverse[5].strip }
  end

  def test_scroll_off_large
    tmux.send_keys "seq 1000 | #{FZF} --scroll-off=9999", :Enter
    tmux.until { |lines| assert_equal 1000, lines.item_count }
    height = tmux.until { |lines| lines }.first.to_i
    tmux.send_keys :PgUp
    tmux.until { |lines| assert_equal "> #{height}", lines[height / 2].strip }
    tmux.send_keys :Up
    tmux.until { |lines| assert_equal "> #{height + 1}", lines[height / 2].strip }
    tmux.send_keys :Up
    tmux.until { |lines| assert_equal "> #{height + 2}", lines[height / 2].strip }
    tmux.send_keys :Down
    tmux.until { |lines| assert_equal "> #{height + 1}", lines[height / 2].strip }
  end

  def test_header_first
    tmux.send_keys "seq 1000 | #{FZF} --header foobar --header-lines 3 --header-first", :Enter
    tmux.until do |lines|
      expected = <<~OUTPUT
        > 4
          997/997
        >
          3
          2
          1
          foobar
      OUTPUT

      assert_equal expected.chomp, lines.reverse.take(7).reverse.join("\n")
    end
  end

  def test_header_first_reverse
    tmux.send_keys "seq 1000 | #{FZF} --header foobar --header-lines 3 --header-first --reverse --inline-info", :Enter
    tmux.until do |lines|
      expected = <<~OUTPUT
          foobar
          1
          2
          3
        >   < 997/997
        > 4
      OUTPUT

      assert_equal expected.chomp, lines.take(6).join("\n")
    end
  end

  def test_change_preview_window
    tmux.send_keys "seq 1000 | #{FZF} --preview 'echo [[{}]]' --preview-window border-none --bind '" \
      'a:change-preview(echo __{}__),' \
      'b:change-preview-window(down)+change-preview(echo =={}==)+change-preview-window(up),' \
      'c:change-preview(),d:change-preview-window(hidden),' \
      "e:preview(printf ::%${FZF_PREVIEW_COLUMNS}s{})+change-preview-window(up),f:change-preview-window(up,wrap)'", :Enter
    tmux.until { |lines| assert_equal 1000, lines.item_count }
    tmux.until { |lines| assert_includes lines[0], '[[1]]' }

    # change-preview action permanently changes the preview command set by --preview
    tmux.send_keys 'a'
    tmux.until { |lines| assert_includes lines[0], '__1__' }
    tmux.send_keys :Up
    tmux.until { |lines| assert_includes lines[0], '__2__' }

    # When multiple change-preview-window actions are bound to a single key,
    # the last one wins and the updated options are immediately applied to the new preview
    tmux.send_keys 'b'
    tmux.until { |lines| assert_equal '==2==', lines[0] }
    tmux.send_keys :Up
    tmux.until { |lines| assert_equal '==3==', lines[0] }

    # change-preview with an empty preview command closes the preview window
    tmux.send_keys 'c'
    tmux.until { |lines| refute_includes lines[0], '==' }

    # change-preview again to re-open the preview window
    tmux.send_keys 'a'
    tmux.until { |lines| assert_equal '__3__', lines[0] }

    # Hide the preview window with hidden flag
    tmux.send_keys 'd'
    tmux.until { |lines| refute_includes lines[0], '__3__' }

    # One-off preview
    tmux.send_keys 'e'
    tmux.until do |lines|
      assert_equal '::', lines[0]
      refute_includes lines[1], '3'
    end

    # Wrapped
    tmux.send_keys 'f'
    tmux.until do |lines|
      assert_equal '::', lines[0]
      assert_equal '  3', lines[1]
    end
  end

  def test_change_preview_window_rotate
    tmux.send_keys "seq 100 | #{FZF} --preview-window left,border-none --preview 'echo hello' --bind '" \
      "a:change-preview-window(right|down|up|hidden|)'", :Enter
    3.times do
      tmux.until { |lines| lines[0].start_with?('hello') }
      tmux.send_keys 'a'
      tmux.until { |lines| lines[0].end_with?('hello') }
      tmux.send_keys 'a'
      tmux.until { |lines| lines[-1].start_with?('hello') }
      tmux.send_keys 'a'
      tmux.until { |lines| assert_equal 'hello', lines[0] }
      tmux.send_keys 'a'
      tmux.until { |lines| refute_includes lines[0], 'hello' }
      tmux.send_keys 'a'
    end
  end

  def test_change_preview_window_rotate_hidden
    tmux.send_keys "seq 100 | #{FZF} --preview-window hidden --preview 'echo =={}==' --bind '" \
      "a:change-preview-window(nohidden||down,1|)'", :Enter
    tmux.until { |lines| assert_equal 100, lines.match_count }
    tmux.until { |lines| refute_includes lines[1], '==1==' }
    tmux.send_keys 'a'
    tmux.until { |lines| assert_includes lines[1], '==1==' }
    tmux.send_keys 'a'
    tmux.until { |lines| refute_includes lines[1], '==1==' }
    tmux.send_keys 'a'
    tmux.until { |lines| assert_includes lines[-2], '==1==' }
    tmux.send_keys 'a'
    tmux.until { |lines| refute_includes lines[-2], '==1==' }
    tmux.send_keys 'a'
    tmux.until { |lines| assert_includes lines[1], '==1==' }
  end

  def test_change_preview_window_rotate_hidden_down
    tmux.send_keys "seq 100 | #{FZF} --bind '?:change-preview-window:up||down|' --preview 'echo =={}==' --preview-window hidden,down,1", :Enter
    tmux.until { |lines| assert_equal 100, lines.match_count }
    tmux.until { |lines| refute_includes lines[1], '==1==' }
    tmux.send_keys '?'
    tmux.until { |lines| assert_includes lines[1], '==1==' }
    tmux.send_keys '?'
    tmux.until { |lines| refute_includes lines[1], '==1==' }
    tmux.send_keys '?'
    tmux.until { |lines| assert_includes lines[-2], '==1==' }
    tmux.send_keys '?'
    tmux.until { |lines| refute_includes lines[-2], '==1==' }
    tmux.send_keys '?'
    tmux.until { |lines| assert_includes lines[1], '==1==' }
  end

  def test_ellipsis
    tmux.send_keys 'seq 1000 | tr "\n" , | fzf --ellipsis=SNIPSNIP -e -q500', :Enter
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.until { |lines| assert_match(/^> SNIPSNIP.*SNIPSNIP$/, lines[-3]) }
  end

  def assert_block(expected, lines)
    cols = expected.lines.map(&:chomp).map(&:length).max
    actual = lines.reverse.take(expected.lines.length).reverse.map { _1[0, cols].rstrip + "\n" }.join
    assert_equal_org expected, actual
  end

  def test_height_range_fit
    tmux.send_keys 'seq 3 | fzf --height ~100% --info=inline --border', :Enter
    expected = <<~OUTPUT
      ╭──────────
      │   3
      │   2
      │ > 1
      │ >   < 3/3
      ╰──────────
    OUTPUT
    tmux.until { assert_block(expected, _1) }
  end

  def test_height_range_fit_preview_above
    tmux.send_keys 'seq 3 | fzf --height ~100% --info=inline --border --preview "seq {}" --preview-window up,60%', :Enter
    expected = <<~OUTPUT
      ╭──────────
      │ ╭────────
      │ │ 1
      │ │
      │ │
      │ │
      │ ╰────────
      │   3
      │   2
      │ > 1
      │ >   < 3/3
      ╰──────────
    OUTPUT
    tmux.until { assert_block(expected, _1) }
  end

  def test_height_range_fit_preview_above_alternative
    tmux.send_keys 'seq 3 | fzf --height ~100% --border=sharp --preview "seq {}" --preview-window up,40%,border-bottom --padding 1 --exit-0 --header hello --header-lines=2', :Enter
    expected = <<~OUTPUT
      ┌─────────
      │
      │  1
      │  2
      │  3
      │  ───────
      │  > 3
      │    2
      │    1
      │    hello
      │    1/1 ─
      │  >
      │
      └─────────
    OUTPUT
    tmux.until { assert_block(expected, _1) }
  end

  def test_height_range_fit_preview_left
    tmux.send_keys "seq 3 | fzf --height ~100% --border=vertical --preview 'seq {}' --preview-window left,5,border-right --padding 1 --exit-0 --header $'hello\\nworld' --header-lines=2", :Enter
    expected = <<~OUTPUT
      │
      │  1       │ > 3
      │  2       │   2
      │  3       │   1
      │          │   hello
      │          │   world
      │          │   1/1 ─
      │          │ >
      │
    OUTPUT
    tmux.until { assert_block(expected, _1) }
  end

  def test_height_range_overflow
    tmux.send_keys 'seq 100 | fzf --height ~5 --info=inline --border', :Enter
    expected = <<~OUTPUT
      ╭──────────────
      │   2
      │ > 1
      │ >   < 100/100
      ╰──────────────
    OUTPUT
    tmux.until { assert_block(expected, _1) }
  end

  def test_start_event
    tmux.send_keys 'seq 100 | fzf --multi --sync --preview-window hidden:border-none --bind "start:select-all+last+preview(echo welcome)"', :Enter
    tmux.until do |lines|
      assert_match(/>100.*welcome/, lines[0])
      assert_includes(lines[-2], '100/100 (100)')
    end
  end

  def test_focus_event
    tmux.send_keys 'seq 100 | fzf --bind "focus:transform-prompt(echo [[{}]]),?:unbind(focus)"', :Enter
    tmux.until { |lines| assert_includes(lines[-1], '[[1]]') }
    tmux.send_keys :Up
    tmux.until { |lines| assert_includes(lines[-1], '[[2]]') }
    tmux.send_keys :X
    tmux.until { |lines| assert_includes(lines[-1], '[[]]') }
    tmux.send_keys '?'
    tmux.send_keys :BSpace
    tmux.until { |lines| assert_equal 100, lines.match_count }
    tmux.until { |lines| refute_includes(lines[-1], '[[1]]') }
  end

  def test_labels_center
    tmux.send_keys 'echo x | fzf --border --border-label foobar --preview : --preview-label barfoo --bind "space:change-border-label(foobarfoo)+change-preview-label(barfoobar),enter:transform-border-label(echo foo{}foo)+transform-preview-label(echo bar{}bar)"', :Enter
    tmux.until do
      assert_includes(_1[0], '─foobar─')
      assert_includes(_1[1], '─barfoo─')
    end
    tmux.send_keys :space
    tmux.until do
      assert_includes(_1[0], '─foobarfoo─')
      assert_includes(_1[1], '─barfoobar─')
    end
    tmux.send_keys :Enter
    tmux.until do
      assert_includes(_1[0], '─fooxfoo─')
      assert_includes(_1[1], '─barxbar─')
    end
  end

  def test_labels_left
    tmux.send_keys ': | fzf --border --border-label foobar --border-label-pos 2 --preview : --preview-label barfoo --preview-label-pos 2', :Enter
    tmux.until do
      assert_includes(_1[0], '╭foobar─')
      assert_includes(_1[1], '╭barfoo─')
    end
  end

  def test_labels_right
    tmux.send_keys ': | fzf --border --border-label foobar --border-label-pos -2 --preview : --preview-label barfoo --preview-label-pos -2', :Enter
    tmux.until do
      assert_includes(_1[0], '─foobar╮')
      assert_includes(_1[1], '─barfoo╮')
    end
  end

  def test_labels_bottom
    tmux.send_keys ': | fzf --border --border-label foobar --border-label-pos 2:bottom --preview : --preview-label barfoo --preview-label-pos -2:bottom', :Enter
    tmux.until do
      assert_includes(_1[-1], '╰foobar─')
      assert_includes(_1[-2], '─barfoo╯')
    end
  end

  def test_info_separator_unicode
    tmux.send_keys 'seq 100 | fzf -q55', :Enter
    tmux.until { assert_includes(_1[-2], '  1/100 ─') }
  end

  def test_info_separator_no_unicode
    tmux.send_keys 'seq 100 | fzf -q55 --no-unicode', :Enter
    tmux.until { assert_includes(_1[-2], '  1/100 -') }
  end

  def test_info_separator_repeat
    tmux.send_keys 'seq 100 | fzf -q55 --separator _-', :Enter
    tmux.until { assert_includes(_1[-2], '  1/100 _-_-') }
  end

  def test_info_separator_ansi_colors_and_tabs
    tmux.send_keys "seq 100 | fzf -q55 --tabstop 4 --separator $'\\x1b[33ma\\tb'", :Enter
    tmux.until { assert_includes(_1[-2], '  1/100 a   ba   ba') }
  end

  def test_info_no_separator
    tmux.send_keys 'seq 100 | fzf -q55 --no-separator', :Enter
    tmux.until { assert(_1[-2] == '  1/100') }
  end

  def test_info_right
    tmux.send_keys "#{FZF} --info=right --separator x --bind 'start:reload:seq 100; sleep 10'", :Enter
    tmux.until { assert_match(%r{xxx [⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏] 100/100}, _1[-2]) }
  end

  def test_info_inline_right
    tmux.send_keys "#{FZF} --info=inline-right --bind 'start:reload:seq 100; sleep 10'", :Enter
    tmux.until { assert_match(%r{[⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏] 100/100}, _1[-1]) }
  end

  def test_prev_next_selected
    tmux.send_keys 'seq 10 | fzf --multi --bind ctrl-n:next-selected,ctrl-p:prev-selected', :Enter
    tmux.until { |lines| assert_equal 10, lines.item_count }
    tmux.send_keys :BTab, :BTab, :Up, :BTab
    tmux.until { |lines| assert_equal 3, lines.select_count }
    tmux.send_keys 'C-n'
    tmux.until { |lines| assert_includes lines, '>>4' }
    tmux.send_keys 'C-n'
    tmux.until { |lines| assert_includes lines, '>>2' }
    tmux.send_keys 'C-n'
    tmux.until { |lines| assert_includes lines, '>>1' }
    tmux.send_keys 'C-n'
    tmux.until { |lines| assert_includes lines, '>>4' }
    tmux.send_keys 'C-p'
    tmux.until { |lines| assert_includes lines, '>>1' }
    tmux.send_keys 'C-p'
    tmux.until { |lines| assert_includes lines, '>>2' }
  end

  def test_listen
    { '--listen 6266' => -> { URI('http://localhost:6266') },
      "--listen --sync --bind 'start:execute-silent:echo $FZF_PORT > /tmp/fzf-port'" =>
        -> { URI("http://localhost:#{File.read('/tmp/fzf-port').chomp}") } }.each do |opts, fn|
      tmux.send_keys "seq 10 | fzf #{opts}", :Enter
      tmux.until { |lines| assert_equal 10, lines.item_count }
      Net::HTTP.post(fn.call, 'change-query(yo)+reload(seq 100)+change-prompt:hundred> ')
      tmux.until { |lines| assert_equal 100, lines.item_count }
      tmux.until { |lines| assert_equal 'hundred> yo', lines[-1] }
      teardown
      setup
    end
  end

  def test_toggle_alternative_preview_window
    tmux.send_keys "seq 10 | #{FZF} --bind space:toggle-preview --preview-window '<100000(hidden,up,border-none)' --preview 'echo /{}/{}/'", :Enter
    tmux.until { |lines| assert_equal 10, lines.item_count }
    tmux.until { |lines| refute_includes lines, '/1/1/' }
    tmux.send_keys :Space
    tmux.until { |lines| assert_includes lines, '/1/1/' }
  end

  def test_become
    tmux.send_keys "seq 100 | #{FZF} --bind 'enter:become:seq {} | #{FZF}'", :Enter
    tmux.until { |lines| assert_equal 100, lines.item_count }
    tmux.send_keys 999
    tmux.until { |lines| assert_equal 0, lines.match_count }
    tmux.send_keys :Enter
    tmux.until { |lines| assert_equal 0, lines.match_count }
    tmux.send_keys :BSpace
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys :Enter
    tmux.until { |lines| assert_equal 99, lines.item_count }
  end

  def test_no_extra_newline_issue_3209
    tmux.send_keys(%(seq 100 | #{FZF} --height 10 --preview-window up,wrap --preview 'printf "─%.0s" $(seq 1 "$((FZF_PREVIEW_COLUMNS - 5))"); printf $"\\e[7m%s\\e[0m" title; echo; echo something'), :Enter)
    expected = <<~OUTPUT
      ╭──────────
      │ ─────────
      │ something
      │
      ╰──────────
        3
        2
      > 1
        100/100 ─
      >
    OUTPUT
    tmux.until { assert_block(expected, _1) }
  end

  def test_track
    tmux.send_keys "seq 1000 | #{FZF} --query 555 --track --bind t:toggle-track", :Enter
    tmux.until do |lines|
      assert_equal 1, lines.match_count
      assert_includes lines, '> 555'
    end
    tmux.send_keys :BSpace
    index = tmux.until do |lines|
      assert_equal 28, lines.match_count
      assert_includes lines, '> 555'
    end.index('> 555')
    tmux.send_keys :BSpace
    tmux.until do |lines|
      assert_equal 271, lines.match_count
      assert_equal '> 555', lines[index]
    end
    tmux.send_keys :BSpace
    tmux.until do |lines|
      assert_equal 1000, lines.match_count
      assert_equal '> 555', lines[index]
    end
    tmux.send_keys '555'
    tmux.until do |lines|
      assert_equal 1, lines.match_count
      assert_includes lines, '> 555'
      assert_includes lines[-2], '+T'
    end
    tmux.send_keys 't'
    tmux.until do |lines|
      refute_includes lines[-2], '+T'
    end
    tmux.send_keys :BSpace
    tmux.until do |lines|
      assert_equal 28, lines.match_count
      assert_includes lines, '> 55'
    end
    tmux.send_keys :BSpace
    tmux.until do |lines|
      assert_equal 271, lines.match_count
      assert_includes lines, '> 5'
    end
    tmux.send_keys 't'
    tmux.until do |lines|
      assert_includes lines[-2], '+T'
    end
    tmux.send_keys :BSpace
    tmux.until do |lines|
      assert_equal 1000, lines.match_count
      assert_includes lines, '> 5'
    end
  end

  def test_track_action
    tmux.send_keys "seq 1000 | #{FZF} --query 555 --bind t:track", :Enter
    tmux.until do |lines|
      assert_equal 1, lines.match_count
      assert_includes lines, '> 555'
    end
    tmux.send_keys :BSpace
    tmux.until do |lines|
      assert_equal 28, lines.match_count
      assert_includes lines, '> 55'
    end
    tmux.send_keys :t
    tmux.until do |lines|
      assert_includes lines[-2], '+T'
    end
    tmux.send_keys :BSpace
    tmux.until do |lines|
      assert_equal 271, lines.match_count
      assert_includes lines, '> 55'
    end

    # Automatically disabled when the tracking item is no longer visible
    tmux.send_keys '4'
    tmux.until do |lines|
      assert_equal 28, lines.match_count
      refute_includes lines[-2], '+T'
    end
    tmux.send_keys :BSpace
    tmux.until do |lines|
      assert_equal 271, lines.match_count
      assert_includes lines, '> 5'
    end
    tmux.send_keys :t
    tmux.until do |lines|
      assert_includes lines[-2], '+T'
    end
    tmux.send_keys :Up
    tmux.until do |lines|
      refute_includes lines[-2], '+T'
    end
  end

  def test_one_and_zero
    tmux.send_keys "seq 10 | #{FZF} --bind 'zero:preview(echo no match),one:preview(echo {} is the only match)'", :Enter
    tmux.send_keys '1'
    tmux.until do |lines|
      assert_equal 2, lines.match_count
      refute(lines.any? { _1.include?('only match') })
      refute(lines.any? { _1.include?('no match') })
    end
    tmux.send_keys '0'
    tmux.until do |lines|
      assert_equal 1, lines.match_count
      assert(lines.any? { _1.include?('only match') })
    end
    tmux.send_keys '0'
    tmux.until do |lines|
      assert_equal 0, lines.match_count
      assert(lines.any? { _1.include?('no match') })
    end
  end

  def test_height_range_with_exit_0
    tmux.send_keys "seq 10 | #{FZF} --height ~10% --exit-0", :Enter
    tmux.until { |lines| assert_equal 10, lines.item_count }
    tmux.send_keys :c
    tmux.until { |lines| assert_equal 0, lines.match_count }
  end

  def test_reload_and_change
    tmux.send_keys "(echo foo; echo bar) | #{FZF} --bind 'load:reload-sync(sleep 60)+change-query(bar)'", :Enter
    tmux.until { |lines| assert_equal 1, lines.match_count }
  end

  def test_reload_and_change_cache
    tmux.send_keys "echo bar | #{FZF} --bind 'zero:change-header(foo)+reload(echo foo)+clear-query'", :Enter
    expected = <<~OUTPUT
      > bar
        1/1
      >
    OUTPUT
    tmux.until { assert_block(expected, _1) }
    tmux.send_keys :z
    expected = <<~OUTPUT
      > foo
        foo
        1/1
      >
    OUTPUT
    tmux.until { assert_block(expected, _1) }
  end

  def test_delete_with_modifiers
    tmux.send_keys "seq 100 | #{FZF} --bind 'ctrl-delete:up+up,shift-delete:down,focus:transform-prompt:echo [{}]'", :Enter
    tmux.until { |lines| assert_equal 100, lines.item_count }
    tmux.send_keys 'C-Delete'
    tmux.until { |lines| assert_equal '[3]', lines[-1] }
    tmux.send_keys 'S-Delete'
    tmux.until { |lines| assert_equal '[2]', lines[-1] }
  end

  def test_become_tty
    tmux.send_keys "sleep 0.5 | #{FZF} --bind 'start:reload:ls' --bind 'load:become:tty'", :Enter
    tmux.until { |lines| assert_includes lines, '/dev/tty' }
  end

  def test_disabled_preview_update
    tmux.send_keys "echo bar | #{FZF} --disabled --bind 'change:reload:echo foo' --preview 'echo [{q}-{}]'", :Enter
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.until { |lines| assert(lines.any? { |line| line.include?('[-bar]') }) }
    tmux.send_keys :x
    tmux.until { |lines| assert(lines.any? { |line| line.include?('[x-foo]') }) }
  end
end

module TestShell
  def setup
    @tmux = Tmux.new(shell)
    tmux.prepare
  end

  def teardown
    @tmux.kill
  end

  def set_var(name, val)
    tmux.prepare
    tmux.send_keys "export #{name}='#{val}'", :Enter
    tmux.prepare
  end

  def unset_var(name)
    tmux.prepare
    tmux.send_keys "unset #{name}", :Enter
    tmux.prepare
  end

  def test_ctrl_t
    set_var('FZF_CTRL_T_COMMAND', 'seq 100')

    tmux.prepare
    tmux.send_keys 'C-t'
    tmux.until { |lines| assert_equal 100, lines.item_count }
    tmux.send_keys :Tab, :Tab, :Tab
    tmux.until { |lines| assert lines.any_include?(' (3)') }
    tmux.send_keys :Enter
    tmux.until { |lines| assert lines.any_include?('1 2 3') }
    tmux.send_keys 'C-c'
  end

  def test_ctrl_t_unicode
    writelines(tempname, ['fzf-unicode 테스트1', 'fzf-unicode 테스트2'])
    set_var('FZF_CTRL_T_COMMAND', "cat #{tempname}")

    tmux.prepare
    tmux.send_keys 'echo ', 'C-t'
    tmux.until { |lines| assert_equal 2, lines.item_count }
    tmux.send_keys 'fzf-unicode'
    tmux.until { |lines| assert_equal 2, lines.match_count }

    tmux.send_keys '1'
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal 1, lines.select_count }

    tmux.send_keys :BSpace
    tmux.until { |lines| assert_equal 2, lines.match_count }

    tmux.send_keys '2'
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal 2, lines.select_count }

    tmux.send_keys :Enter
    tmux.until { |lines| assert_match(/echo .*fzf-unicode.*1.* .*fzf-unicode.*2/, lines.join) }
    tmux.send_keys :Enter
    tmux.until { |lines| assert_equal 'fzf-unicode 테스트1 fzf-unicode 테스트2', lines[-1] }
  end

  def test_alt_c
    tmux.prepare
    tmux.send_keys :Escape, :c
    lines = tmux.until { |lines| assert_operator lines.match_count, :>, 0 }
    expected = lines.reverse.find { |l| l.start_with?('> ') }[2..]
    tmux.send_keys :Enter
    tmux.prepare
    tmux.send_keys :pwd, :Enter
    tmux.until { |lines| assert lines[-1]&.end_with?(expected) }
  end

  def test_alt_c_command
    set_var('FZF_ALT_C_COMMAND', 'echo /tmp')

    tmux.prepare
    tmux.send_keys 'cd /', :Enter

    tmux.prepare
    tmux.send_keys :Escape, :c
    tmux.until { |lines| assert_equal 1, lines.item_count }
    tmux.send_keys :Enter

    tmux.prepare
    tmux.send_keys :pwd, :Enter
    tmux.until { |lines| assert_equal '/tmp', lines[-1] }
  end

  def test_ctrl_r
    tmux.prepare
    tmux.send_keys 'echo 1st', :Enter
    tmux.prepare
    tmux.send_keys 'echo 2nd', :Enter
    tmux.prepare
    tmux.send_keys 'echo 3d', :Enter
    tmux.prepare
    3.times do
      tmux.send_keys 'echo 3rd', :Enter
      tmux.prepare
    end
    tmux.send_keys 'echo 4th', :Enter
    tmux.prepare
    tmux.send_keys 'C-r'
    tmux.until { |lines| assert_operator lines.match_count, :>, 0 }
    tmux.send_keys 'e3d'
    # Duplicates removed: 3d (1) + 3rd (1) => 2 matches
    tmux.until { |lines| assert_equal 2, lines.match_count }
    tmux.until { |lines| assert lines[-3]&.end_with?(' echo 3d') }
    tmux.send_keys 'C-r'
    tmux.until { |lines| assert lines[-3]&.end_with?(' echo 3rd') }
    tmux.send_keys :Enter
    tmux.until { |lines| assert_equal 'echo 3rd', lines[-1] }
    tmux.send_keys :Enter
    tmux.until { |lines| assert_equal '3rd', lines[-1] }
  end

  def test_ctrl_r_multiline
    tmux.send_keys 'echo "foo', :Enter, 'bar"', :Enter
    tmux.until { |lines| assert_equal %w[foo bar], lines[-2..] }
    tmux.prepare
    tmux.send_keys 'C-r'
    tmux.until { |lines| assert_equal '>', lines[-1] }
    tmux.send_keys 'foo bar'
    tmux.until { |lines| assert lines[-3]&.match?(/bar"␊?/) }
    tmux.send_keys :Enter
    tmux.until { |lines| assert lines[-1]&.match?(/bar"␊?/) }
    tmux.send_keys :Enter
    tmux.until { |lines| assert_equal %w[foo bar], lines[-2..] }
  end

  def test_ctrl_r_abort
    skip("doesn't restore the original line when search is aborted pre Bash 4") if shell == :bash && `#{Shell.bash} --version`[/(?<= version )\d+/].to_i < 4
    %w[foo ' "].each do |query|
      tmux.prepare
      tmux.send_keys :Enter, query
      tmux.until { |lines| assert lines[-1]&.start_with?(query) }
      tmux.send_keys 'C-r'
      tmux.until { |lines| assert_equal "> #{query}", lines[-1] }
      tmux.send_keys 'C-g'
      tmux.until { |lines| assert lines[-1]&.start_with?(query) }
    end
  end
end

module CompletionTest
  def test_file_completion
    FileUtils.mkdir_p('/tmp/fzf-test')
    FileUtils.mkdir_p('/tmp/fzf test')
    (1..100).each { |i| FileUtils.touch("/tmp/fzf-test/#{i}") }
    ['no~such~user', '/tmp/fzf test/foobar'].each do |f|
      FileUtils.touch(File.expand_path(f))
    end
    tmux.prepare
    tmux.send_keys 'cat /tmp/fzf-test/10**', :Tab
    tmux.until { |lines| assert_operator lines.match_count, :>, 0 }
    tmux.send_keys ' !d'
    tmux.until { |lines| assert_equal 2, lines.match_count }
    tmux.send_keys :Tab, :Tab
    tmux.until { |lines| assert_equal 2, lines.select_count }
    tmux.send_keys :Enter
    tmux.until(true) do |lines|
      assert_equal 'cat /tmp/fzf-test/10 /tmp/fzf-test/100', lines[-1]
    end

    # ~USERNAME**<TAB>
    user = `whoami`.chomp
    tmux.send_keys 'C-u'
    tmux.send_keys "cat ~#{user}**", :Tab
    tmux.until { |lines| assert_operator lines.match_count, :>, 0 }
    tmux.send_keys "/#{user}"
    tmux.until { |lines| assert(lines.any? { |l| l.end_with?("/#{user}") }) }
    tmux.send_keys :Enter
    tmux.until(true) do |lines|
      assert_match %r{cat .*/#{user}}, lines[-1]
    end

    # ~INVALID_USERNAME**<TAB>
    tmux.send_keys 'C-u'
    tmux.send_keys 'cat ~such**', :Tab
    tmux.until(true) { |lines| assert lines.any_include?('no~such~user') }
    tmux.send_keys :Enter
    tmux.until(true) { |lines| assert_equal 'cat no~such~user', lines[-1] }

    # /tmp/fzf\ test**<TAB>
    tmux.send_keys 'C-u'
    tmux.send_keys 'cat /tmp/fzf\ test/**', :Tab
    tmux.until { |lines| assert_operator lines.match_count, :>, 0 }
    tmux.send_keys 'foobar$'
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys :Enter
    tmux.until(true) { |lines| assert_equal 'cat /tmp/fzf\ test/foobar', lines[-1] }

    # Should include hidden files
    (1..100).each { |i| FileUtils.touch("/tmp/fzf-test/.hidden-#{i}") }
    tmux.send_keys 'C-u'
    tmux.send_keys 'cat /tmp/fzf-test/hidden**', :Tab
    tmux.until(true) do |lines|
      assert_equal 100, lines.match_count
      assert lines.any_include?('/tmp/fzf-test/.hidden-')
    end
    tmux.send_keys :Enter
  ensure
    ['/tmp/fzf-test', '/tmp/fzf test', '~/.fzf-home', 'no~such~user'].each do |f|
      FileUtils.rm_rf(File.expand_path(f))
    end
  end

  def test_file_completion_root
    tmux.send_keys 'ls /**', :Tab
    tmux.until { |lines| assert_operator lines.match_count, :>, 0 }
    tmux.send_keys :Enter
  end

  def test_dir_completion
    (1..100).each do |idx|
      FileUtils.mkdir_p("/tmp/fzf-test/d#{idx}")
    end
    FileUtils.touch('/tmp/fzf-test/d55/xxx')
    tmux.prepare
    tmux.send_keys 'cd /tmp/fzf-test/**', :Tab
    tmux.until { |lines| assert_operator lines.match_count, :>, 0 }
    tmux.send_keys :Tab, :Tab # Tab does not work here
    tmux.send_keys 55
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys :Enter
    tmux.until(true) { |lines| assert_equal 'cd /tmp/fzf-test/d55/', lines[-1] }
    tmux.send_keys :xx
    tmux.until { |lines| assert_equal 'cd /tmp/fzf-test/d55/xx', lines[-1] }

    # Should not match regular files (bash-only)
    if instance_of?(TestBash)
      tmux.send_keys :Tab
      tmux.until { |lines| assert_equal 'cd /tmp/fzf-test/d55/xx', lines[-1] }
    end

    # Fail back to plusdirs
    tmux.send_keys :BSpace, :BSpace, :BSpace
    tmux.until { |lines| assert_equal 'cd /tmp/fzf-test/d55', lines[-1] }
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal 'cd /tmp/fzf-test/d55/', lines[-1] }
  end

  def test_process_completion
    tmux.send_keys 'sleep 12345 &', :Enter
    lines = tmux.until { |lines| assert lines[-1]&.start_with?('[1] ') }
    pid = lines[-1]&.split&.last
    tmux.prepare
    tmux.send_keys 'C-L'
    tmux.send_keys 'kill **', :Tab
    tmux.until { |lines| assert_operator lines.match_count, :>, 0 }
    tmux.send_keys 'sleep12345'
    tmux.until { |lines| assert lines.any_include?('sleep 12345') }
    tmux.send_keys :Enter
    tmux.until(true) { |lines| assert_equal "kill #{pid}", lines[-1] }
  ensure
    if pid
      begin
        Process.kill('KILL', pid.to_i)
      rescue StandardError
        nil
      end
    end
  end

  def test_custom_completion
    tmux.send_keys '_fzf_compgen_path() { echo "$1"; seq 10; }', :Enter
    tmux.prepare
    tmux.send_keys 'ls /tmp/**', :Tab
    tmux.until { |lines| assert_equal 11, lines.match_count }
    tmux.send_keys :Tab, :Tab, :Tab
    tmux.until { |lines| assert_equal 3, lines.select_count }
    tmux.send_keys :Enter
    tmux.until(true) { |lines| assert_equal 'ls /tmp 1 2', lines[-1] }
  end

  def test_unset_completion
    tmux.send_keys 'export FZFFOOBAR=BAZ', :Enter
    tmux.prepare

    # Using tmux
    tmux.send_keys 'unset FZFFOOBR**', :Tab
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys :Enter
    tmux.until { |lines| assert_equal 'unset FZFFOOBAR', lines[-1] }
    tmux.send_keys 'C-c'

    # FZF_TMUX=1
    new_shell
    tmux.focus
    tmux.send_keys 'unset FZFFOOBR**', :Tab
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys :Enter
    tmux.until { |lines| assert_equal 'unset FZFFOOBAR', lines[-1] }
  end

  def test_file_completion_unicode
    FileUtils.mkdir_p('/tmp/fzf-test')
    tmux.paste "cd /tmp/fzf-test; echo test3 > $'fzf-unicode \\355\\205\\214\\354\\212\\244\\355\\212\\2701'; echo test4 > $'fzf-unicode \\355\\205\\214\\354\\212\\244\\355\\212\\2702'"
    tmux.prepare
    tmux.send_keys 'cat fzf-unicode**', :Tab
    tmux.until { |lines| assert_equal 2, lines.match_count }

    tmux.send_keys '1'
    tmux.until { |lines| assert_equal 1, lines.match_count }
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal 1, lines.select_count }

    tmux.send_keys :BSpace
    tmux.until { |lines| assert_equal 2, lines.match_count }

    tmux.send_keys '2'
    tmux.until { |lines| assert_equal 1, lines.select_count }
    tmux.send_keys :Tab
    tmux.until { |lines| assert_equal 2, lines.select_count }

    tmux.send_keys :Enter
    tmux.until(true) { |lines| assert_match(/cat .*fzf-unicode.*1.* .*fzf-unicode.*2/, lines[-1]) }
    tmux.send_keys :Enter
    tmux.until { |lines| assert_equal %w[test3 test4], lines[-2..] }
  end

  def test_custom_completion_api
    tmux.send_keys 'eval "_fzf$(declare -f _comprun)"', :Enter
    %w[f g].each do |command|
      tmux.prepare
      tmux.send_keys "#{command} b**", :Tab
      tmux.until do |lines|
        assert_equal 2, lines.item_count
        assert_equal 1, lines.match_count
        assert lines.any_include?("prompt-#{command}")
        assert lines.any_include?("preview-#{command}-bar")
      end
      tmux.send_keys :Enter
      tmux.until { |lines| assert_equal "#{command} #{command}barbar", lines[-1] }
      tmux.send_keys 'C-u'
    end
  ensure
    tmux.prepare
    tmux.send_keys 'unset -f _fzf_comprun', :Enter
  end
end

class TestBash < TestBase
  include TestShell
  include CompletionTest

  def shell
    :bash
  end

  def new_shell
    tmux.prepare
    tmux.send_keys "FZF_TMUX=1 #{Shell.bash}", :Enter
    tmux.prepare
  end

  def test_dynamic_completion_loader
    tmux.paste 'touch /tmp/foo; _fzf_completion_loader=1'
    tmux.paste '_completion_loader() { complete -o default fake; }'
    tmux.paste 'complete -F _fzf_path_completion -o default -o bashdefault fake'
    tmux.send_keys 'fake /tmp/foo**', :Tab
    tmux.until { |lines| assert_operator lines.match_count, :>, 0 }
    tmux.send_keys 'C-c'

    tmux.prepare
    tmux.send_keys 'fake /tmp/foo'
    tmux.send_keys :Tab, 'C-u'

    tmux.prepare
    tmux.send_keys 'fake /tmp/foo**', :Tab
    tmux.until { |lines| assert_operator lines.match_count, :>, 0 }
  end
end

class TestZsh < TestBase
  include TestShell
  include CompletionTest

  def shell
    :zsh
  end

  def new_shell
    tmux.send_keys "FZF_TMUX=1 #{Shell.zsh}", :Enter
    tmux.prepare
  end

  def test_complete_quoted_command
    tmux.send_keys 'export FZFFOOBAR=BAZ', :Enter
    ['unset', '\unset', "'unset'"].each do |command|
      tmux.prepare
      tmux.send_keys "#{command} FZFFOOBR**", :Tab
      tmux.until { |lines| assert_equal 1, lines.match_count }
      tmux.send_keys :Enter
      tmux.until { |lines| assert_equal "#{command} FZFFOOBAR", lines[-1] }
      tmux.send_keys 'C-c'
    end
  end
end

class TestFish < TestBase
  include TestShell

  def shell
    :fish
  end

  def new_shell
    tmux.send_keys 'env FZF_TMUX=1 FZF_DEFAULT_OPTS=--no-scrollbar fish', :Enter
    tmux.send_keys 'function fish_prompt; end; clear', :Enter
    tmux.until { |lines| assert_empty lines }
  end

  def set_var(name, val)
    tmux.prepare
    tmux.send_keys "set -g #{name} '#{val}'", :Enter
    tmux.prepare
  end
end

__END__
set -u
PS1= PROMPT_COMMAND= HISTFILE= HISTSIZE=100
unset <%= UNSETS.join(' ') %>
unset $(env | sed -n /^_fzf_orig/s/=.*//p)
unset $(declare -F | sed -n "/_fzf/s/.*-f //p")

export FZF_DEFAULT_OPTS=--no-scrollbar

# Setup fzf
# ---------
if [[ ! "$PATH" == *<%= BASE %>/bin* ]]; then
  export PATH="${PATH:+${PATH}:}<%= BASE %>/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "<%= BASE %>/shell/completion.<%= __method__ %>" 2> /dev/null

# Key bindings
# ------------
source "<%= BASE %>/shell/key-bindings.<%= __method__ %>"

# Old API
_fzf_complete_f() {
  _fzf_complete "+m --multi --prompt \"prompt-f> \"" "$@" < <(
    echo foo
    echo bar
  )
}

# New API
_fzf_complete_g() {
  _fzf_complete +m --multi --prompt "prompt-g> " -- "$@" < <(
    echo foo
    echo bar
  )
}

_fzf_complete_f_post() {
  awk '{print "f" $0 $0}'
}

_fzf_complete_g_post() {
  awk '{print "g" $0 $0}'
}

[ -n "${BASH-}" ] && complete -F _fzf_complete_f -o default -o bashdefault f
[ -n "${BASH-}" ] && complete -F _fzf_complete_g -o default -o bashdefault g

_comprun() {
  local command=$1
  shift

  case "$command" in
    f) fzf "$@" --preview 'echo preview-f-{}' ;;
    g) fzf "$@" --preview 'echo preview-g-{}' ;;
    *) fzf "$@" ;;
  esac
}
./typos.toml	[[[1
6
# See https://github.com/crate-ci/typos/blob/master/docs/reference.md to configure typos
[default.extend-words]
ba = "ba"
fo = "fo"
enew = "enew"
tabe = "tabe"
./uninstall	[[[1
113
#!/usr/bin/env bash

xdg=0
prefix='~/.fzf'
prefix_expand=~/.fzf
fish_dir=${XDG_CONFIG_HOME:-$HOME/.config}/fish

help() {
  cat << EOF
usage: $0 [OPTIONS]

    --help               Show this message
    --xdg                Remove files generated under \$XDG_CONFIG_HOME/fzf
EOF
}

for opt in "$@"; do
  case $opt in
    --help)
      help
      exit 0
      ;;
    --xdg)
      xdg=1
      prefix='"${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf'
      prefix_expand=${XDG_CONFIG_HOME:-$HOME/.config}/fzf/fzf
      ;;
    *)
      echo "unknown option: $opt"
      help
      exit 1
      ;;
  esac
done

ask() {
  while true; do
    read -p "$1 ([y]/n) " -r
    REPLY=${REPLY:-"y"}
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      return 0
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      return 1
    fi
  done
}

remove() {
  echo "Remove $1"
  rm -f "$1"
}

remove_line() {
  src=$1
  echo "Remove from $1:"

  shift
  line_no=1
  match=0
  while [ -n "$1" ]; do
    line=$(sed -n "$line_no,\$p" "$src" | \grep -m1 -nF "$1")
    if [ $? -ne 0 ]; then
      shift
      line_no=1
      continue
    fi
    line_no=$(( $(sed 's/:.*//' <<< "$line") + line_no - 1 ))
    content=$(sed 's/^[0-9]*://' <<< "$line")
    match=1
    echo    "  - Line #$line_no: $content"
    [ "$content" = "$1" ] || ask "    - Remove?"
    if [ $? -eq 0 ]; then
      temp=$(mktemp)
      awk -v n=$line_no 'NR == n {next} {print}' "$src" > "$temp" &&
        cat "$temp" > "$src" && rm -f "$temp" || break
      echo  "      - Removed"
    else
      echo  "      - Skipped"
      line_no=$(( line_no + 1 ))
    fi
  done
  [ $match -eq 0 ] && echo "  - Nothing found"
  echo
}

for shell in bash zsh; do
  shell_config=${prefix_expand}.${shell}
  remove "${shell_config}"
  remove_line ~/.${shell}rc \
    "[ -f ${prefix}.${shell} ] && source ${prefix}.${shell}" \
    "source ${prefix}.${shell}"
done

bind_file="${fish_dir}/functions/fish_user_key_bindings.fish"
if [ -f "$bind_file" ]; then
  remove_line "$bind_file" "fzf_key_bindings"
fi

if [ -d "${fish_dir}/functions" ]; then
  remove "${fish_dir}/functions/fzf.fish"
  remove "${fish_dir}/functions/fzf_key_bindings.fish"

  if [ -z "$(ls -A "${fish_dir}/functions")" ]; then
    rmdir "${fish_dir}/functions"
  else
    echo "Can't delete non-empty directory: \"${fish_dir}/functions\""
  fi
fi

config_dir=$(dirname "$prefix_expand")
if [[ "$xdg" = 1 ]] && [[ "$config_dir" = */fzf ]] && [[ -d "$config_dir" ]]; then
  rmdir "$config_dir"
fi
