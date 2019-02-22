require 'formula'

# Main class describing formula
class Deltarpm < Formula
  homepage 'https://github.com/breiter/vpnc.git'
  url 'https://github.com/ncubede/homebrew-ales/blob/master/Archives/vpnc-0.5.3.tar.gz?raw=true'
  sha256 '8709945bbfd43702f2d6eafc49e2907ba3cf90fcea1705e8007025ad802c115f'

  depends_on 'gmp'
  depends_on 'gnutls'
  depends_on 'libffi'
  depends_on 'libgcrypt'
  depends_on 'libgpg-error'
  depends_on 'libtasn1'
  depends_on 'libunistring'
  depends_on 'nettle'
  depends_on 'p11-kit'
  depends_on 'coreutils'

  def install
    inreplace 'Makefile', 'install -m', '$(INSTALL) -m '
    system 'make', "PREFIX=#{prefix}", 'INSTALL=/usr/local/bin/ginstall', 'clean'
    system 'make', "PREFIX=#{prefix}", 'INSTALL=/usr/local/bin/ginstall', 'install'
  end

end
