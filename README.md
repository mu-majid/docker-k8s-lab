# Overview: 

  * Complete guide to Docker and kubernestes, with CI+CD Workflows,  AWS Deployment, and  Kubernetes in Production.

## Brief Introduction:

  **Local Tools**
  - Docker CLI is a piece of software that we always interact with from our terminal.
  - Docker Server(Daemon) is another software that the CLI passes commands we write to, and this server tries to find for example an image to run a container from it, if the image is not found locally, it then request it from the connected registries.
  - Docker Hub is remote registry that has images (public/private).

## What is a container?

  * A container is just a combination between two linux features called `Namespacing` and `Control Groups (cgroups)`
  * The following images describe what is a container in detail:

  - The below image describes hoe processes on our computer interact with hardware, basically, it invokes a `system-call` that is received by the kernel, which in turn `exec` that call and deal with the hardware through their installed drivers.

  ![process-os](./pics/process-os.png)

  - The next scenario is imaginary, such that, chrome depend on `python v2` and node.js depend on `python v3`, **but** we only have `v2` installed, and cannot install `v3`. So, only chrome will be able to run on our PC.

  ![depend-issue](./pics/depend-issue.png)

  - A solution to that problem is to segment/isolate parts of our hard drive and install each version of `python` on a different segment, and allow our kernel to decide which segment to use depending on the calling/invoking process.

  ![sol2](./pics/sol2.png)

  - This segmentation and deciding based on the invoking process is actually a feature in `linux` that is called `name-spacing`, and it also used along side `cgroups` to limit resources used by isolated processes.

  ![defn-ns-cg](./pics/defn-ns-cg.png)

  - So, a container is basically an isolated process that has governed access to our system/pc resources
  
  ![container](./pics/container.png)

  ![container2](./pics/container2.png)

  - And to create a running container, we need what is called an image, which is a file system snapshot and a startup command. So when we issue `docker run` command, what happens in nutshell, is that the snapshot get copied from the image to isolated (namespaced) portion of our hard drive, and allocate some limited resources like RAM, Network ..., then run the startup command to spawn a process that is only allowed to access that isolated segment of our hard drive.

  ![image-container](./pics/image-container.png)

## Container Life cycle:

  - The first step is to `create` a container. This essentially means, copy the FS snapshot from the image and paste it to our isolated segment on our hard drive.
  - Then the created container is `started`, by running the `startup command`.
  - If the container process stopped/exited, the container then becomes a stopped container (could be started again but the startup command cannot be changed from the the first time we ran the container.)

## Important Commands: 

  - `docker run <image-name>`: used to create and run a Container from an Image.
    1. override default command/startup: `docker run <image-name> **command**`, ex: `docker run <image-name> bash`.

  - `docker ps`: list all running containers on the PC.
    1. `docker ps --all`: list all containers whether running ot shut down.

  - `docker system prune`: used to delete stopped containers among other things, like build cache (images pulled from remote registry), dangling images, and networks used by docker.

  - `docker logs <container_id>`: used to get logs that have been emitted from a container.

  - `docker stop <container_id>`: stop the running docker container by sending `SIGTERM` signal, that allows the process to shut down gracefully.
  
  - `docker kill <container_id>`: kill the running docker container by sending `SEGKILL` signal, that **does not** allow the process to shut down gracefully.

  - `docker exec -it <cont_id> <cmd>`: run another command (cmd) inside an already running container. the `it` flag means: `i` means attaching our terminal to the container so the container's process running the command `cmd` stdin/stdout/stderr channel is attached to our terminal. `t` means formatting the text typed or output to screen.

  - `docker build -t <image-tag> <build-context>`: used to build a reusable image from a docker file, the build context is essentially where the files used to build an image is located (normally the Dockerfile)


## what is a base Image?

  - it is the initial setup for the container to run in, more like an operating system on a computer, it gives basic file system and some commands to help us further configure the container.

  **Image building process**: 

  1. Download the base image (fs-snapshot + empty startup command).
  2. take the previous image (base img in the first RUN command in this case) snapshot and copy it to an intermediate container, then run the command associated with the `RUN` statement, make changes to the running container filesystem.
  3. After command completes running, stop the container, take a snapshot of the container's current updated filesystem, and save this image.
  4. Repeat steps 2 & 3 for all file system changing commands.
  5. the final `CMD` command, just copy whatever startup command to the previous image startup command and produce the final image.

  **Note**: when building an image docker server checks its building cache before going through the process of creating temp containers and creating intermediate images from them. And also the order of operations is what determines if the image will be found in the cache or not, because we are building layers above layers, and taking a snapshot after each layer.


