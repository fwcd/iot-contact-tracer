# Server
The server storing the reported identifiers.

## System Dependencies
* Python 3 + `venv`

## Setup
* Create a venv: `python3 -m venv venv`
* Activate it: `source venv/bin/activate`
* Install the dependencies: `pip3 install -r requirements.txt`

Alternatively just run `pipenv install` to set up the venv and install
the required packages.

## Running
* Use `flask run` to run the development server (inside the venv).
* The server is now listening under `http://localhost:5000`
