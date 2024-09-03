#!/bin/sh

APOLLO_FRAMEWORK_PATH="${SRCROOT}/Pods/Apollo"
cd "${SRCROOT}/${TARGET_NAME}"
"${APOLLO_FRAMEWORK_PATH}/run-bundled-codegen.sh" codegen:generate --target=swift --localSchemaFile="schema.json" API.swift
