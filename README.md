# Offensive GraphQL

Bundle GraphQL security testing tools from “Black Hat GraphQL” in two
Docker images.

Most of the tools are in the main Dockerfile. The commix image is
standalone because it relies on the entire Metasploit Framework, so the
resultant image is massive by comparison (over 2GB). All GUI tools are
not bundled at all, so you will need to use your host OS or another
means to run them.

# Installation

As a prerequisite, you will need Docker installed on your host machine.
You could do this in a VM, but “virtualization within virtualization”
can sometimes lead to unintended behaviors.

You will also need space for each image:

- *Dockerfile* (main collection): ~600MB
- *Dockerfile\_commix* (Commix only): ~2.5GB

Run `build.sh` to build both images:

    ~$ bash build.sh

On Windows, you may also be able to execute this as a batch script.

You can also build each Dockerfile manually if needed. Use each 
install command from the script to get an idea of how each image
should build. 

# Usage

For the tools, launch an interactive shell, then use whatever tool you
want.

    docker run --rm -it offensive-graphql

The Commix image is not mean to be interactive, so use the command:

    docker run --rm offensive-graphql-commix [options from commix manpage]

# Testing

You can test the Damn Vulnerable GraphQL Application by using the setup
steps from the official project: 
[https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application]
(https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application)

From either *offensive-graphql* image, target the GraphQL endpoint at
[http://host.docker.internal:5013].

# Caveats

## Internal Host Name

For local testing, you will need to ping *host.docker.internal* from
within either image. If you can find a way to alias this, you should.
This approach was taken so you didn’t have to run the DVGA container
stack within a Kali VM, but the tradeoff is that you’ll have to type
this long name each time.

For example, within these containers, you can access the DVGA instance
on your host like:

    http://host.docker.internal:5013

To make this a little easier, the tools ship with an *as-is* Python
script that identifies the host IP and sets the hosts file accordingly.
You’ll have to run it as *sudo* and take ownership of any failures. Feel
free to modify it to fit your own needs.

## Monolithic tools image

The bundling approach is fine for my specific use case. You may find it
more meaningful to install or compile your tooling on the host system
directly, or to create a Dockerfile only for a specific subset of tools
that you find most useful. You could also just install them in a Kali VM
if that’s easier for you.

## GUI Tools

You shoud run the GUI tools on your host or on another system. You will
likely see better performance, it will require less Docker
configuration, and it will result in smaller Docker images.

You may find a situation where you need a graphical environment. In such
a case, you can try something like VNC to get a graphical environment.
However, that is out of scope for this project.

## Testing

I haven’t extensively tested the bundled tools within this image. Some
of them may have undefined behavior or may outright break. If so,
consider running those on a Kali VM or on your host, and open an issue
in GitHub here.

# Tool Sources

Basics:

- Altair: [Web
  version](https://help.venmo.com/hc/en-us/articles/210414067-Signing-In-FAQ)
- DVGA: Use host Docker

Install on host:

- cURL: Built in
- Burp Suite: Use installer for your host

Kali apt:

- Commix (note: preloaded on standard Kali systems)
- eyewitness
- nmap (could also use the host)

Pip3:

- Clairvoyance: `pip3 install clairvoyance`
- InQL: `pip3 install inql`

External:

- graphw00f: Install from Github, https://github.com/dolevf/graphwoof
- BatchQL: Install from Github, https://github.com/assetnote/batchql
- graphql-path-enum: Install from Gitlab,
  https://gitlab.com/dee-see/graphql-path-enum
- GraphQL Cop: Install from Github,
  https://github.com/dolevf/graphql-cop
- CrackQL: Install from GitHub, https://github.com/nicholasleks/CrackQL
