.globl abs_loss

.text

abs_loss:

    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)

    slli t0, a2, 2
    add t0, t0, a0 # end of array a
    mv t1, a0
    mv t2, a1
    mv t3, a3
    li a0, 0

loop_start:
    bge t1, t0, loop_end
    lw s1, 0(t1)
    lw s2, 0(t2)
    sub s1, s1, s2
    bge s1, x0, abs_end
    sub s1, x0, s1
abs_end:
    sw s1, 0(t3)
    add a0, a0, s1

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