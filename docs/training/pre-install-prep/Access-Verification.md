# Verify you can pull from Repo1 and IronBank

> Note: Platform One has 4 Useful Places to pull from  

1. Repo1's Gitlab Git Repo: [repo1.dso.mil](https://repo1.dso.mil)
   Repo1's Gitlab Git Repo is the Upstream Source of Truth Git Repo for P1's IaC/CaC
2. Repo1's Gitlab Docker Registry: [registry.dso.mil](https://registry.dso.mil)
   The Big Bang team sometimes stores docker images needed for tooling and prototyping here.
   Such docker images are stored here to signify that they have not gone through the official IronBank Process yet.
3. IronBank's Frontend GUI (where justifications and risk assessment are stored): [ironbank.dso.mil](https://ironbank.dso.mil)
4. IronBank's Harbor Docker Registry: [registry1.dso.mil](https://registry1.dso.mil)
   Source of truth for IronBank Images.

## Task #1 Clone the Engineering Cohort Repo from Repo1's Gitlab Git Repo: repo1.dso.mil

Repo1's Gitlab Git Repo is the Upstream Source of Truth Git Repo for P1's IaC/CaC

```bash
cd ~/Desktop
git config --global user.name "FIRST_NAME LAST_NAME"
git config --global user.email "MY_NAME@workemail.com or .mil"
cat ~/.gitconfig  #or cat ~/.git/config
git clone https://repo1.dso.mil/platform-one/onboarding/big-bang/engineering-cohort.git
```


## Task #2 Update your local clone of the Big Bang Residency git repo, by pulling the latest changes
>  Notes:  
> * This path is based on assumption that you cloned to the location shown above.  
> * Also, git commands are sensitive to your current working directory

```bash
cd ~/Desktop/engineering-cohort
git pull origin master
```


## Task #3 Pull an Image from Repo1 Gitlab's Docker Registry

```bash
docker pull registry.dso.mil/platform-one/plugins/kustomize/all:v0.1.1

# Note for Ubuntu users, if you get the following error (rare edge case)
# Error response from daemon: Get "https://registry.dso.mil/v2/": dial tcp: lookup registry.dso.mil: Temporary failure in name resolution
# then try
sudo systemctl restart systemd-resolved.service
```
> The above container image is publicly accessible (no auth needed).  
> If an image does require auth use a Gitlab Personal Access token for credentials.


## Task #4 Visit the IronBank Frontend website

