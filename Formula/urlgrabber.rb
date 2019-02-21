require 'formula'

# Main class describing formula
class Urlgrabber < Formula
  homepage 'http://urlgrabber.baseurl.org//'
  url 'http://urlgrabber.baseurl.org/download/urlgrabber-3.10.2.tar.gz'
  sha256 '53691185e3d462bb0fa8db853a205ee79cdd4089687cddd22cabb8b3d4280142'

  depends_on 'coreutils'
  depends_on 'libxml2' => 'with-python'
  depends_on 'python@2'

  def install
    inreplace 'Makefile', 'install:', 'install::'
    inreplace ['Makefile', 'docs/Makefile', 'etc/Makefile', 'rpmUtils/Makefile', 'yum/Makefile'], 'install -m', '$(INSTALL) -m'
    inreplace ['etc/Makefile'], 'install -D', '$(INSTALL) -D'
    inreplace ['rpmUtils/Makefile', 'yum/Makefile'], '$(shell $(PYTHON) -c \'import sys; print sys.prefix\')', ''
    system pybin, 'setup.py', 'build'
    system pybin, 'setup.py', 'install', "--prefix=#{prefix}"
  end

end
