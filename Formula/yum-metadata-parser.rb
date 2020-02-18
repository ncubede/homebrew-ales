require 'formula'

# Main class describing formula
class YumMetadataParser < Formula
  homepage 'http://yum.baseurl.org/'
  url 'http://yum.baseurl.org/download/yum-metadata-parser/yum-metadata-parser-1.1.4.tar.gz'
  sha256 'f1560a284541feb720c3ae35b6b31f80c2be5cb9ca86b3a1ee9459846f821ada'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'sqlite3'
  depends_on "ncubede/ales/python@2"

  def install
    # Fix for removed python. stuff... Argh!
    python_prefix = `python-config --prefix`.chomp
    python = "#{python_prefix}/bin/python"

    system python, 'setup.py', 'build'
    system python, 'setup.py', 'install', "--prefix=#{prefix}"
  end
end
