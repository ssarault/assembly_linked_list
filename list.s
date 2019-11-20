    .section .text

# struct LinkedList {
#   LinkedList *prev; // offset 0
#   LinkedList *next; // offset 8
#   int32 value;      // offset 16
#   char padding[4]; // not used
# };
# // sizeof(struct LinkedList) is 24 bytes

    .globl LinkedList_delete
    .type LinkedList_delete, @function
    .globl LinkedList_push
    .type LinkedList_push, @function
    .globl LinkedList_remove
    .type LinkedList_remove, @function
    .globl LinkedList_last
    .type LinkedList_last, @function

LinkedList_push:
# LinkedList *LinkedList_push(LinkedList **head, int value)
# NOTE: adds node to front of list!
    pushq %rbp
    movq %rsp, %rbp
    pushq %rsi # value -8
    pushq %rdi # head -16

    movq $24, %rdi # sizeof(LinkedList)
    call malloc@PLT # rax will hold new_head
    cmpq $0, %rax
    je .exit # malloc failed, return NULL

    movq $0, (%rax) # new_head->prev = NULL
    movq -16(%rbp), %rdi # rdi = LinkedList **head
    movq (%rdi), %rdi # rdi holds old head node, LinkedList *head
    movq %rdi, 8(%rax) # new_head->next = old head node
    movl -8(%rbp), %esi # value now in esi
    movq $2, %rcx
    movl %esi, (%rax, %rcx, 8) # new_head->value = esi
    movq -16(%rbp), %rdx # rdx = head (the arg)
    cmpq $0, %rdi # if (old_head_node == NULL)
    je .exit
    movq %rax, (%rdi) # old_head_node->prev = new_head

.exit:
    movq %rax, (%rdx) # *head = rax
    movq %rbp, %rsp
    popq %rbp
    ret

LinkedList_remove:
# LinkedList *LinkedList_remove(LinkedList **head, LinkedList *node)
# removes node from list
    cmpq (%rdi), %rsi # if (*head == node)
    jne .remove_non_head_node

    cmpq $0, 8(%rsi) # if (node->next == NULL) // node is head and only node
    jne .remove_and_change_head
    movq $0, (%rdi) # *head = NULL, list is now empty
    jmp .exit1

.remove_and_change_head:
    movq 8(%rsi), %rdx # rdx = node->next, node is head
    movq $0, (%rdx) # rdx->prev = NULL
    movq %rdx, (%rdi) # *head = head->next
    jmp .exit1

.remove_non_head_node:
    movq (%rsi), %rdx # rdx = node->prev
    movq 8(%rsi), %rcx # rcx = node->next
    movq %rcx, 8(%rdx) # rdx->next = rcx
    cmpq $0, %rcx # if (rcx == NULL)
    je .exit1
    movq %rdx, (%rcx) # rcx->prev = rdx

.exit1:
    movq %rsi, %rax # return removed node
    ret

LinkedList_delete:
# void LinkedList_delete(LinkedList *head)
    cmpq $0, %rdi # if(head == NULL)
    jne .begin
    ret

.begin:
    pushq %rbx

.loop:
    movq 8(%rdi), %rbx # move node->next to rbx
    call free@PLT
    cmpq $0, %rbx # if node->next is null then return
    je .exit2
    movq %rbx, %rdi
    jmp .loop

.exit2:
    popq %rbx
    ret

LinkedList_last:
# LinkedList *LinkedList_last(LinkedList *head)
# returns last node in list, returns NULL if head is null
    movq %rdi, %rax
    cmpq $0, %rax
    je .exit3 # head was NULL

.loop1:
    cmpq $0, 8(%rax) # if node->next is NULL return node
    je .exit3
    movq 8(%rax), %rax # node = node->next
    jmp .loop1

.exit3:
    ret
