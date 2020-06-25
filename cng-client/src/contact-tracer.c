#include <random.h>
#include <contiki.h>
#include <string.h>
#include <clock.h>
#include <dev/leds.h>
#include <dev/serial-line.h>
#include <net/nullnet/nullnet.h>
#include <net/netstack.h>
#include <sys/node-id.h>
#include <sys/log.h>

#define LOG_MODULE "Contact tracer"
#define LOG_LEVEL LOG_LEVEL_INFO

// A "chance of infection" in percent that is checked each REBROADCAST_TIME.
// Note that this only applies if the node has encountered other nodes.
#define EXPOSURE_CHANCE 50

// The interval of seconds at which new identifiers are generated
#define EXPIRATION_TIME (40 * 60)

// The interval of seconds at which identifiers are broadcasted
#define REBROADCAST_TIME 10

// The number of seconds for which an identifier is stored
#define INCUBATION_TIME (14 * 24 * 3600)

// The number of stored identifiers for a single person.
// Ideally this should be equivalent to:
// #define STORED_IDENTIFIER_COUNT ((INCUBATION_TIME) / (EXPIRATION_TIME))
#define STORED_IDENTIFIER_COUNT 504

// The identifier size in bytes (must be even)
#define IDENTIFIER_SIZE 2

// == Common ==

#define ARRAY_SIZE(XS) (sizeof(XS) / sizeof(XS[0]))

/** A rolling identifier to identify a person. */
struct rolling_identifier {
    uint16_t value[IDENTIFIER_SIZE / 2];
};

/** A better RNG. */
uint16_t random_number(void) {
    return random_rand() ^ (node_id * 100) ^ clock_time();
}

/** Generates a new identifier (pseudo-)randomly. */
struct rolling_identifier rolling_identifier_generate(void) {
    struct rolling_identifier ident;
    uint8_t i;
    for (i = 0; i < ARRAY_SIZE(ident.value); i++) {
        ident.value[i] = random_number() ^ (i * 1000);
    }
    return ident;
}

uint8_t rolling_identifier_equals(struct rolling_identifier lhs, struct rolling_identifier rhs) {
    uint8_t i;
    for (i = 0; i < ARRAY_SIZE(lhs.value); i++) {
        if (lhs.value[i] != rhs.value[i]) {
            return 0;
        }
    }
    return 1;
}

/** A cyclic buffer holding the full history of a person. */
struct identifier_store {
    struct rolling_identifier identifiers[STORED_IDENTIFIER_COUNT];
    uint16_t last_in;
    uint16_t next_in;
    uint16_t next_out;
    uint16_t size;
};

void identifier_store_init(struct identifier_store *self) {
    self->last_in = -1;
    self->next_in = 0;
    self->next_out = 0;
    self->size = 0;
}

void identifier_store_insert(struct identifier_store *self, struct rolling_identifier identifier) {
    uint16_t capacity = ARRAY_SIZE(self->identifiers);

    self->identifiers[self->next_in] = identifier;
    self->last_in = (self->last_in + 1) % capacity;
    self->next_in = (self->next_in + 1) % capacity;

    if (self->size < capacity) {
        self->size++;
    } else {
        self->next_out = (self->next_out + 1) % capacity;
    }
}

uint8_t identifier_store_contains(struct identifier_store *self, struct rolling_identifier identifier) {
    uint8_t i;
    for (i = 0; i < self->next_in; i++) {
        if (rolling_identifier_equals(self->identifiers[i], identifier)) {
            return 1;
        }
    }
    return 0;
}

/** Generates a new identifier and pushes it into the current store. */
void identifier_store_roll(struct identifier_store *self) {
    identifier_store_insert(self, rolling_identifier_generate());
}

/** A structure holding the full history of own and other identifiers. */
struct known_identifiers {
    struct identifier_store own;
    struct identifier_store others;
};

