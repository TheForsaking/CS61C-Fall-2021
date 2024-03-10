#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    if (!head) return 0;
    node* prev = head, *tail = head;
    while (tail) {
        tail = tail->next;
        if (tail == NULL) break;
        tail = tail->next;
        prev = prev->next;
        if (tail == prev) return 1;
    }
    return 0;
}
