project(appframework)
add_library(appframework STATIC AppSystemGroup.cpp ../public/filesystem_init.cpp)
target_include_directories(appframework PUBLIC ../thirdparty/SDL)

if(BUILD_SDL)
    target_sources(appframework PUBLIC sdlmgr.cpp)
endif()

if(APPLE AND BUILD_GL)
    target_sources(appframework PUBLIC glmrendererinfo_osx.mm)
endif()

if(WIN32)
    target_sources(appframework PUBLIC VguiMatSysApp.cpp WinApp.cpp)
else()
    target_sources(appframework PUBLIC posixapp.cpp)
endif()
