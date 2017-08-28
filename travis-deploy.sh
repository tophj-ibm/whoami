#!/bin/bash
set -e

echo "Starting deploy"
image="$TARGET_REGISTRY:5000/tophj/whoami"
docker tag whoami "$image:linux-$ARCH-$TRAVIS_TAG"
docker push "$image:linux-$ARCH-$TRAVIS_TAG"

if [ "$ARCH" == "amd64" ]; then
  set +e
  echo "Waiting for other images $image:linux-arm-$TRAVIS_TAG"
  until docker run --rm stefanscherer/winspector "$image:linux-arm-$TRAVIS_TAG"
  do
    sleep 15
    echo "Try again"
  done
  until docker run --rm stefanscherer/winspector "$image:linux-arm64-$TRAVIS_TAG"
  do
    sleep 15
    echo "Try again"
  done
#  until docker run --rm stefanscherer/winspector "$image:windows-amd64-$TRAVIS_TAG"
#  do
#    sleep 15
#    echo "Try again"
#  done
  set -e

  echo "Downloading docker client with manifest command"
  wget https://4277-88013053-gh.circle-artifacts.com/1/work/build/docker-linux-amd64
  #  wget https://4242-88013053-gh.circle-artifacts.com/1/work/build/docker-linux-amd64
  # https://3806-88013053-gh.circle-artifacts.com/1/work/build/docker-linux-amd64
  mv docker-linux-amd64 docker
  chmod +x docker
  ./docker version
  

  # installing cert
  echo "Installing certs"
  apt-get install -y curl openssl
  curl -k https://$TARGET_REGISTRY/ca -o /usr/local/share/ca-certificates/$TARGET_REGISTRY.crt
  update-ca-certificates
  service docker restart

  mkdir -p /etc/docker/certs.d/$TARGET_REGISTRY:5000
  openssl s_client -connect $TARGET_REGISTRY:5000 -showcerts </dev/null 2>/dev/null | openssl x509 -outform PEM | tee /etc/docker/certs.d/$TARGET_REGISTRY:5000/ca.crt
  service docker restart



  set -x
  
  echo "Pushing manifest $image:$TRAVIS_TAG"
  ./docker -D manifest create "$image:$TRAVIS_TAG" \
    "$image:linux-amd64-$TRAVIS_TAG" \
    "$image:linux-arm-$TRAVIS_TAG" \
    "$image:linux-arm64-$TRAVIS_TAG" \
#    "$image:windows-amd64-$TRAVIS_TAG"
  ./docker manifest annotate "$image:$TRAVIS_TAG" "$image:linux-arm-$TRAVIS_TAG" --os linux --arch arm
  ./docker manifest annotate "$image:$TRAVIS_TAG" "$image:linux-arm64-$TRAVIS_TAG" --os linux --arch arm64
  ./docker -D manifest push "$image:$TRAVIS_TAG"

  echo "Pushing manifest $myimage:latest"
  ./docker -D manifest create "$myimage:latest" \
    "$image:linux-amd64-$TRAVIS_TAG" \
    "$image:linux-arm-$TRAVIS_TAG" \
    "$image:linux-arm64-$TRAVIS_TAG" \
#    "$image:windows-amd64-$TRAVIS_TAG"
  ./docker manifest annotate "$image:latest" "$image:linux-arm-$TRAVIS_TAG" --os linux --arch arm
  ./docker manifest annotate "$image:latest" "$image:linux-arm64-$TRAVIS_TAG" --os linux --arch arm64
  ./docker -D manifest push "$image:latest"
fi
