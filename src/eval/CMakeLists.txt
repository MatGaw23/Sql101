# Evaluation module - Query comparison and hint generation

add_library(sql_game_eval STATIC)

target_sources(sql_game_eval PRIVATE
    # Add source files as they are created
    placeholder.cpp
)

target_include_directories(sql_game_eval PUBLIC
    ${CMAKE_SOURCE_DIR}/include
)

target_link_libraries(sql_game_eval PUBLIC
    sqlpp11::sqlpp11
    yaml-cpp::yaml-cpp
    spdlog::spdlog
    sql_game_core
    sql_game_data
    sql_game_util
)

set_target_properties(sql_game_eval PROPERTIES
    CXX_STANDARD 23
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)
