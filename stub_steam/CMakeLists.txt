project(stub_steam)
add_library(steam_api SHARED steam_api.cpp)
target_include_directories(steam_api PUBLIC ../thirdparty/SDL)

install(TARGETS steam_api DESTINATION bin)
