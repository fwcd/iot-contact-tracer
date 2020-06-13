# Contiki NG Adapter
A TCP server that accepts connections from Contiki-NG/Coojas serial port interface and mediates between the Contiki-NG client and the actual server.

## System Dependencies
* Python 3

## Setup
* Create a venv: `python3 -m venv venv` (or share one with the `server` module)
* Activate it: `source venv/bin/activate`
* Install the dependencies: `pip3 install -r requirements.txt`

## Running
* Use `python3 -m cng_adapter` to run the development server (inside the venv).
* The server is now listening under `http://localhost:7533`
* Now start `cooja`, create a simulation, setup the motes and for each mote:
    * Connect the adapter in Cooja under `Tools > Serial Socket (CLIENT) > YourNode` with:
        * Host: `localhost`
        * Port: `7533`
