#!/bin/bash
set -e

export ARCH="amd64"
export TRAVIS_TAG="1.3.9-test1"
echo "Starting deploy"

echo "Removing old manifest from dir"
rm -rf /home/tophj/.docker/manifests/*

echo "Logging in"
#docker login -u="$DOCKER_USER" -p="$DOCKER_PASS"


echo "Pushing inital images"

image="tophj/whoami"
#docker tag whoami "$image:$ARCH"
#docker push "$image:$ARCH"
if [ "$ARCH" == "amd64" ]; then
#  set +e
#  echo "Waiting for other images $image:linux-arm-$TRAVIS_TAG"
#  until docker run --rm stefanscherer/winspector "$image:$ARCH"
#  do
#    sleep 15
#    echo "Try again"
#  done
#  until docker run --rm stefanscherer/winspector "$image:$ARCH"
#  do
#    sleep 15
#    echo "Try again"
#  done
#  until docker run --rm stefanscherer/winspector "$image:windows-amd64-$TRAVIS_TAG"
#  do
#    sleep 15
#    echo "Try again"
#  done
  set -e

  echo "Downloading docker client with manifest command"
#  wget https://4277-88013053-gh.circle-artifacts.com/1/work/build/docker-linux-amd64
  #  wget https://4242-88013053-gh.circle-artifacts.com/1/work/build/docker-linux-amd64
  # https://3806-88013053-gh.circle-artifacts.com/1/work/build/docker-linux-amd64
 # mv docker-linux-amd64 docker
 # chmod +x docker
  ./docker version

#  ./docker build -t whoami -f "Dockerfile.$ARCH" .
#  ./docker tag whoami "$image:$ARCH"
#  ./docker push "$image:$ARCH"

  ./docker build -t tophj/whoami:amd64 -f Dockerfile.amd64 .
#  ./docker tag whoami "$image:$ARCH"
#  ./docker push tophj/whoami:amd64



 image="45.55.81.106:5000/whoami"
 ./docker tag tophj/whoami:amd64 45.55.81.106:5000/whoami:amd64 
 ./docker push "$image:$ARCH"

 image2="45.55.81.106:5000/alpine2"
 ./docker pull alpine
 ./docker tag alpine "$image2:$ARCH"
 ./docker push "$image2:$ARCH"
 

#  echo "\/\/\\/\/\/\/\/\/\\/\/\/\\/\/\/\/\/\/\/\/\/\/\//\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/"
#  docker info
#  echo "[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]["
#  ./docker info
#  whoami
#  pwd
#  echo $HOME
#  echo "\/\/\\/\/\/\/\/\/\\/\/\/\\/\/\/\/\/\/\/\/\/\/\//\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/"
  set -x

  ./docker 
  #./docker tag $image:amd64 $image:amd64-2
  #./docker push $image:amd64-2
#  ./docker images


  echo "Trying to type it out?"
  ./docker -D manifest create "$image:$TRAVIS_TAG" \
   "$image:$ARCH" "$image2:$ARCH"
  ./docker -D manifest push "$image:$TRAVIS_TAG"








#  echo "Creating and pushing manifest list $image:$TRAVIS_TAG"
#  ./docker -D manifest create "$image:$TRAVIS_TAG" \
#    "$image:amd64" \
#    "$image:amd64-2"



#    "$image:arm" \
#    "$image:arm64" \
#    "$image:windows-amd64-$TRAVIS_TAG"
#  ./docker manifest annotate "$image:$TRAVIS_TAG" "$image:arm" --os linux --arch arm
#  ./docker manifest annotate "$image:$TRAVIS_TAG" "$image:arm64" --os linux --arch arm64
#  sleep 5
#  ./docker -D manifest push "$image:$TRAVIS_TAG"

#  echo "Pushing manifest $image:latest"
#  ./docker -D manifest create "$image:latest" \
#    "$image:linux-amd64-$TRAVIS_TAG" \
#    "$image:linux-arm-$TRAVIS_TAG" \
#    "$image:linux-arm64-$TRAVIS_TAG" \
#    "$image:windows-amd64-$TRAVIS_TAG"
#  ./docker manifest annotate "$image:latest" "$image:linux-arm-$TRAVIS_TAG" --os linux --arch arm
#  ./docker manifest annotate "$image:latest" "$image:linux-arm64-$TRAVIS_TAG" --os linux --arch arm64
#  ./docker -D manifest push "$image:latest"
fi
