#!/usr/bin/env bash

# This file is part of the Hipace test suite.
# It resets all checksum benchmarks one by one,
# based on the current version of the code.
#
# Usage:
#
# To reset all benchmarks, run:
# > ./reset_all_benchmarks.sh
#
# To reset only benchmark <benchmark_name>, run
# > /reset_all_benchmarks.sh <benchmark_name>

# abort on first encounted error
set -eu -o pipefail

# Check if the user wants to reset one benchmark or all of them
if [ "$#" -ne 1 ]
then
    all_tests=true
    one_test_name="no"
else
    all_tests=false
    one_test_name=$1
fi

# Depending on the user input, recompile serial and/or parallel
compile_serial=false
compile_parallel=false
if [[ $one_test_name == *"Serial" ]] || [[ $all_tests = true ]]
then
    compile_serial=true
fi
if [[ $one_test_name == *"Rank" ]] || [[ $all_tests = true ]]
then
    compile_parallel=true
fi

echo "Run all tests   : $all_tests"
echo "Run single test : $one_test_name"
echo "Compile serial  : $compile_serial"
echo "Compile parallel: $compile_parallel"

hipace_dir=$(echo $(cd ../.. && pwd))
build_dir=${hipace_dir}/build
checksum_dir=${hipace_dir}/tests/checksum

read -p "This will run \"rm -rf ${build_dir}\" and re-build. If unsure, check the script. proceed? y/n: " -n 1 -r
echo
if [[ $REPLY != "y" ]]
then
    echo "No, abort."
    exit 0
fi
echo "Yes, proceed."

### Compile code and reset benchmarks: serial ###
#################################################

if [[ $compile_serial = true ]]
then
    rm -rf $build_dir
    mkdir $build_dir
    cd $build_dir
    cmake .. -DHiPACE_MPI=OFF
    make -j 4
fi

# blowout_wake.Serial
#if [[ $all_tests = true ]] || [[ $one_test_name = "blowout_wake.Serial" ]]
#then
#    cd $build_dir
#    ctest --output-on-failure -R blowout_wake.Serial \
#        || echo "ctest command failed, maybe just because checksums are different. Keep going"
#    cd $checksum_dir
#    ./checksumAPI.py --reset-benchmark \
#                     --plotfile ${build_dir}/bin/plt00001 \
#                     --test-name blowout_wake.Serial
#fi

# beam_in_vacuum.SI.Serial
#if [[ $all_tests = true ]] || [[ $one_test_name = "beam_in_vacuum.SI.Serial" ]]
#then
#    cd $build_dir
#    ctest --output-on-failure -R beam_in_vacuum.SI.Serial \
#        || echo "ctest command failed, maybe just because checksums are different. Keep going"
#    cd $checksum_dir
#    ./checksumAPI.py --reset-benchmark \
#                     --plotfile ${build_dir}/bin/plt00001 \
#                     --test-name beam_in_vacuum.SI.Serial
#fi

# beam_in_vacuum.normalized.Serial
#if [[ $all_tests = true ]] || [[ $one_test_name = "beam_in_vacuum.normalized.Serial" ]]
#then
#    cd $build_dir
#    ctest --output-on-failure -R beam_in_vacuum.normalized.Serial \
#        || echo "ctest command failed, maybe just because checksums are different. Keep going"
#    cd $checksum_dir
#    ./checksumAPI.py --reset-benchmark \
#                     --plotfile ${build_dir}/bin/plt00001 \
#                     --test-name beam_in_vacuum.normalized.Serial
#fi

### Compile code and reset benchmarks: parallel ###
###################################################

if [[ $compile_parallel = true ]]
then
    rm -rf $build_dir
    mkdir $build_dir
    cd $build_dir
    cmake .. -DHiPACE_MPI=ON
    make -j 4
fi

# blowout_wake.1Rank
if [[ $all_tests = true ]] || [[ $one_test_name = "blowout_wake.1Rank" ]]
then
    cd $build_dir
    ctest --output-on-failure -R blowout_wake.1Rank \
        || echo "ctest command failed, maybe just because checksums are different. Keep going"
    cd $checksum_dir
    ./checksumAPI.py --reset-benchmark \
                     --plotfile ${build_dir}/bin/normalized_data \
                     --test-name blowout_wake.1Rank
fi

# beam_evolution.1Rank
if [[ $all_tests = true ]] || [[ $one_test_name = "beam_evolution.1Rank" ]]
then
    cd $build_dir
    ctest --output-on-failure -R beam_evolution.1Rank \
        || echo "ctest command failed, maybe just because checksums are different. Keep going"
    cd $checksum_dir
    ./checksumAPI.py --reset-benchmark \
                     --plotfile ${build_dir}/bin/plt00020 \
                     --test-name beam_evolution.1Rank
fi

