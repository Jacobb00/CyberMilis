install -d ${PKG}/etc/
install -Dm644 /sources/protocol-numbers.xml ${PKG}/usr/share/iana-etc/protocol-numbers.iana
install -Dm644 /sources/service-names-port-numbers.xml ${PKG}/usr/share/iana-etc/port-numbers.iana

LC_ALL=C awk -F"[<>]" '
BEGIN {
	print "# See the full IANA XML file at: /usr/share/iana-etc/protocol-numbers.iana\n"
}
{
if (/<record/) { v=n=0 }
if (/<value/) v=$3
if (/<name/ && !($3~/ /)) n=$3
if (/<\/record/ && (v || n=="HOPOPT") && n) printf "%-12s %3i %s\n", tolower(n),v,n
}
' /sources/protocol-numbers.xml > ${PKG}/etc/protocols

LC_ALL=C awk -F"[<>]" '
BEGIN {
print "# See the full IANA XML file at: /usr/share/iana-etc/port-numbers.iana\n"
}
{
	if (/<record/) { n=u=p=c=0 }
	if (/<name/ && !/\(/) n=$3
	if (/<number/) u=$3
	if (/<protocol/) p=$3
	if (/Unassigned/ || /Reserved/ || /historic/) c=1
	if (/<\/record/ && n && u && p && !c) printf "%-15s %5i/%s\n", n,u,p # services
}
' /sources/service-names-port-numbers.xml > ${PKG}/etc/services
