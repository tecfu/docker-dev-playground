# docker-dev-playground

## An Image for developing from within Docker

Quite handy if you're required to use a Windows machine at your job.

** FULL VERSION **

For *slim* version that contains Vim and Nodejs, please checkout *slim* branch.

See [https://hub.docker.com/r/tecfu/docker-dev-playground/](https://hub.docker.com/r/tecfu/docker-dev-playground/)


## Installation:

```
git clone https://github.com/tecfu/docker-dev-playground
cd docker-dev-playground
docker build --tag dev-full .
```


## Run:

- To start in `bash`

*powershell*
```powershell
docker run -it -v ${PWD}:/home dev-full /bin/bash
```

*bash*
```sh
docker run -it -v ${pwd}:/home dev-full /bin/bash
```


- To start in `zsh`

*powershell*
```powershell
docker run -it -v ${PWD}:/home dev-full zsh
```

*bash*
```sh
docker run -it -v ${pwd}:/home dev-full zsh
```


## Tools Included:

- bash
- ctags
- tensorflow
- tmux
- vim
- zsh


## Languages Included:

### C# [via mono]

```
$ csharp
```

### DotNet

```
$ dotnet
```

### Java [via Java 9]

```
$ jshell
```

### Julia

```
$ julia
```

### Nodejs

```
$ node
```

### Python 2.7

``` 
$ python
```

### R

```
$ R
```
