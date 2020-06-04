# docker_icub_tf
This repository containes the dockerfiles for the images stored in Docker hub (guidoski)

# Usage

SSH from your machine to the remote host enabling X11 forwarding

```
ssh -X <user>@<IP-remote-host>
```

then run the script start_server, passing the IP address of the client machine (your pc).
For instance, if client and remote host are in a local network:

```
sh scripts/run_icub_sim.sh 192.168.1.229
````

If client is a MacOS, run before ssh the following command:

```
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```
