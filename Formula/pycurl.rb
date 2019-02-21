require 'formula'

class Pycurl < Formula
  homepage 'http://pycurl.io/'
  url 'https://dl.bintray.com/pycurl/pycurl/pycurl-7.43.0.2.tar.gz'
  sha256 '0f0cdfc7a92d4f2a5c44226162434e34f7d6967d3af416a6f1448649c09a25a4'

  depends_on 'coreutils'
  depends_on 'libxml2' => 'with-python'
  depends_on 'python@2'

  def install
    python_prefix = `python-config --prefix`.chomp
    python = "#{python_prefix}/bin/python"
    pyver = `#{python} -c 'import sys; print "%.3s" %(sys.version)'`.chomp
    ENV['PYTHONPATH'] = "#{prefix}/lib/python#{pyver}/site-packages"

    system python, 'setup.py', 'build', '--with-openssl'
    system python, 'setup.py', 'install', "--prefix=#{prefix}", '--with-openssl'
  end

end
