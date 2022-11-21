# my_zsh

Check if zsh is already installed

```bash
grep zsh /etc/shells
```

If you got something like that, skip the Download and install step:

```bash
/bin/zsh  
/usr/bin/zsh
```

Download and install the Z shell

```bash
sudo apt-get install zsh
```

Set zsh as the default login shell

```bash
chsh -s /bin/zsh ${USER}
```

Install antigen

```bash
git clone https://github.com/zsh-users/antigen.git ${WORKSPACE}/antigen
```

Install Liquidprompt

```bash
git clone https://github.com/nojhan/liquidprompt.git ${WORKSPACE}/liquidprompt
```

Install DotMatrix

```bash
git clone https://github.com/nojhan/lp-dotmatrix.git ${WORKSPACE}/lp-dotmatrix
```

Copy my .zshrc and .alias files

```bash
curl https://raw.githubusercontent.com/maxulysse/myzsh/main/.zshrc -o ${HOME}/.zshrc
curl https://raw.githubusercontent.com/maxulysse/myzsh/main/.alias -o ${HOME}/.alias
```

## Credits

- [linuxg.net](http://linuxg.net/how-to-install-zsh-shell-how-to-set-it-as-a-default-login-shell/)
- [github.com/robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
- [github.com/zsh-users/antigen](https://github.com/zsh-users/antigen)
- [github.com/nojhan/liquidprompt](https://github.com/nojhan/liquidprompt)
- [github.com/nojhan/lp-dotmatrix](https://github.com/nojhan/lp-dotmatrix)
