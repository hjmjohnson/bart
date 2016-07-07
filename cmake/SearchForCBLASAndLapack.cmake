# Copyright 2015-2016. Hans J. Johnson <hans-johnson@uiowa.edu>
# All rights reserved. Use of this source code is governed by
# a BSD-style license which can be found in the LICENSE file.
# \author Hans J. Johnson <hans-johnson@uiowa.edu>
#
# CBLAS and LAPACKE are relatively new C wrappers added to
# to lapack-3.5.0 and later.  These interfaces are not universally
# supported by optimized versions of blas and lapack (i.e. Apple
# Accelerate framework, Intel-MLK, Atlas, RedhatEL6 default lapack
# do do provide implementation of these interfaces.
#
# Currently supporting only OpenBlas that is available
# on mac from homebrew and MACPORTS, and RHEL6, and debian releases.
#
# TODO: Eventually this file can be extended so that if CBLAS and LAPACKE
#       are not found from optimized versions, then the lapack git repository
#       can be downloaded and compiled with USE_OPTIMZED_LAPACK and USE_OPTIMIZED_BLAS
#       to provide the base fortran from (Atlas, MLK, etc) and the CBLAS/LAPACKE
#       interfaces from a local build.

### Now find CBLAS and LAPACKE interfaces
set(LAPACKE_CBLAS_LIBS ${BLAS_LIBRARIES} ${LAPACK_LIBRARIES})
list(REMOVE_DUPLICATES LAPACKE_CBLAS_LIBS)
foreach(curr_lib ${LAPACKE_CBLAS_LIBS})
  get_filename_component(curr_dir ${curr_lib} DIRECTORY) #Remove library name
  get_filename_component(curr_dir ${curr_dir} DIRECTORY) #Remove "/lib" directory name
  list(APPEND LAPACKE_CBLAS_LIBRARY_SEARCH_DIRS ${curr_dir})
endforeach()
list(REMOVE_DUPLICATES LAPACKE_CBLAS_LIBRARY_SEARCH_DIRS)
message(STATUS "SEARCHING FOR LAPACKE/CBLAS in: ${LAPACKE_CBLAS_LIBRARY_SEARCH_DIRS}")

set(CBLAS_LIBRARY_SEARCH_NAMES cblas)
set(LAPACKE_LIBRARY_SEARCH_NAMES lapacke)

if(BLA_VENDOR MATCHES "OpenBLAS") #The libary name cblas/lapacke is openblas
  set(CBLAS_LIBRARY_SEARCH_NAMES openblas)
  set(LAPACKE_LIBRARY_SEARCH_NAMES openblas)
endif()

if(BLA_VENDOR MATCHES "Intel") #The libary name cblas/lapacke in mlk is UNKOWN
  message(FATAL_ERROR "MLK is not yet supported.")
#  set(CBLAS_LIBRARY_SEARCH_NAMES openblas)
#  set(LAPACKE_LIBRARY_SEARCH_NAMES openblas)
endif()

find_path ( CBLAS_INCLUDE_DIRS 
          name cblas.h
          PATHS  $ENV{CMAKE_PREFIX_PATH}
          PATH_SUFFIXES include
          DOC "search for the LAPCKE_INCLUDE_DIRS cache documentation string"
         )
find_library (
          CBLAS_LIBRARIES
          NAMES ${CBLAS_LIBRARY_SEARCH_NAMES}
          PATHS ${LAPACKE_CBLAS_LIBRARY_SEARCH_DIRS} $ENV{CMAKE_PREFIX_PATH}
          PATH_SUFFIXES lib64 lib
          DOC "find cblas library"
         )
message(STATUS "CBLAS_INCLUDE_DIRS: ${CBLAS_INCLUDE_DIRS}")
message(STATUS "CBLAS_LIBRARIES: ${CBLAS_LIBRARIES}")
find_path ( LAPACKE_INCLUDE_DIRS 
          name lapacke.h
          PATHS $ENV{CMAKE_PREFIX_PATH}
          PATH_SUFFIXES include
          DOC "search for the LAPCKE_INCLUDE_DIRS cache documentation string"
         )
find_library (
          LAPACKE_LIBRARIES
          NAMES ${LAPACKE_LIBRARY_SEARCH_NAMES}
          PATHS ${LAPACKE_CBLAS_LIBRARY_SEARCH_DIRS} $ENV{CMAKE_PREFIX_PATH}
          PATH_SUFFIXES lib64 lib
          DOC "find lapacke library"
         )
message(STATUS "LAPACKE_INCLUDE_DIRS: ${LAPACKE_INCLUDE_DIRS}")
message(STATUS "LAPACKE_LIBRARIES: ${LAPACKE_LIBRARIES}")
