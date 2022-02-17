# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

S="${WORKDIR}"
MY_PN="Vieb"

inherit xdg chromium-2

DESCRIPTION="Vim Inspired Electron Browser"
HOMEPAGE="https://vieb.dev"
SRC_URI="
	amd64? ( https://github.com/Jelmerro/Vieb/releases/download/${PV}/vieb-${PV}.pacman -> vieb-${PV}-amd64.tar.xz )
	arm64? ( https://github.com/Jelmerro/Vieb/releases/download/${PV}/vieb-${PV}-aarch64.pacman -> vieb-${PV}-arm64.tar.xz )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
IUSE="system-7zip system-ffmpeg system-mesa wayland +examples" # TODO: system-electron

RESTRICT="strip"

RDEPEND="
	app-accessibility/at-spi2-core:2
	app-accessibility/at-spi2-atk:2
	app-crypt/libsecret
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/libxkbfile
	x11-libs/pango
	system-7zip? ( app-arch/p7zip )
	system-ffmpeg? ( media-video/ffmpeg[chromium] )
"

QA_PREBUILT="
	opt/${MY_PN}/vieb
	opt/${MY_PN}/chrome-sandbox
	opt/${MY_PN}/libffmpeg.so
	opt/${MY_PN}/libvk_swiftshader.so
	opt/${MY_PN}/libvulkan.so.1
	opt/${MY_PN}/libEGL.so
	opt/${MY_PN}/libGLESv2.so
	opt/${MY_PN}/swiftshader/libEGL.so
	opt/${MY_PN}/swiftshader/libGLESv2.so
"

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	use examples || rm -r "${S}/opt/${MY_PN}/resources/app.asar.unpacked/app" || die "failed to remove examples"
	[[ $ARCH == amd64 ]] || rm -r "${S}/opt/${MY_PN}/resources/app.asar.unpacked/node_modules/7zip-bin/linux/x64" || die
	[[ $ARCH == arm64 ]] || rm -r "${S}/opt/${MY_PN}/resources/app.asar.unpacked/node_modules/7zip-bin/linux/arm64" || die
	# these will never be used (not supported by OS/program)
	rm -r "${S}/opt/${MY_PN}/resources/app.asar.unpacked/node_modules/7zip-bin/mac" || die
	rm -r "${S}/opt/${MY_PN}/resources/app.asar.unpacked/node_modules/7zip-bin/linux/arm" || die
	rm -r "${S}/opt/${MY_PN}/resources/app.asar.unpacked/node_modules/7zip-bin/linux/ia32" || die

}

src_install() {
	pushd "${S}/opt/${MY_PN}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	if use wayland ; then
		ewarn "WARNING! due to upstream electron bug vieb-bin doesn't work on Wayland"
		ewarn "See https://github.com/Jelmerro/Vieb/issues/349"
	fi

	insinto /
	doins -r *
	[[ ${ARCH} == amd64 ]] && dir="x64" || dir==${ARCH}
	fperms +x "/opt/${MY_PN}/resources/app.asar.unpacked/node_modules/7zip-bin/linux/${dir}/7za"
	fperms +x "/opt/${MY_PN}/"{vieb,chrome-sandbox}
	unset dir

	if use system-ffmpeg ; then
		rm "${ED}/opt/${MY_PN}/libffmpeg.so" || die "failed to enable system-ffmpeg"
		cat > 99vieb <<-EOF
		LDPATH="${EPREFIX}/usr/$(get_libdir)/chromium"
		EOF
		doenvd 99vieb
		elog "Using system ffmpeg. This is experimental and may lead to crashes."
	fi

	if use system-7zip ; then
		if [[ $ARCH == amd64 ]] ; then
			rm -r "${S}/opt/${MY_PN}/resources/app.asar.unpacked/node_modules/7zip-bin/linux/x64" || die "failed to enable system-7zip"
			dosym -r /usr/lib64/p7zip/7za "${ED}/opt/${MY_PN}/resources/app.asar.unpacked/node_modules/7zip-bin/linux/x64/7za"
		elif [[ $ARCH == arm64 ]] ; then
			rm -r "${S}/opt/${MY_PN}/resources/app.asar.unpacked/node_modules/7zip-bin/linux/arm64" || die "failed to enable system-7zip"
			dosym -r "/usr/lib64/p7zip/7za ${ED}/opt/${MY_PN}/resources/app.asar.unpacked/node_modules/7zip-bin/linux/arm64/7za"
		fi
		elog "Using system p7zip. This is experimental and may lead to crashes."
	fi
}
