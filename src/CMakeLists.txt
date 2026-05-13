cmake_minimum_required(VERSION 3.28.3)

# Find CppUnit
find_package(PkgConfig REQUIRED)
pkg_check_modules(CPPUNIT REQUIRED cppunit)

# Test sources
set(TEST_SOURCES
    Test_assign.cpp
    main.cpp
    log.cpp
)

# Create test executable
add_executable(ast_utest ${TEST_SOURCES})

# Link libraries
target_link_libraries(streamy_test
    ${PROJECT_NAME}_lib
    ${CPPUNIT_LIBRARIES}
)

# Include directories
target_include_directories(ast_utest PRIVATE ${CPPUNIT_INCLUDE_DIRS})

# Compiler flags
target_compile_options(ast_utest PRIVATE ${CPPUNIT_CFLAGS_OTHER})

# Add test to CTest
add_test(NAME UnitTests COMMAND ast_utest)