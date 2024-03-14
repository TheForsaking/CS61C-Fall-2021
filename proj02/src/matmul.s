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

    addi sp, sp, -16
    sw s0, 0(sp)  # pointer of a
    sw s1, 4(sp)  # pointer of b
    sw s2, 8(sp)  # pointer of c
    sw s3, 12(sp) # delta of b
    li t0, 0 # row of c
    li t1, 0 # col of c
    li t2, 0

    slli s3, a5, 2
    # Prologue

outer_loop_start:
    bge t0, a1, outer_loop_end

inner_loop_start:
    bge t1, a5, inner_loop_end
    li t2, 0
    li t6, 0
    mul s2, t0, a2
    add s2, s2, t1
    slli s2, s2, 2
    add s2, s2, a6

    mul s0, t0, a2
    slli s0, s0, 2
    add s0, s0, a0

    slli s1, t1, 2
    add s1, s1, a3
ab_loop_start:
    bge t2, a2, ab_loop_end

    lw t3, 0(s0)
    lw t4, 0(s1)
    mul t5, t3, t4
    add t6, t6, t5

    addi t2, t2, 1
    addi s0, s0, 4
    add s1, s1, s3
    j ab_loop_start    
ab_loop_end:
    sw t6, 0(s2)
    addi t1, t1, 1
    j inner_loop_start
inner_loop_end:
    li t1, 0
    addi t0, t0, 1
    j outer_loop_start
outer_loop_end:
    # Epilogue
    

    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 16
    ret

matmul_exit_59:
    li a1, 59
    call exit2