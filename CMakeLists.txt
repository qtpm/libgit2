cmake_minimum_required(VERSION 3.1.0)

# project global setting

project(libgit2)

set(LIBGIT2_MAJOR_VERSION 0)
set(LIBGIT2_MINOR_VERSION 22)
set(LIBGIT2_PATCH_VERSION 1)
set(LIBGIT2_VERSION
 ${LIBGIT2_MAJOR_VERSION}.${LIBGIT2_MINOR_VERSION}.${LIBGIT2_PATCH_VERSION})
set(CMAKE_BUILD_TYPE Debug)
set(WORKDIR "build-debug")


# compiler setting

set(CMAKE_CXX_STANDARD 11)
if(MSVC)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")
else()
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
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
set(CMAKE_INCLUDE_CURRENT_DIR ON)
if(DEFINED ENV{QTDIR})
    set(CMAKE_PREFIX_PATH "$ENV{QTDIR}")
endif()
if(DEFINED ENV{QTPM_INCLUDE_PATH})
    include_directories("$ENV{QTPM_INCLUDE_PATH}")
endif()
if(DEFINED ENV{QTPM_LIBRARY_PATH})
    link_directories("$ENV{QTPM_LIBRARY_PATH}")
endif()


# include extra settings

include("CMakeExtra.txt")

# build setting

include_directories(src)
set(sources src/private/annotated_commit.c src/private/attr.c src/private/attr_file.c src/private/attrcache.c src/private/blame.c src/private/blame_git.c src/private/blob.c src/private/branch.c src/private/buf_text.c src/private/buffer.c src/private/cache.c src/private/checkout.c src/private/cherrypick.c src/private/clone.c src/private/commit.c src/private/commit_list.c src/private/config.c src/private/config_cache.c src/private/config_file.c src/private/crlf.c src/private/date.c src/private/delta-apply.c src/private/delta.c src/private/deps/http-parser/http_parser.c src/private/describe.c src/private/diff.c src/private/diff_driver.c src/private/diff_file.c src/private/diff_patch.c src/private/diff_print.c src/private/diff_stats.c src/private/diff_tform.c src/private/diff_xdiff.c src/private/errors.c src/private/fetch.c src/private/fetchhead.c src/private/filebuf.c src/private/fileops.c src/private/filter.c src/private/fnmatch.c src/private/global.c src/private/graph.c src/private/hash.c src/private/hash/hash_generic.c src/private/hashsig.c src/private/ident.c src/private/ignore.c src/private/index.c src/private/indexer.c src/private/iterator.c src/private/merge.c src/private/merge_file.c src/private/message.c src/private/mwindow.c src/private/netops.c src/private/notes.c src/private/object.c src/private/object_api.c src/private/odb.c src/private/odb_loose.c src/private/odb_mempack.c src/private/odb_pack.c src/private/oid.c src/private/oidarray.c src/private/openssl_stream.c src/private/pack-objects.c src/private/pack.c src/private/path.c src/private/pathspec.c src/private/pool.c src/private/posix.c src/private/pqueue.c src/private/push.c src/private/rebase.c src/private/refdb.c src/private/refdb_fs.c src/private/reflog.c src/private/refs.c src/private/refspec.c src/private/remote.c src/private/repository.c src/private/reset.c src/private/revert.c src/private/revparse.c src/private/revwalk.c src/private/settings.c src/private/sha1_lookup.c src/private/signature.c src/private/socket_stream.c src/private/sortedcache.c src/private/stash.c src/private/status.c src/private/strmap.c src/private/submodule.c src/private/sysdir.c src/private/tag.c src/private/thread-utils.c src/private/trace.c src/private/transaction.c src/private/transport.c src/private/transports/auth.c src/private/transports/auth_negotiate.c src/private/transports/cred.c src/private/transports/cred_helpers.c src/private/transports/git.c src/private/transports/http.c src/private/transports/local.c src/private/transports/smart.c src/private/transports/smart_pkt.c src/private/transports/smart_protocol.c src/private/transports/ssh.c src/private/transports/winhttp.c src/private/tree-cache.c src/private/tree.c src/private/tsort.c src/private/util.c src/private/vector.c src/private/xdiff/xdiffi.c src/private/xdiff/xemit.c src/private/xdiff/xhistogram.c src/private/xdiff/xmerge.c src/private/xdiff/xpatience.c src/private/xdiff/xprepare.c src/private/xdiff/xutils.c src/private/zstream.c)
if(UNIX)
  list(APPEND sources src/private/unix/map_unix.c src/private/unix/realpath_unix.c)
