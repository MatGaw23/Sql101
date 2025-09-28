# UI module - Command line interface and user interaction

add_library(sql_game_ui STATIC)

target_sources(sql_game_ui PRIVATE
    # Add source files as they are created
    placeholder.cpp
)

target_include_directories(sql_game_ui PUBLIC
    ${CMAKE_SOURCE_DIR}/include
)

target_link_libraries(sql_game_ui PUBLIC
    sqlpp11::sqlpp11
    yaml-cpp::yaml-cpp
    spdlog::spdlog
    sql_game_core
    sql_game_data
    sql_game_eval
    sql_game_util
)

set_target_properties(sql_game_ui PROPERTIES
    CXX_STANDARD 23
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)
