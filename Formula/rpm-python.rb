require 'formula'

# Main class describing formula
class RpmPython < Formula
  homepage 'http://www.rpm.org/'
  url 'http://ftp.rpm.org/releases/rpm-4.14.x/rpm-4.14.2.1.tar.bz2'
  sha256 '1139c24b7372f89c0a697096bf9809be70ba55e006c23ff47305c1849d98acda'

  depends_on 'pkg-config' => :build
  depends_on 'nss'
  depends_on 'nspr'
  depends_on "python@2"
  depends_on "berkeley-db"
  depends_on "gettext"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "lua@5.1"
  depends_on "openssl"
  depends_on "pkg-config"
  depends_on "popt"
  depends_on "xz"
  depends_on "zstd"

  conflicts_with 'rpm', because: 'These are two different forks of the same tool.'

  def install
    pypref = `python-config --prefix`.chomp
    pybin = "#{pypref}/bin/python"

    ENV.append 'CPPFLAGS', "-I#{Formula['nss'].include}"
    ENV.append 'CPPFLAGS', "-I#{Formula['nspr'].include}"
    ENV.append 'LDFLAGS', `python-config --ldflags`
    ENV['LUA_CFLAGS'] = "-I#{HOMEBREW_PREFIX}/include/lua5.1"
    ENV['LUA_LIBS'] = "-L#{HOMEBREW_PREFIX}/lib -llua5.1"
    ENV['__PYTHON'] = pybin

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["lua@5.1"].opt_libexec/"lib/pkgconfig"

    inreplace ['scripts/find-provides', 'scripts/find-requires'], '/usr/lib/rpm/rpmdeps', "#{prefix}/lib/rpm/rpmdeps"
    inreplace ["macros.in", "platform.in"], "@prefix@", HOMEBREW_PREFIX
    inreplace "scripts/pkgconfigdeps.sh", "/usr/bin/pkg-config", Formula["pkg-config"].opt_bin/"pkg-config"
    inreplace 'rpmio/digest_openssl.c', 'EVP_md2', 'EVP_md_null'

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sharedstatedir=#{var}/lib",
                          "--sysconfdir=#{etc}",
                          "--with-path-magic=#{HOMEBREW_PREFIX}/share/misc/magic",
                          "--enable-nls",
                          "--disable-plugins",
                          "--with-external-db",
                          "--with-crypto=openssl",
                          "--without-apidocs",
                          "--with-vendor=homebrew",
			  "--enable-python"

    system "make", "install"

    # the default install makes /usr/bin/rpmquery a symlink to /bin/rpm
    # by using ../.. but that doesn't really work with any other prefix.
    ln_sf 'rpm', "#{bin}/rpmquery"
    ln_sf 'rpm', "#{bin}/rpmverify"
  end

  def post_install
    (var/"lib/rpm").mkpath

    # Attempt to fix expected location of GPG to a sane default.
    inreplace lib/"rpm/macros", "/usr/bin/gpg2", "#{HOMEBREW_PREFIX}/bin/gpg"
  end
end
