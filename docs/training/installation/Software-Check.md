# Software Installation and Verification Commands to run from Bash

Note: the purpose of running these commands is to confirm that the CLI tool has been properly installed. The versions in the output of these commands don't actually matter.

## Note sometimes this lab guide tells users to update their ~/.bashrc or ~/.zshrc file
```bash
# bash is the default shell, but Users who have tinkered with their system 
# long ago and forgot about it might be using zsh
echo $SHELL
# will tell you if you use bash or zsh
```

### Recommendation/Note for Mac users of Bash
```bash
# Mac defaults to an ancient version of bash, try the following to update
brew install bash

# In some versions of Mac the ~/.bashrc file doesn't exists or acts werid by default
# werid as in some case ~/.bash_profile is used, other cases ~/.bashrc is used
# the following makes it so ~/.bashrc is the main file, which improves consistency
touch ~/.bashrc   # create if doesn't exist 
echo 'source ~/.bashrc' >> ~/.bash_profile    # makes ~/.bashrc the primary config file
source ~/.bashrc    # makes the current session consistent with newly opened sessions
```



## [curl](https://curl.se/)
### Check if / Verify that curl is installed
```bash
# [admin@Laptop:~]
curl --version
```

### Install curl (if needed)
* Aparently Ubuntu 21.04 doesn't ship with curl installed by default (only been out 5 days, so maybe this'll change)
```bash
# [admin@Laptop:~]
sudo apt update -y && sudo apt install curl -y
```



## [sshuttle](https://github.com/sshuttle/sshuttle#obtaining-sshuttle)
### Install sshuttle (Linux):
```bash
# [admin@Linux:~]
# Verify pip is installed (pip = "pip installs packages", pip3 = pip associated with python3)
pip3 --version

# If you see "pip: command not found", then run one of the following
# Ubuntu Users:
sudo apt update -y && sudo apt install python3-pip -y
# Centos 8 Users: 
sudo dnf update -y && sudo dnf install python3-pip -y

# Use pip to install sshuttle
pip3 install sshuttle
```

### Install sshuttle (Mac):
```bash
# [admin@Mac:~]
brew install sshuttle
```

### Verify sshuttle is installed
```bash
sshuttle --version
# 1.0.3 (or higher)
```

### sshuttle troubleshooting
* On some versions of Linux, you may receive an `invalid syntax` error upon trying `sshuttle --version`. If this happens, you need to ensure that sshuttle is using python3 instead of python2. Replace it to fix this error.

```
sudo vi /usr/bin/sshuttle
:%s/python2.7/python3
:wq!

sshuttle --version
# 1.0.3 (or higher)
```

## [kubectl](https://kubernetes.io/docs/tasks/tools/)
### Check if / Verify that kubectl is installed
* Note: Docker Desktop & Rancher Desktop will often auto install kubectl, so mac users may find that it's preinstalled
```bash
kubectl version --client
# Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.2", GitCommit:"9d142434e3af351a628bffee3939e64c681afa4d", GitTreeState:"clean", BuildDate:"2022-01-19T17:35:46Z", GoVersion:"go1.17.5", Compiler:"gc", Platform:"darwin/amd64"}
```

### Install kubectl (Linux):
```bash
# [admin@Laptop:~]
wget -q -P  /tmp https://storage.googleapis.com/kubernetes-release/release/v1.23.2/bin/linux/amd64/kubectl
sudo chmod +x /tmp/kubectl
sudo mv /tmp/kubectl /usr/local/bin/kubectl
sudo ln -s /usr/local/bin/kubectl /usr/local/bin/k  #equivalent to alias k=kubectl
```

### Install kubectl (Mac):
```bash
# [admin@Laptop:~]
brew install kubectl  # likely pre-installed if you've already installed docker.
```





## [Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/binaries/)
### Check if / Verify that kustomize is installed:
```bash
kustomize version
# {Version:kustomize/v4.5.2 GitCommit:7439f1809e5ccd4677ed52be7f98f2ad75122a93 BuildDate:2020-12-30T00:43:15+00:00 GoOs:darwin GoArch:amd64}
```

