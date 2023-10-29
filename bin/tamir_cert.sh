#!/bin/bash
if [ ! -f /etc/ssl/certs/ca-certificates.crt ] ;then
	[ -f /etc/pki/tls/certs/ca-bundle.crt ] && ln -sv /etc/pki/tls/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
fi
