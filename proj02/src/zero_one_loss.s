.globl zero_one_loss

.text

zero_one_loss:

    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)

    slli t0, a2, 2
    add t0, t0, a0 # end of array a
    mv t1, a0
    mv t2, a1
    mv t3, a3

loop_start:
    bge t1, t0, loop_end
    lw s1, 0(t1)
    lw s2, 0(t2)
    li t4, 0
    bne s1, s2, add_end
    addi, t4, t4, 1
add_end:
    sw t4, 0(t3)

    addi, t1, t1, 4
    addi, t2, t2, 4
    addi, t3, t3, 4
    j loop_start
loop_end:

    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi, sp, sp, 12
    ret