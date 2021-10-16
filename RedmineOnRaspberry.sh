#Raspbian OS un lite versiyonu olan image dosyasýný yüklüyoruz. 
#Sadece konsol üzerinden eriþeceðimiz için desktop versiyonunu tercih etmedim.
#Aþaðýdaki komutlar ile RPI cihazýn güncellemelerini yükleyin.

sudo apt-get update && sudo apt-get upgrade

#Docker kuruyoruz.
curl -sSL https://get.docker.com | sh

#pi kullanýcýsýný docker a tanýtýyoruz.
sudo usermod -aG docker pi

#þimdi ileride kuracaðýmýz stack için docker-compose kuruyoruz.

sudo apt-get install libffi-dev libssl-dev
sudo apt install python3-dev
sudo apt-get install -y python3 python3-pip

sudo pip3 install docker-compose

#docker kurulduktan sonra docker image lerininin web üzerinden güncellenmesi ve bakýmý ve performansý gözlemlemek için portainer kuruyoruz.(isteðe baðlýdýr)
sudo docker pull portainer/portainer-ce:linux-arm
sudo docker run --restart always -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:linux-arm

#Time zone ayarlýyoruz.
sudo dpkg-reconfigure tzdata

#yeni bir git kullanýcý tanýmlýyoruz.
sudo adduser --disabled-login --gecos 'Gitea' git

#Gitea için oluþtutulan git kullanýcýsýný docker a tanýtýyoruz.
sudo usermod -aG docker git

#oluþturduðumuz git kullanýcýsý kontrol ediyoruz 2. satýrdaki cevabý almamýz gerekiyor.
sudo -u git id
=>  uid=1001(git) gid=1001(git) groups=1001(git) 

#Þimdi USB disk için bir dosya adresi oluþturup izinlerini alýyoruz.
sudo mkdir /mnt/git
sudo chown -R git:git /mnt/git
sudo chmod -R 775 /mnt/git

#Aþaðýdaki kodu çalýþtýrýp mount edilecek USB diskin UUID sini kopyalýyoruz.
sudo blkid

#Þimdi kopyaladýðýmýz UUID verisi ile aþaðýdaki satýrý güncelliyoruz ve fstab dosyasýnýn altýna ekliyoruz.
#UUID=00F60E97F60E8D5A     /mnt/git     ntfs-3g      uid=1001,gid=1001,umask=002 0 0
sudo nano /etc/fstab

#aþaðýdaki komut ile usb cihazý mount ediyoruz.
sudo mount -a

#þimdi USB cihazýn mount listesinde olup olmadýðýný kontrol ediyoruz.
sudo mount -fav

#gelen cevap bu olmalý;
#/proc                         : already mounted
#/boot                         : already mounted
#/                             : ignored
#/mnt/git                      : successfully mounted <<<<< !!!!


#Gitea doker compose için açmýþ olduðumuz git kullanýcýna atlýyoruz.
sudo su - git 

#bir dosya oluþturuyor ve içine giriyoruz.
mkdir redmine
cd redmine

#aþaðýdaki kodu çalýþtýrýnca karþýmýza nano text editör yeni bir sayfa getirecek. buraya repo içindeki "docker-compose.yml" isimli dosyanýn tamamýný kopyalayýp yapýþtýrýyoruz.
nano docker-compose.yml
# kaydetmek için ctrl + O tuþluyoruz devamýnda enter daha sonra dosyadan çýkmak için ctrl + X tuþluyoruz.

#Son olarak docker stack dosyamýzý çalýþtýrýyoruz. 
docker-compose up -d

#Git user den çýkmak için "exit" yazabilirsiniz.

#kurulum tamamlandýktan sonra http://<local_ipadres>:5000 adresinden gitea kurulum sayfasýný çaðýrabilirsiniz.

#Þimdi ayarlarý web üzerinden tamamlamak için readme.md dosyasýna geçiyoruz.