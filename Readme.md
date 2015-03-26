# CSSE Hub Shell Client
This is a simple client for the UW Platteville CSSE Hub in the form of a shell script.

## Instalation
Clone this repository. Open punchin.sh and change the DEFAULT_USERNAME variable to your username if you so desire. Then run:

```
cd CSSEHubShellClient
cp punchin.sh /usr/local/bin/punchin
chmod +rx /usr/local/bin/punchin
```

This will install the shell script in your local usr bin.

Next, open `/usr/local/bin/punchin` in your prefered text editor. Change the default username to your username and the project repo path to the path to your copy of the repo on IO.

Assuming you have `/usr/local/bin` on your `$PATH`, you can now punch in to CSSE hub by running `punchin` from a terminal.

You will be prompted for your username and password. Then you will be punched into CSSE Hub.

### Required Packages
Logging into IO requires [sshpass](http://sourceforge.net/projects/sshpass/) to be install on your machine. 

## Features
Right now, all it can do is punch in to the CSSE Hub. (But only into SE Project II)

## How it works
Bascially, it runs two `curl`s. The first one logs you into CSSE Hub and stores the session cookies in a temp file. The second one punches you in. Right now, it only punches you into `se4730`. I have no plans to change that at the moment.

Note: I have no idea what will happen if you try and run this without being in se4730.
