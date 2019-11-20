#ifndef SSARAULT_LIST_H
#define SSARAULT_LIST_H

#include <stdint.h>

// this LinkedList only adds nodes to the front of the list

typedef struct LinkedList {
    struct LinkedList *prev;
    struct LinkedList *next;
    int32_t value;
} LinkedList;

LinkedList *LinkedList_push(LinkedList **head, int32_t value);
LinkedList *LinkedList_remove(LinkedList **head, LinkedList *node);
void LinkedList_delete(LinkedList *head);
LinkedList *LinkedList_last(LinkedList *head);

#define LinkedList_pop(HEAD) LinkedList_remove((HEAD), *(HEAD))

#define LinkedList_forEach(HEAD) \
    for(LinkedList *node = (HEAD); node != NULL; node = node->next)

#define LinkedList_forEachReverse(LAST) \
    for (LinkedList *node = (LAST); node != NULL; node = node->prev)

#define LinkedList_forEachAutoReverse(HEAD) LinkedList_forEachReverse(LinkedList_last(HEAD))

#define LinkedList_new() (NULL)

#endif