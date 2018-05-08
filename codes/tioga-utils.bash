#!/bin/bash

exawind_proj_env ()
{
    exawind_load_deps zlib libxml2 hdf5 trilinos yaml-cpp tioga nalu-wind
}

exawind_cmake ()
{
    local extra_args="$@"
    local install_dir=""
    if [ -n "$TIOGA_UTILS_INSTALL_PREFIX" ] ; then
        install_dir="-DCMAKE_INSTALL_PREFIX=\"$TIOGA_UTILS_INSTALL_PREFIX\""
    fi

    # Force CMake to use absolute paths for the libraries so that it doesn't
    # pick up versions installed in `/usr/lib64` on peregrine
    local lib_path_save=${LIBRARY_PATH}
    unset LIBRARY_PATH

    command cmake \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE:-RELEASE} \
        -DTrilinos_DIR:PATH=${TRILINOS_ROOT_DIR} \
        -DTIOGA_DIR:PATH=${TIOGA_ROOT_DIR} \
        -DYAML_DIR:PATH=${YAML_CPP_ROOT_DIR} \
        -DNALU_DIR:PATH=${NALU_WIND_ROOT_DIR} \
        ${install_dir} \
        ${extra_args} ../src

    export LIBRARY_PATH=${lib_path_save}
}
