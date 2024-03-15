.globl read_matrix
.globl test_print

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================

test_print:
    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, a0
    call print_str
    call print_str
    call print_str

    lw ra, 0(sp)
    addi, sp, sp, 4
    ret

read_matrix:
    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp) # fd
    sw s1, 4(sp) # row
    sw s2, 8(sp) # col
    sw s3, 12(sp)
    sw s4, 16(sp) # row * col * 4
    sw s5, 20(sp) # res
    sw s6, 24(sp) # number of reads(bytes)
    sw ra, 28(sp)

    mv s1, a1
    mv s2, a2
    mv a1, a0
    li a2, 0
    call fopen
    li t0, -1
    beq a0, t0, error_fopen
    mv s0, a0

    # read row and col
    mv a1, s0
    mv a2, s1
    li a3, 4
    call fread
    li a3, 4
    bne a0, a3, error_fread
    lw s1, 0(s1)
    mv a1, s0
    mv a2, s2
    li a3, 4
    call fread
    li a3, 4
    bne a0, a3, error_fread
    lw s2, 0(s2)

    mul s4, s1, s2
    slli s4, s4, 2

    mv a0, s4
    call malloc
    beq a0, x0, error_malloc
    mv s5, a0

    li s6, 0
read_loop:
    bge s6, s4, read_end
    add a2, s5, s6
    mv a1, s0
    li a3, 4
    call fread
    li a3, 4
    bne a0, a3, error_fread

    addi, s6, s6, 4
    j read_loop
read_end:

    mv a1, s0
    call fclose
    li t0, -1
    beq t0, a0, error_fclose

    # Epilogue
    mv a0, s5
    lw ra, 28(sp)
    lw s6, 24(sp)
    lw s5, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 32
    ret

error_malloc:
    li a1, 88
    call exit2

error_fopen:
    li a1, 89
    call exit2

error_fclose:
    li a1, 90
    call exit2

error_fread:
    li a1, 91
    call exit2