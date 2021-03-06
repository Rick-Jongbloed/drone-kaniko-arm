#!/bin/busybox sh
set -euo pipefail

KANIKO_PATH=${PLUGIN_KANIKO_PATH:-/kaniko}

export PATH=$PATH:${KANIKO_PATH}/

REGISTRY=${PLUGIN_REGISTRY:-index.docker.io}

if [ "${PLUGIN_USERNAME:-}" ] || [ "${PLUGIN_PASSWORD:-}" ]; then
    DOCKER_AUTH=`echo -n "${PLUGIN_USERNAME}:${PLUGIN_PASSWORD}" | base64 | tr -d "\n"`

    cat > ${KANIKO_PATH}/.docker/config.json <<DOCKERJSON
{
    "auths": {
        "${REGISTRY}": {
            "auth": "${DOCKER_AUTH}"
        }
    }
}
DOCKERJSON
fi

if [ "${PLUGIN_JSON_KEY:-}" ]; then      # not used??
    echo "${PLUGIN_JSON_KEY}" > ${KANIKO_PATH}/gcr.json  
    export GOOGLE_APPLICATION_CREDENTIALS=${KANIKO_PATH}/gcr.json
fi

DOCKERFILE=${PLUGIN_DOCKERFILE:-Dockerfile}
CONTEXT=${PLUGIN_CONTEXT:-$PWD}
LOG=${PLUGIN_LOG:-info}

if [[ -n "${PLUGIN_TARGET:-}" ]]; then
    TARGET="--target=${PLUGIN_TARGET}"
fi

if [[ "${PLUGIN_CACHE:-}" == "true" ]]; then
    CACHE="--cache=true"
fi

if [[ "${PLUGIN_INSECURE:-}" == "true" ]]; then
    INSECURE="--insecure"
fi

if [[ "${PLUGIN_INSECURE_REGISTRY:-}" == "true" ]]; then
    INSECURE_REGISTRY="--insecure-registry"
fi

if [[ "${PLUGIN_INSECURE_PULL:-}" == "true" ]]; then
    INSECURE_PULL="--insecure-pull"
fi

if [[ "${PLUGIN_SKIP_TLS_VERIFY:-}" == "true" ]]; then
    SKIP_TLS_VERIFY="--skip-tls-verify"
fi

if [ -n "${PLUGIN_BUILD_ARGS:-}" ]; then
    BUILD_ARGS=$(echo "${PLUGIN_BUILD_ARGS}" | tr ',' '\n' | while read build_arg; do echo "--build-arg=${build_arg}"; done)
fi

if [ -n "${PLUGIN_TAGS:-}" ]; then
    DESTINATIONS=$(echo "${PLUGIN_TAGS}" | tr ',' '\n' | while read tag; do echo "--destination=${REGISTRY}/${PLUGIN_REPO}:${tag} "; done)
elif [ -n "${PLUGIN_REPO:-}" ]; then
    DESTINATIONS="--destination=${PLUGIN_REPO}:latest"
else
    DESTINATIONS="--no-push"
    # Cache is not valid with --no-push
    CACHE=""
fi

${KANIKO_PATH}/executor -v ${LOG} \
    --context=${CONTEXT} \
    --dockerfile=${DOCKERFILE} \
    ${DESTINATIONS} \
    ${CACHE:-} \
    ${INSECURE_REGISTRY:-} \
    ${INSECURE_PULL:-} \
    ${INSECURE:-} \
    ${SKIP_TLS_VERIFY:-}
    ${TARGET:-} \
    ${BUILD_ARGS:-}

#echo ${KANIKO_PATH}/executor -v ${LOG}     --context=${CONTEXT}     --dockerfile=${DOCKERFILE}     ${DESTINATIONS}     ${CACHE:-}     ${INSECURE_REGISTRY:-}    ${INSECURE_PULL:-}     ${INSECURE:-}    ${TARGET:-}     ${BUILD_ARGS:-} ${PATH}