#include <contiki.h>
#include <dev/leds.h>
#include <sys/node-id.h>
#include <sys/log.h>

#define LOG_MODULE "Contact tracer"
#define LOG_LEVEL LOG_LEVEL_INFO

// == Common ==

// == Main ==

PROCESS(contact_tracer_process, "Contact tracer process");
AUTOSTART_PROCESSES(&contact_tracer_process);

PROCESS_THREAD(contact_tracer_process, env, data) {
    // static struct etimer timer;

    PROCESS_BEGIN();

    LOG_INFO("Test test 123\n");

    PROCESS_END();
}
