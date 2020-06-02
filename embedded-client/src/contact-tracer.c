#include <contiki.h>
#include <dev/leds.h>
#include <net/ipv6/ip64-addr.h>
#include <net/app-layer/http-socket/http-socket.h>
#include <sys/node-id.h>
#include <sys/log.h>

#define LOG_MODULE "Contact tracer"
#define LOG_LEVEL LOG_LEVEL_INFO

// Based on https://github.com/contiki-ng/contiki-ng/blob/develop/examples/websocket/http-example.c

void http_callback(struct http_socket *socket, void *ptr, http_socket_event_t event, const uint8_t *data, uint16_t length) {
    switch (event) {
    case HTTP_SOCKET_ERR:
        LOG_ERR("HTTP socket error.\n");
        break;
    case HTTP_SOCKET_TIMEDOUT:
        LOG_ERR("HTTP socket timed out.\n");
        break;
    case HTTP_SOCKET_ABORTED:
        LOG_ERR("HTTP socket aborted.\n");
        break;
    case HTTP_SOCKET_HOSTNAME_NOT_FOUND:
        LOG_ERR("HTTP socket hostname not found.\n");
        break;
    case HTTP_SOCKET_CLOSED:
        LOG_ERR("HTTP socket closed.\n");
        break;
    case HTTP_SOCKET_DATA:
        LOG_INFO("HTTP socket received %d bytes: ", length);
        uint16_t i;
        if (LOG_INFO_ENABLED) {
            for (i = 0; i < length; i++) {
                LOG_OUTPUT("%c", data[i]);
            }
            LOG_OUTPUT("\n");
        }
        break;
    default:
        LOG_WARN("Unrecognized HTTP socket event.\n");
        break;
    }
}

PROCESS(contact_tracer_process, "Contact tracer process");
AUTOSTART_PROCESSES(&contact_tracer_process);

PROCESS_THREAD(contact_tracer_process, env, data) {
    static struct http_socket socket;
    static struct etimer timer;
    static uip_ip4addr_t dns_ipv4_addr;
    static uip_ip6addr_t dns_ipv6_addr;

    PROCESS_BEGIN();

    // Setup DNS server addresses (Google Public DNS)
    uip_ipaddr(&dns_ipv4_addr, 8, 8, 8, 8);
    ip64_addr_4to6(&dns_ipv4_addr, &dns_ipv6_addr);

    etimer_set(&timer, CLOCK_SECOND * 20);
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&timer));

    // Perform GET request to locally running web server
    http_socket_init(&socket);
    http_socket_get(&socket, "http://localhost:5000", 0, 0, http_callback, NULL);

    PROCESS_END();
}
