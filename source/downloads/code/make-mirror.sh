#!/bin/bash

set -x

if [ "$1" = "" ]; then
  echo "Usage: $0 [repo]"
  exit 1
fi

REPO=$1.git
GIT_BASE=/home/git/repositories
MIRROR_PATH=/home/jxb/git-mirrors
REPO_PATH=$MIRROR_PATH/$REPO

# 我們要使用 git clone --mirror 建立一個原始 repo 的鏡像：
cd $MIRROR_PATH && git clone --mirror $GIT_BASE/$REPO

# 接下來下一步，由於之後 git 使用者會透過 post-receive hook 來同步兩個 repository，
# 我們直接修改這個境像 repository 的 owner / group 為 git 來讓它有讀寫權限。
chown -R git:git $REPO_PATH

# 再來我們要設定原本 repo 的 hooks ：
cd $GIT_BASE/$REPO/hooks

cat > post-receive <<EOS
#!/bin/bash
/usr/bin/git push --mirror $REPO_PATH
EOS

# 建立完 post-receive 檔案後修改權限：
chown git:git post-receive
chmod 700 post-receive

# 由於 Git 在做 mirror push 的時候，會保留原始的檔案與資料夾存取權限，
# 在 gitolite 控管下，只有 owner 有讀寫權限，所以一做 mirror push 這個鏡像的 repository 就沒辦法被其他 process 讀取到了，
# 所以我們一開始就要告訴這個 mirror repository 它是被分享的，並且設定它應該要有的存取權限：
sudo -u git sh <<EOS
set -x
cd $REPO_PATH
chmod a+rX -R ./
git config --add core.sharedRepository 644
EOS
