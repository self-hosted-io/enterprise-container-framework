set -eux

# See https://github.com/python/cpython/issues/80225
# Basically, if we don't set this, then optimisation of the Python binary takes forever for 3.7. Later python versions
# have a sensible default here.
# We use a case statement because posix doesn't allow wildcards in string comparisons
# https://stackoverflow.com/a/48913862
case $PYTHON_VERSION in
    "3.7."*)  export PROFILE_TASK='-m test.regrtest --pgo \
         			test_array \
         			test_base64 \
         			test_binascii \
         			test_binhex \
         			test_binop \
         			test_bytes \
         			test_c_locale_coercion \
         			test_class \
         			test_cmath \
         			test_codecs \
         			test_compile \
         			test_complex \
         			test_csv \
         			test_decimal \
         			test_dict \
         			test_float \
         			test_fstring \
         			test_hashlib \
         			test_io \
         			test_iter \
         			test_json \
         			test_long \
         			test_math \
         			test_memoryview \
         			test_pickle \
         			test_re \
         			test_set \
         			test_slice \
         			test_struct \
         			test_threading \
         			test_time \
         			test_traceback \
         			test_unicode \
         		';;
    *) ;;
esac

echo "PROFILE_TASK="${PROFILE_TASK-not set}

savedDnfMark="$(dnf repoquery --userinstalled --qf '%{name}')"
dnf install -y \
    gcc \
    gnupg \
    dirmngr \
    bzip2-devel \
    glibc-devel \
    expat-devel \
    libffi-devel \
    xz-devel \
    ncurses-devel \
    readline-devel \
    sqlite-devel \
    openssl-devel \
    make \
    tk-devel \
    libuuid-devel \
    wget \
    xz \
    zlib-devel

# Python package install with the ASCII-armored digital signature package for verification and authentication
wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"


mkdir -p /usr/src/python
# Extract python source and binary files
tar --extract --directory /usr/src/python --strip-components=1 --file python.tar.xz
rm python.tar.xz

cd /usr/src/python
# Configure python installation
gnuArch="$(rpm --eval %{_host})"
# shellcheck disable=SC2089
common_flags="--build=$gnuArch \
    --enable-loadable-sqlite-extensions \
    --enable-optimizations \
    --enable-option-checking=fatal \
    --enable-shared \
    --with-lto \
    --with-system-expat \
    --without-ensurepip"


./configure $common_flags --with-openssl-rpath=auto


nproc="$(nproc)"
if [ -n "${PROFILE_TASK-}" ]; then
    make -j "$nproc" \
      LDFLAGS="-Wl,--strip-all" \
      PROFILE_TASK="${PROFILE_TASK}"
else
    make -j "$nproc" \
      LDFLAGS="-Wl,--strip-all"
fi

make install

cd /
rm -rf /usr/src/python

# Remove compiled python files and test-related-directories from /usr/local if present
find /usr/local -depth \
    \( \
        \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
        -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name 'libpython*.a' \) \) \
    \) -exec rm -rf '{}' + \

ldconfig -v /usr/local/lib

# Remove packages and configurations that were installed automatically and are no longer needed
dnf autoremove -y
rm -rf /var/cache/dnf/*

python3 --version