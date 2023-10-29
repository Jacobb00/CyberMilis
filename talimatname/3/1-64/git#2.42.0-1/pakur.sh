make \
prefix='/usr' \
gitexecdir='/usr/lib/git-core' \
perllibdir="$(/usr/bin/perl -MConfig -wle 'print $Config{installvendorlib}')" \
CFLAGS="$CFLAGS" \
LDFLAGS="$LDFLAGS" \
NO_CROSS_DIRECTORY_HARDLINKS=1 \
NO_PERL_CPAN_FALLBACKS=1 \
USE_LIBPCRE2=1 \
DESTDIR=$PKG install
