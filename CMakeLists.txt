# File Name:  CMakeLists.txt
# Build Date: Sat, Nov 29, 2025  1:20:21 AM
# Version:    0.1.1

cmake_minimum_required(VERSION 3.28.3)
# We don't use the C++ compiler, so don't let project()
# test for it in case the platform doesn't have one
project(streamy VERSION 0.1.0
                DESCRIPTION "Very nice project"
                LANGUAGES CXX)


if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    # Specify the C++ standard (e.g., C++14)
    set(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "CYGWIN")
    message(STATUS "Building under Cygwin, defining CYGWIN macro")
    add_definitions(-DCYGWIN)
endif()

set(Boost_DIR  "/home/brian/src/boost_1_91_0/tools/cmake/config/")  # only find static libs
include_directories(${Boost_INCLUDE_DIRS})
# Find the Boost package, requiring the 'regex' component
# 'CONFIG' mode is generally preferred with modern Boost versions (1.70+)
find_package(Boost 1.66.0 CONFIG REQUIRED COMPONENTS regex)

# Find required packages
find_package(fmt REQUIRED)
if(NOT fmt_FOUND)
   message(FATAL_ERROR "fmt not found")
endif()

find_package(PkgConfig REQUIRED)
pkg_check_modules(CPPUNIT REQUIRED cppunit)
if(NOT CPPUNIT_FOUND)
   message(FATAL_ERROR "CPPUnit not found")
endif()

# Include directories
include_directories(${CMAKE_SOURCE_DIR}/src, ${CMAKE_SOURCE_DIR}/cbuild, )

# Add source files
set(SOURCES
        src/fileio.cpp
        src/utility.cpp
        src/ast.cpp
		src/lexer.cpp
		build/pparser.tab.cpp
		src/log.cpp
		src/parser.cpp
)

# Create test executable
add_executable(${PROJECT_NAME} ${SOURCES})

# include(FetchContent)
# FetchContent_Declare(
#   fmt
#   GIT_REPOSITORY https://github.com/fmtlib/fmt
#   GIT_TAG        e69e5f977d458f2650bb346dadf2ad30c5320281) # 10.2.1
# FetchContent_MakeAvailable(fmt)
# target_link_libraries(${PROJECT_NAME} fmt::fmt)


# Link the executable against the Boost::regex imported target
# CMake handles linking to the correct library file and adding the include directories
target_link_libraries(${PROJECT_NAME} PRIVATE Boost::regex)

# Create library from sources
#add_library(${PROJECT_NAME}_lib ${SOURCES})

# Enable testing
enable_testing()

# Add tests subdirectory
#add_subdirectory(tests)
