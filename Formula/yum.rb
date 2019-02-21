require 'formula'

# Main class describing formula
class Yum < Formula
  homepage 'http://yum.baseurl.org//'
  url 'http://yum.baseurl.org/download/3.4/yum-3.4.3.tar.gz'
  sha256 '0178f97820ced9bfbcc269e6fc3ea35e29e35e2d263d24c7bff8660ee62d37ca'

  depends_on 'ncubede/ales/yum-metadata-parser@1.1.4'
  depends_on 'ncubede/ales/rpm-python'
  depends_on 'coreutils'
  depends_on 'libxml2' => 'with-python'

  def install
    inreplace 'Makefile', 'install:', 'install::'
    inreplace ['Makefile', 'docs/Makefile', 'etc/Makefile', 'rpmUtils/Makefile', 'yum/Makefile'], 'install -m', '$(INSTALL) -m'
    inreplace ['etc/Makefile'], 'install -D', '$(INSTALL) -D'
    system 'make', "prefix=#{prefix}", 'INSTALL=ginstall', 'clean', 'install'
  end

end
