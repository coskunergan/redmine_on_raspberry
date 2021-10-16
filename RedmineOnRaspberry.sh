#Raspbian OS un lite versiyonu olan image dosyas�n� y�kl�yoruz. 
#Sadece konsol �zerinden eri�ece�imiz i�in desktop versiyonunu tercih etmedim.
#A�a��daki komutlar ile RPI cihaz�n g�ncellemelerini y�kleyin.

sudo apt-get update && sudo apt-get upgrade

#Docker kuruyoruz.
curl -sSL https://get.docker.com | sh

#pi kullan�c�s�n� docker a tan�t�yoruz.
sudo usermod -aG docker pi

#�imdi ileride kuraca��m�z stack i�in docker-compose kuruyoruz.

sudo apt-get install libffi-dev libssl-dev
sudo apt install python3-dev
sudo apt-get install -y python3 python3-pip

sudo pip3 install docker-compose

#docker kurulduktan sonra docker image lerininin web �zerinden g�ncellenmesi ve bak�m� ve performans� g�zlemlemek i�in portainer kuruyoruz.(iste�e ba�l�d�r)
sudo docker pull portainer/portainer-ce:linux-arm
sudo docker run --restart always -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:linux-arm

#Time zone ayarl�yoruz.
sudo dpkg-reconfigure tzdata

#yeni bir git kullan�c� tan�ml�yoruz.
sudo adduser --disabled-login --gecos 'Gitea' git

#Gitea i�in olu�tutulan git kullan�c�s�n� docker a tan�t�yoruz.
sudo usermod -aG docker git

#olu�turdu�umuz git kullan�c�s� kontrol ediyoruz 2. sat�rdaki cevab� almam�z gerekiyor.
sudo -u git id
=>  uid=1001(git) gid=1001(git) groups=1001(git) 

#�imdi USB disk i�in bir dosya adresi olu�turup izinlerini al�yoruz.
sudo mkdir /mnt/git
sudo chown -R git:git /mnt/git
sudo chmod -R 775 /mnt/git

#A�a��daki kodu �al��t�r�p mount edilecek USB diskin UUID sini kopyal�yoruz.
sudo blkid

#�imdi kopyalad���m�z UUID verisi ile a�a��daki sat�r� g�ncelliyoruz ve fstab dosyas�n�n alt�na ekliyoruz.
#UUID=00F60E97F60E8D5A     /mnt/git     ntfs-3g      uid=1001,gid=1001,umask=002 0 0
sudo nano /etc/fstab

#a�a��daki komut ile usb cihaz� mount ediyoruz.
sudo mount -a

#�imdi USB cihaz�n mount listesinde olup olmad���n� kontrol ediyoruz.
sudo mount -fav

#gelen cevap bu olmal�;
#/proc                         : already mounted
#/boot                         : already mounted
#/                             : ignored
#/mnt/git                      : successfully mounted <<<<< !!!!


#Gitea doker compose i�in a�m�� oldu�umuz git kullan�c�na atl�yoruz.
sudo su - git 

#bir dosya olu�turuyor ve i�ine giriyoruz.
mkdir redmine
cd redmine

#a�a��daki kodu �al��t�r�nca kar��m�za nano text edit�r yeni bir sayfa getirecek. buraya repo i�indeki "docker-compose.yml" isimli dosyan�n tamam�n� kopyalay�p yap��t�r�yoruz.
nano docker-compose.yml
# kaydetmek i�in ctrl + O tu�luyoruz devam�nda enter daha sonra dosyadan ��kmak i�in ctrl + X tu�luyoruz.

#Son olarak docker stack dosyam�z� �al��t�r�yoruz. 
docker-compose up -d

#Git user den ��kmak i�in "exit" yazabilirsiniz.

#kurulum tamamland�ktan sonra http://<local_ipadres>:5000 adresinden gitea kurulum sayfas�n� �a��rabilirsiniz.

#�imdi ayarlar� web �zerinden tamamlamak i�in readme.md dosyas�na ge�iyoruz.