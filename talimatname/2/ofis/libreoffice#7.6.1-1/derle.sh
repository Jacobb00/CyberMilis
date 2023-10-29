ulimit -n 10240

noextract=(0168229624cfac409e766913506961a8-ucpp-1.3.2.tar.gz
17410483b5b5f267aa18b7e00b65e6e0-hsqldb_1_8_0.zip
185d60944ea767075d27247c3162b3bc-unowinreg.dll
1f5def51ca0026cd192958ef07228b52-rasqal-0.9.33.tar.gz                                                                                                                                           
26b3e95ddf3d9c077c480ea45874b3b8-lp_solve_5.5.tar.gz
35c94d2df8893241173de1d16b6034c0-swingExSrc.zip
48d647fbd8ef8889e5a7f422c1bfda94-clucene-core-2.3.3.4.tar.gz
5ade6ae2a99bc1e9e57031ca88d36dad-hyphen-2.8.8.tar.gz
798b2ffdc8bcfe7bca2cf92b62caf685-rhino1_5R5.zip
8249374c274932a21846fa7629c2aa9b-officeotron-0.7.4-master.jar
a39f6c07ddb20d7dd2ff1f95fa21e2cd-raptor2-2.0.15.tar.gz
a7983f859eafb2677d7ff386a023bc40-xsltml_2.1.2.zip
ba2930200c9f019c2d93a8c88c651a0f-flow-engine-0.9.4.zip
boost_1_82_0.tar.xz
box2d-2.4.1.tar.gz
cppunit-1.15.1.tar.gz
d8bd5eed178db6e2b18eeed243f85aa8-flute-1.1.6.zip
dragonbox-1.1.3.tar.gz
dtoa-20180411.tgz
e5be03eda13ef68aabab6e42aa67715e-redland-1.0.17.tar.gz
f543e6e2d7275557a839a164941c0a86e5f2c3f2a0042bfc434c88c6dde9e140-opens___.ttf
Firebird-3.0.7.33374-0.tar.bz2
frozen-1.1.1.tar.gz
hunspell-1.7.2.tar.gz
language-subtag-registry-2021-03-05.tar.bz2
language-subtag-registry-2023-05-11.tar.bz2
libabw-0.1.3.tar.xz
libcdr-0.1.7.tar.xz
libcmis-0.5.2.tar.xz
libe-book-0.1.3.tar.xz
libepubgen-0.1.1.tar.xz
libetonyek-0.1.10.tar.xz
libexttextcat-3.4.6.tar.xz
libfreehand-0.1.2.tar.xz
liblangtag-0.6.3.tar.bz2
libmspub-0.1.4.tar.xz
libmwaw-0.3.21.tar.xz
libnumbertext-1.0.11.tar.xz
libodfgen-0.1.8.tar.xz
liborcus-0.18.1.tar.xz
libpagemaker-0.0.4.tar.xz
libqxp-0.0.2.tar.xz
libreoffice-help-7.6.1.2.tar.xz
libreoffice-translations-7.6.1.2.tar.xz
librevenge-0.0.4.tar.bz2
libstaroffice-0.0.7.tar.xz
libvisio-0.1.7.tar.xz
libwebp-1.3.1.tar.gz
libwpd-0.10.3.tar.xz
libwpg-0.3.4.tar.xz
libwps-0.4.12.tar.xz
libzmf-0.0.2.tar.xz
ltm-1.2.0.tar.xz
lxml-4.1.1.tgz
mariadb-connector-c-3.1.8-src.tar.gz
mdds-2.1.1.tar.xz
mythes-1.2.5.tar.xz
odfvalidator-1.2.0-incubating-SNAPSHOT-jar-with-dependencies-971c54fd38a968f5860014b44301872706f9e540.jar
pdfium-5778.tar.bz2
QR-Code-generator-1.4.0.tar.gz
skia-m111-a31e897fb3dcbc96b2b40999751611d029bf5404.tar.xz
xmlsec1-1.2.37.tar.gz
zxing-cpp-2.0.0.tar.gz
)

# move external sources into place
mkdir "${SRC}"/ext_sources && pushd "${SRC}"/ext_sources
for source in "${noextract[@]}"; do
	ln -s /sources/$source .
done
popd

# unowinreg.dll must be a file not a symlink or the result will become a broken symlink
# /usr/share/libreoffice/sdk/classes/win/unowinreg.dll -> /build/libreoffice/src/185d60944ea767075d27247c3162b3bc-unowinreg.dll
rm $SRC/ext_sources/185d60944ea767075d27247c3162b3bc-unowinreg.dll
cp -f /sources/185d60944ea767075d27247c3162b3bc-unowinreg.dll ${SRC}/ext_sources/


# fix not upstreamable pyuno paths - FS#54250
patch -Np1 -i ${SRC}/make-pyuno-work-with-system-wide-module-install.diff

