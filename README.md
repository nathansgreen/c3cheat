# Cookie Clicker City Cheater

Grab a copy and self-host cookie clicker city. Change stuff. Cheat. Win.

### example

The JSON path `/project/6/2/1/3/3` will land you at the `REFUND` section.
One very, very easy thing to do is to change the multiplier from the
default of 25% (`0.25`) to a positive number.

### requirements

You need to be an administrator on your computer or otherwise have the
ability to change DNS results seen by your computer. Do the setup steps
before changing any DNS configuration because 

You'll need OpenSSL to generate the certificates for hosting.

Nginx is used to run the web server.

Run `create-all.sh` to set up the web server and download all the files.

#### hosting

The simplest thing is to run `sudo e/etc/hosts` and insert the following:

```
127.0.0.1 cookieclickercity.com
::1       cookieclickercity.com
```

Once your computer is getting the correct IP address for the domain,
the `run-nginx.sh` script will start up the web server and host the game.

#### browser setup

https://stackoverflow.com/a/60516812

`https://github.com/FiloSottile/mkcert`

`chrome://flags/#allow-insecure-localhost`
