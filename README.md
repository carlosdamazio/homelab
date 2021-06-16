# homelab
This is my personal lab that has all the required tools to work with anything that I can.

## How to use it
Use make and its targets defined in Makefile to build the environment.

1. ``make mysql`` - Deploys a MySQL server into your k8s setup at nodeport 30006.
2. ``make mysql-clean`` - Removes deployment.

