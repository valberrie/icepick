project(shaderapiempty)
add_library(shaderapiempty SHARED
        shaderapiempty.cpp
        ../../public/tier0/memoverride.cpp
)

add_dependencies(shaderapiempty tier0 tier1)
target_link_libraries(shaderapiempty PUBLIC tier0 tier1)

target_compile_definitions(shaderapiempty PUBLIC SHADER_DLL_EXPORT PROTECTED_THINGS_ENABLE)
target_include_directories(shaderapiempty PUBLIC ./ ../../public ../../public/tier0 ../../public/tier1 ../../common ../ ../../thirdparty/SDL)

install(TARGETS shaderapiempty DESTINATION bin)
