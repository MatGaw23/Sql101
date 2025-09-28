# CompilerConfig.cmake - Compiler-specific configuration utilities

# Function to set compiler-specific flags
function(set_compiler_flags target_name)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        target_compile_options(${target_name} PRIVATE
            -Wall
            -Wextra
            -Wpedantic
            -Werror
            -Wno-unused-parameter
            -Wno-missing-field-initializers
        )
        
        # Use libc++ on systems where it's available
        if(NOT WIN32)
            target_compile_options(${target_name} PRIVATE -stdlib=libc++)
            target_link_options(${target_name} PRIVATE -stdlib=libc++)
        endif()
        
        # Enable additional warnings for better code quality
        target_compile_options(${target_name} PRIVATE
            -Wconversion
            -Wsign-conversion
            -Wold-style-cast
            -Wundef
            -Wredundant-decls
            -Wwrite-strings
            -Wpointer-arith
            -Wcast-qual
            -Wformat=2
            -Wmissing-include-dirs
            -Wcast-align
            -Wno-unused-function
        )
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        target_compile_options(${target_name} PRIVATE
            -Wall
            -Wextra
            -Wpedantic
            -Werror
            -Wno-unused-parameter
        )
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        target_compile_options(${target_name} PRIVATE
            /W4
            /WX
            /permissive-
        )
    endif()
endfunction()

# Function to set C++23 standard for a target
function(set_cxx23_standard target_name)
    set_target_properties(${target_name} PROPERTIES
        CXX_STANDARD 23
        CXX_STANDARD_REQUIRED ON
        CXX_EXTENSIONS OFF
    )
endfunction()
