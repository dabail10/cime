# - Try to find NetCDF-Fortran
#
# This can be controlled by setting the NetCDF_DIR CMake variable, or the
# NETCDF environment variable.
#
# Once done, this will define:
#
#   NetCDF_Fortran_IS_SHARED    (BOOL) - Whether library is shared/dynamic
#   NetCDF_Fortran_FOUND        (BOOL) - system has NetCDF
#   NetCDF_Fortran_INCLUDE_DIR  (PATH) - Location of the Fortran include files
#   NetCDF_Fortran_INCLUDE_DIRS (LIST) - the NetCDF include directories
#   NetCDF_Fortran_LIBRARY      (FILE) - Path to the Fortran library file
#   NetCDF_Fortran_LIBRARIES    (LIST) - link these to use NetCDF
#   NetCDF_Fortran_DEFINITIONS  (LIST) - preprocessor macros to use with NetCDF
#   NetCDF_Fortran_OPTIONS      (LIST) - compiler options to use NetCDF

# Determine include dir search order
set (NetCDF_Fortran_INCLUDE_HINTS)
if (NetCDF_Fortran_INCLUDE_DIR)
    list (APPEND NetCDF_Fortran_INCLUDE_HINTS ${NetCDF_Fortran_INCLUDE_DIR})
endif ()
if (NetCDF_DIR)
    list (APPEND NetCDF_Fortran_INCLUDE_HINTS ${NetCDF_DIR}/include)
endif ()
if (DEFINED ENV{NETCDF})
    list (APPEND NetCDF_Fortran_INCLUDE_HINTS $ENV{NETCDF}/include)
endif ()

# Search for include file
find_path (NetCDF_Fortran_INCLUDE_DIR
           NAMES netcdf.inc netcdf.mod
           HINTS ${NetCDF_Fortran_INCLUDE_HINTS})
           
# Unset include search variables
unset (NetCDF_Fortran_INCLUDE_HINTS)

# Determine library dir search order
set (NetCDF_Fortran_LIBRARY_HINTS)
if (NetCDF_Fortran_LIBRARY)
    get_filename_component (netcdf_c_library_path ${NetCDF_Fortran_LIBRARY} PATH)
    list (APPEND NetCDF_Fortran_LIBRARY_HINTS ${netcdf_c_library_path})
    unset (netcdf_c_library_path)
endif ()
if (NetCDF_DIR)
    list (APPEND NetCDF_Fortran_LIBRARY_HINTS ${NetCDF_DIR}/lib)
endif ()
if (DEFINED ENV{NETCDF})
    list (APPEND NetCDF_Fortran_LIBRARY_HINTS $ENV{NETCDF}/lib)
endif ()

# Search for library file
set (NetCDF_Fortran_IS_SHARED FALSE)
find_library (NetCDF_Fortran_LIBRARY
              NAMES netcdff
              HINTS ${NetCDF_Fortran_LIBRARY_HINTS})
if (NetCDF_Fortran_LIBRARY)
    set (NetCDF_Fortran_IS_SHARED TRUE)
else ()
    find_library (NetCDF_Fortran_LIBRARY
                  NAMES libnetcdff.a
                  HINTS ${NetCDF_Fortran_LIBRARY_HINTS})
endif ()

# Unset include search variables
unset (NetCDF_Fortran_LIBRARY_HINTS)

# Set return variables
set (NetCDF_Fortran_INCLUDE_DIRS ${NetCDF_Fortran_INCLUDE_DIR} )
set (NetCDF_Fortran_LIBRARIES ${NetCDF_Fortran_LIBRARY} )
set (NetCDF_Fortran_DEFINITIONS)
set (NetCDF_Fortran_OPTIONS)

# If static, look for dependencies
if (NOT NetCDF_Fortran_IS_SHARED)

    # Dependency find_package arguments
    set (find_args)
    if (NetCDF_Fortran_FIND_REQUIRED)
        list (APPEND find_args REQUIRED)
    endif ()
    if (NetCDF_Fortran_FIND_QUIETLY)
        list (APPEND find_args QUIET)
    endif ()

    # DEPENDENCY: HDF5
    find_package (HDF5 ${find_args})
    if (HDF5_FOUND)
        list (APPEND NetCDF_Fortran_INCLUDE_DIRS ${HDF5_INCLUDE_DIRS})
        list (APPEND NetCDF_Fortran_LIBRARIES ${HDF5_Fortran_LIBRARIES}
                                              ${HDF5_HL_LIBRARIES})
    endif ()

     
endif ()

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and 
# set NetCDF_Fortran_FOUND to TRUE if all listed variables are TRUE
find_package_handle_standard_args (NetCDF_Fortran DEFAULT_MSG
                                   NetCDF_Fortran_LIBRARY NetCDF_Fortran_INCLUDE_DIR)
mark_as_advanced (NetCDF_Fortran_INCLUDE_DIR NetCDF_Fortran_LIBRARY)

# HACK For bug in CMake v3.0:
set (NetCDF_Fortran_FOUND ${NETCDF_FORTRAN_FOUND})
