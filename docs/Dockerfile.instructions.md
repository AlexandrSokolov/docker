
- [Running commands in `Dockerfile` vs. in bash scripts](#running-commands-in-dockerfile-vs-in-bash-scripts)
- [`CMD` vs. `ENTRYPOINT`](#cmd-vs-entrypoint)


### Running commands in `Dockerfile` vs. in bash scripts

The `RUN` instruction is used in Dockerfiles to execute commands that build and configure the Docker image. 
These commands are executed during the image build process, and 
each `RUN` instruction creates a new layer in the Docker image.

When you must run commands in the bash script to handle
- environment variable. For instance, you want to set the timezone based on `TZ` variable, passed to the container.
- permissions on the files, that are passed via `Docker` volumes

### [`CMD` vs. `ENTRYPOINT`](https://www.docker.com/blog/docker-best-practices-choosing-between-run-cmd-and-entrypoint/)

```Dockerfile
COPY /entrypoint /entrypoint.cron
COPY /startup /startup.cron

ENTRYPOINT ["/entrypoint.cron"]
CMD ["/startup.cron"]
```

- `CMD` - Defines the default executable of a Docker image that can be easily overridden by `docker run` arguments.
- `ENTRYPOINT` - Defines the default executable. Overriding the default executable is not desired.
  `ENTRYPOINT` is particularly useful for turning a container into a standalone executable.
  It still can be overridden by the `--entrypoint` `docker run` arguments.

For example, by default, you might want a web server to start:
```Dockerfile
CMD ["apache2ctl", "-DFOREGROUND"]
```
but users could override this to run a shell instead:
```bash
docker run -it <image> /bin/bash
```
For example, suppose you are packaging a custom script that requires arguments (e.g., `my_script extra_args`). 
In that case, you can use `ENTRYPOINT` to always run the script process (`my_script`) and then 
allow the image users to specify the `extra_args` on the `docker run` command line:

```Dockerfile
ENTRYPOINT ["my_script"]
```

#### Combining `CMD` and `ENTRYPOINT`

`CMD` instruction can be used to provide default arguments to `ENTRYPOINT` if it is specified in the exec form. 
This setup allows the entry point to be the main executable and `CMD` to specify additional arguments that 
can be overridden by the user.

For example, you might have a container that runs a Python application where you always want to 
use the same application file but allow users to specify different command-line arguments:

```Dockerfile
ENTRYPOINT ["python", "/app/my_script.py"]
CMD ["--default-arg"]
```

Running `docker run myimage --user-arg` executes `python /app/my_script.py --user-arg`.
