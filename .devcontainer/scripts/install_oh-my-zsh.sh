#!/bin/bash

set -e  # 如果有任何命令失败，则退出

# 定义环境变量
is_linux=false
is_wsl2=false
is_macos=false
is_freebsd=false
is_openbsd=false
is_netbsd=false
is_cygwin=false
is_git_bash=false
is_msys2=false

# Linux 发行版变量
is_debian_based=false
is_arch_based=false
is_rhel_based=false
is_suse_based=false
is_gentoo_based=false

# 检测操作系统
case "$OSTYPE" in
    linux-gnu*)
        is_linux=true
        if grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null; then
            is_wsl2=true
        fi
        # 检测 Linux 发行版
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                debian|ubuntu|kali|mint|elementary|zorin|deepin)
                    is_debian_based=true
                    ;;
                arch|manjaro|endeavouros)
                    is_arch_based=true
                    ;;
                rhel|centos|fedora|rocky|alma)
                    is_rhel_based=true
                    ;;
                opensuse*|sles)
                    is_suse_based=true
                    ;;
                gentoo)
                    is_gentoo_based=true
                    ;;
            esac
        fi
        ;;
    darwin*)
        is_macos=true
        ;;
    freebsd*)
        is_freebsd=true
        ;;
    openbsd*)
        is_openbsd=true
        ;;
    netbsd*)
        is_netbsd=true
        ;;
    cygwin)
        is_cygwin=true
        ;;
    msys)
        if [[ "$MSYSTEM" == "MINGW64" || "$MSYSTEM" == "MINGW32" ]]; then
            is_git_bash=true
        else
            is_msys2=true
        fi
        ;;
    *)
        echo "未知的操作系统"
        exit 1
esac

# 安装软件包的函数
spi() {
    if [ $# -eq 0 ]; then
        echo "没有指定要安装的软件包。"
        return 1
    fi

    if $is_debian_based; then
        sudo apt update && sudo apt install -y "$@"
    elif $is_arch_based; then
        sudo pacman -S --needed --noconfirm "$@"
    elif $is_rhel_based; then
        sudo dnf install -y "$@"
    elif $is_suse_based; then
        sudo zypper install -y "$@"
    elif $is_gentoo_based; then
        sudo emerge "$@"
    elif $is_freebsd; then
        sudo pkg install -y "$@"
    elif $is_openbsd || $is_netbsd; then
        sudo pkg_add "$@"
    elif $is_macos; then
        brew install "$@"
    elif $is_msys2; then
        pacman -S --needed --noconfirm "$@"
    elif $is_git_bash; then
        gsudo pacman -S --needed --noconfirm --overwrite="*" "$@"
    else
        echo "不支持的软件包安装系统"
        return 1
    fi
}

# 检查并安装 zsh、curl 和 git
echo "检查必要的依赖..."
for package in zsh curl git; do
    if ! command -v $package &>/dev/null; then
        echo "$package 未安装，正在安装..."
        spi "$package"
    else
        echo "$package 已安装。"
    fi
done

# 安装 Oh My Zsh
echo "正在安装 Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安装插件
echo "正在安装插件..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 添加插件到.zshrc
echo "正在添加插件到.zshrc..."
sed -i 's/^plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# 添加alias到.zshrc
echo "正在添加alias到.zshrc..."
echo "alias ls='ls --color=auto'" >> ~/.zshrc
echo "alias ll='ls -lh --color=auto'" >> ~/.zshrc
echo "alias la='ls -lah --color=auto'" >> ~/.zshrc
echo "alias grep='grep --color=auto'" >> ~/.zshrc
echo "alias fgrep='fgrep --color=auto'" >> ~/.zshrc
echo "alias egrep='egrep --color=auto'" >> ~/.zshrc
echo "alias md='mkdir -p'" >> ~/.zshrc
echo "alias rd='rmdir'" >> ~/.zshrc
echo "alias g='git'" >> ~/.zshrc
echo "alias gst='git status'" >> ~/.zshrc
echo "alias glg='git log --graph --oneline --all --decorate --color=auto'" >> ~/.zshrc
echo "alias gpl='git pull'" >> ~/.zshrc
echo "alias gph='git push'" >> ~/.zshrc
echo "alias gplr='git pull --rebase'" >> ~/.zshrc
echo "alias gco='git checkout'" >> ~/.zshrc
echo "alias gbr='git branch'" >> ~/.zshrc
echo "alias gcm='git commit -m'" >> ~/.zshrc
echo "alias gcmm='git commit -m'" >> ~/.zshrc
echo "alias gcam='git commit --amend -m'" >> ~/.zshrc
echo "alias gplm='git pull && git merge'" >> ~/.zshrc
echo "alias glog='git log --oneline --graph --decorate --color=auto'" >> ~/.zshrc
echo "alias gdiff='git diff --color=auto'" >> ~/.zshrc
echo "alias gblame='git blame --color=auto'" >> ~/.zshrc
echo "alias gpush='git push'" >> ~/.zshrc
echo "alias gpull='git pull'" >> ~/.zshrc
echo "alias gsh='git stash'" >> ~/.zshrc
echo "alias gstash='git stash'" >> ~/.zshrc




echo "安装完成！"
