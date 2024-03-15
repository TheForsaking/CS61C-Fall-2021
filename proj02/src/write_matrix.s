.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp) # fd
    sw s1, 4(sp) # row
    sw s2, 8(sp) # col
    sw s3, 12(sp) # matrix
    sw s4, 16(sp) # buffer
    sw s5, 20(sp) # row * col * 4
    sw ra, 24(sp)

    mv s1, a2
    mv s2, a3
    mv s3, a1


    mv a1, a0
    li a2, 1
    call fopen
    li t0, -1
    beq t0, a0, error_fopen
    mv s0, a0


    lw s4, 0(s3)
    sw s1, 0(s3)
    mv a1, s0
    mv a2, s3
    li a3, 1
    li a4, 4
    call fwrite
    li a4, 1
    bne a4, a0, error_fwrite
    sw s2, 0(s3)
    mv a1, s0
    mv a2, s3
    li a3, 1
    li a4, 4
    call fwrite
    li a4, 1
    bne a4, a0, error_fwrite
    sw s4, 0(s3)

    mul s5, s1, s2
    slli s5, s5, 2

    li s4, 0
write_loop:
    bge s4, s5, write_end
    mv a1, s0
    add a2, s4, s3
    li a3, 1
    li a4, 4
    call fwrite
    li a4, 1
    bne a4, a0, error_fwrite

    addi s4, s4, 4
    j write_loop
write_end:

    mv a1, s0
    call fclose
    bne a0, x0, error_fclose
    # Epilogue
    lw ra, 24(sp)
    lw s5, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 28
    ret

error_fopen:
    li a1, 89
    call exit2

error_fclose:
    li a1, 90
    call exit2

error_fwrite:
    li a1, 92
    call exit2