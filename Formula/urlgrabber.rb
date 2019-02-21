require 'formula'

# Main class describing formula
class Urlgrabber < Formula
  homepage 'http://urlgrabber.baseurl.org//'
  url 'http://urlgrabber.baseurl.org/download/urlgrabber-3.10.2.tar.gz'
  sha256 '53691185e3d462bb0fa8db853a205ee79cdd4089687cddd22cabb8b3d4280142'

  depends_on 'ncubede/ales/pycurl'

  def install
    python_prefix = `python-config --prefix`.chomp
    python = "#{python_prefix}/bin/python"

    system python, 'setup.py', 'build'
    system python, 'setup.py', 'install', "--prefix=#{prefix}"
  end

end
