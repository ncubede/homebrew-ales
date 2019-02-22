require 'formula'

# Main class describing formula
class Deltarpm < Formula
  homepage 'http://yum.baseurl.org//'
  url 'https://github.com/rpm-software-management/deltarpm/archive/3.6.1.tar.gz'
  sha256 '357509c40ef57fdba9851cdce41067bd0e4399b2b2f90094735bccf753c74d8a'

  depends_on 'xz'
  depends_on 'ncubede/ales/rpm-python'

  def install
    inreplace 'Makefile', '-DDELTARPM_64BIT', '-DDELTARPM_64BIT -Dfseeko64=fseek -Dfopen64=fopen -Doff64_t=off_t -Dftello64=ftello -Dpread64=pread -Dpwrite64=pwrite -Dmkstemp64=mkstemp -Dftruncate64=ftruncate'
    inreplace 'Makefile', 'CFLAGS = -fPIC -O2 -Wall -g', 'CFLAGS = -fPIC -O2 -Wall -g -I/usr/local/include'
    inreplace 'Makefile', 'LDLIBS = -lbz2 $(zlibldflags) -llzma', 'LDLIBS = -L/usr/local/lib -lbz2 $(zlibldflags) -llzma'
    inreplace 'Makefile', 'LDFLAGS =', 'LDFLAGS = -L/usr/local/lib'
    inreplace 'Makefile', 'PYTHONS = python python3', 'PYTHONS = python2'
    inreplace 'Makefile', '/usr/bin/$$PY', '/usr/local/bin/$$PY'
    inreplace 'Makefile', 'PYCFLAGS=`$$PY-config --cflags`;', 'PYCFLAGS=`$$PY-config --cflags`; PYLDFLAGS=`$$PY-config --ldflags`;'
    inreplace 'Makefile', '-shared -Wl,-soname,_deltarpmmodule.so', '-dylib -arch x86_64 $$PYLDFLAGS'
    inreplace 'Makefile', 'install -m', '$(INSTALL) -m'
    inreplace 'Makefile', '`$$PY -c \'from distutils import sysconfig ; print(sysconfig.get_python_lib(1))\'`', prefix'/lib'
    inreplace 'md5.c', 'memset(ctx, 0, sizeof(ctx));', 'memset(ctx, 0, sizeof(*ctx));'
    inreplace 'makedeltarpm.c', 'if (!strcmp(c2, "off") != 0)', 'if (!strcmp(c2, "off"))'

    system 'make', "prefix=#{prefix}", 'INSTALL=/usr/local/bin/ginstall', 'clean'
    system 'make', "prefix=#{prefix}", 'INSTALL=/usr/local/bin/ginstall', 'zlib-1.2.2.f-rsyncable/libz.a'
    system 'make', "prefix=#{prefix}", 'INSTALL=/usr/local/bin/ginstall'
    system 'make', "prefix=#{prefix}", 'INSTALL=/usr/local/bin/ginstall', '_deltarpmmodule.so'
    system 'make', "prefix=#{prefix}", 'INSTALL=/usr/local/bin/ginstall', 'install'
  end

end
