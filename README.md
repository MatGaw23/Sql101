# SQL Learning Game

An interactive C++ console game that teaches SQL through progressive, interactive challenges using modern C++ and the `sqlpp11` library.

## Project Status: M0 Bootstrap Complete ✅

The project foundation has been successfully implemented with:

- ✅ CMake build system with C++23
- ✅ Modern dependency management
- ✅ Modular directory structure
- ✅ Core dependencies integrated:
  - `sqlpp11` - Type-safe SQL DSL
  - `spdlog` - Structured logging
  - `yaml-cpp` - Quest definition parsing
  - `GoogleTest` - Testing framework
  - `SQLite3` - Database backend

## Directory Structure

```
/sql_game
  /cmake/              # CMake modules and utilities
  /third_party/        # External dependencies
  /include/sql_game/   # Public headers
    /core/             # Quest, Progression, PlayerProfile
    /data/             # DBManager, DatasetFactory
    /eval/             # QueryEvaluator, HintEngine
    /ui/               # CLI Renderer, Input
    /util/             # Logging, Formatting
  /src/                # Implementation files
    /core/
    /data/
    /eval/
    /ui/
    /util/
    main.cpp           # Application entry point
  /quests/             # Quest definitions
    /basics/
    /joins/
  /schemas/            # Database schemas
  /datasets/           # Sample datasets
  /tests/              # Unit and integration tests
  CMakeLists.txt       # Root build configuration
  README.md
  HL_Context.md        # High-level project context
```

## Build Requirements

- **Compiler**: MSVC with C++23 support 
- **Build System**: CMake 3.25+ ✅
- **Platform**: Windows (with PowerShell)

## Building the Project

```bash
# Create build directory
mkdir build
cd build

# Get dependencies with conan
conan profile detect --force && conan install . --output-folder=build --profile=clang_profile.txt --build=missing

# Configure with Clang
cmake ..

# Build
cmake --build .

# Run
./bin/sql_game
```

## Testing

```bash
# Run all tests
cmake --build . --target test

# Or run the test executable directly
./bin/sql_game_tests
```

## Next Milestones

**M1a: Domain Models** - Core data structures and quest parsing
**M1b: Database Foundation** - SQLite connection and query execution
**M1c: First Quest + Evaluator** - Basic quest implementation
**M1d: CLI + Second Quest** - User interface and progression

See `HL_Context.md` for complete milestone roadmap and architectural details.

## Contributing

This project follows modern C++ best practices:
- C++23 standard with `std::expected` error handling
- No exceptions - all APIs use `std::expected<T, Error>`
- Value semantics and RAII
- Modular architecture with clear separation of concerns
- Comprehensive testing with GoogleTest

## License

[License information to be added]
