cmake_minimum_required(VERSION 3.22)

project(sql_game
    VERSION 0.1.0
    DESCRIPTION "Interactive SQL Learning Game"
    LANGUAGES CXX
)

find_package(sqlpp11 REQUIRED)
find_package(yaml-cpp REQUIRED)
find_package(spdlog REQUIRED)
find_package(GTest REQUIRED)

# Set C++23 standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Set compiler-specific flags for Clang
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    add_compile_options(-Wall -Wextra -Wpedantic -Werror)
    if(NOT WIN32)
        add_compile_options(-stdlib=libc++)
        add_link_options(-stdlib=libc++)
    endif()
endif()

# Build type configuration
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Include directories
include_directories(${CMAKE_SOURCE_DIR}/include)

# Add cmake modules path
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Add subdirectories
add_subdirectory(src)

# Enable testing
enable_testing()
add_subdirectory(tests)

# Main executable
add_executable(sql_game src/main.cpp)
target_link_libraries(sql_game 
    sql_game_core
    sql_game_data
    sql_game_eval
    sql_game_ui
    sql_game_util
)

# Set target properties
set_target_properties(sql_game PROPERTIES
    CXX_STANDARD 23
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)

# Installation
install(TARGETS sql_game
    RUNTIME DESTINATION bin
)

install(DIRECTORY quests/
    DESTINATION share/sql_game/quests
)

install(DIRECTORY schemas/
    DESTINATION share/sql_game/schemas
)

install(DIRECTORY datasets/
    DESTINATION share/sql_game/datasets
)
