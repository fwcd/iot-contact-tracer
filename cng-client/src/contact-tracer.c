#include <random.h>
#include <contiki.h>
#include <dev/leds.h>
#include <sys/node-id.h>
#include <sys/log.h>

#define LOG_MODULE "Contact tracer"
#define LOG_LEVEL LOG_LEVEL_INFO

// The interval of seconds at which new identifiers are generated
#define EXPIRATION_TIME (5 * 60)

// The interval of seconds at which identifiers are broadcasted
#define REBROADCAST_TIME 10

// The number of seconds for which an identifier is stored
#define INCUBATION_TIME (14 * 24 * 3600)

// The number of stored identifiers for a single person
#define STORED_IDENTIFIER_COUNT ((INCUBATION_TIME) / (EXPIRATION_TIME))

// The (theoretical) number of other persons for which a full history could be maintained
#define PERSON_COUNT 2

// == Common ==

#define ARRAY_SIZE(XS) (sizeof(XS) / sizeof(XS[0]))

/** A rolling identifier to identify a per. */
struct rolling_identifier {
    uint16_t value[4];
};

/** Generates a new identifier (pseudo-)randomly. */
struct rolling_identifier rolling_identifier_generate(void) {
    struct rolling_identifier ident;
    uint8_t i;
    for (i = 0; i < ARRAY_SIZE(ident.value); i++) {
        ident.value[i] = random_rand();
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
    uint16_t next_in;
    uint16_t next_out;
    uint16_t size;
};

void identifier_store_init(struct identifier_store *self) {
    self->next_in = 0;
    self->next_out = 0;
    self->size = 0;
}

void identifier_store_insert(struct identifier_store *self, struct rolling_identifier identifier) {
    uint16_t capacity = ARRAY_SIZE(self->identifiers);

    self->identifiers[self->next_in] = identifier;
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
    struct identifier_store others[PERSON_COUNT];
};

void known_identifiers_init(struct known_identifiers *self) {
    identifier_store_init(&self->own);
    identifier_store_init(&self->others);
}

struct rolling_identifier known_identifiers_current(struct known_identifiers *self) {
    if (self->own.size == 0) {
        LOG_ERR("Cannot fetch current identifier without one being present, things will fail from here on.\n");
    }
    return self->own.identifiers[self->own.next_out];
}

// == Main ==

PROCESS(contact_tracer_process, "Contact tracer process");
AUTOSTART_PROCESSES(&contact_tracer_process);

PROCESS_THREAD(contact_tracer_process, env, data) {
    static struct etimer timer;
    static uint16_t elapsed = 0;
    static struct known_identifiers known;

    PROCESS_BEGIN();

    known_identifiers_init(&known);
    etimer_set(&timer, REBROADCAST_TIME * CLOCK_SECOND);

    while (true) {
        PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&timer));
        elapsed += REBROADCAST_TIME;

        if (elapsed >= EXPIRATION_TIME) {
            identifier_store_roll(&known.own);
            elapsed = 0;
        }

        // TODO
    }

    PROCESS_END();
}
