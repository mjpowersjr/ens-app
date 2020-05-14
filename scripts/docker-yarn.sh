#!/bin/bash

set -e

project_root=$(git rev-parse --show-toplevel)
dockerfile="build.Dockerfile"
image="`basename $project_root`-build"

uid=$(id -u)
gid=$(id -g)

# build docker image
docker build \
  --tag "$image" \
  --file "$dockerfile" \
  "$project_root/scripts"


# run yarn inside docker
docker run \
  --rm \
  --interactive \
  --network host \
  --tty \
  --user "$uid:$gid" \
  --volume "$project_root:$project_root:rw" \
  --workdir "$project_root" \
  "$image" \
  yarn "$@" | cat
