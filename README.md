# IoT Contact Tracer
A decentralized contact tracing system, inspired by [DP-3T](https://github.com/DP-3T/documents) and Apple/Google's [Exposure Notification](https://en.wikipedia.org/wiki/Exposure_Notification), featuring:

* `server`: A server storing exposed identifiers
* `cng-client`: An embedded client based on the [Contiki-NG](https://github.com/contiki-ng/contiki-ng) os
* `cng-adapter`: An adapter that mediates between the embedded client and the server
* `mobile-client`: A mobile client for Android/iOS, using Flutter

![Simulation](cooja-simulation.png)
> Cooja Simulation of the Contiki-NG client nodes
