cmake_minimum_required(VERSION 3.1.0)

# project global setting

project(git2)

set(GIT2_MAJOR_VERSION 0)
set(GIT2_MINOR_VERSION 24)
set(GIT2_PATCH_VERSION 0)
set(GIT2_VERSION
 ${GIT2_MAJOR_VERSION}.${GIT2_MINOR_VERSION}.${GIT2_PATCH_VERSION})
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
set(sources src/private/annotated_commit.c src/private/attr.c src/private/attr_file.c src/private/attrcache.c src/private/blame.c src/private/blame_git.c src/private/blob.c src/private/branch.c src/private/buf_text.c src/private/buffer.c src/private/cache.c src/private/checkout.c src/private/cherrypick.c src/private/clone.c src/private/commit.c src/private/commit_list.c src/private/config.c src/private/config_cache.c src/private/config_file.c src/private/crlf.c src/private/curl_stream.c src/private/date.c src/private/delta-apply.c src/private/delta.c src/private/deps/http-parser/http_parser.c src/private/describe.c src/private/diff.c src/private/diff_driver.c src/private/diff_file.c src/private/diff_patch.c src/private/diff_print.c src/private/diff_stats.c src/private/diff_tform.c src/private/diff_xdiff.c src/private/errors.c src/private/fetch.c src/private/fetchhead.c src/private/filebuf.c src/private/fileops.c src/private/filter.c src/private/fnmatch.c src/private/global.c src/private/graph.c src/private/hash.c src/private/hash/hash_generic.c src/private/hashsig.c src/private/ident.c src/private/ignore.c src/private/index.c src/private/indexer.c src/private/iterator.c src/private/merge.c src/private/merge_file.c src/private/message.c src/private/mwindow.c src/private/netops.c src/private/notes.c src/private/object.c src/private/object_api.c src/private/odb.c src/private/odb_loose.c src/private/odb_mempack.c src/private/odb_pack.c src/private/oid.c src/private/oidarray.c src/private/openssl_stream.c src/private/pack-objects.c src/private/pack.c src/private/path.c src/private/pathspec.c src/private/pool.c src/private/posix.c src/private/pqueue.c src/private/push.c src/private/rebase.c src/private/refdb.c src/private/refdb_fs.c src/private/reflog.c src/private/refs.c src/private/refspec.c src/private/remote.c src/private/repository.c src/private/reset.c src/private/revert.c src/private/revparse.c src/private/revwalk.c src/private/settings.c src/private/sha1_lookup.c src/private/signature.c src/private/socket_stream.c src/private/sortedcache.c src/private/stash.c src/private/status.c src/private/stransport_stream.c src/private/strmap.c src/private/submodule.c src/private/sysdir.c src/private/tag.c src/private/thread-utils.c src/private/tls_stream.c src/private/trace.c src/private/transaction.c src/private/transport.c src/private/transports/auth.c src/private/transports/auth_negotiate.c src/private/transports/cred.c src/private/transports/cred_helpers.c src/private/transports/git.c src/private/transports/http.c src/private/transports/local.c src/private/transports/smart.c src/private/transports/smart_pkt.c src/private/transports/smart_protocol.c src/private/transports/ssh.c src/private/transports/winhttp.c src/private/tree-cache.c src/private/tree.c src/private/tsort.c src/private/util.c src/private/vector.c src/private/xdiff/xdiffi.c src/private/xdiff/xemit.c src/private/xdiff/xhistogram.c src/private/xdiff/xmerge.c src/private/xdiff/xpatience.c src/private/xdiff/xprepare.c src/private/xdiff/xutils.c src/private/zstream.c)
if(UNIX)
  list(APPEND sources src/private/unix/map_unix.c src/private/unix/realpath_unix.c)
endif(UNIX)
if(WIN32)
  list(APPEND sources src/private/deps/regex/regex_windows.c src/private/hash/hash_windows.c src/private/win32/dir_windows.c src/private/win32/error_windows.c src/private/win32/findfile_windows.c src/private/win32/map_windows.c src/private/win32/path_w32_windows.c src/private/win32/posix_w32_windows.c src/private/win32/precompiled_windows.c src/private/win32/pthread_windows.c src/private/win32/utf-conv_windows.c src/private/win32/w32_buffer_windows.c src/private/win32/w32_crtdbg_stacktrace_windows.c src/private/win32/w32_stack_windows.c src/private/win32/w32_util_windows.c)
endif(WIN32)

add_library(git2 SHARED ${sources})
SET_TARGET_PROPERTIES(git2 PROPERTIES VERSION ${GIT2_VERSION} SOVERSION ${GIT2_MAJOR_VERSION})


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

install(FILES ${public_headers} DESTINATION include/git2)
foreach(dir IN LISTS extra_install_dirs)

  install(DIRECTORY ${dir} DESTINATION include/git2)
endforeach()

