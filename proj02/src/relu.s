.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# ==============================================================================
relu:
    # Prologue
    addi, sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)

    addi, a1, a1, -1
    blt a1, x0, relu_exit
    beq x0, a0, relu_exit
    addi, a1, a1, 1

    li s1, 0
    slli a1, a1, 2
loop_start:
    bge s1, a1, loop_end
    add t0, a0, s1
    lw s2, 0(t0)
    bge s2, x0, loop_continue
    sw x0, 0(t0)

loop_continue:
    addi, s1, s1, 4
    j loop_start

loop_end:


    # Epilogue
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi, sp, sp, 12
	ret

relu_exit:
    li a1, 57
    call exit2