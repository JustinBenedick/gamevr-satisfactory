sudo apt get update
sudo dpkg --add-architecture i386
sudo add-apt-repository multiverse
sudo apt install -y curl git libc6-i386 lib32gcc1 lib32stdc++6 lib32tinfo5 lib32z1 unzip tar wget libstdc++6 libstdc++6:i386 gdb libcurl4-gnutls-dev:i386
mkdir -p ~/gameserver/util/steamcmd/
cd ~/gameserver/util/steamcmd/
wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" 
tar -xvzf steamcmd_linux.tar.gz
~/gameserver/util/steamcmd/steamcmd.sh +login anonymous +quit
cd ~
mkdir .steam
cd .steam
mkdir sdk32
cd sdk32
ln -s /home/sysoper/gameserver/bin/steamclient.so
cd ~
cd /
sudo mkdir app
sudo chown sysoper app

