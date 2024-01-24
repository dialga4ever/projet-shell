
# Projet shell faire un gestionnaire de version

Le but de ce projet est de réaliser un utilitaire de gestion de versions appelé
version.sh. Comme son nom l’indique, version.sh implémenté en langage
shell.


## Authors

- [@dialga4ever](https://github.com/dialga4ever)

- [@Antoine2525](https://github.com/Antoine2525)
## Usage/Examples

```shell

Usage:
    ./version.sh --help
    ./version.sh <command> FILE [OPTION]
    where <command> can be: add amend checkout|co commit|ci diff log reset rm
    
./version.sh add FILE MESSAGE
    Add FILE under versioning with the initial log message MESSAGE
    
./version.sh commit|ci FILE MESSAGE  
    Commit a new version of FILE with the log message MESSAGE
    
./version.sh amend FILE MESSAGE
    Modify the last registered version of FILE, or (inclusive) its log message
    
./version.sh checkout|co FILE [NUMBER]
    Restore FILE in the version NUMBER indicated, or in the
    latest version if there is no number passed in argument
    
./version.sh diff FILE   
    Displays the difference between FILE and the last committed version

./version.sh log FILE    
    Displays the logs of the versions already committed

./version.sh reset FILE NUMBER
    Restores FILE in the version NUMBER indicated and
    deletes the versions of number strictly superior to NUMBER
    
./version.sh rm FILE
    Deletes all versions of a file under versioning
```


## Tech Stack

**Client:** Debian Almquist shell 



## Info

[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)


