#include <iostream>
#include <spdlog/spdlog.h>

int main() {
  spdlog::info("SQL Learning Game - Bootstrap Version");
  spdlog::info("Project structure initialized successfully!");

  std::cout << "Welcome to the SQL Learning Game!\n";
  std::cout << "This is the bootstrap version (M0 milestone).\n";
  std::cout << "The project foundation has been set up with:\n";
  std::cout << "  - CMake build system with C++23 support\n";
  std::cout << "  - Clang compiler configuration\n";
  std::cout << "  - Modern C++ dependencies (spdlog, yaml-cpp, sqlpp11, "
               "GoogleTest)\n";
  std::cout << "  - Modular directory structure\n";
  std::cout << "  - Ready for M1 implementation phase\n";

  return 0;
}
