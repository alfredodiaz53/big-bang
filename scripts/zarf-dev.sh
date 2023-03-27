#!/usr/bin/env bash

ZARF_VERSION=v0.25.0
NVM_VERSION=v0.39.3

# Usage: scripts/zarf-dev.sh
# Prerequisites: REGISTRY1_USERNAME and REGISTRY1_PASSWORD must be exported locally.
# Configurable: ZARF_TEST_REPO, ZARF_TEST_REPO_BRANCH, ZARF_TEST_REPO_DIRECTORY all define where to pick up the zarf.yaml file.
# Example with configuration: ZARF_TEST_REPO=https://repo1.dso.mil/some-repo.git ZARF_TEST_REPO_BRANCH=development scripts/zarf-dev.sh

ZARF_TEST_REPO=${ZARF_TEST_REPO:=https://github.com/defenseunicorns/zarf}
ZARF_TEST_REPO_BRANCH=${ZARF_TEST_REPO_BRANCH:=main}
ZARF_TEST_REPO_DIRECTORY=${ZARF_TEST_REPO_DIRECTORY:=zarf/examples/big-bang}

function run() {
  ssh -i ~/.ssh/${SSHKEYNAME}.pem -o StrictHostKeyChecking=no -o IdentitiesOnly=yes ubuntu@${PUBLICIP} $1
}

# install npm
run "sudo apt-get install -y make npm"
run "sudo snap install go --classic"
run "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash"
run "source ~/.nvm/nvm.sh && nvm install --lts && nvm use --lts"

# install zarf
echo Installing zarf...
run "curl -LO https://github.com/defenseunicorns/zarf/releases/download/${ZARF_VERSION}/zarf_${ZARF_VERSION}_Linux_amd64"
run "sudo mv /home/ubuntu/zarf_${ZARF_VERSION}_Linux_amd64 /usr/local/bin/zarf"
run "sudo chmod +x /usr/local/bin/zarf"

# get zarf init package
echo "Retrieving zarf init package..."
run "wget -q https://github.com/defenseunicorns/zarf/releases/download/${ZARF_VERSION}/zarf-init-amd64-${ZARF_VERSION}.tar.zst"

# zarf init, package and deploy
run "set +o history && echo ${REGISTRY1_PASSWORD} | zarf tools registry login registry1.dso.mil --username ${REGISTRY1_USERNAME} --password-stdin || set -o history"
run "zarf init --components=git-server --confirm"
run "git clone --single-branch --branch ${ZARF_TEST_REPO_BRANCH} ${ZARF_TEST_REPO}"
run "cd ${ZARF_TEST_REPO_DIRECTORY} && zarf package create --confirm --max-package-size=0"
run "cd ${ZARF_TEST_REPO_DIRECTORY} && zarf package deploy zarf-package-big-bang-example-amd64-1.54.0.tar.zst --confirm --components=gitea-virtual-service"
