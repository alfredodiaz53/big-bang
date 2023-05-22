# VI Basics

## Lab 3 Task #1: Get familiar with vi (Terminal Text Editor)

### bruh, vi sucks why are you torturing me with cruel and unusual punishment?

* We want you to have basic familiarity with vi
* Some tools in the Kubernetes/Linux Ecosystem default to vi or only support vi  
  `Mozilla SOPS` is one example
* There's a gotcha when copying and pasting into vi that's worth knowing

### vi basics

#### Create/Edit a file

The cli section will have you use vi to create a ~/.aws/config file, copy and paste the following data into that file    
`vi ~/.aws/config`
```txt
[bb-onboarding]
region = us-gov-west-1
s3 =
    max_concurrent_requests = 40
    max_queue_size = 10000
    multipart_threshold = 8MB
    multipart_chunksize = 8MB
```
> Make sure that you are not currently the root user, run this commands as your normal user.

```bash
mkdir -p ~/.aws
vi ~/.aws/config
```
>  If the file `~/.aws/config` doesn't exist, this will start a session to create the file.
>  If the file `~/.aws/config` does exist, this will start a session to edit the file.

#### Save and exit vi

```shell
[Inside of vi cli text editor]
 Press: escape
 Type:   :wq!   #w means write, q means quit, ! means don't prompt for unsaved changes
 Press: enter
```

#### Exit vi without saving

```shell
[Inside of vi cli text editor]
 Press: escape
 Type:   :q!
 Press: enter
```

#### Switch to insert mode

```shell
[Inside of vi cli text editor]
 Press: escape
 Press: i
```
> Think of insert mode as normal text editing mode, arrow keys, backspace, enter, delete, work as expected.  
>  Note: escape will take you out of insert mode  

#### Delete an entire line

```shell
[Inside of vi cli text editor]
 Press: escape   #If you were in insert mode this will take you out of it, if not extra escapes don't hurt
 Use the up down arrow keys to navigate to the line you want to delete
 Press: dd     #This will delete the line
```

#### A Nuance Around Copy Pasting into Vi

> You've stored a block of text from `../Manually_Created_Prereqs/Example_Laptop_Config.txt` into your clipboard  
> You open vi and go to paste the text  
> Sometimes the first ~6 characters of what you paste will be cut off during the paste operation  
> 
> What's happening is if `vi` isn't in `insert mode`, and you start typing, it will assume you want to be in `insert mode` and automatically switch; however the first ~6 characters of the paste were eaten up by vi thinking you wanted to switch to insert mode.
> 
> This won't always happen, some implementations detect the paste fine and will never eat the first ~6 characters, but because they will be eaten in some cases, it's best practice building a habit of always doing the following when pasting in vi:
> Press: `escape`
> Press: `i`
> Press: `control+v`
> Press: `:wq` to save and quit
> then from the command line run
```bash
 head <filename>
 ```
> to check that the first few characters didn't get chopped off the top of the file.

## (Not a task/extra info for the curious) You can add alias's to bash

[Example_Laptop_Config.txt](../../Manually_Created_Prereqs/Example_Laptop_Config.txt)
`Example_Laptop_Config.txt` covers what you can add to your `~/.bashrc` file to create some useful alias's
It also shows you the syntax you'd use to support multiple AWS Profiles
This is a completely optional step. Ubuntu users would add it to the end of the file.
In the case of Mac users the file is usually fairly empty.
Note: the bash function and alias won't work until you close and reopen the terminal, type `source .`, or type `bash` to start a new session)

## Next Lab

[AWS Access](D-aws-access.md)
