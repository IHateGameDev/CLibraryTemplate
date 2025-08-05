cmake_minimum_required(VERSION 3.10)
project(Template)

option(REMOVE_INPUTS "Remove *.in files" ON)

set(PROJECT_NAME "defaultProjectName" CACHE STRING "Project name insert")
set(FOUNDERS "Semenovih Andrey" CACHE STRING "Project founders")
set(LIBRARY_PREFIX "defaultLibraryPrefix" CACHE STRING "Library prefix")
set(STRUCT_PREFIX "${LIBRARY_PREFIX}" CACHE STRING "Struct prefix")

string(TOUPPER ${LIBRARY_PREFIX} MACRO_PREFIX)
string(TOLOWER ${LIBRARY_PREFIX} FUNCTION_PREFIX)
string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)

string(TIMESTAMP CURRENT_YEAR "%Y")

message(STATUS "Poject name: ${PROJECT_NAME}")
message(STATUS "Founders: ${FOUNDERS}")
message(STATUS "Library prefix: ${LIBRARY_PREFIX}")
message(STATUS "Struct prefix: ${STRUCT_PREFIX}")
message(STATUS "Macro prefix: ${MACRO_PREFIX}")
message(STATUS "Function prefix: ${FUNCTION_PREFIX}")
message(STATUS "Current year: ${CURRENT_YEAR}")

file(GLOB_RECURSE ffi "*.in")

foreach(fileIn ${ffi})
  message(STATUS "File input: ${fileIn}")

  string(LENGTH ${fileIn} fileOutLength)
  math(EXPR fileOutWLELength "${fileOutLength} - 3")
  string(SUBSTRING "${fileIn}" 0 ${fileOutWLELength} fileOut)

  message(STATUS "File output ${fileOut}\n")

  configure_file(${fileIn} ${fileOut} @ONLY)

  if(REMOVE_INPUTS)
    file(REMOVE ${fileIn})
  endif()
endforeach()

file(RENAME "${CMAKE_SOURCE_DIR}/Lib" "${CMAKE_SOURCE_DIR}/${PROJECT_NAME}")
