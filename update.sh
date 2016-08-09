#!/bin/sh

#if [ ! -e libgit2 ]; then
#    git clone git@github.com:libgit2/libgit2.git
#else 
#    pushd libgit2
#    git pull
#    popd
#fi

echo "copying src"
rm -rf src
mkdir -p src/private/deps/regex
cp libgit2/deps/regex/*.h src/private/deps/regex
cat libgit2/deps/regex/regex.c | sed -e "s/\.c/.c.h/" > src/private/deps/regex/regex_windows.c
cp libgit2/deps/regex/regcomp.c src/private/deps/regex/regcomp.c.h
cp libgit2/deps/regex/regexec.c src/private/deps/regex/regexec.c.h
cp libgit2/deps/regex/regex_internal.c src/private/deps/regex/regex_internal.c.h

cp -r libgit2/deps/http-parser src/private/deps/http-parser
#cp -r libgit2/deps/winhttp src/private/deps/winhttp
cp -r libgit2/deps/zlib src/private/deps/zlib
sed -i -e 's/src\///g' src/private/deps/zlib/zconf.h
cp -r libgit2/src/* src/private/
pushd src/private/deps/zlib > /dev/null
for f in *.c; do
  mv $f _$f
done
popd > /dev/null
for f in src/private/win32/*.c; do
  mv $f ${f%.c}_windows.c;
done
for f in src/private/unix/*.c; do
  mv $f ${f%.c}_unix.c;
done
mv src/private/hash/hash_win32.c src/private/hash/hash_windows.c
echo "copying headers"
cp -r libgit2/include/git2 src/
cp libgit2/include/git2.h src/
echo "copying examples"
cp -r libgit2/examples/* examples/