# reset.1Rank
if [[ $all_tests = true ]] || [[ $one_test_name = "reset.1Rank" ]]
then
    cd $build_dir
    ctest --output-on-failure -R reset.1Rank \
        || echo "ctest command failed, maybe just because checksums are different. Keep going"
    cd $checksum_dir
    ./checksumAPI.py --reset-benchmark \
                     --plotfile ${build_dir}/bin/plt00001 \
                     --test-name reset.1Rank
fi

# slice_beam.1Rank
if [[ $all_tests = true ]] || [[ $one_test_name = "slice_beam.1Rank" ]]
then
    cd $build_dir
    ctest --output-on-failure -R slice_beam.1Rank \
        || echo "ctest command failed, maybe just because checksums are different. Keep going"
    cd $checksum_dir
    ./checksumAPI.py --reset-benchmark \
                     --plotfile ${build_dir}/bin/plt00001 \
                     --test-name slice_beam.1Rank
fi

# linear_wake.normalized.1Rank
if [[ $all_tests = true ]] || [[ $one_test_name = "linear_wake.normalized.1Rank" ]]
then
    cd $build_dir
    ctest --output-on-failure -R linear_wake.normalized.1Rank \
        || echo "ctest command failed, maybe just because checksums are different. Keep going"
    cd $checksum_dir
    ./checksumAPI.py --reset-benchmark \
                     --plotfile ${build_dir}/bin/plt00001 \
                     --test-name linear_wake.normalized.1Rank
fi

# linear_wake.SI.1Rank
if [[ $all_tests = true ]] || [[ $one_test_name = "linear_wake.SI.1Rank" ]]
then
    cd $build_dir
    ctest --output-on-failure -R linear_wake.SI.1Rank \
        || echo "ctest command failed, maybe just because checksums are different. Keep going"
    cd $checksum_dir
    ./checksumAPI.py --reset-benchmark \
                     --plotfile ${build_dir}/bin/plt00001 \
                     --test-name linear_wake.SI.1Rank
fi

# gaussian_linear_wake.normalized.1Rank
if [[ $all_tests = true ]] || [[ $one_test_name = "gaussian_linear_wake.normalized.1Rank" ]]
then
    cd $build_dir
    ctest --output-on-failure -R gaussian_linear_wake.normalized.1Rank \
        || echo "ctest command failed, maybe just because checksums are different. Keep going"
    cd $checksum_dir
    ./checksumAPI.py --reset-benchmark \
                     --plotfile ${build_dir}/bin/plt00001 \
                     --test-name gaussian_linear_wake.normalized.1Rank
fi

# gaussian_linear_wake.SI.1Rank
if [[ $all_tests = true ]] || [[ $one_test_name = "gaussian_linear_wake.SI.1Rank" ]]
then
    cd $build_dir
    ctest --output-on-failure -R gaussian_linear_wake.SI.1Rank \
        || echo "ctest command failed, maybe just because checksums are different. Keep going"
    cd $checksum_dir
    ./checksumAPI.py --reset-benchmark \
                     --plotfile ${build_dir}/bin/plt00001 \
                     --test-name gaussian_linear_wake.SI.1Rank
fi

# beam_in_vacuum.SI.1Rank
if [[ $all_tests = true ]] || [[ $one_test_name = "beam_in_vacuum.SI.1Rank" ]]
then
    cd $build_dir
    ctest --output-on-failure -R beam_in_vacuum.SI.1Rank \
        || echo "ctest command failed, maybe just because checksums are different. Keep going"
    cd $checksum_dir
    ./checksumAPI.py --reset-benchmark \
                     --plotfile ${build_dir}/bin/plt00001 \
                     --test-name beam_in_vacuum.SI.1Rank
fi

# beam_in_vacuum.normalized.1Rank
if [[ $all_tests = true ]] || [[ $one_test_name = "beam_in_vacuum.normalized.1Rank" ]]
then
    cd $build_dir
    ctest --output-on-failure -R beam_in_vacuum.normalized.1Rank \
        || echo "ctest command failed, maybe just because checksums are different. Keep going"
    cd $checksum_dir
    ./checksumAPI.py --reset-benchmark \
                     --plotfile ${build_dir}/bin/plt00001 \
                     --test-name beam_in_vacuum.normalized.1Rank
fi

# blowout_wake.2Rank
### This test is inactive as Hipace doesn't support parallelization yet.
#if [[ $all_tests = true ]] || [[ $one_test_name = "blowout_wake.2Rank" ]]
#then
#    cd $build_dir
#    ctest --output-on-failure -R blowout_wake.2Rank \
#        || echo "ctest command failed, maybe just because checksums are different. Keep going"
#    cd $checksum_dir
#    ./checksumAPI.py --reset-benchmark \
#                     --plotfile ${build_dir}/bin/plt00001 \
#                     --test-name blowout_wake.2Rank
#fi
