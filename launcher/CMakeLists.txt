project(launcher)
add_library(launcher SHARED
        ../public/filesystem_init.cpp
        launcher.cpp
        reslistgenerator.cpp
        ../public/tier0/memoverride.cpp
)

target_include_directories(launcher PUBLIC ./ ../public ../public/tier0 ../public/tier1 ../common android/libunwind ../thirdparty/SDL)
target_compile_definitions(launcher PUBLIC LAUNCHERONLY=1 CFLAGS="${CMAKE_CXX_FLAGS}" LDFLAGS="")

add_dependencies(launcher tier0 tier1 tier2 tier3 vstdlib steam_api appframework togl)
target_link_libraries(launcher PUBLIC tier0 tier1 tier2 tier3 vstdlib steam_api appframework SDL2 togl unwind)

if(ANDROID EQUAL 1)
    target_sources(launcher PUBLIC android/main.cpp android/crashhandler.cpp)
    target_include_directories(launcher PUBLIC android/libunwind)
    target_link_libraries(launcher PUBLIC UNWIND)
endif()

install(TARGETS launcher DESTINATION bin)
