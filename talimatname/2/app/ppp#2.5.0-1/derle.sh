patch -p1 -i "$SRC"/ppp-2.4.6-makefiles.patch

# enable active filter
sed -i "s:^#FILTER=y:FILTER=y:" pppd/Makefile.linux
# enable ipv6 support
sed -i "s:^#HAVE_INET6=y:HAVE_INET6=y:" pppd/Makefile.linux
# Enable Microsoft proprietary Callback Control Protocol
sed -i "s:^#CBCP=y:CBCP=y:" pppd/Makefile.linux

# -D_GNU_SOURCE is needed for IPv6 to work apparently
CFLAGS="$CPPFLAGS $CFLAGS -D_GNU_SOURCE" LDFLAGS="$LDFLAGS" ./configure $CONF_OPT
make
