#include <iostream>
#include <thread>
#include <mutex>

std::mutex mtx; // Global mutex for shared resource
int shared_counter = 0;

void increment() {
    // lock_guard automatically locks mtx upon creation, 
    // and unlocks it when it goes out of scope.
    std::lock_guard<std::mutex> lock(mtx);
    
    ++shared_counter;
    std::cout << "Thread ID: " << std::this_thread::get_id() 
              << " | Counter: " << shared_counter << '\n';
}

int main() {
    std::thread t1(increment);
    std::thread t2(increment);

    t1.join();
    t2.join();

    return 0;
}
