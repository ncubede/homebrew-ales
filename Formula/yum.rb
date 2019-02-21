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
#    inreplace ['bin/createrepo', 'bin/modifyrepo'], '/usr/share/createrepo', "#{HOMEBREW_PREFIX}/share/createrepo"
#    inreplace ['dmd.py', 'worker.py', 'genpkgmetadata.py', 'mergerepo.py', 'modifyrepo.py'], '/usr/bin/python', '/usr/bin/env python'
#    inreplace 'Makefile', '(cd $(DESTDIR)$(compdir); for n in $(ALIASES); do ln -s $(PKGNAME) $$n; done)', '(cd $(DESTDIR)$(compdir); for n in $(ALIASES); do ln -sf $(PKGNAME) $$n; done)'
#    inreplace "createrepo/Makefile", '$(shell $(PYTHON) -c \'import sys; print sys.prefix\')', prefix
    system 'make', "prefix=#{prefix}", 'INSTALL=ginstall -p --verbose', "compdir=#{HOMEBREW_PREFIX}/etc/bash_completion.d", 'clean', 'install'
  end

end
