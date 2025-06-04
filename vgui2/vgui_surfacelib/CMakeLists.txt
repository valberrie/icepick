project(vgui_surfacelib)
add_library(vgui_surfacelib STATIC
        BitmapFont.cpp
        FontAmalgam.cpp
        FontManager.cpp
        FontEffects.cpp
)

target_include_directories(vgui_surfacelib PUBLIC ./ ../ ../../ ../../public/ ../../public/tier0 ../../public/tier1 ../../common ../../thirdparty/fontconfig/fontconfig ../../thirdparty/freetype/include)

if(WIN32)
    target_sources(vgui_surfacelib PUBLIC Win32Font.cpp)
else ()
    target_sources(vgui_surfacelib PUBLIC linuxfont.cpp)
endif()
