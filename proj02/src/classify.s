.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0, 5
    bne t0, a0, error_wrong_args

    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp) # argc
    sw s1, 8(sp) # argv
    sw s2, 12(sp) # res
    sw s3, 16(sp) # (m0 * input)
    sw s4, 20(sp) # m1 * ReLu(m0 * input)
    sw s5, 24(sp) # print
    sw s6, 28(sp) # buffer
    sw s7, 32(sp) # m0
    sw s8, 36(sp) # m1
    sw s9, 40(sp) # input
    sw s10, 44(sp)

    mv s0, a0
    mv s1, a1
    mv s5, a2

	# =====================================
    # LOAD MATRICES
    # =====================================
    li a0, 24
    call malloc
    beq a0, x0, error_malloc
    mv s6, a0
    mv a0, s6
    li a1, 2

    # Load pretrained m0
    lw a0, 4(s1)
    mv a1, s6
    addi a2, s6, 4
    call read_matrix
    mv s7, a0

    # Load pretrained m1
    lw a0, 8(s1)
    addi a1, s6, 8
    addi a2, s6, 12
    call read_matrix
    lw t1, 0(s6)
    lw t0, 12(s6)
    mv s8, a0

    # Load input matrix
    lw a0, 12(s1)
    addi a1, s6, 16
    addi a2, s6, 20
    call read_matrix
    lw t0, 16(s6)
    lw t1, 4(s6)
    mv s9, a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    lw t0, 0(s6)
    lw t1, 20(s6)
    mul, a0, t0, t1
    slli a0, a0, 2
    call malloc
    beq a0, x0, error_malloc
    mv s3, a0

    mv a0, s7
    lw a1, 0(s6)
    lw a2, 4(s6)
    mv a3, s9
    lw a4, 16(s6)
    lw a5, 20(s6)
    mv a6, s3
    call matmul
    lw a0, 0(s6)
    lw a1, 20(s6)
    mul a1, a0, a1
    mv a0, s3
    call relu

    lw t0, 8(s6)
    lw t1, 20(s6)
    mul a0, t0, t1
    slli a0, a0, 2
    call malloc
    beq a0, x0, error_malloc
    mv s4, a0

    mv a0, s8
    lw a1, 8(s6)
    lw a2, 12(s6)
    mv a3, s3
    lw a4, 0(s6)
    lw a5, 20(s6)
    mv a6, s4
    call matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 16(s1)
    mv a1, s4
    lw a2, 8(s6)
    lw a3, 20(s6)
    call write_matrix



    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    mv a0, s4
    lw t0, 8(s6)
    lw t1, 20(s6)
    mul a1, t0, t1
    call argmax
    mv s2, a0

    bne x0, s5, print_end
    # Print classification
    mv a1, s2
    call print_int

    # Print newline afterwards for clarity
    li a1, 10
    call print_char

    mv a0, s3
    call free
    mv a0, s4
    call free
    mv a0, s6
    call free
    mv a0, s7
    call free
    mv a0, s8
    call free
    mv a0, s9
    call free

print_end:

test_end:
    li a0, 0
    lw s10, 44(sp)
    lw s9, 40(sp)
    lw s8, 36(sp)
    lw s7, 32(sp)
    lw s6, 28(sp)
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 48
    ret


error_wrong_args:
    li a1, 72
    call exit2

error_malloc:
    li a1, 88
    call exit2




print_array:
    addi, sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    mv s0, a0
    slli s1, a1, 2
    add s1, s1, s0

print_array_loop:
    bge s0, s1, print_array_end
    lw a1, 0(s0)
    call print_int
    li a1, 10
    call print_char
    addi s0, s0, 4
    j print_array_loop
print_array_end:  

    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi, sp, sp, 12
    ret