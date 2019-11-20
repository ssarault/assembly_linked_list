#include <stdio.h>
#include <stdlib.h>
#include "list.h"

int main(int argc, char **argv)
{
    printf("size of LinkedList is: %zu bytes\n", sizeof(LinkedList));

    LinkedList *list = LinkedList_new();

    for (int i = 0; i < 10; i++)
        LinkedList_push(&list, i);
    
    LinkedList_forEach(list) {
        node->value += 10;
        printf("%d\n", node->value);
    }
    putchar('\n');

    LinkedList_forEachAutoReverse(list)
        printf("%d\n", node->value);
    putchar('\n');

    LinkedList *popped = LinkedList_pop(&list);
    free(popped);

    LinkedList_forEach(list)
        printf("%d\n", node->value);

    LinkedList_delete(list);
    puts("done!");
    return 0;
}