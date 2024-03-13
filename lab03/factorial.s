.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE

    addi sp, sp, -4
    sw s1, 0(sp)

    add s1, x0, a0
    li a0, 1
loop:
    beq s1, x0, exit  
    mul a0, a0, s1
    addi s1, s1, -1

    j loop

exit:
    lw s1, 0(sp)
    addi, sp, sp, 4
    jr ra