if [ -f /tools/bin/ld-new ];then
	
	# Toolchain Ayarlama - Adjusting toolchain
	# Not: sadece önsistem->temel sistem geçişinde çalışacak. 

	#############################
	# Önsistem linklemesinin ayarlanması(Adjusting the Toolchain) yani artık üretilen 
	# paketler yeni ürettiğimiz glibc e link edilmiş olacak. Glibc paketlenmesinden önce 
	# başka linkleme içeren paketleme yapılmamalıdır

	mv -v /tools/bin/{ld,ld-old}
	mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
	mv -v /tools/bin/{ld-new,ld}
	ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld

	#############################
	# gcc speclerinin derleme yaparken yeni linkerin nerde olduğunu (/tools takısı silinerek)
	# bilmesi ayarlanır, ayrıca
	# üsbaşlık(headers) dosyalarının konumu ayarlanır.

	gcc -dumpspecs | sed -e 's@/tools@@g'                   \
		-e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
		-e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
		`dirname $(gcc --print-libgcc-file-name)`/specs

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
	# /usr/lib/../lib/crt1.o succeeded
	# /usr/lib/../lib/crti.o succeeded
	# /usr/lib/../lib/crtn.o succeeded
	#############################
	# Derleyicinin doğru üstbaşlık dosyalarına baktığını(headers kontrol)
	# komutu ile kontrol ederiz.

	grep -B1 '^ /usr/include' dummy.log

	# çıktı:
	# #include <...> search starts here:
	# /usr/include
	#############################
	# Linkerin doğru yolları araştırdığına da emin oluruz.

	grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

	# çıktı (en son satırlar -linux-gnu leri görmezden gelinir.):
	# SEARCH_DIR("/usr/lib")
	# SEARCH_DIR("/lib")
	#############################
	# Doğru libc kütüphanesi kullandığımızı kontrol için

	grep "/lib.*/libc.so.6 " dummy.log

	# çıktı:
	# attempt to open /lib/libc.so.6 succeeded
	#############################
	# Son olarak gcc nin doğru dinamik linkerini kullandığına emin oluruz.

	grep found dummy.log

	# çıktı:
	# found ld-linux-x86-64.so.2 at /usr/lib/ld-linux-x86-64.so.2
	#############################

	# temizlik
	rm -v dummy.c a.out dummy.log

fi
