# zshrc
> A *somewhat opinionated* Modularised ZSH configuration

*Mainly for use by me* ***because I find it to be a pain in the arse*** when I'm in an enviroment with an unconfigured shell and have to spend too much time on configuration.

To resolve this issue I have decided to modularise, and make my zsh more maintainable, and easy to setup.

This is done using a simple `bootstrap.zsh` script, and still uses the standard `.zshrc` only for this instance, it serves simply as an entry point.

Currently I've only got it optimized for a CLI on a Mac system, however I intend to expand this to most POSIX systems in due time.

- Uses antigen.zsh as a plugin manager. 
- Requires the following packages:
  - zsh
  - curl
  - package manager (homebrew if mac)

> Feel free to create a PR if you think you have something to add.

--- 

## How to Run

Clone the Repository

```shell
git clone https://github.com/nuclearBulldog/zshrc.git
```

Make the Startup Script Executable

```shell
chmod +x zshrc/bootstrap.zsh
```

Run the Startup Script

```shell
zsh zshrc/bootstrap.zsh
```

Restart ZSH

```shell
exec zsh
```
