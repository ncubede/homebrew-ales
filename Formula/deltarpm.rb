require 'formula'

# Main class describing formula
class Deltarpm < Formula
  homepage 'http://yum.baseurl.org//'
  url 'https://github.com/rpm-software-management/deltarpm/archive/3.6.1.tar.gz'
  sha256 '357509c40ef57fdba9851cdce41067bd0e4399b2b2f90094735bccf753c74d8a'

  depends_on 'ncubede/ales/rpm-python'

  def install
    python_prefix = `python-config --prefix`.chomp
    python = "#{python_prefix}/bin/python"

    inreplace 'Makefile', '-DDELTARPM_64BIT', '-DDELTARPM_64BIT -Dfseeko64=fseek -Dfopen64=fopen -Doff64_t=off_t -Dftello64=ftello -Dpread64=pread -Dpwrite64=pwrite -Dmkstemp64=mkstemp -Dftruncate64=ftruncate '
    inreplace 'Makefile', 'install -m', '$(INSTALL) -m'
    inreplace 'md5.c', 'memset(ctx, 0, sizeof(ctx));', 'memset(ctx, 0, sizeof(*ctx));'
    inreplace 'makedeltarpm.c', 'if (!strcmp(c2, "off") != 0)', 'if (!strcmp(c2, "off"))'

    system 'make', "prefix=#{prefix}", 'INSTALL=ginstall', "PYTHONS=%{python}", 'clean', 'install'
  end

end
