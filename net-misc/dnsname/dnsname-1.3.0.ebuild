# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="dns CNI plugin for podman"
HOMEPAGE="https://github.com/containers/dnsname"
SRC_URI="https://github.com/containers/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="net-misc/cni-plugins"

src_compile() {
	unset LDFLAGS
	if [[ ${PV} == 9999 ]]; then
		emake
	else
		emake GIT_COMMIT="dc59f285546a0b0d8b8f20033e1637ea82587840"
	fi
}

src_install() {
	exeinto /opt/cni/bin
	doexe bin/dnsname
}
