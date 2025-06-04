project(tier2)
add_library(tier2 STATIC
        beamsegdraw.cpp
        defaultfilesystem.cpp
        dmconnect.cpp
        fileutils.cpp
        keybindings.cpp
        ../public/map_utils.cpp
        ../public/materialsystem/MaterialSystemUtil.cpp
        camerautils.cpp
        meshutils.cpp
        p4helpers.cpp
        renderutils.cpp
        riff.cpp
        soundutils.cpp
        tier2.cpp
        util_init.cpp
        utlstreambuffer.cpp
        vconfig.cpp
        keyvaluesmacros.cpp
)
target_include_directories(tier2 PRIVATE ../thirdparty/SDL ../public/tier2)
