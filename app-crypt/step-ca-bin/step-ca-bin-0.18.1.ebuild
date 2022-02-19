# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="step-ca"

DESCRIPTION="A private certificate authority (X.509 & SSH) & ACME server."
HOMEPAGE="https://smallstep.com/certificates/"
SRC_URI="
	amd64? ( https://github.com/smallstep/certificates/releases/download/v${PV}/${MY_PN}_linux_${PV}_amd64.tar.gz )
	x86? ( https://github.com/smallstep/certificates/releases/download/v${PV}/${MY_PN}_linux_${PV}_386.tar.gz )
	arm64? ( https://github.com/smallstep/certificates/releases/download/v${PV}/${MY_PN}_linux_${PV}_arm64.tar.gz )
	arm? ( https://github.com/smallstep/certificates/releases/download/v${PV}/${MY_PN}_linux_${PV}_armv7.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="!app-crypt/step-ca"

S="${WORKDIR}/${MY_PN}_${PV}"

src_install(){
	dobin "${S}"/bin/"${MY_PN}"
	dobin "${S}"/bin/step-{aws,cloud}kms-init
	dodoc "${S}"/README.md
}