void known_identifiers_init(struct known_identifiers *self) {
    identifier_store_init(&self->own);
    identifier_store_init(&self->others);
}

struct rolling_identifier known_identifiers_current(struct known_identifiers *self) {
    if (self->own.size == 0) {
        LOG_ERR("Cannot fetch current identifier without one being present, things will fail from here on.\n");
    }
    return self->own.identifiers[self->own.last_in];
}

void request(const char *req, struct identifier_store *store) {
    LOG_INFO("[REQUEST %s ", req);

    uint16_t i;
    uint16_t j;
    for (i = 0; i < store->size; i++) {
        struct rolling_identifier ident = store->identifiers[store->next_out + i];
        for (j = 0; j < ARRAY_SIZE(ident.value); j++) {
            LOG_OUTPUT("%x", ident.value[j]);
        }
        LOG_OUTPUT(" ");
    }

    LOG_OUTPUT("]\n");
}

void report_exposure(struct known_identifiers *known) {
    request("reportExposure", &known->own);
}

void check_health(struct known_identifiers *known) {
    request("checkHealth", &known->others);
}

// == Globals ==

static struct known_identifiers known;
static uint8_t is_exposed = 0;

void set_exposed(void) {
    if (!is_exposed) {
        LOG_WARN("Exposed to COVID-19 after having generated %d identifiers!\n", known.own.size);
        is_exposed = 1;
        leds_set(LEDS_RED);
        report_exposure(&known);
    }
}

// == Networking ==

void broadcast(struct rolling_identifier identifier) {
    nullnet_len = sizeof(identifier);
    nullnet_buf = (uint8_t *) &identifier;
    NETSTACK_NETWORK.output(NULL);
}

void receive(const void *data, uint16_t len, const linkaddr_t *src, const linkaddr_t *dest) {
    if (len == sizeof(struct rolling_identifier)) {
        // Make sure that the structure is aligned properly
        struct rolling_identifier ident;
        memcpy(&ident, data, sizeof(struct rolling_identifier));

        if (!identifier_store_contains(&known.others, ident)) {
            identifier_store_insert(&known.others, ident);
            LOG_INFO("Stored %d identifiers from others.\n", known.others.size);
        }
    } else {
        LOG_WARN("Got packet of unrecognized size %d (instead of the expected size %d)\n", len, sizeof(struct rolling_identifier));
    }
}

// == Main ==

PROCESS(contact_tracer_process, "Contact tracer process");
AUTOSTART_PROCESSES(&contact_tracer_process);

PROCESS_THREAD(contact_tracer_process, ev, data) {
    static struct etimer timer;
    static uint16_t elapsed = EXPIRATION_TIME;

    PROCESS_BEGIN();

    known_identifiers_init(&known);
    nullnet_set_input_callback(receive);
    etimer_set(&timer, REBROADCAST_TIME * CLOCK_SECOND);

    if (node_id == 1) {
        identifier_store_roll(&known.own);
        set_exposed();
    }

    while (true) {
        if (!is_exposed) {
            if (elapsed >= EXPIRATION_TIME) {
                LOG_INFO("Rolling the current identifier...\n");
                identifier_store_roll(&known.own);
                elapsed = 0;
            }

            check_health(&known);
        }

        LOG_DBG("Broadcasting identifier...\n");
        broadcast(known_identifiers_current(&known));

        PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&timer));
        etimer_reset(&timer);
        elapsed += REBROADCAST_TIME;

        // Handle health check response
        if (ev == serial_line_event_message) {
            const char *response = (char *) data;
            LOG_INFO("Got '%%'\n", response);
            switch (response[0]) {
            case 'E':
                LOG_DBG("Exposed!\n");
                set_exposed();
                break;
            case 'H':
                LOG_DBG("Healthy!\n");
                break;
            default:
                LOG_WARN("Unrecognized response %s!\n", response);
                break;
            }
        }
    }

    PROCESS_END();
}
