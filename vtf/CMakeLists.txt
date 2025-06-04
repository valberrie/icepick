project(vtf)
add_library(vtf STATIC
        convert_x360.cpp
        vtf.cpp
)

if(WIN32)
    target_sources(vtf PUBLIC s3tc_decode.cpp)
endif()