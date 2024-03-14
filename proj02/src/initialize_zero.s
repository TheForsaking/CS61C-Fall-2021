.globl initialize_zero

.text

initialize_zero:
    li t1, 1
    blt a0, t1, exit_123

    addi sp, sp, -4
    sw ra, 0(sp)

    mv t1, a0

    addi sp, sp, -4
    sw t1, 0(sp)
    jal malloc
    lw t1, 0(sp)
    addi sp, sp, 4
    li a1, -1
    beq a0, a1, exit_122

    add t0, a0, x0
    slli t2, t1, 2
    add t2, t2, t0
loop_start:
    bge t0, t2, loop_end
    sw x0, 0(t0)
    addi t0, t0, 4
    j loop_start
loop_end:

    lw ra, 0(sp)
    addi, sp, sp, 4
    ret

malloc:
    mv a1, a0
    li a0, 0x3CC
    ecall
    ret

exit_122:
    li a1, 122
    call exit2

exit_123:
    li a1, 123
    call exit2