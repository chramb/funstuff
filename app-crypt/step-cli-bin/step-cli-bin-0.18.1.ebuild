# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit bash-completion-r1

MY_PN="step"

DESCRIPTION="A private certificate authority (X.509 & SSH) & ACME server."
HOMEPAGE="https://smallstep.com/certificates/"
SRC_URI="
	amd64? ( https://github.com/smallstep/cli/releases/download/v${PV}/${MY_PN}_linux_${PV}_amd64.tar.gz )
	x86? ( https://github.com/smallstep/cli/releases/download/v${PV}/${MY_PN}_linux_${PV}_386.tar.gz )
	arm64? ( https://github.com/smallstep/cli/releases/download/v${PV}/${MY_PN}_linux_${PV}_arm64.tar.gz )
	arm? ( https://github.com/smallstep/cli/releases/download/v${PV}/${MY_PN}_linux_${PV}_armv7.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

IUSE="+bash-completions zsh-completions"

DEPEND="!app-crypt/step-cli"

S="${WORKDIR}/${MY_PN}_${PV}"

src_install(){
	dobin "${S}"/bin/"${MY_PN}"
	dodoc "${S}"/README.md

	use bash-completions && newbashcomp "${S}"/autocomplete/bash_autocomplete step

	if use zsh-completions; then
		insinto /usr/share/zsh/site-functions
		newins "${S}"/autocomplete/zsh_autocomplete _step
	fi
}
