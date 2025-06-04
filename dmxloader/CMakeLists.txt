project(dmxloader)
add_library(dmxloader STATIC
        dmxattribute.cpp
        dmxelement.cpp
        dmxloader.cpp
        dmxloadertext.cpp
        dmxserializationdictionary.cpp
)