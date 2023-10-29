## Milis Linux+Nginx+PHP+MariaDB+PostgreSQL (NPMP) Kurulumu
### Nginx Kurulumu
Nginx paketinin kurulması
```
mps kur nginx
```
Nginx servisinin eklenmesi
```
servis ekle nginx
```
Nginx servisinin çalıştırılması
```
servis kos nginx
```
Test için `netstat -ntpl` çıktısında 80 portunun dinlendiği görülmelidir.

Tarayıcıdan http://localhost sayfası açıldığında it works sayfası görülecektir.


**Geliştirme ortamınıza göre veritabanı sistemlerinden birini tercih ederek ilgili ayarları yapınız**


### PostgreSQL Kurulumu
PostgreSQL paketinin kurulması
```
mps kur postgresql
```
PostgreSQL servisinin eklenmesi
```
servis ekle postgresql
```
PostgreSQL servisinin çalıştırılması
```
servis kos postgresql
```
Test için `netstat -ntpl` çıktısında TCP 5432 portunun dinlendiği görülmelidir.

PostgreSQL e yetkili giriş
```
psql -U postgres
```
Veritabanı, kullanıcı oluşturulması ve yetki tanımlanması
```
postgres=# create database vt1;
postgres=# create user deneme with password 'denemepasswd';
postgres=# grant all privileges on database vt1 to deneme;
postgres=# \q
```

### MariaDB(MySQL) Kurulumu
Maridb paketinin kurulması
```
mps kur mariadb
```
Mysql servisinin eklenmesi
```
servis ekle mysql
```
Dinleme IP'nin ayarlanması için `/etc/my.cnf` dosyasına aşağıdaki satır eklenir.
```
[mysqld]
bind-address=0.0.0.0
```
Mysql servisinin çalıştırılması
```
servis kos mysql
```
Test için `netstat -ntpl` çıktısında TCP 3306 portunun dinlendiği görülmelidir.

Mysql e yetkili giriş
```
sudo mysql
```
Veritabanı, kullanıcı oluşturulması ve yetki tanımlanması
```
Mariadb [(none)]> create database vt1;
MariaDB [(none)]> create user 'deneme'@'localhost' identified by 'denemepasswd';
MariaDB [(none)]> grant all privileges on vt1.* to 'deneme'@'localhost'
MariaDB [(none)]> exit
```

### PHP Kurulması
PHP paketinin kurulması
```
mps kur php
```
Nginx ile PHP haberleşmesi için php-fpm servisinin eklenmesi ve çalıştırılması
```
servis ekle php-fpm
servis kos php-fpm
```
Test için `netstat -ntpl` çıktısında 9000 portunun dinlendiği görülmelidir.
Tarayıcıdan http://localhost/info.php sayfası açıldığında PHP kurulum bilgileri gelecektir.


### PHP-PostgreSQL PDO Eklentisinin Etkinleştirilmesi
/etc/php/php.ini dosyasında aşağıdaki satırlar yorumdan çıkarılır.
```
extension=pdo_pgsql
extension=pgsql
```
Bu düzenlemeden sonra php-fpm servisi tekrar başlatılır.
```
servis dur php-fpm
servis kos php-fpm
```
Tarayıcıda http://localhost/info.php sayfasında PDO kısmında driver pgsql eklenmiş olmalıdır.
Altında ise pdo_pgsql kısmı da eklenmiş olarak görülecektir.


### PHP-MYSQL PDO Eklentisinin Etkinleştirilmesi
/etc/php/php.ini dosyasında aşağıdaki satır yorumdan çıkarılır.
```
extension=pdo_mysql
```
Bu düzenlemeden sonra php-fpm servisi tekrar başlatılır.
```
servis dur php-fpm
servis kos php-fpm
```
Tarayıcıda http://localhost/info.php sayfasında PDO kısmında driver mysql eklenmiş olmalıdır.
Altında ise pdo_mysql kısmı da eklenmiş olarak görülecektir.

### PHP-MYSQL Bağlantı Testi
Aşağıdaki kod /var/www/mysqltest.php olarak kayıt edildikten sonra tarayıcıdan test edilir.
```
<?php 
$host="localhost";
$user="deneme";
$password="denemepasswd";

$conn=new PDO("mysql:host=$host;dbname=vt1",$user,$password);

if ($conn->connect_error){
  die("vt bağlantı hatası - " . $conn->connect_error);
}

echo "vt bağlantı başarılı";
?>
```

### PHP-PostgreSQL Bağlantı Testi
Aşağıdaki kod /var/www/pgtest.php olarak kayıt edildikten sonra tarayıcıdan test edilir.
```
<?php 
   $host        = "host = 127.0.0.1";
   $port        = "port = 5432";
   $db          = "dbname = vt1";
   $credentials = "user = deneme password=denemepasswd";

   $db = pg_connect("$host $port $db $credentials");
   if(!$db) {
      echo "vt bağlantı başarısız!\n";
   } else {
      echo "vt bağlantı başarılı\n";
   }
?>
```
