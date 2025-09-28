# Data module - Database management and dataset handling

add_library(sql_game_data STATIC)

target_sources(sql_game_data PRIVATE
    # Add source files as they are created
    placeholder.cpp
)

target_include_directories(sql_game_data PUBLIC
    ${CMAKE_SOURCE_DIR}/include
)

target_link_libraries(sql_game_data PUBLIC
    sqlpp11::sqlpp11
    yaml-cpp::yaml-cpp
    spdlog::spdlog
    sql_game_util
)

set_target_properties(sql_game_data PROPERTIES
    CXX_STANDARD 23
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)
