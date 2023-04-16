#!/usr/bin/env bash

# cronjob으로 이 스크립트 실행하기
make commit 2>&1
make deploy 2>&1