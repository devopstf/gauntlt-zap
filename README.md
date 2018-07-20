# Gauntlt with ZAP and Arachni for Docker
Docker containers for security testing based on James Wickett's Gauntlt, and owasp-zap for CI/CD by Stephen Donner

## How it works
The Gauntlt container is purposely made to get started with security testing with Gauntlt.

- Arachni, nikto, dirb, sqlmap, nmap, owasp-zap (zap-cli, and zapr are included) are installed inside the container as a basic set of attacking tools
- Gauntlt is installed and is set as the entrypoint
- You can run `make install-stub` for including `gauntlt-docker`into your path

You can also run your attacks using Arachni or ZAP outside Gauntlt. There are two ad-hoc scripts for doing that you can use and modify:

- ``./zap-docker.sh <target-url>``
- ``./arachni-docker.sh <target-url>``

## Setup

1. Clone this repo
  ```
  git clone https://github.com/devopstf/gauntlt-zap
  ```

2. Build the docker container

  ```
  $ cd /path/to/cloned/repo/gauntlt-docker
  $ make build
  ```

3. Check out what `make` can do for you
  ```
  $ make
  ```

4. Copy binary stub to your $PATH (like `/usr/local/bin`)
  ```
  $ make install-stub
  ```

5. Test it out with a `gauntlt-docker --help`

6. You can get interactive access to the container (with current path bind mounted to ``/working``) to test attack tools installed
  ```
  $ make interactive
  ```

7. You can set your target URL into the config file for Cucumber, located at ``config/cucumber.yml``, using the following script:
```
$ ./set-target.sh <target-url>
```
