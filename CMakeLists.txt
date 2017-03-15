cmake_minimum_required(VERSION 3.1.0)

# project global setting

project(libgit2)

set(LIBGIT2_MAJOR_VERSION 0)
set(LIBGIT2_MINOR_VERSION 22)
set(LIBGIT2_PATCH_VERSION 1)
set(LIBGIT2_VERSION 0.22.1)

if(DEFINED QTPM_IS_ROOT_PROJECT)
    set(READ_SUBDIRECTORIES FALSE)
else()
    set(READ_SUBDIRECTORIES TRUE)
    set(QTPM_IS_ROOT_PROJECT FALSE)
endif()

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/../../vendor)
    set(VENDOR_PATH ${CMAKE_CURRENT_SOURCE_DIR}/..)
else()
    set(VENDOR_PATH ${CMAKE_CURRENT_SOURCE_DIR}/vendor)
endif()

# compiler setting

set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)
set(CMAKE_CXX_STANDARD 11)
if(MSVC)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")
else()
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
endif()
if(DEFINED EMSCRIPTEN)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -s BINARYEN_METHOD='native-wasm,asmjs' -s BINARYEN=1")
endif()

if(APPLE)
    set(CMAKE_MACOSX_RPATH ON)
    set(CMAKE_SKIP_BUILD_RPATH FALSE)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
    set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
    list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/lib" isSystemDir)
    if("${isSystemDir}" STREQUAL "-1")
        set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
    endif()
endif()

# enable Qt

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
set(CMAKE_INCLUDE_CURRENT_DIR ON)
if(DEFINED ENV{QTDIR})
    set(CMAKE_PREFIX_PATH "$ENV{QTDIR}")
endif()

# extra setting

include("CMakeExtra.txt" OPTIONAL)

# build setting

