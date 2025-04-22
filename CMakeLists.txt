cmake_minimum_required(VERSION 3.10)
project(Template)

option(OVERWRITE_LISTS "CMakeLists.txt.in to CMakeLists.txt(not CMakeLists.txt.out)" ON)
option(REMOVE_INPUTS "Remove *.in files" ON)

set(PROJECT_NAME "defaultProjectName" CACHE STRING "Project name insert")
set(LIBRARY_PREFIX "defaultLibraryPrefix" CACHE STRING "Library prefix")
set(STRUCT_PREFIX "${LIBRARY_PREFIX}" CACHE STRING "Struct prefix")

string(TOUPPER ${LIBRARY_PREFIX} MACRO_PREFIX)
string(TOLOWER ${LIBRARY_PREFIX} FUNCTION_PREFIX)
string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)

string(TIMESTAMP CURRENT_YEAR "%Y")

message(STATUS "Poject name: ${PROJECT_NAME}")
message(STATUS "Library prefix: ${LIBRARY_PREFIX}")
message(STATUS "Struct prefix: ${STRUCT_PREFIX}")
message(STATUS "Macro prefix: ${MACRO_PREFIX}")
message(STATUS "Function prefix: ${FUNCTION_PREFIX}")
message(STATUS "Current year: ${CURRENT_YEAR}")

file(GLOB_RECURSE ffi "*.in")

list(REMOVE_ITEM ffi "${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt.in")

foreach(fileIn ${ffi})
  get_filename_component(fileOut ${fileIn} NAME_WE)
  get_filename_component(fileDir ${fileIn} DIRECTORY)
  configure_file(${fileIn} "${fileDir}/${fileOut}" @ONLY)
  
  if(REMOVE_INPUTS)
    file(REMOVE ${fileIn})
  endif()
endforeach()

if(OVERWRITE_LISTS)
  configure_file(CMakeLists.txt.in CMakeLists.txt @ONLY)
else()
  configure_file(CMakeLists.txt.in CMakeLists.txt.out @ONLY)
endif()

