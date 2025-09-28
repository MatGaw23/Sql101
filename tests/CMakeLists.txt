# GoogleTest configuration (from Conan)
find_package(GTest REQUIRED)
include(GoogleTest)

# Create test executable
add_executable(sql_game_tests)

target_sources(sql_game_tests PRIVATE
    bootstrap_test.cpp
)

target_link_libraries(sql_game_tests PRIVATE
    GTest::gtest_main
    GTest::gmock_main
    sql_game_core
    sql_game_data
    sql_game_eval
    sql_game_ui
    sql_game_util
    sqlpp11::sqlpp11
    yaml-cpp::yaml-cpp
    spdlog::spdlog
)

target_include_directories(sql_game_tests PRIVATE
    ${CMAKE_SOURCE_DIR}/include
)

set_target_properties(sql_game_tests PROPERTIES
    CXX_STANDARD 23
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)

# Discover tests
gtest_discover_tests(sql_game_tests)