endif(UNIX)
if(WIN32)
  list(APPEND sources src/private/deps/regex/regex_windows.c src/private/hash/hash_windows.c src/private/win32/dir_windows.c src/private/win32/error_windows.c src/private/win32/findfile_windows.c src/private/win32/map_windows.c src/private/win32/path_w32_windows.c src/private/win32/posix_w32_windows.c src/private/win32/precompiled_windows.c src/private/win32/pthread_windows.c src/private/win32/utf-conv_windows.c src/private/win32/w32_util_windows.c)
endif(WIN32)

add_library(git2 SHARED ${sources})
SET_TARGET_PROPERTIES(git2 PROPERTIES VERSION ${LIBGIT2_VERSION} SOVERSION ${LIBGIT2_MAJOR_VERSION})

# build examples

file(GLOB examples RELATIVE examples *.cpp)
foreach(path IN LISTS examples)
  get_filename_component(target ${path} NAME_WE)
  add_executable(${target} ${path})
  qt5_use_modules(${target})
  target_link_libraries(${target} git2)
endforeach()

# install setting

install(TARGETS git2 LIBRARY DESTINATION lib)

set(public_headers src/git2.h)

install(FILES ${public_headers} DESTINATION include/libgit2/)

set(public_headers__git2 src/git2/annotated_commit.h src/git2/attr.h src/git2/blame.h src/git2/blob.h src/git2/branch.h src/git2/buffer.h src/git2/checkout.h src/git2/cherrypick.h src/git2/clone.h src/git2/commit.h src/git2/common.h src/git2/config.h src/git2/cred_helpers.h src/git2/describe.h src/git2/diff.h src/git2/errors.h src/git2/filter.h src/git2/global.h src/git2/graph.h src/git2/ignore.h src/git2/index.h src/git2/indexer.h src/git2/inttypes.h src/git2/merge.h src/git2/message.h src/git2/net.h src/git2/notes.h src/git2/object.h src/git2/odb.h src/git2/odb_backend.h src/git2/oid.h src/git2/oidarray.h src/git2/pack.h src/git2/patch.h src/git2/pathspec.h src/git2/push.h src/git2/rebase.h src/git2/refdb.h src/git2/reflog.h src/git2/refs.h src/git2/refspec.h src/git2/remote.h src/git2/repository.h src/git2/reset.h src/git2/revert.h src/git2/revparse.h src/git2/revwalk.h src/git2/signature.h src/git2/stash.h src/git2/status.h src/git2/stdint.h src/git2/strarray.h src/git2/submodule.h src/git2/tag.h src/git2/trace.h src/git2/transaction.h src/git2/transport.h src/git2/tree.h src/git2/types.h src/git2/version.h)

install(FILES ${public_headers__git2} DESTINATION include/libgit2/git2)

set(public_headers__git2__sys src/git2/sys/commit.h src/git2/sys/config.h src/git2/sys/diff.h src/git2/sys/filter.h src/git2/sys/hashsig.h src/git2/sys/index.h src/git2/sys/mempack.h src/git2/sys/odb_backend.h src/git2/sys/openssl.h src/git2/sys/refdb_backend.h src/git2/sys/reflog.h src/git2/sys/refs.h src/git2/sys/repository.h src/git2/sys/stream.h src/git2/sys/transport.h)

install(FILES ${public_headers__git2__sys} DESTINATION include/libgit2/git2/sys)
