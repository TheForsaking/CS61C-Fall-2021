.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================
dot:

    # Prologue
    li t0, 1
    blt a2, t0, dot_exit_57
    blt a3, t0, dot_exit_58
    blt a4, t0, dot_exit_58

    addi sp, sp, -12
    sw s0, 0(sp) # result
    sw s1, 4(sp) # pointer of a
    sw s2, 8(sp) # pointer of b

    li t0, 0
    li s0, 0
    li s1, 0
    li s2, 0
    slli a2, a2, 2
    slli a3, a3, 2
    slli a4, a4, 2
    add s1, a0, x0
    add s2, a1, x0
loop_start:
    bge t0, a2, loop_end
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul t3, t1, t2
    add s0, s0, t3

    add s1, s1, a3
    add s2, s2, a4
    addi t0, t0, 4
    j loop_start
loop_end:
    # Epilogue
    add a0, s0, x0

    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 12

    ret

dot_exit_57:
    li a1, 57
    call exit2
dot_exit_58:
    li a1, 58
    call exit2