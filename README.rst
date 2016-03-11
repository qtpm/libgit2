Libgit2
=================================

`libgit2 <https://libgit2.github.com/>`_ package for qtpm.

Install
--------------

This is a `qtpm <https://github.com/qtpm/qtpm>`_ package.

.. code-block:: bash

   $ qtpm get github.com/qtpm/libgit2

Headers and a library file are installed under ``vendor/debug`` and ``vendor/release`` directory.

Example
--------------

.. code-block:: cpp

   #include <git2/git2.h>

   int main() {
       git_buf root = {0};
       int error = git_repository_discover(&root, "/tmp/…", 0, NULL);
       git_buf_free(&root);
   }

Reference
--------------

* `libgit2 API <https://libgit2.github.com/libgit2/>`_

Author
--------------

* libgit2 authors
* packaged by Yoshiki Shibukawa

License
--------------

libgit2 is under GPL2 with linking exception.

History
--------------

* 3/11/2016: first version
