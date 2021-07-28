function(author_shaders target_name output_dir)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs SOURCES)
    cmake_parse_arguments(S "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT DEFINED GLC)
        set(GLC glslc)
    else() 
        message("Using user set glslc: ${GLC}")
    endif()
    set(GLCFLAGS "--target-env=vulkan1.2")
    set(DIR ${CMAKE_CURRENT_SOURCE_DIR})
    set(BUILD_DIR "${PROJECT_BINARY_DIR}/shaders/${output_dir}")
    file(MAKE_DIRECTORY ${BUILD_DIR})

    foreach(SRC ${S_SOURCES})
        get_filename_component(FILE_NAME ${SRC} NAME)
        set(SPV "${BUILD_DIR}/${FILE_NAME}.spv")
        set(CMD ${GLC} ${GLCFLAGS} ${DIR}/${SRC} -o ${SPV})
        add_custom_command(
            OUTPUT ${SPV}
            COMMAND ${CMD}
            DEPENDS ${SRC})
        list(APPEND SPVS ${SPV})
    endforeach(SRC)

    add_custom_target(${target_name} ALL DEPENDS ${SPVS})

    if (NOT DEFINED SHADER_INSTALL_PREFIX)
        set(SHADER_INSTALL_DIR ${CMAKE_INSTALL_DATADIR}/shaders/${output_dir})
    else()
        set(SHADER_INSTALL_DIR ${SHADER_INSTALL_PREFIX}/${output_dir})
    endif()
    if (NOT DEFINED SPVS)
        message(FATAL_ERROR "SPVS not defined. Can call build_shaders() before to create them. Aborting shader installation.")
    endif()
    if (DEFINED SHADER_INSTALL_DIR)
        message("Installing shaders to ${SHADER_INSTALL_DIR}")
        install(FILES ${SPVS}
            DESTINATION ${SHADER_INSTALL_DIR})
    else()
        install(FILES ${SPVS}
            DESTINATION ${SHADER_INSTALL_PREFIX})
    endif()
endfunction()
