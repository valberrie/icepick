include(episodic.cmake)

set(GAME_NAME rgv)
target_include_directories(client PUBLIC ../.. ./ rgv ../shared/rgv)
target_compile_definitions(server PUBLIC RGV_CLIENT_DLL)
# target_sources(server PUBLIC)