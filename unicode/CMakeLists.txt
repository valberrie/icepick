project(unicode)
add_library(unicode STATIC)

if(WIN32)
    target_sources(unicode PUBLIC unicode.cpp ../public/tier0/memoverride.cpp)
    target_compile_definitions(unicode PUBLIC UNICODE_EXPORTS=1)
    add_dependencies(unicode tier0 tier1 tier2 vstdlib mathlib)
    target_link_libraries(unicode PUBLIC tier0 tier1 tier2 vstdlib mathlib user32)
endif()