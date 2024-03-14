.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:

    # Prologue
    li t1, 1
    blt a1, t1, exit_57

    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    
    mv t0, a0
    mv t3, a0
    slli t1, a1, 2
    add t1, t1, a0
    lw s1, 0(a0)
    addi t0, t0, 4
loop_start:
    bge t0, t1, loop_end
    lw s0, 0(t0)
    blt s1, s0, update
    j loop_continue
update:
    mv a0, t0
    lw s1, 0(a0)
loop_continue:
    addi, t0, t0, 4
    j loop_start
loop_end:
    sub a0, a0, t3
    srai a0, a0, 2

    # Epilogue
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 12


    ret

exit_57:
    li a1, 57
    call exit2