# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

S="${WORKDIR}/stig-0.12.2a0"

DESCRIPTION="TUI and CLI for the BitTorrent client Transmission "
HOMEPAGE="https://github.com/rndusr/stig"
#SRC_URI="https://github.com/rndusr/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/rndusr/${PN}/archive/refs/tags/v0.12.2a0.tar.gz -> ${PN}-0.12.2a0.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="setproctitle proxy"

RDEPEND="
	>=dev-python/urwid-2.0
	>=dev-python/urwidtrees-1.0.3
	>=dev-python/aiohttp-3
	<dev-python/aiohttp-4
	dev-python/async_timeout
	dev-python/pyxdg
	dev-python/blinker
	dev-python/natsort
	setproctitle? ( dev-python/setproctitle )
	proxy? ( dev-python/aiohttp-socks )
"
# ebuilds for those packages don't exist
#BDEPEND="
#		test? (
#				>=dev-python/pytest-5
#				<dev-python/pytest-6
#				>=dev-python/asynctest-0.11
#				)
#"
#
#distutils_enable_tests pytest
