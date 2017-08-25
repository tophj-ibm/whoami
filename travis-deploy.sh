#!/bin/bash
set -e

docker images

image="stefanscherer/whoami"
myimage="tophj/whoami"
docker tag whoami "$myimage:linux-$ARCH-$TRAVIS_TAG"
docker push "$myimage:linux-$ARCH-$TRAVIS_TAG"

#if [ "$ARCH" == "amd64" ]; then
#  set +e
#  echo "Waiting for other images $myimage:linux-arm-$TRAVIS_TAG"
#  until docker run --rm stefanscherer/winspector "$image:linux-arm-$TRAVIS_TAG"
#  do
#    sleep 15
#    echo "Try again"
#  done
#  until docker run --rm stefanscherer/winspector "$image:linux-arm64-$TRAVIS_TAG"
#  do
#    sleep 15
#    echo "Try again"
#  done
#  until docker run --rm stefanscherer/winspector "$image:windows-amd64-$TRAVIS_TAG"
#  do
#    sleep 15
#    echo "Try again"
#  done
#  set -e

  echo "Downloading docker client with manifest command"
  wget https://4242-88013053-gh.circle-artifacts.com/1/work/build/docker-linux-amd64
  # https://3806-88013053-gh.circle-artifacts.com/1/work/build/docker-linux-amd64
  mv docker-linux-amd64 docker
  chmod +x docker
  ./docker version
  
  set -x
  
  echo "Pushing manifest $myimage:$TRAVIS_TAG"
  ./docker -D manifest create "$myimage:$TRAVIS_TAG" \
    "$image:linux-amd64-$TRAVIS_TAG" \
    "$image:linux-arm-$TRAVIS_TAG" \
    "$image:linux-arm64-$TRAVIS_TAG" \
    "$image:windows-amd64-$TRAVIS_TAG"
  ./docker manifest annotate "$myimage:$TRAVIS_TAG" "$image:linux-arm-$TRAVIS_TAG" --os linux --arch arm
  ./docker manifest annotate "$myimage:$TRAVIS_TAG" "$image:linux-arm64-$TRAVIS_TAG" --os linux --arch arm64
  ./docker -D manifest push "$myimage:$TRAVIS_TAG"

  echo "Pushing manifest $myimage:latest"
  ./docker -D manifest create "$myimage:latest" \
    "$image:linux-amd64-$TRAVIS_TAG" \
    "$image:linux-arm-$TRAVIS_TAG" \
    "$image:linux-arm64-$TRAVIS_TAG" \
    "$image:windows-amd64-$TRAVIS_TAG"
  ./docker manifest annotate "$myimage:latest" "$image:linux-arm-$TRAVIS_TAG" --os linux --arch arm
  ./docker manifest annotate "$myimage:latest" "$image:linux-arm64-$TRAVIS_TAG" --os linux --arch arm64
  ./docker manifest -D push "$myimage:latest"
fi
