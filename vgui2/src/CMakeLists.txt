project(vgui2)
add_library(vgui2 SHARED
        Bitmap.cpp
        Border.cpp
        ScalableImageBorder.cpp
        ImageBorder.cpp
        ../../public/filesystem_helpers.cpp
        ../../public/filesystem_init.cpp
        InputWin32.cpp
        LocalizedStringTable.cpp
        MemoryBitmap.cpp
        Scheme.cpp
        ../../public/UnicodeFileHelpers.cpp
        vgui.cpp
        vgui_internal.cpp
        vgui_key_translation.cpp
        VPanel.cpp
        VPanelWrapper.cpp
        keyrepeat.cpp
        ../../public/tier0/memoverride.cpp
)

target_compile_definitions(vgui2 PUBLIC DONT_PROTECT_FILEIO_FUNCTIONS=1)
target_include_directories(vgui2 PUBLIC ../../thirdparty/SDL ./ ../../public ../ ../../public/tier0 ../../public/tier1)

add_dependencies(vgui2 tier0 tier1 tier2 tier3 vstdlib)
target_link_libraries(vgui2 PUBLIC tier0 tier1 tier2 tier3 vstdlib SDL2)

if(WIN32)
    target_sources(vgui2 PUBLIC Surface.cpp System.cpp)
else()
    if(APPLE)
        target_link_libraries(vgui2 PUBLIC APPLICATIONSERVICES)
    endif()

    target_sources(vgui2 PUBLIC system_posix.cpp)
endif()

install(TARGETS vgui2 DESTINATION bin)
