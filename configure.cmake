function(configure config_in_file)
    if(NOT DEFINED CMAKE_INSTALL_LIBDIR)
        message(FATAL_ERROR "Must define CMAKE_INSTALL_LIBDIR or include GNUInstallDirs")
    endif()

    set(CONF ${PROJECT_NAME}Config)
    string(TOLOWER ${PROJECT_NAME} project_name)

    add_library(${CONF} INTERFACE)
    target_include_directories(${CONF} INTERFACE
      $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
      $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
      $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${project_name}>)

    install(TARGETS ${PROJECT_NAME}Config EXPORT ${PROJECT_NAME}Targets)
    add_library(${PROJECT_NAME}::Config ALIAS ${PROJECT_NAME}Config)

    include(CMakePackageConfigHelpers)

    install(EXPORT ${PROJECT_NAME}Targets
      DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
      FILE ${PROJECT_NAME}Targets.cmake
      NAMESPACE ${PROJECT_NAME}::)

    configure_package_config_file(
        ${config_in_file}
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
      INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

    write_basic_package_version_file("${PROJECT_NAME}ConfigVersion.cmake"
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY SameMajorVersion)

    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
                  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
      DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

    install(EXPORT ${PROJECT_NAME}Targets
      DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
      FILE ${PROJECT_NAME}Targets.cmake
      NAMESPACE ${PROJECT_NAME}::
      EXPORT_LINK_INTERFACE_LIBRARIES)
endfunction()
