.globl main

.data
source:
    .word   3
    .word   1
    .word   4
    .word   1
    .word   5
    .word   9
    .word   0
dest:
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0

.text
# fun:                   # a0 = (a0 + 1) * (-a0);
fun:
    addi t0, a0, 1
    sub t1, x0, a0
    mul a0, t0, t1
    jr ra

main:
    # BEGIN PROLOGUE
    addi sp, sp, -20   # sp -= 20;
    sw s0, 0(sp)       # *sp = s0
    sw s1, 4(sp)       # *(sp + 1) = s1
    sw s2, 8(sp)       # *(sp + 2) = s2
    sw s3, 12(sp)      # *(sp + 3) = s3
    sw ra, 16(sp)      # *(sp + 4) = ra
    # END PROLOGUE
    addi t0, x0, 0     # t0 = 0
    addi s0, x0, 0     # s0 = 0
    la s1, source      # s1 = source
    la s2, dest        # s2 = dest
loop:
    slli s3, t0, 2     # s3 = t0 << 2;
    add t1, s1, s3     # t1 = s1 + s3
    lw t2, 0(t1)       # t2 = *t1
    beq t2, x0, exit   # if (!t2) break;
    add a0, x0, t2     # a0 = t2
    addi sp, sp, -8    # sp -= 8
    sw t0, 0(sp)       # *sp = t0
    sw t2, 4(sp)       # *(sp + 1) = t2
    jal fun            # a0 = (a0 + 1) * (-a0)
    lw t0, 0(sp)       # t0 = *sp
    lw t2, 4(sp)       # t2 = *(sp + 1)
    addi sp, sp, 8     # sp += 8;
    add t2, x0, a0     # t2 = a0
    add t3, s2, s3     # t3 = s2 + s3
    sw t2, 0(t3)       # *t3 = t2
    add s0, s0, t2     # s0 += t2
    addi t0, t0, 1     # t0++
    jal x0, loop       
exit:
    add a0, x0, s0
    # BEGIN EPILOGUE
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    # END EPILOGUE
    jr ra

# t0 = 0;
# s0 = 0;
# s1 = source;
# s2 = dest;
# while (true) {
#     s3 = t0 * 4;
#     t1 = source + t0 * 4;
#     t2 = source[t0];
#     if (!t2) break;
#     a0 = (t2 + 1) * (-t2);
#     t2 = a0;
#     t3 = dest + t0 * 4;
#     s0 += a0;
#     dest[t0] = a0;
#     *t3 = t2;
#     s0 += a0;
#     t0++;
# }
# a0 = s0;