include_directories(src)
set(sources src/git2/sys/commit.h
    src/git2/sys/config.h
    src/git2/sys/diff.h
    src/git2/sys/filter.h
    src/git2/sys/hashsig.h
    src/git2/sys/index.h
    src/git2/sys/mempack.h
    src/git2/sys/odb_backend.h
    src/git2/sys/openssl.h
    src/git2/sys/refdb_backend.h
    src/git2/sys/reflog.h
    src/git2/sys/refs.h
    src/git2/sys/repository.h
    src/git2/sys/stream.h
    src/git2/sys/transport.h
    src/private/annotated_commit.c
    src/private/annotated_commit.h
    src/private/array.h
    src/private/attr.c
    src/private/attr.h
    src/private/attr_file.c
    src/private/attr_file.h
    src/private/attrcache.c
    src/private/attrcache.h
    src/private/bitvec.h
    src/private/blame.c
    src/private/blame.h
    src/private/blame_git.c
    src/private/blame_git.h
    src/private/blob.c
    src/private/blob.h
    src/private/branch.c
    src/private/branch.h
    src/private/bswap.h
    src/private/buf_text.c
    src/private/buf_text.h
    src/private/buffer.c
    src/private/buffer.h
    src/private/cache.c
    src/private/cache.h
    src/private/cc-compat.h
    src/private/checkout.c
    src/private/checkout.h
    src/private/cherrypick.c
    src/private/clone.c
    src/private/clone.h
    src/private/commit.c
    src/private/commit.h
    src/private/commit_list.c
    src/private/commit_list.h
    src/private/common.h
    src/private/config.c
    src/private/config.h
    src/private/config_cache.c
    src/private/config_file.c
    src/private/config_file.h
    src/private/crlf.c
    src/private/date.c
    src/private/delta-apply.c
    src/private/delta-apply.h
    src/private/delta.c
    src/private/delta.h
    src/private/deps/http-parser/http_parser.c
    src/private/deps/http-parser/http_parser.h
    src/private/deps/regex/config.h
    src/private/deps/regex/regcomp.c.h
    src/private/deps/regex/regex.h
    src/private/deps/regex/regex_internal.c.h
    src/private/deps/regex/regex_internal.h
    src/private/deps/regex/regexec.c.h
    src/private/deps/zlib/crc32.h
    src/private/deps/zlib/deflate.h
    src/private/deps/zlib/inffast.h
    src/private/deps/zlib/inffixed.h
    src/private/deps/zlib/inflate.h
    src/private/deps/zlib/inftrees.h
    src/private/deps/zlib/trees.h
    src/private/deps/zlib/zconf.h
    src/private/deps/zlib/zlib.h
    src/private/deps/zlib/zutil.h
    src/private/describe.c
    src/private/diff.c
    src/private/diff.h
    src/private/diff_driver.c
    src/private/diff_driver.h
    src/private/diff_file.c
    src/private/diff_file.h
    src/private/diff_patch.c
    src/private/diff_patch.h
    src/private/diff_print.c
    src/private/diff_stats.c
    src/private/diff_tform.c
    src/private/diff_xdiff.c
    src/private/diff_xdiff.h
    src/private/errors.c
    src/private/fetch.c
    src/private/fetch.h
    src/private/fetchhead.c
    src/private/fetchhead.h
    src/private/filebuf.c
    src/private/filebuf.h
    src/private/fileops.c
    src/private/fileops.h
    src/private/filter.c
    src/private/filter.h
    src/private/fnmatch.c
    src/private/fnmatch.h
    src/private/global.c
    src/private/global.h
    src/private/graph.c
    src/private/hash.c
    src/private/hash.h
    src/private/hash/hash_common_crypto.h
    src/private/hash/hash_generic.h
    src/private/hash/hash_openssl.h
    src/private/hash/hash_win32.h
    src/private/hashsig.c
    src/private/ident.c
    src/private/ignore.c
    src/private/ignore.h
    src/private/index.c
    src/private/index.h
    src/private/indexer.c
    src/private/iterator.c
    src/private/iterator.h
    src/private/khash.h
    src/private/map.h
    src/private/merge.c
    src/private/merge.h
    src/private/merge_file.c
    src/private/merge_file.h
    src/private/message.c
    src/private/message.h
    src/private/mwindow.c
    src/private/mwindow.h
    src/private/netops.c
    src/private/netops.h
    src/private/notes.c
    src/private/notes.h
    src/private/object.c
    src/private/object.h
    src/private/object_api.c
    src/private/odb.c
    src/private/odb.h
    src/private/odb_loose.c
    src/private/odb_mempack.c
    src/private/odb_pack.c
    src/private/offmap.h
    src/private/oid.c
    src/private/oid.h
    src/private/oidarray.c
    src/private/oidarray.h
    src/private/oidmap.h
    src/private/openssl_stream.c
    src/private/openssl_stream.h
    src/private/pack-objects.c
    src/private/pack-objects.h
    src/private/pack.c
    src/private/pack.h
    src/private/path.c
    src/private/path.h
    src/private/pathspec.c
    src/private/pathspec.h
    src/private/pool.c
    src/private/pool.h
    src/private/posix.c
    src/private/posix.h
    src/private/pqueue.c
    src/private/pqueue.h
    src/private/push.c
    src/private/push.h
    src/private/rebase.c
    src/private/refdb.c
    src/private/refdb.h
    src/private/refdb_fs.c
    src/private/refdb_fs.h
    src/private/reflog.c
    src/private/reflog.h
    src/private/refs.c
    src/private/refs.h
    src/private/refspec.c
    src/private/refspec.h
    src/private/remote.c
    src/private/remote.h
    src/private/repo_template.h
    src/private/repository.c
    src/private/repository.h
    src/private/reset.c
    src/private/revert.c
    src/private/revparse.c
    src/private/revwalk.c
    src/private/revwalk.h
    src/private/settings.c
    src/private/sha1_lookup.c
    src/private/sha1_lookup.h
    src/private/signature.c
    src/private/signature.h
    src/private/socket_stream.c
    src/private/socket_stream.h
    src/private/sortedcache.c
    src/private/sortedcache.h
    src/private/stash.c
    src/private/status.c
    src/private/status.h
    src/private/stream.h
    src/private/strmap.c
    src/private/strmap.h
    src/private/strnlen.h
    src/private/submodule.c
    src/private/submodule.h
    src/private/sysdir.c
    src/private/sysdir.h
    src/private/tag.c
    src/private/tag.h
    src/private/thread-utils.c
    src/private/thread-utils.h
    src/private/trace.c
    src/private/trace.h
    src/private/transaction.c
    src/private/transport.c
    src/private/transports/auth.c
    src/private/transports/auth.h
    src/private/transports/auth_negotiate.c
    src/private/transports/auth_negotiate.h
    src/private/transports/cred.c
    src/private/transports/cred.h
    src/private/transports/cred_helpers.c
    src/private/transports/git.c
    src/private/transports/http.c
    src/private/transports/local.c
    src/private/transports/smart.c
    src/private/transports/smart.h
    src/private/transports/smart_pkt.c
    src/private/transports/smart_protocol.c
    src/private/transports/ssh.c
    src/private/transports/winhttp.c
    src/private/tree-cache.c
    src/private/tree-cache.h
    src/private/tree.c
    src/private/tree.h
    src/private/tsort.c
    src/private/unix/posix.h
    src/private/userdiff.h
    src/private/util.c
    src/private/util.h
    src/private/vector.c
    src/private/vector.h
    src/private/win32/config.h
    src/private/win32/dir.h
    src/private/win32/error.h
    src/private/win32/findfile.h
    src/private/win32/mingw-compat.h
    src/private/win32/msvc-compat.h
    src/private/win32/path_w32.h
    src/private/win32/posix.h
    src/private/win32/precompiled.h
    src/private/win32/pthread.h
    src/private/win32/reparse.h
    src/private/win32/utf-conv.h
    src/private/win32/version.h
    src/private/win32/w32_util.h
    src/private/xdiff/xdiff.h
    src/private/xdiff/xdiffi.c
    src/private/xdiff/xdiffi.h
    src/private/xdiff/xemit.c
    src/private/xdiff/xemit.h
    src/private/xdiff/xhistogram.c
    src/private/xdiff/xinclude.h
    src/private/xdiff/xmacros.h
    src/private/xdiff/xmerge.c
    src/private/xdiff/xpatience.c
    src/private/xdiff/xprepare.c
    src/private/xdiff/xprepare.h
    src/private/xdiff/xtypes.h
    src/private/xdiff/xutils.c
    src/private/xdiff/xutils.h
    src/private/zstream.c
    src/private/zstream.h)
