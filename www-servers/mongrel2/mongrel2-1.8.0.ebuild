# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Mongrel2 is an application, language, and network architecture agnostic web server that focuses on web applications using modern browser technologies"
HOMEPAGE="https://mongrel2.org"
SRC_URI="http://mongrel2.org/static/downloads/${P}.tar.bz2"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-db/sqlite:3
	=net-libs/zeromq-2.1.4"

RDEPEND="${DEPEND}"

src_install(){
	emake install DESTDIR=${D} PREFIX="${EPREFIX}"/usr
	newconfd "${FILESDIR}"/mongrel2.confd mongrel2
	newinitd "${FILESDIR}"/mongrel2-1.6.initd mongrel2
}

pkg_postinst(){
	ewarn "Be aware that this version does not compile with"
	ewarn "-j option passed to the make command"
	ewarn ""
	ewarn ""
	einfo "If you are upgrading mongrel2, remember to update"
	einfo "your database config:"
	einfo "Schema modifications for 1.7.2"
	einfo "	alter table server add column use_ssl INTEGER default 0;"
	einfo ""
	einfo "Since column default_host changed from INTEGER to TEXT and"
	einfo "sqlite does not support column dropping we must re-create the"
	einfo "server table, changing the type of default_host column:"
	einfo ""
	einfo "	create table s2 as select id, uuid, access_log, error_log, chroot, pid_file, name, bind_addr, port, use_ssl from server;"
	einfo "	alter table s2 add column default_host TEXT default '';"
	einfo "	update s2 set default_host = (select default_host from server s1 where s1.id = s2.id);"
	einfo "	drop table server;"
	einfo "	create table server as select * from s2;"
}

