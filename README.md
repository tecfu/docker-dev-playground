# docker-dev-playground

## A Docker Image for Development

**SLIM VERSION**

See [https://hub.docker.com/r/tecfu/docker-dev-playground/](https://hub.docker.com/r/tecfu/docker-dev-playground/)


## Installation:

```
git clone https://github.com/tecfu/docker-dev-playground
cd docker-dev-playground
docker build --tag dev-docker .
```


## Run:

- To start in `bash`

*powershell*
```powershell
docker run -it -v ${PWD}:/home dev-docker /bin/bash 
```

*bash*
```sh
docker run -it -v ${pwd}:/home dev-docker /bin/bash 
```


- To start in `zsh`

*powershell*
```powershell
docker run -it -v ${PWD}:/home dev-docker zsh
```

*bash*
```sh
docker run -it -v ${pwd}:/home dev-docker zsh
```


## Includes:

- ctags
- nodejs (via nvm)
- tmux
- vim
- zsh
