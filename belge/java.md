Milis Linux'ta Java ve bağımlı uygulamaları çalıştırmak ve geliştirmek için [sdkman](https://sdkman.io) uygulamasından yararlanılır.
Aşağıda yer alan komutlar yetkili komut satırında uygulanır.


#### Kurulum
```
[ ~ ]# sdk_setup.sh
[ ~ ]# source "/opt/sdkman/bin/sdkman-init.sh"
```

#### Java Sürümleri Listeleme
```
[ ~ ]# sdk list java
```

#### Java Sürüm Kurma
```
[ ~ ]# sdk install java 22.0.1-open
Downloading: java 22.0.1-open

In progress...

###################%100

Repackaging Java 22.0.1-open...

Done repackaging...

Installing: java 22.0.1-open
Done installing!


Setting java 22.0.1-open as default.

```

#### Java Konumu
```
[ ~ ]# which java
/opt/sdkman/candidates/java/current/bin/java

```
