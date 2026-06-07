#include <iostream>
#include <thread>
#include <mutex>

std::mutex mtx; // Global mutex for shared resource
int shared_counter = 0;

void increment() {
    // lock_guard automatically locks mtx upon creation, 
    // and unlocks it when it goes out of scope.
    mtx.lock();
    
    ++shared_counter;
    std::cout << "Thread ID: " << std::this_thread::get_id() 
              << " | Counter: " << shared_counter << '\n';

    mtx.unlock();
}

int main() {
    std::thread t1(increment);
    std::thread t2(increment);

    t1.join();
    t2.join();

    return 0;
}
