.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:

    # Error checks
    bne a2, a4, matmul_exit_59
    li t0, 1
    blt a1, t0, matmul_exit_59
    blt a2, t0, matmul_exit_59
    blt a5, t0, matmul_exit_59

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)  # pointer of a
    sw s1, 4(sp)  # pointer of b
    sw s2, 8(sp)  # pointer of c
    sw s3, 12(sp) # delta of b
    sw s4, 16(sp) # height
    sw s5, 20(sp) # width of a / height of b
    sw s6, 24(sp) # width
    sw s7, 28(sp) #

    mv s0, a0
    mv s1, a3
    mv s2, a6
    mv s4, a1
    mv s5, a2
    mv s6, a5
    mv s3, s6
    slli s3, s3, 2

    li t0, 0 # x
outer_loop_start:
    bge t0, s4, outer_loop_end
    li t1, 0 # y
inner_loop_start:
    bge t1, s6, inner_loop_end

    li t3, 0
    mv t4, t0
    mul t4, t4, s5
    slli t4, t4, 2
    add t4, t4, s0

    mv t5, t1
    slli t5, t5, 2
    add t5, t5, s1

    li t6, 0
    li a4, 0

 ab_loop_start:
    bge t6, s5, ab_loop_end

    lw a1, 0(t4)
    lw a2, 0(t5)
    mul a3, a1, a2
    add a4, a4, a3

    addi t4, t4, 4
    add t5, t5, s3
    addi t6, t6, 1
    j ab_loop_start
ab_loop_end:
    sw a4, 0(s2)
    addi t1, t1, 1
    addi s2, s2, 4
    j inner_loop_start

inner_loop_end:
    addi t0, t0, 1
    j outer_loop_start
outer_loop_end:


    # Epilogue
    lw s6, 24(sp)
    lw s5, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 28
    ret



matmul_exit_59:
    li a1, 59
    call exit2