# fix build - https://gerrit.libreoffice.org/c/core/+/145421
patch -Np1 -i ${SRC}/623ea5c.diff

# java yama
patch -Np0 -i $SRC/optjava.patch
 
#use the CFLAGS but remove the LibO overridden ones
for i in $CFLAGS; do
	case "$i" in
		-O?|-pipe|-Wall|-g|-fexceptions) continue;;
	esac
	ARCH_FLAGS="$ARCH_FLAGS $i"
done

# strip -s from Makeflags in case you use it to shorten build logs
_MAKEFLAGS=${MAKEJOBS/-s/}

# Build only minimal debug info to reduce size (~1.2GB -> ~225MB)
CFLAGS=${CFLAGS/-g /-g1 }
CXXFLAGS=${CXXFLAGS/-g /-g1 }

# this uses malloc_usable_size, which is incompatible with fortification level 3
# /usr/lib/libreoffice/program/libskialo.so uses malloc_usable_size
export CFLAGS="${CFLAGS/_FORTIFY_SOURCE=3/_FORTIFY_SOURCE=2}"
export CXXFLAGS="${CXXFLAGS/_FORTIFY_SOURCE=3/_FORTIFY_SOURCE=2}"

# http://site.icu-project.org/download/61#TOC-Migration-Issues
CPPFLAGS+=' -DU_USING_ICU_NAMESPACE=1'
./autogen.sh \
	--enable-split-app-modules \
	--with-parallelism=${MAKEJOBS/-j/} \
	--with-external-tar="${SRC}/ext_sources" \
	--disable-fetch-external \
	--enable-release-build \
	--prefix=/usr --exec-prefix=/usr --sysconfdir=/etc \
	--libdir=/usr/lib --mandir=/usr/share/man \
	--with-lang="tr" \
	--with-help=html \
	--disable-avahi \
	--enable-dbus \
	--enable-gio\
	--disable-qt5 \
	--enable-gtk3 \
	--enable-introspection \
	--enable-openssl \
	--enable-odk\
	--enable-python=system \
	--enable-scripting-javascript \
	--disable-dconf \
	--disable-report-builder \
	--disable-online-update \
	--enable-ext-wiki-publisher \
	--without-system-lpsolve \
	--enable-lto \
	--without-fonts\
	--without-system-libcdr \
	--without-system-mdds\
	--without-myspell-dicts \
	--without-system-libvisio \
	--without-system-libcmis \
	--without-system-libmspub \
	--without-system-libexttextcat \
	--without-system-orcus \
	--without-system-liblangtag \
	--without-system-libodfgen \
	--without-system-libmwaw \
	--without-system-libetonyek \
	--without-system-libfreehand \
	--without-system-firebird \
	--without-system-libatomic-ops \
	--without-system-libebook \
	--without-system-libabw \
	--without-system-xmlsec \
	--disable-coinmp  \
	--without-system-box2d \
	--with-system-poppler \
	--with-system-dicts \
	--with-external-dict-dir=/usr/share/hunspell \
	--with-external-hyph-dir=/usr/share/hyphen \
	--with-external-thes-dir=/usr/share/mythes \
	--without-system-cppunit\
	--with-system-graphite\
	--with-system-glm \
	--without-system-libnumbertext \
	--without-system-libwpg \
	--without-system-libwps \
	--without-system-redland\
	--with-system-gpgmepp \
	--without-java \
	--without-junit \
	--without-system-boost\
	--with-system-icu \
	--with-system-cairo \
	--with-system-libs \
	--without-system-mythes \
	--with-system-headers \
	--without-system-hsqldb \
	--without-system-clucene \
	--disable-dependency-tracking \
	--without-system-libzmf \
	--without-system-libstaroffice \
	--without-system-jfreereport \
	--without-system-beanshell \
	--without-system-librevenge \
	--without-system-libepubgen \
	--without-system-libwpd \
	--without-system-libpagemaker \
	--without-system-libqxp \
	--with-system-mariadb \
	--with-system-postgresql \
	--with-system-odbc \
	--without-system-libtommath \
	--without-system-dragonbox \
	--without-system-libfixmath \
	--without-system-frozen \
	--without-system-sane \
	--without-system-hunspell \
	--without-system-zxing \
	--without-system-altlinuxhyph \
	--without-system-abseil \
	--without-system-libwebp \
	--without-doxygen

touch src.downloaded

sed -i '/bootstrap: check-if-root compilerplugins/c\bootstrap: compilerplugins' Makefile
make

mkdir "${SRC}"/fakeinstall
make DESTDIR="${SRC}"/fakeinstall distro-pack-install

#--without-system-mariadb \
#--without-system-postgresql \
#--without-system-odbc \

# source
# postgresql-13.11.tar.bz2
