#include <iostream>
#include <cppunit/CompilerOutputter.h>
#include <cppunit/extensions/TestFactoryRegistry.h>
#include <cppunit/TestResult.h>
#include <cppunit/TestResultCollector.h>
#include <cppunit/TestRunner.h>
#include <cppunit/BriefTestProgressListener.h>


using std::cout;
using std::endl;

int main() {

    #ifdef __CYGWIN__
        std::cout << "Running on Cygwin." << std::endl;
    #elif _WIN32
        std::cout << "Running on Windows (but not Cygwin)." << std::endl;
    #else
        std::cout << "Running on a non-Windows, non-Cygwin system." << std::endl;
    #endif
    
    // Create the event manager and test controller
    CppUnit::TestResult controller;

    // Add a listener that collects test results
    CppUnit::TestResultCollector result;
    controller.addListener( &result );

    // Add a listener that prints dots as tests run
    CppUnit::BriefTestProgressListener progress;
    controller.addListener( &progress );

    // Add the top suite to the test runner
    CppUnit::TestRunner runner;
    runner.addTest( CppUnit::TestFactoryRegistry::getRegistry().makeTest() );
    runner.run( controller );

    // Print test results
    CppUnit::CompilerOutputter outputter( &result, std::cerr );
    outputter.write();

    return result.wasSuccessful() ? 0 : 1;
}