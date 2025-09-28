# Utility module - Logging, formatting, and helper functions

 add_library(sql_game_util STATIC
     placeholder.cpp
 )

target_sources(sql_game_util PRIVATE
    # Add source files as they are created
)

target_include_directories(sql_game_util PUBLIC
    ${CMAKE_SOURCE_DIR}/include
)

target_link_libraries(sql_game_util PUBLIC
    sqlpp11::sqlpp11
    yaml-cpp::yaml-cpp
    spdlog::spdlog
)

set_target_properties(sql_game_util PROPERTIES
    CXX_STANDARD 23
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)
