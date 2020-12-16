#!/bin/bash

. ./setup.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'

BRED='\033[1;31m'
BGREEN='\033[1;32m'
BBLUE='\033[1;34m'

NC='\033[0m'

#export TAU_MAKEFILE=shared-clang-pdt
export TAU_MAKEFILE=shared-TEST-clang
#export TAU_OPTIONS='-optCompInst -optVerbose'

export LLVM_DIR=/home/users/fdeny/llvm_build/pluginVersions/plugin-tau-llvm-module-11/install

ERRFILE="toto"
ERRFILE2="toto2"

#which clang
#echo $LLVM_DIR

echo -e "${BBLUE}Instrumentation${NC}"

clang++ -c -O3 -g -fplugin=${LLVM_DIR}/lib/TAU_Profiling_CXX.so -mllvm -tau-input-file=./functions_CXX_hh.txt householder.cpp &> $ERRFILE
clang++ -o householder householder.o -fplugin=${LLVM_DIR}/lib/TAU_Profiling_CXX.so -ldl -L${TAU}/lib/$TAU_MAKEFILE -lTAU -Wl,-rpath,${TAU}/lib/$TAU_MAKEFILE &> $ERRFILE2
RC=$?
echo -n "C++ instrumentation"
if [ $RC != 0 ]; then
    echo -e "                               ${BRED}[FAILED]${NC}"
else
    echo -e "                               ${BGREEN}[PASSED]${NC}"
fi
echo -n "Instrumented functions"
if [ `grep "Instrument"  $ERRFILE | wc -l` -gt 0 ] ; then
    echo -e "                            ${BGREEN}[PASSED]${NC}"
else
    echo -e "                            ${BRED}[FAILED]${NC}"
fi
rm $ERRFILE $ERRFILE2

clang -c -O3 -g -fplugin=${LLVM_DIR}/lib/TAU_Profiling.so -mllvm -tau-input-file=./functions_C_mm.txt matmult.c matmult_initialize.c &> $ERRFILE
clang -fplugin=${LLVM_DIR}/lib/TAU_Profiling.so -ldl -L${TAU}/lib/$TAU_MAKEFILE -lTAU -Wl,-rpath,${TAU}/lib/$TAU_MAKEFILE matmult.o matmult_initialize.o -o mm_c &> $ERRFILE2
echo -n "C instrumentation"
if [ $RC != 0 ]; then
    echo -e "                                 ${BRED}[FAILED]${NC}"
else
    echo -e "                                 ${BGREEN}[PASSED]${NC}"
fi
echo -n "Instrumented functions"
if [ `grep "Instrument"  $ERRFILE | wc -l` -gt 0 ] ; then
    echo -e "                            ${BGREEN}[PASSED]${NC}"
else
    echo -e "                            ${BRED}[FAILED]${NC}"
fi
rm $ERRFILE $ERRFILE2


#clang -O3 -g -fplugin=${LLVM_DIR}/lib/TAU_Profiling_CXX.so -mllvm -tau-input-file=./functions_CXX_mm.txt -ldl -L${TAU}/lib/$TAU_MAKEFILE -lTAU -Wl,-rpath,${TAU}/lib/$TAU_MAKEFILE matmult.cpp matmult_initialize.cpp -o mm_cpp

#clang++ -fjit -O3 -g -fplugin=${LLVM_DIR}/lib/TAU_Profiling_CXX.so -mllvm -tau-input-file=./functions_CXX_hh.txt -ldl -L${TAU}/lib/$TAU_MAKEFILE -lTAU -Wl,-rpath,${TAU}/lib/$TAU_MAKEFILE householder_jit.cpp -o householder_jit

export F18_FC=gfortran
#flang -O3 -g -fplugin=${LLVM_DIR}/lib/TAU_Profiling.so -mllvm -tau-input-file=./functions_F_copy.txt -ldl -L${TAU}/lib/$TAU_MAKEFILE -lTAU -Wl,-rpath,${TAU}/lib/$TAU_MAKEFILE  -o copy2f_openmp copy2f_openmp.f90



