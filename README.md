# DevCon


## Known Probelems
- Currently the `docker` command doesnt work withouth `sudo` inside the container
  - This is due to the fact that the `docker` socket is mounted into the Container
    - Workaround: set `alias docker="sudo docker"` in your `.zshrc


## What is devcon?
### TLDR;
- My most critical tools in a docker container that i can run anywhere

### The long story
I need to have my workstation or my most crucial Tools operational and didnt want to run into problems because some update on my laptop screwed something up.
So the basic concept of `devcon` comes from the `devcontainer` Project (hence the name) but on a more permanent basis.

I wanted to always be able to have a working environment that is consistent and reproducible.
I also work in an environment that is highly controlled so im not able to freely install software on my workstation.

But what i have is a `git` client and a `docker` client.
I have this container running on my workstation and if i cant access my usual worksation i have this container running on my most important `docker` hosts.
So even if i dont have access to my workstation all i need is to be able to ssh into one of my `docker` hosts.

## How to use it?

### General Notice
- I would recommend that you fork this repo, set i to private and use it as a base for your own image.
- You can then from time to time sync your fork with this repo to get updates.
  - Beware of Merge Conflicts!


<a id="First-time-setup"></a>
### First time setup
- Fork this Repo
- Clone your new repo
- Copy the `example.env` to `.env`
- Copy the `example.docker-compose.yml` to `docker-compose.yml`
- Edit the `.env` file to your needs (especially important the username and password)
  - The `.gitignore` is configured to ignore `.env` files
- Edit the `Dockerfile` to your needs
  - It is based on the latest ubuntu LTS Image
    - Why ubuntu? 
      - Because the package availablity is big
      - LTS Release is important for stability (for me)
- Build the image via the `build-image.sh` script
- Edit the `docker-compose.yml` to your needs
- In my workflow i bind every folder under the `/workspace/` directory
  - Makes it easier for me to not spread out my work
- Run `docker-compose up -d` to start the container
- Run `docker exec -it _container-name-from-your-compose-file_ zsh` to get a shell into the container
  - The container is configured to run `zsh` as the default shell and always restarts
- Install your tools you want and live in the user directory

### Setting the Container as your default environment
If you want to setup your Terminal Application to always use the container add the `docker-exec` command shown above as your Start command 

### On Image update

- Update the `.env` with the new Name:Tag you want
- Generate new image via `build-image.sh` Script, or pull the image from a registry
- Stop the container
- Run `docker-compose up -d` to start the container

#### Optional
- Backup your home directory volume

## Important Notes

### About the home directory
I have chosen to use a `docker volume` as the home directory of the user.
The reason is that many antivirus scanner dont like to have dumped thousands of tiny files into a directory.
I tried it in the beginning and the perfomance impact on my laptop was huge.
So i chose the `docker volume` approach. Given the fact that multiple Container can use the same volume this is a good approach for me.
That also means however that you have to install software that resides in the user directory manually once.
An example would be [`LazyVim`](https://www.lazyvim.org/) or my `.ssh` config.

### About the username and password
If you choose to use the `.env` file for your username and password declaration like i described above (in the [First-time-setup](#First-time-setup) ) you should be aware that you dont want to push that image to a public registry.
If you want your image to be public then you should set the ENV VAR `USER_PASSWORD` to something generic and later add the following to your `docker-compose.yml` in the `command:` section:
```yaml
command: "passwd $USER_NAME your-personal-password-here"
```


## Links

### Mentioned in this File
#### NeoVim Distro
- https://www.lazyvim.org/
