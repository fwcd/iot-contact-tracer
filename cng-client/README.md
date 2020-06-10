# Embedded Client
A contact tracing client running on IoT hardware and is based on the Contiki-NG os.

## Setup
To setup the local development environment, first make sure that you have checked out all submodules:

`git submodule update --init --recursive`

Then you will need Docker. Detailed instructions can be found here:

https://github.com/contiki-ng/contiki-ng/wiki/Docker

Specifically, you will have to pull the Docker image for `contiki-ng`:

`docker pull contiker/contiki-ng`

After you make sure that Docker is running, you can run (depending on whether you run Linux/macOS or Windows) one of the `contiker` scripts in this repo to launch a shell in a new Contiki container.

## Running Cooja
To launch Cooja (the GUI networking simulator), you can run:

`./contiker cooja`

Or - alternatively - inside the container:

`cooja`

> Note that you need to start an X server (such as `Vcxsrv`) prior to this if you are running Docker on Windows

## Building and Running the Project in Cooja
First, open Cooja as described above. Then create a new simulation (in the `File` menu) and add a new `Cooja` mote, where the `*.c` source file from the project is configured as your `Contiki process/Firmware`. Now add as many motes as you like and start the simulation.