1. In Chrome visit [ironbank.dso.mil](https://ironbank.dso.mil)
2. Click Browse all Hardened Containers
3. Type argo
4. Click Argocd
4. Look at the interface & versions available


## Task #5 Pull a Docker Image from IronBank

1. Visit [registry1.dso.mil](https://registry1.dso.mil)
1. Login via OIDC Provider
1. Navigate to Project ironbank
1. You'll see a search magnifying glass, click it and you'll have the option to filter repositories
1. search "ubi" (Side Note: UBI stands for Red Hat Universal Base Image)
1. Click ironbank/redhat/ubi/ubi8
1. Click the Button in the Pull Command column that corresponds to the latest tag mentioned in the
Tags Column.
1. Make a mental note of the other tag that is present (at the time of writing I see 8.5)
1. Paste that command into your terminal (initial error is expected and will be fixed in a subsequent step)
```shell
docker pull registry1.dso.mil/ironbank/redhat/ubi/ubi8:8.5
# Error response from daemon: unauthorized: unauthorized to access repository: ironbank/redhat/ubi/ubi8,
# action: pull: unauthorized to access repository: ironbank/redhat/ubi/ubi8, action: pull
```
10. In the top right click your name, then go to User Profile
11. Your User Profile section will have a CLI secret that you can copy
12. Type Login Command into Bash, here's an example
>  Use the `-u` option for username (use your own)
```bash
docker login registry1.dso.mil -u cmcgrath
```
>  The above command will prompt you for a password, that's your CLI secret from step 12  

13. Retry the docker pull command in step 9 and it'll now work.
14. Run the below docker command using a tag reference instead of a SHA256 reference, 
    note the latest tag at the time of writing was 8.5, during step 9 you may end up 
    seeing a newer tag, if a newer tag like :8.6 exists, use that instead.
```bash
docker pull registry1.dso.mil/ironbank/redhat/ubi/ubi8:8.5
```

## Task #6 Rotate your IronBank Docker Pull Credential

> Note: IronBank (registry1.dso.mil) is an instance of Harbor. At one point it was mis-configured such
> that docker pull credentials were tied to the life of your OIDC login, and the IronBank docker pull
> credentials would stop working after 30 minutes, and refuse to pull images until you logged into the
> IronBank GUI which would refresh an OIDC token and cause the pull credentials to start working again
> until the token expired 30 mins later.
> 
> IronBank was reconfigured such that newly minted pull credentials are created with an offline flag
> that separates them from the OIDC life cycle/makes them work as expected. (where they keep working
> regardless of if you'd recently logged into the GUI or not.)
> 
> Rotate your Iron Bank Docker Pull Credentials:
> This ensures that you don't have a docker pull credential that was created with the old
> misconfiguration that ties it into the OIDC token life cycle. The newly rotated credential will get
> generated using the new config / offline flag, such that it works as intended.

How to Rotate IB Docker Pull Credentials:
1. In a web browser go to [registry1.dso.mil](https://registry1.dso.mil)
2. Login via OIDC provider
3. Top right of the page, click your name --> User Profile
4. your username is what you'll put into the file's username spot
5. your CLI secret is what you'll use as a password
6. There are 2 rectangles next to CLI secret, click it, and you'll see green feedback "copy success"
7. Paste into a notepad
8. Click the 3 dots
9. Press Generate, a pop up will ask "Are you sure you can regenerate secret?"
10. Press Confirm, and you'll see green feedback "Cli secret setting is successful"
11. Click the 2 rectangles next to the CLI secret, and you'll see green feedback "copy success"
12. Paste into a notepad to verify the credentials have been rotated
13. Log into docker registry again shown below.

```bash
docker login registry1.dso.mil -u cmcgrath
```
>  The above command will prompt you for a password, that's your new CLI secret from step 11

## Task #7 Record your Registry1 IronBank Docker Image Pull Credentials

* Write your Registry1 username and password into a text file
* You will need to plug both sets of credentials into an encrypted config file in a future lab guide. (That lab guide will have a reminder saying that in this one you were supposed to write the creds into a text file for use in 5th lab guide's 3rd lab.)

## Task #8 Create a Repo1 Gitlab Personal Access Token

1. Login to [repo1.dso.mil/users/sign_in](https://repo1.dso.mil/users/sign_in)  which has a register button if needed.
2. In the top right of the GUI, click your user icon, a dropdown will appear, Select Settings
3. In the Bottom Left of the screen you'll see ">>", which when clicked will change to "<< Collapse sidebar"
4. Click ">>" to expand the sidebar, then click Access Tokens
5. You'll end up on this page: [repo1.dso.mil/profile/personal_access_tokens](https://repo1.dso.mil/profile/personal_access_tokens)
6. Create a Personal Access Token
7. It will ask you what scope you want the token to have, select all. 
8. It will ask you when you want the token to expire (have it expire 1 day from now, we won't actually be using it as part of the labs, but it's good info to know.)

> The name can be arbitrary, but as a convention it's best to have it match you're username.
> When you click on the button that says [Create personal access token], it'll show you the
> token which is effectively a password.
> There is no need to save or store the personal access token in a password manager, because
> it's very easy to revoke and provision a new one. 
> Note: You won't use it as part of the labs, but it's useful to know how to privision as it allows commiting to repos and accessing private repos. 

## Useful Background Info
> Your newly rotated IB Docker Pull Credentials are still tied to a OIDC token, just an OIDC token created with offline flag so it lasts for 30 days vs 30 minutes. Thus you'll want to login to the GUI once every 30 days to refresh it and prevent it from expiring.
> For production deployments ask your BigBang Liaison or P1 Customer Success to request the Container Hardening Team provision an IronBank Robo Credential, which lasts for 6 months.
> Personal IB creds are intended for per user clusters, IronBank Robo Creds are intended for production deployments



# Access: How to get Access to AWS

## Task #1 Know where to look for the lab's AWS credentials

AWS GUI and CLI Credentials will be shared via email.

> * These are credentials to a sandbox AWS account, even though it's a sandbox, don't delete anything you didn't spin up.
> * These credentials will be shared by the entire group, so do not change the password or rotate the keys.
> * If the shared credentials are leaked please inform the onboarding guides and we'll have the entire group rotate creds.
> * The onboarding guides will delete/rotate the credentials at the conclusion of the program.

## Task #2: Verify that you can login to the AWS GUI

<https://bb-onboarding.signin.amazonaws-us-gov.com/console>
(Username and Password supplied by onboarding guides)

You should have the following access:

> * Route53 (RO)
> * VPC (RO)
> * EC2 (full)
> * S3 (full)

## Task #3: Configure AWS CLI part 1 of 3 (create ~/.aws hidden folder)
```bash
mkdir -p ~/.aws
```

## Task #4: Configure AWS CLI part 2 of 3 (create ~/.aws/config)
> ~/.aws/config is 1 of 2 config files that's necessary for AWS CLI.      
> If you did not create it before in the vi lab, do so now 

`vi ~/.aws/config`
```text
[profile bb-onboarding]
region = us-gov-west-1
s3 =
    max_concurrent_requests = 40
    max_queue_size = 10000
    multipart_threshold = 8MB
    multipart_chunksize = 8MB
```

## Task #5: Configure AWS CLI part 3 of 3 (create ~/.aws/credentials)
`vi ~/.aws/credentials`
```text
[bb-onboarding]
region=us-gov-west-1
aws_access_key_id = Grab_this_value_from_the_email_sent_out_on_day_0
aws_secret_access_key = Grab_this_value_from_the_email_sent_out_on_day_0
```

## Task #6: Edit ~/.aws/credentials, and add in values from email
* Edit the credentials file, replace "Grab_this..." with values from email
`vi ~/.aws/credentials`
```text
[bb-onboarding]
region=us-gov-west-1
aws_access_key_id = Don't forget to edit
aws_secret_access_key = REPLACE ME
```


### Why didn't we just use aws configure? Was it merely to practice vi? (no)

Knowing how to configure AWS CLI without using aws configure can be useful.
Because some software uses AWS's API/references these files in these locations, but doesn't ship with the aws cli
While interfacing with P1 tooling, you may encounter docker images designed to work with AWS CLI creds, for the sake of leanness and a lower attack surface, the AWS CLI often isn't packaged with these docker containers, which means you can't use aws configure. They'll use your Laptops default AWS creds or those attached to an EC2 instances IAM role, but it can be useful when debugging to know how to manually set credentials within the container without making use of the AWS configure command.


## Task #7: Purposefully run these incorrect commands, so you'll be familiar with common mistakes

Do the following in a fresh terminal to ensure your .bashrc file is refreshed and your environment variables aren't set in a weird way.

Executing the following command will fail with error "Unable to locate credentials. You can configure credentials by running aws configure". Ignore the error and move to the next step.

```shell
[user@Laptop:~] 

aws s3 ls

```


## Task #8: Verify that you can use the AWS CLI credentials / config is correct

```shell
[user@Laptop:~]
env
# ^-- will show you all variables defined in your CLI environment

export AWS_PROFILE=bb-onboarding; export AWS_DEFAULT_PROFILE=bb-onboarding
# ^-- export is a linux command that sets CLI environment variables

env | grep -i aws
#      ^-- pipe grep with case insensitive -i cmd flag, will filter for matching results

aws s3 ls | grep bb-onboarding-labs-tf
# 2020-06-18 22:26:00 bb-onboarding-labs-tf
# ^-- The above needs to work before moving on
```

## Task #9: Additional cli config verification command:
```bash
## Export the profile we just created
export AWS_PROFILE=bb-onboarding; export AWS_DEFAULT_PROFILE=bb-onboarding
## Ensure we have configuration (your access_key and secret_key may look different)
aws configure list
#      Name                    Value             Type    Location
#      ----                    -----             ----    --------
#   profile            bb-onboarding              env    ['AWS_PROFILE', 'AWS_DEFAULT_PROFILE']
#access_key     ****************XQ5F shared-credentials-file
#secret_key     ****************Jv6c shared-credentials-file
#    region            us-gov-west-1      config-file    ~/.aws/config
```




