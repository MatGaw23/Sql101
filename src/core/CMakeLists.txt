# Core module - Domain models and business logic


add_library(sql_game_core STATIC
     placeholder.cpp
)

target_include_directories(sql_game_core PUBLIC
    ${CMAKE_SOURCE_DIR}/include
)

target_link_libraries(sql_game_core PUBLIC
    sqlpp11::sqlpp11
    yaml-cpp::yaml-cpp
    spdlog::spdlog
)

set_target_properties(sql_game_core PROPERTIES
    CXX_STANDARD 23
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)
