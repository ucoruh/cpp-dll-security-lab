cmake_minimum_required(VERSION 3.10)
project(MatematikDLL)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

# Include dizinleri
include_directories(${CMAKE_SOURCE_DIR}/src)

# DLL (paylaşımlı kütüphane) projesi
add_library(matematik SHARED src/matematik.c)
target_compile_definitions(matematik PRIVATE -DMATEMATIK_EXPORTS)

# Kötü niyetli DLL projesi
add_library(malicious_matematik SHARED kotu-amacli/malicious_matematik.c)
target_compile_definitions(malicious_matematik PRIVATE -DMATEMATIK_EXPORTS)

# Statik kütüphane projesi
add_library(matematik_static STATIC src/matematik.c)
target_compile_definitions(matematik_static PRIVATE -DMATEMATIK_EXPORTS)
set_target_properties(matematik_static PROPERTIES OUTPUT_NAME "matematik_static")

# DLL kullanan C++ uygulaması
add_executable(matematik_client istemciler/main.cpp)
target_link_libraries(matematik_client matematik)

# Statik kütüphaneyi kullanan C++ uygulaması
add_executable(matematik_static_client istemciler/main_static.cpp)
target_link_libraries(matematik_static_client matematik_static)
target_compile_definitions(matematik_static_client PRIVATE -DUSE_STATIC_LIB)

# Programatik DLL yükleyici uygulama
add_executable(explicit_dll_loader istemciler/explicit_dll_loader.cpp)

# Hedef dosyalar için çıktı dizinleri
set_target_properties(matematik PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
)

set_target_properties(malicious_matematik PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
)

set_target_properties(matematik_static PROPERTIES 
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
)

set_target_properties(matematik_client PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)

set_target_properties(matematik_static_client PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)

set_target_properties(explicit_dll_loader PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
) 