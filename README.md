# Gauntlt with ZAP and Arachni for Docker
This repo is intended for hosting a handful of scripts for security testing based on [James Wickett's security testing class](https://github.com/wickett/security-testing-class), and [dockerized owasp-zap for CI/CD by Stephen Donner](https://github.com/stephendonner/docker-zap)

## How it works
The [Gauntlt](https://github.com/gauntlt/gauntlt) container is purposely made to get started with security testing with Gauntlt.

- [Arachni](https://github.com/Arachni/arachni), nikto, dirb, sqlmap, nmap, [owasp-zap](https://github.com/zaproxy/zaproxy) ([zap-cli](https://github.com/Grunny/zap-cli), and [zapr](https://github.com/garethr/zapr) are included) are installed inside the container as a basic set of attacking tools
- Gauntlt is installed and is set as the entrypoint
- You can run `make path` for including `gauntlt-docker`and other scripts into your path
- Gauntlt is based on [Aruba extension](https://github.com/cucumber/aruba) for [Cucumber framework](https://github.com/cucumber/cucumber-ruby); hence yo can define your attacks using [Gherkin syntax](https://docs.cucumber.io/gherkin/reference/) for your scenarios (i.e. using Given, When, Then, clauses)
- You can find sample attacks from James Wicketts's classes included into the ``attacks`` folder.

You can also run your attacks using Arachni or ZAP outside Gauntlt.

There are two ad-hoc scripts for doing that you can use and modify:

- ``zap-docker <target-url>``
- ``arachni-docker <target-url>``

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

3. Copy binary stub to your $PATH (like `/usr/local/bin`)

  ```
  $ make path
  ```

4. Test it out,

  ```
  $ gauntlt-docker --help
  ```

5. Set your target URL into the config file for Cucumber, located at ``config/cucumber.yml``, using the following command:

  ```
  $ gauntlt-target <target-url>
  ```

6. Launch your attack,

  ```
  gauntl-docker path/to/your/file.attack
  ```

You can get interactive access to the container (with current path bind mounted to ``/working``) to individually test attack tools installed

  ```
  $ make interactive
  ```


## Test Application

You can use [Gruyere](https://google-gruyere.appspot.com/part1), the cheese web application from _Google Code Labs_ for testing purposes: you can either set it up online, or using [a docker image](https://hub.docker.com/r/karthequian/gruyere/) through the makefile provided:
  
  ```
  $ cd /path/to/cloned/repo/gauntlt-docker
  $ make get-gruyere
  $ make gruyere-start
  ```

Once you're done, you can simply kill the application instance issuing this command:

  ```
  $ make gruyere-kill
  ```