# This one is expected to give an error
clang++ -c -O3 -g -fplugin=${LLVM_DIR}/lib/TAU_Profiling_CXX.so -mllvm -tau-input-file=./functions_CXX_hh_bad.txt householder_bad.cpp &> $ERRFILE
clang++ -fplugin=${LLVM_DIR}/lib/TAU_Profiling_CXX.so -ldl -L${TAU}/lib/$TAU_MAKEFILE -lTAU -Wl,-rpath,${TAU}/lib/$TAU_MAKEFILE householder_bad.o -o householder-bad &> $ERRFILE2
RC=$?
echo -n "Error when the input file is wrong"
if [ $RC != 0 ] ; then
    echo -e "                   ${BRED}[FAILED]${NC} compilation failed"
else
    if [ `grep "Wrong syntax:"  $ERRFILE | wc -l` -gt 0 ] ; then
	echo -e "                ${BGREEN}[PASSED]${NC}"
    else
	echo -e "                ${BRED}[FAILED]${NC} compiled but no warning generated"
    fi
fi
rm $ERRFILE $ERRFILE2
rm householder-bad

clang -c -O3 -g -fplugin=${LLVM_DIR}/lib/TAU_Profiling.so -mllvm -tau-input-file=./functions_C_files.txt matmul.c householder3.c Q.c R.c &> $ERRFILE

clang -o householder3 matmul.o Q.o householder3.o R.o -fplugin=${LLVM_DIR}/lib/TAU_Profiling.so -ldl -L${TAU}/lib/$TAU_MAKEFILE -lTAU -Wl,-rpath,${TAU}/lib/$TAU_MAKEFILE -lm&> $ERRFILE2

RC=$?
echo -n "C instrumentation with file inclusion/exclusion"
if [ $RC != 0 ]; then
    echo -e "   ${BRED}[FAILED]${NC}"
else
    echo -e "   ${BGREEN}[PASSED]${NC}"
fi
echo -n "Instrumented functions"
if [ `grep "Instrument"  $ERRFILE | wc -l` -gt 0 ] ; then
    echo -e "                            ${BGREEN}[PASSED]${NC}"
else
    echo -e "                            ${BRED}[FAILED]${NC}"
fi
rm $ERRFILE $ERRFILE2

# This test doesn't support the use of wildcards, so these testcases are irrelevant
#echo -e "${BBLUE}Regular expressions${NC}"
#
#clang -O3 -g -fplugin=${LLVM_DIR}/lib/TAU_Profiling.so -mllvm -tau-input-file=./functions_C_mm_regex.txt -ldl -L${TAU}/lib/$TAU_MAKEFILE -lTAU -Wl,-rpath,${TAU}/lib/$TAU_MAKEFILE matmult.c matmult_initialize.c -o mm_c_regex &> $ERRFILE
#echo -n "Instrumentation using regular expressions - C"
#if [ $RC != 0 ]; then
#    echo -e "	  ${BRED}[FAILED]${NC}"
#else
#    echo -e " 	  ${BGREEN}[PASSED]${NC}"
#fi
#echo -n "Instrumented functions"
#if [ `grep "Instrument"  $ERRFILE | wc -l` -gt 0 ] ; then
#    echo -e "			  	  ${BGREEN}[PASSED]${NC}"
#else
#    echo -e "	                          ${BRED}[FAILED]${NC}"
#fi
#rm $ERRFILE
#
#
#clang++ -O3 -g -fplugin=${LLVM_DIR}/lib/TAU_Profiling_CXX.so -mllvm -tau-input-file=./functions_CXX_hh_regex.txt -ldl -L${TAU}/lib/$TAU_MAKEFILE -lTAU -Wl,-rpath,${TAU}/lib/$TAU_MAKEFILE householder.cpp -o householder-regex &> $ERRFILE
#RC=$?
#echo -n "Instrumentation using regular expressions - C++"
#if [ $RC != 0 ]; then
#    echo -e "   ${BRED}[FAILED]${NC}"
#else
#    echo -e "   ${BGREEN}[PASSED]${NC}"
#fi
#echo -n "Instrumented functions"
#if [ `grep "Instrument"  $ERRFILE | wc -l` -gt 0 ] ; then
#    echo -e "                            ${BGREEN}[PASSED]${NC}"
#else
#    echo -e "                            ${BRED}[FAILED]${NC}"
#fi
#rm $ERRFILE
