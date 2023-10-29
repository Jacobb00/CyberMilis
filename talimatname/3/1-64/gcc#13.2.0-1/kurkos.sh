# Doğruluk Testleri

#############################
# aşağıdaki komutla artık derlenen uygulamaların doğru yere linklendiğine emin oluruz.

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

# çıktı: 
# [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
# 32bit test için çıktı -> /lib/ld-linux.so.2. olmalı
#############################
# Doğru başlangıç dosyalarını kurduğumuzdan aşağıdaki komutla emin oluruz.

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

# çıktı:
# /usr/lib/gcc/x86_64-pc-linux-gnu/10.2.0/../../../../lib/crt1.o succeeded
# /usr/lib/gcc/x86_64-pc-linux-gnu/10.2.0/../../../../lib/crti.o succeeded
# /usr/lib/gcc/x86_64-pc-linux-gnu/10.2.0/../../../../lib/crtn.o succeeded
#############################
# Derleyicinin doğru üstbaşlık dosyalarına baktığını(headers kontrol)
# komutu ile kontrol ederiz.

grep -B4 '^ /usr/include' dummy.log

# çıktı:
# include <...> search starts here:
# /usr/lib/gcc/x86_64-pc-linux-gnu/10.2.0/include
# /usr/local/include
# /usr/lib/gcc/x86_64-pc-linux-gnu/10.2.0/include-fixed
# /usr/include
#############################
# Linkerin doğru yolları araştırdığına da emin oluruz.

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

# çıktı:
# SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")
# SEARCH_DIR("/usr/local/lib64")
# SEARCH_DIR("/lib64")
# SEARCH_DIR("/usr/lib64")
# SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")
# SEARCH_DIR("/usr/local/lib")
# SEARCH_DIR("/lib")
# SEARCH_DIR("/usr/lib");
#############################
# Doğru libc kütüphanesi kullandığımızı kontrol için

grep "/lib.*/libc.so.6 " dummy.log

# çıktı:
# attempt to open /usr/lib/libc.so.6 succeeded
#############################
# Son olarak gcc nin doğru dinamik linkerini kullandığına emin oluruz.

grep found dummy.log

# çıktı:
# found ld-linux-x86-64.so.2 at /usr/lib/ld-linux-x86-64.so.2
#############################

# temizlik
rm -v dummy.c a.out dummy.log