### Install kustomize (Linux):
> **NOTE: DO NOT INSTALL kustomize via Ubuntu's snap install (snap's kustomization has been broken for many months, use the below method)**
```bash
# [admin@Laptop:~]
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash 
chmod +x kustomize
sudo mv kustomize /usr/bin/kustomize
```

### Install kustomize (Mac):
```bash
# [admin@Laptop:~]
brew install kustomize
brew upgrade kustomize # If you think you have an old version
```



## [Git](https://git-scm.com/downloads) 
### Check if / Verify that git is installed:
```bash
git version
# git version 2.30.1 (Apple Git-122.3)
```

### Install git (Centos 8):
```bash
sudo dnf install git -y
```

### Install git (Ubuntu):
```bash
sudo apt install git -y
```

### Install git (Mac):
```bash
brew install git
```


## [Terraform](https://www.terraform.io/downloads.html)
### Verify Terraform is installed:
```bash
terraform version
# Terraform v1.0.3 or higher
```

### Install Terraform (Ubuntu):
```bash
# [admin@Laptop:~]
wget https://releases.hashicorp.com/terraform/1.1.6/terraform_1.1.6_linux_amd64.zip
sudo apt update -y && sudo apt install unzip -y && unzip terraform_1.1.6_linux_amd64.zip && sudo mv terraform /usr/local/bin/ && rm terraform_1.1.6_linux_amd64.zip
```

### Install Terraform (Centos 8):
```bash
# [admin@Laptop:~]
wget https://releases.hashicorp.com/terraform/1.1.6/terraform_1.1.6_linux_amd64.zip
sudo yum update -y && sudo yum install unzip -y && unzip terraform_1.1.6_linux_amd64.zip && sudo mv terraform /usr/local/bin/ && rm terraform_1.1.6_linux_amd64.zip
```

### Install Terraform (Mac):
```bash
# [admin@Laptop:~]
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew update
brew upgrade hashicorp/tap/terraform
```

## [Docker](https://docs.docker.com/docker-for-mac/install/)
### Install Docker Part 1 of 2 (Linux):
```bash
# [admin@Laptop:~]
curl -fsSL https://get.docker.com | bash
# After install complete part 2 of docker install
```

