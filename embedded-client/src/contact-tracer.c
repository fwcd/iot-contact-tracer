#include <contiki.h>
#include <dev/leds.h>
#include <net/linkaddr.h>
#include <net/netstack.h>
#include <net/nullnet/nullnet.h>
#include <sys/node-id.h>
#include <sys/log.h>

#define LOG_MODULE "Contact tracer"
#define LOG_LEVEL LOG_LEVEL_INFO

PROCESS(contact_tracer_process, "Contact tracer process");
AUTOSTART_PROCESSES(&contact_tracer_process);

PROCESS_THREAD(contact_tracer_process, env, data) {
    PROCESS_BEGIN();

    // TODO: Do stuff
    LOG_INFO("Hello World!\n");

    PROCESS_END();
}
