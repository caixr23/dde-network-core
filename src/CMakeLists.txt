cmake_minimum_required(VERSION 3.7)

set(VERSION "3.0.0" CACHE STRING "define project version")
project(dde-network-core6)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

include(GNUInstallDirs)
# set(CMAKE_PREFIX_PATH $ENV{Qt5_DIR})

# if (CMAKE_BUILD_TYPE STREQUAL "Debug")
#     set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -fsanitize=address -O0")
#     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -fsanitize=address -O0")
# endif()

file(GLOB_RECURSE SOURCEFILES "*.h" "*.cpp")



add_custom_target(networktranslations ALL DEPENDS ${QM_FILES})

add_library(${PROJECT_NAME} SHARED ${SOURCEFILES})

find_package(Qt6 COMPONENTS Core DBus Network Gui REQUIRED)
find_package(PkgConfig REQUIRED)
find_package(Dtk6 COMPONENTS Core REQUIRED)
find_package(KF6NetworkManagerQt REQUIRED)

pkg_check_modules(DFrameworkDBus REQUIRED dframeworkdbus)
# pkg_check_modules(QGSettings REQUIRED gsettings-qt)
pkg_check_modules(LibNM REQUIRED IMPORTED_TARGET libnm)

file(GLOB TS_FILES "translations/*.ts")

qt_add_translation(QM_FILES ${TS_FILES})

target_include_directories(${PROJECT_NAME} PUBLIC
    dbus
    impl
    impl/networkmanager
    impl/serviceinter
    Qt6::Core
    Qt6::DBus
    Qt6::Network
    Qt6::Gui
    Dtk6::Core
    KF6::NetworkManagerQt
    ${DFrameworkDBus_INCLUDE_DIRS}
    # ${QGSettings_INCLUDE_DIRS}
    # ${KF6_QT_INCLUDE_DIRS}
    PkgConfig::LibNM
)

message(STATUS ${LibNM_INCLUDE_DIRS})

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::DBus
    Qt6::Network
    Qt6::Gui
    Dtk6::Core
    KF6::NetworkManagerQt
    ${DFrameworkDBus_LIBRARIES}
    # ${KF6_QT_LIBRARIES}
    # ${DtkCore_LIBRARIES}
    PkgConfig::LibNM
)

configure_file(dde-network-core.pc.in ../dde-network-core.pc @ONLY)

set(INTERFACEFILES
    impl/dslcontroller.h
    impl/hotspotcontroller.h
    impl/vpncontroller.h
    networkconst.h
    networkcontroller.h
    networkdetails.h
    networkdevicebase.h
    proxycontroller.h
    wireddevice.h
    wirelessdevice.h)

set_target_properties(${PROJECT_NAME} PROPERTIES
    VERSION ${CMAKE_PROJECT_VERSION}
    SOVERSION ${CMAKE_PROJECT_VERSION_MAJOR}
    # OUTPUT_NAME dde-network-core
    # EXPORT_NAME Network-Core
)

install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}Targets LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(FILES ${CMAKE_BINARY_DIR}/dde-network-core.pc DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)
install(FILES ${INTERFACEFILES} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/libddenetworkcore)
install(FILES ../config/org.deepin.dde.network.json DESTINATION ${CMAKE_INSTALL_DATADIR}/dsg/configs/org.deepin.dde.network)
# 安装 .qm 文件
install(FILES ${QM_FILES} DESTINATION ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}/translations)
