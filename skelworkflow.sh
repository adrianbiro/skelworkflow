#!/bin/bash
set -o errexit
#set -o nounset
set -o pipefail

NAME="${1}"
if [[ -z "${NAME}" ]]; then
  echo -e "Usage:\v${0} <name> <branch> <tests>"
  exit 64  # EX_USAGE
fi
WDIR=".github/workflows"
FILE="${WDIR}/${NAME}.yaml"
BRANCH="${2:-main}"
TESTS="${3:-Write_some_tests!}"  # test for this file: ./skelworkflow.sh testskel main "./skelworkflow.sh testskel main"
WF=$(cat <<EOF
name: "${NAME} CI"

on:
  pull_request: {}
  push:
    branches:
      - "${BRANCH}"

jobs:
  test:
    runs-on: "ubuntu-latest"

    steps:
      - uses: "actions/checkout@v2"

      - name: "Install ShellCheck"
        run: sudo apt-get install -y shellcheck

      - name: "Lint script"
        run: shellcheck ${NAME}

      - name: "Test for script"
        run: ./${NAME} ${TESTS}
EOF
)
mkdir -p ${WDIR}
echo "${WF}" > "${FILE}"