### Install Docker Part 1 of 2 (Mac):
> Mac Users: Docker Desktop for Mac install link can be found [here](https://docs.docker.com/docker-for-mac/install/)
>
> Note: [Docker-Desktop now requires a license in some cases](https://www.docker.com/blog/updating-product-subscriptions/), [Rancher Desktop](https://rancherdesktop.io/) defaults to containerd/nerdctl, but also has a docker mode that leverages a QEMU VM and a FOSS tool called Moby, it's a closs enough free alternative to Docker-Desktop that can do 90% of what Docker-Desktop can do.      
>
> For those who are curious, Rancher Desktop 1.0.1's limitations:
>  * Doesn't offer an easy way to disable the kubernetes cluster it ships with like docker desktop does.
>  * Doesn't have the ability to edit docker config (/etc/docker/daemon.json) file in the GUI. (This is an advanced use case that people rarely need to use.)        
>
> After installing docker complete part 2 of docker install

### Install Docker Part 2 of 2: 
1. Notice that by default docker will only work when run as root
```bash
# Note installing docker isn't enough, by default docker only works for the root user
# You need to configure docker to work for non-root user as well.

# Note: Centos 8 users will need to add the following 2 lines
sudo systemctl enable docker #enable = autostart the service on reboot
sudo systemctl start docker  #start = start the service now

# The below commands are generic to Mac/Linux
docker run hello-world
# docker: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.35/containers/create: dial unix /var/run/docker.sock: connect: permission denied.See 'docker run --help'.
# If you see something like this, you haven't finished installing docker
# / missed some required configuration
# If you installed docker using snap, try uninstalling it and then using the recommended way to install docker.
# If it works you're good to move on.

sudo docker run hello-world
# If docker only works when you use sudo, further configuration is needed.
# Basically you need to add your non-root user to the docker group.
```

2. Add User to docker group (Linux Instructions)
```bash
sudo groupadd docker
sudo usermod --append --groups docker $USER
```

3. Log out and Log back in (There are other methods but this is the one that works 100% of the time)
* Do not skip this step of logging out and logging back in.
```text
Note there are other methods like 'newgrp docker' command, but those only work 
for 1 terminal. In some cases you can get away with closing all opened terminal
then opening a new terminal instead of logging out and back in, but there are 
edge cases were the only thing that works is a full log out and re login. 

If it doesn't it's because unix security makes it so a process can't gain
any more rights (like a group assignment to docker), than what it started with.
the newgrp docker command, is supposed to start a new process within the terminal
which causes your user being added to the docker group to be recognised
and non-root docker commands to start to work.
```

### Verify Docker is correctly installed:
```bash
docker run hello-world
# docker should now work as a non-root user now / not throw an error message
# 
# If docker doesn't work. Log out and Log back in.
# When you log back in your non-root user will be properly recognised as being
# In the docker group and the command should work.
```



## [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) 
### Install AWS CLI (Linux):
```bash
# [admin@Linux:~]
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws
rm awscliv2.zip
```

### Install AWS CLI (Mac):
```bash
# [admin@Mac:~]
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
rm AWSCLIV2.pkg
```

### Verify AWS CLI is installed:
```bash
aws --version
# aws-cli/2.4.20 Python/3.8.8 Darwin/20.6.0 exe/x86_64 prompt/off
# NOTE: for aws cli version 1.x or 2.x either is fine
```



## [Flux CLI](https://fluxcd.io/docs/guides/installation/)
### Install Flux CLI (Linux):
```bash
# [admin@Laptop:~]
# curl -s -L https://toolkit.fluxcd.io/install.sh | sudo bash
wget -q -O - https://github.com/fluxcd/flux2/releases/download/v0.27.2/flux_0.27.2_linux_amd64.tar.gz > flux.tar.gz
tar -xvf flux.tar.gz
sudo mv ./flux /usr/local/bin/flux
rm flux.tar.gz
```

### Install Flux CLI (Mac):
```bash
# [admin@Laptop:~]
wget -q -O - https://github.com/fluxcd/flux2/releases/download/v0.27.2/flux_0.27.2_darwin_amd64.tar.gz > flux.tar.gz
tar -xvf flux.tar.gz
sudo mv ./flux /usr/local/bin/flux
rm flux.tar.gz
```

### Verify Flux is installed
```bash
# [admin@Laptop:~]
flux --version
# flux version 0.27.2
```

## Flux Lab: Install Flux to Cluster
### Install Flux

> * Fedora Note
>   kubectl is a prereq for flux, and flux expects it in `/usr/local/bin/kubectl`
>   symlink it or copy the binary to fix errors.

### Verify there's no issue with your IronBank Image Pull Credentials
* The goal here is to left shift feedback of potential problems before they occur.

```bash
# Note: In production you'd use an IronBank service account / robot credential like this: 
# export REGISTRY1_USER='robot-ironbank+bigbang-onboarding-imagepull'
# For demos you can use your personal credentials

export REGISTRY1_USER=$(sops --decrypt ~/Desktop/bootstrap/base/secrets.enc.yaml | grep username | tr -d " " | cut -d : -f 2)
export REGISTRY1_TOKEN=$(sops --decrypt ~/Desktop/bootstrap/base/secrets.enc.yaml | grep password | tr -d " " | cut -d : -f 2)

echo $REGISTRY1_TOKEN | docker login registry1.dso.mil --username $REGISTRY1_USER --password-stdin
```

### Install flux.yaml to the cluster

```bash
cd ~/Desktop
git clone https://repo1.dso.mil/platform-one/big-bang/bigbang.git
cd bigbang/
./scripts/install_flux.sh -u $REGISTRY1_USER -p $REGISTRY1_TOKEN

kubectl get pod -n=flux-system
```

### Now new objects types are recognised inside of the cluster

```bash
kubectl get crds | grep flux
```

 Thanks to flux install adding newly recognised resource types / CRDs
 In the next lab we'll get feedback when we run these commands
`kubectl get gitrepositories --all-namespaces`
`kubectl get kustomizations -A`
The expected output is:
`no resources found`
Unless you already ran `kubectl apply bigbang.yaml`  those are fine / they get fixed in a future lab.
The significance of this command is that it at least recognised kustomizations and git repositories as valid object types



## [SOPS](https://github.com/mozilla/sops)

### Install sops CLI (Linux):
```bash
# [admin@Linux:~]
curl -L https://github.com/mozilla/sops/releases/download/v3.7.2/sops-v3.7.2.linux > sops
chmod +x sops
sudo mv sops /usr/bin/sops
```

### Install sops CLI (Mac):
```bash
# [admin@Mac:~]
curl -L https://github.com/mozilla/sops/releases/download/v3.7.2/sops-v3.7.2.darwin > sops
chmod +x sops
mv sops /usr/local/bin/sops
```

### Verify sops is installed
```bash
# [admin@Laptop:~]
sops -v
# sops 3.7.2  (latest)
```

## GPG: (GNU Privacy Guard)
**Note:**     
* sops can leverage CSP(Cloud Service Provider) KMSs(Key Management Services).
* CSP KMS backed with AES 256 bit symmetric encryption is the gold standard / most secure option.
* In scenarios where CSP KMS isn't an option, sops can also leverage GPG & AGE    
  (these are cloud agnostic options that work for air gap deployments)
* For DoD activities, it's recommended to use GPG over AGE, because GPG's RSA keypairs and SHA256 are NIST approved.     
  (Both options are secure; however, AGE's Curve25519 key pairs, and Chacha20 symmetric encyrption with Poly1305 aren't NIST approved.)

### Install GPG (Mac):
```shell
# [admin@Mac:~]
brew install gnupg
gpg --version
# gpg (GnuPG) 2.3.4
# (Note: by default gpg 2.3.x generated keys aren't compatible with gpg 2.0.x - 2.2.x
# ;however, the lab guide includes workaround flags to make the generated keys compatible)
```

### Install GPG (Linux):
```shell
# [admin@Linux:~]
# (all Linux Distros ship with GPG pre-installed, verify with the following)
gpg --version
```


## GRAPHICAL TEXT EDITORS:
* It's recommended that you install at least 1 of these.    
[Sublime Text](https://www.sublimetext.com/download)     
[VS Code](https://code.visualstudio.com/download)     

### Text Editor Note for Linux Users:
Immediately upon installing Sublime Text and VS Code     
The following 2 commands will work to open the editor from the cli      
Bash# `code`    
Bash# `subl`    
(The idea is that whenever you see vi ~/file_to_edit, you'll be able to replace vi with your preferred editor)       
* Note if you like vi but it's "acting funny" (example arrow keys trigger characters, then try adding the the following)
```shell
cat > ~/.vimrc <<EOF
set nocompatible
set backspace=indent,eol,start
" Doublequote is vim's way of comments
" nocomatible makes arrow keys work, (in edge cases where they don't work how you'd expect them to)
" backspace makes backspace and delete keys work, (in edge cases where they don't work how you'd expect them to)
EOF
sudo cp ~/.vimrc /root/.vimrc

# The above creates the following 2 files
cat /home/$USER/.vimrc
sudo cat /root/.vimrc
```

### Text Editor Note for Mac Users:
Upon installing Sublime Text and VS Code      
You won't be able to launch the editors from the CLI until the following additional commands are added
```bash
sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
echo 'export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"' >> ~/.bashrc
tail ~/.bashrc
source ~/.bashrc
```

### Text Editor Recommendation for Linux / Mac Users:
```bash
echo 'export EDITOR="subl --wait"' >> ~/.bashrc
tail ~/.bashrc
source ~/.bashrc
# This will update the default text editor to use sublime text
# Note if you use zshell change ~/.bashrc to ~/.zshrc
# If you prefer VS Code to Sublime Text you can replace subl with code in the above command
# That being said, it's worth noting that subl opens instantly and has yaml syntax highlighting baked in.
```

## Local Utilities
## [jq](https://stedolan.github.io/jq/download/)

jq is like ```sed``` for JSON data - you can use it to slice and filter and map and transform structured data with the same ease that ```sed```, ```awk```, ```grep``` and friends let you play with text.


## OPTIONAL
[kubectx](https://github.com/ahmetb/kubectx#installation)

