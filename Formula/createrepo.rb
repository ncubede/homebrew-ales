require 'formula'

# Main class describing formula
class Createrepo < Formula
  homepage 'http://createrepo.baseurl.org//'
  url 'http://createrepo.baseurl.org/download/createrepo-0.10.4.tar.gz'
  sha256 'f850504a3ec7e556aaaa626d487e8b0def84ffea666fd30774cbbd575c128261'

  depends_on 'ncubede/ales/deltarpm'
  depends_on 'ncubede/ales/yum'
  depends_on 'coreutils'
  depends_on 'libxml2' => 'with-python'

  def install
    inreplace ['bin/createrepo', 'bin/modifyrepo'], '/usr/share/createrepo', "#{HOMEBREW_PREFIX}/share/createrepo"
    inreplace ['dmd.py', 'worker.py', 'genpkgmetadata.py', 'mergerepo.py', 'modifyrepo.py'], '/usr/bin/python', '/usr/bin/env python'
    inreplace 'Makefile', '(cd $(DESTDIR)$(compdir); for n in $(ALIASES); do ln -s $(PKGNAME) $$n; done)', '(cd $(DESTDIR)$(compdir); for n in $(ALIASES); do ln -sf $(PKGNAME) $$n; done)'
    inreplace "createrepo/Makefile", '$(shell $(PYTHON) -c \'import sys; print sys.prefix\')', prefix
    system 'make', "prefix=#{prefix}", 'INSTALL=ginstall -p --verbose', "compdir=#{HOMEBREW_PREFIX}/etc/bash_completion.d", 'clean', 'install'
  end

  def caveats
    keg_site_packages = "#{Formula['libxml2'].opt_prefix}/lib/python2.7/site-packages"
    user_site_packages = `python -m site --user-site`.strip
    msg = <<-EOS
Please make sure python can find libxml2 module.
There's couple of ways to achieve that, libxml2 module should give you
relevant hint when installing. One of the ways that might work for you:
  mkdir -p #{user_site_packages}
  echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> #{user_site_packages}/homebrew.pth
  echo "#{keg_site_packages}" >> /usr/local/lib/python2.7/site-packages/libxml2.pth
EOS
    msg
  end
end
