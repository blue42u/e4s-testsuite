#!/bin/bash

#. ./setup.sh

i=0
for cmd in "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 1 ./pdtest -r 1 -c 1 -s 1 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 1 ./pdtest -r 1 -c 1 -s 3 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 2 ./pdtest -r 1 -c 2 -s 1 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 2 ./pdtest -r 1 -c 2 -s 3 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 3 ./pdtest -r 1 -c 3 -s 1 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 3 ./pdtest -r 1 -c 3 -s 3 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 2 ./pdtest -r 2 -c 1 -s 1 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 2 ./pdtest -r 2 -c 1 -s 3 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 4 ./pdtest -r 2 -c 2 -s 1 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 4 ./pdtest -r 2 -c 2 -s 3 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 6 ./pdtest -r 2 -c 3 -s 1 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 6 ./pdtest -r 2 -c 3 -s 3 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 5 ./pdtest -r 5 -c 1 -s 1 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 5 ./pdtest -r 5 -c 1 -s 3 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 10 ./pdtest -r 5 -c 2 -s 1 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 10 ./pdtest -r 5 -c 2 -s 3 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 15 ./pdtest -r 5 -c 3 -s 1 -b 2 -x 8 -m 20 -f g20.rua" "${TEST_RUN_CMD} ${TEST_RUN_PROCFLAG} 15 ./pdtest -r 5 -c 3 -s 3 -b 2 -x 8 -m 20 -f g20.rua"
do
	((i++))
	p=1
	eval "OMP_NUM_THREADS=2 ${cmd}" || p=0
	if [[ "${p}" -ne 1 ]]; then
		exit 1
	fi
done