if(NOT APPLE)
  list(APPEND sources src/private/deps/zlib/adler32_not_darwin.c
      src/private/deps/zlib/crc32_not_darwin.c
      src/private/deps/zlib/deflate_not_darwin.c
      src/private/deps/zlib/infback_not_darwin.c
      src/private/deps/zlib/inffast_not_darwin.c
      src/private/deps/zlib/inflate_not_darwin.c
      src/private/deps/zlib/inftrees_not_darwin.c
      src/private/deps/zlib/trees_not_darwin.c
      src/private/deps/zlib/zutil_not_darwin.c)
endif(NOT APPLE)
if(UNIX)
  list(APPEND sources src/private/hash/hash_unix.c
      src/private/unix/map_unix.c
      src/private/unix/realpath_unix.c)
endif(UNIX)
if(WIN32)
  list(APPEND sources src/private/deps/regex/regex_windows.c
      src/private/hash/hash_windows.c
      src/private/win32/dir_windows.c
      src/private/win32/error_windows.c
      src/private/win32/findfile_windows.c
      src/private/win32/map_windows.c
      src/private/win32/path_w32_windows.c
      src/private/win32/posix_w32_windows.c
      src/private/win32/precompiled_windows.c
      src/private/win32/pthread_windows.c
      src/private/win32/utf-conv_windows.c
      src/private/win32/w32_util_windows.c)
endif(WIN32)
add_library(git2 STATIC ${sources})
# install setting

install(TARGETS git2 ARCHIVE DESTINATION lib)

set(public_headers src/git2.h)
install(FILES ${public_headers} DESTINATION include/libgit2/)

set(public_headers__git2 src/git2/annotated_commit.h
    src/git2/attr.h
    src/git2/blame.h
    src/git2/blob.h
    src/git2/branch.h
    src/git2/buffer.h
    src/git2/checkout.h
    src/git2/cherrypick.h
    src/git2/clone.h
    src/git2/commit.h
    src/git2/common.h
    src/git2/config.h
    src/git2/cred_helpers.h
    src/git2/describe.h
    src/git2/diff.h
    src/git2/errors.h
    src/git2/filter.h
    src/git2/global.h
    src/git2/graph.h
    src/git2/ignore.h
    src/git2/index.h
    src/git2/indexer.h
    src/git2/inttypes.h
    src/git2/merge.h
    src/git2/message.h
    src/git2/net.h
    src/git2/notes.h
    src/git2/object.h
    src/git2/odb.h
    src/git2/odb_backend.h
    src/git2/oid.h
    src/git2/oidarray.h
    src/git2/pack.h
    src/git2/patch.h
    src/git2/pathspec.h
    src/git2/push.h
    src/git2/rebase.h
    src/git2/refdb.h
    src/git2/reflog.h
    src/git2/refs.h
    src/git2/refspec.h
    src/git2/remote.h
    src/git2/repository.h
    src/git2/reset.h
    src/git2/revert.h
    src/git2/revparse.h
    src/git2/revwalk.h
    src/git2/signature.h
    src/git2/stash.h
    src/git2/status.h
    src/git2/stdint.h
    src/git2/strarray.h
    src/git2/submodule.h
    src/git2/tag.h
    src/git2/trace.h
    src/git2/transaction.h
    src/git2/transport.h
    src/git2/tree.h
    src/git2/types.h
    src/git2/version.h)
install(FILES ${public_headers__git2} DESTINATION include/libgit2/git2)


install(FILES ${public_headers__git2__sys} DESTINATION include/libgit2/git2/sys)
