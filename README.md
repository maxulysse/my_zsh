# myZSH

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
chsh -s /bin/zsh user
```
Install antigen
```bash
git clone https://github.com/zsh-users/antigen.git ~/antigen
```
Copy my .zshrc and .alias files
```bash
curl https://raw.githubusercontent.com/MaxUlysse/myzsh/master/.zshrc -o ~/.zshrc
curl https://raw.githubusercontent.com/MaxUlysse/myzsh/master/.alias -o ~/.alias
```

Include theme based on https://github.com/CodeMonkeyMike/ZshTheme-CodeMachine

## Credits
- [linuxg.net](http://linuxg.net/how-to-install-zsh-shell-how-to-set-it-as-a-default-login-shell/)
- [github.com/robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
- [github.com/zsh-users/antigen](https://github.com/zsh-users/antigen)
