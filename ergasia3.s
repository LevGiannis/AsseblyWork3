# Ioannis Levakos 3220107
# name2
# name3

.data
pinA: .space 40    # Space for 10 integers (each integer requires 4 bytes)
pinB: .space 40
lenA: .word 0
lenB: .word 0
lenC: .word 0
SparseA: .space 80  # Size 20 * 4 bytes/number
SparseB: .space 80
SparseC: .space 80

prompt: .asciiz "\nPosition "
prompt_colon: .asciiz ": "
in_prompt: .asciiz "\n-----------------------------\n1. Read Array A\n2. Read Array B\n3. Create Sparse Array A\n4. Create Sparse Array B\n5. Create Sparse Array C = A + B\n6. Display Sparse Array A\n7. Display Sparse Array B\n8. Display Sparse Array C\n0. Exit\n-----------------------------\nChoice?"
print_read_arrayA: .asciiz "\nReading Array A"
print_read_arrayB: .asciiz "\nReading Array B"
print_create_sparseA: .asciiz "\nCreating Sparse Array A\n"
print_create_sparseB: .asciiz "\nCreating Sparse Array B\n"
print_create_sparseC: .asciiz "\nCreating Sparse Array C  = A + B\n"
print_display_sparseA: .asciiz "\nDisplaying Sparse Array A\n"
print_display_sparseB: .asciiz "\nDisplaying Sparse Array B\n"
print_display_sparseC: .asciiz "\nDisplaying Sparse Array C\n"
values: .asciiz " values\n"
value: .asciiz "  Value : "
newline: .asciiz "\n"

.text
.globl main

main:
    read_option:
        li $v0, 4         # Print prompt
        la $a0, in_prompt
        syscall

        li $v0, 5         # Read user choice
        syscall
        move $t2, $v0     # $t2 = choice

        # Call subroutines with the same parameters and results
        beq $t2, 0, exit_program
        beq $t2, 1, read_arrayA
        beq $t2, 2, read_arrayB
        beq $t2, 3, create_sparseA
        beq $t2, 4, create_sparseB
        beq $t2, 5, create_sparseC
        beq $t2, 6, display_sparseA
        beq $t2, 7, display_sparseB
        beq $t2, 8, display_sparseC
      
        j read_option
    
    exit_program:
    li $v0, 10        # Exit program
    syscall

    read_arrayA:
        li $v0, 4         # Print 
        la $a0, print_read_arrayA
        syscall

        la $a1, pinA
        jal read_pin
        j read_option

    read_arrayB:
        li $v0, 4         # Print 
        la $a0, print_read_arrayB
        syscall

        la $a1, pinB
        jal read_pin
        j read_option

    read_pin:
        # Read 10 integers from the user and store them in the array
        li $t0, 0          # Initialize counter
        
        read_pin_loop:
            # Display message
            li $v0, 4
            la $a0, prompt
            syscall

            li $v0, 1       # syscall: print_int
            move $a0, $t0    # load integer from register $t0 to $a0
            syscall

            # Print " :"
            li $v0, 4          
            la $a0, prompt_colon
            syscall

            # Read integer from the user
            li $v0, 5
            syscall
            sw $v0, 0($a1)    # Store the integer in the array
            addi $t0, $t0, 1   # Increment counter
            addi $a1, $a1, 4   # Move pointer to the next integer

            # Check for end of input
            bne $t0, 10, read_pin_loop

            jr $ra
            
    
    create_sparseA:
        li $v0, 4         # Print 
        la $a0, print_create_sparseA
        syscall

        la $a1, pinA
        la $a2, SparseA
        jal create_sparse

        move $t1, $v0   # lengthA
        sw $t1, lenA
        li $t2, 2
        div $t1, $t2

        li $v0, 1
        move $a0, $t1
        syscall

        li $v0, 4          
        la $a0, values
        syscall

        j read_option
                

    create_sparseB:
        li $v0, 4         # Print 
        la $a0, print_create_sparseB
        syscall

        la $a1, pinB
        la $a2, SparseB
        jal create_sparse

        move $t1, $v0   # lengthB
        sw $t1, lenB
        li $t2, 2
        div $t1, $t2

        li $v0, 1
        move $a0, $t1
        syscall

        li $v0, 4          
        la $a0, values
        syscall

        j read_option
    
    create_sparse:
        li $t0, 0          
        li $t1, 0          

        create_sparse_loop:
            beq $t1, 10, create_sparse_exit

            lw $t2, ($a1)     # Read from the array
            beq $t2, 0, create_sparse_next

            sw $t1, ($a2)     # Store position in Sparse
            addi $a2, $a2, 4  # Increment Sparse pointer

            sw $t2, ($a2)     # Store value in Sparse
            addi $a2, $a2, 4  # Increment Sparse pointer

            addi $t0, $t0, 1  # Increment counter
            create_sparse_next:

            addi $a1, $a1, 4  # Increment array pointer
            addi $t1, $t1, 1  # Increment i
            j create_sparse_loop

        create_sparse_exit:
            move $v0, $t0   # Return length of Sparse Array
            jr $ra

    display_sparseA:
        li $v0, 4         # Print 
        la $a0, print_display_sparseA
        syscall

        la $a1, SparseA
        
        lw $a2, lenA
        
        jal print_sparse
        j read_option

    display_sparseB:
        li $v0, 4         # Print 
        la $a0, print_display_sparseB
        syscall

        la $a1, SparseB
        
        lw $a2, lenB
        
        jal print_sparse
        j read_option

    display_sparseC:
        li $v0, 4         # Print 
        la $a0, print_display_sparseC
        syscall

        la $a1, SparseC
        
        lw $a2, lenC
        
        jal print_sparse
        j read_option
    
    print_sparse:
        li $t0, 0          # i
        print_sparse_loop:
            bge $t0, $a2, print_sparse_exit

            lw $t2, 0($a1)     # Read position from Sparse
           
            li $v0, 4         # Print new line
            la $a0, prompt
            syscall

            li $v0, 4         # Print separator (:)
            la $a0, prompt_colon
            syscall

            li $v0, 1         # Print position
            move $a0, $t2
            syscall

            li $v0, 4         # Print new line
            la $a0, value
            syscall

            addi $a1, $a1, 4  # Increment Sparse pointer
            lw $t3, 0($a1)    # Read value from Sparse

            li $v0, 1         # Print value
            move $a0, $t3
            syscall

            li $v0, 4         # Print new line
            la $a0, newline
            syscall

            addi $a1, $a1, 4  # Increment Sparse pointer
            addi $t0, $t0, 1  # Increment i
            j print_sparse_loop

        print_sparse_exit:
            jr $ra

    create_sparseC:
        li $v0, 4         # Print 
        la $a0, print_create_sparseC
        syscall

        la $a1, SparseA
        la $a2, SparseB
        la $a3, SparseC
        lw $t1, lenA
        lw $t2, lenB

        jal add_sparse
        move $t1, $v0   # lengthC

        sw $t1, lenC
        li $t2, 2
        div $t1, $t2

        li $v0, 1
        move $a0, $t1
        syscall

        li $v0, 4          
        la $a0, values
        syscall

        j read_option

    add_sparse:
        li $t3, 0 # a
        li $t4, 0 # b
        li $t5, 0 # c
        
        add_sparse_loop:
            lw $t6, ($a1)     # Read position from SparseA
            lw $t7, 4($a1)    # Read value from SparseA

            lw $t8, ($a2)     # Read position from SparseB
            lw $t9, 4($a2)    # Read value from SparseB

            bge $t3, $t1, add_sparse_exit_by_a
            bge $t4, $t2, add_sparse_exit_by_b

            bne $t6, $t8, add_sparse_a_not_equal_b

            sw $t6, ($a3)     # Store position in SparseC
            addi $a3, $a3, 4  # Increment SparseC pointer

            add $t7, $t7, $t9  # Sum values
            sw $t7, ($a3)     # Store value in SparseC

            addi $a3, $a3, 4  # Increment SparseC pointer
            addi $t5, $t5, 1
            addi $a1, $a1, 8  # Increment SparseA pointer
            addi $t3, $t3, 1
            addi $a2, $a2, 8  # Increment SparseB pointer
            addi $t4, $t4, 1
            j add_sparse_loop

        add_sparse_a_not_equal_b:
            blt $t6, $t8, add_sparse_a_less_than_b
            sw $t8, ($a3)     # Store position in SparseC
            addi $a3, $a3, 4  # Increment SparseC pointer

            sw $t9, ($a3)     # Store value in SparseC

            addi $a3, $a3, 4  # Increment SparseC pointer
            addi $a2, $a2, 8  # Increment SparseB pointer

            addi $t5, $t5, 1
            addi $t4, $t4, 1  
            j add_sparse_loop

        add_sparse_a_less_than_b:
            sw $t6, ($a3)     # Store position in SparseC
            addi $a3, $a3, 4  # Increment SparseC pointer
            
            sw $t7, ($a3)     # Store value in SparseC

            addi $a3, $a3, 4  # Increment SparseC pointer
            addi $a1, $a1, 8  # Increment SparseA pointer

            addi $t5, $t5, 1
            addi $t3, $t3, 1
            j add_sparse_loop

        add_sparse_exit_by_a:
            bge $t4, $t2, add_sparse_exit

            sw $t8, ($a3)     # Store position in SparseC
            addi $a3, $a3, 4  # Increment SparseC pointer

            sw $t9, ($a3)     # Store value in SparseC

            addi $a3, $a3, 4  # Increment SparseC pointer
            addi $a2, $a2, 8  # Increment SparseB pointer

            addi $t5, $t5, 1
            addi $t4, $t4, 1  
            j add_sparse_loop

        add_sparse_exit_by_b:
            bge $t3, $t1, add_sparse_exit

            j add_sparse_a_less_than_b

        add_sparse_exit:
            move $v0, $t5   # Return length of SparseC
            jr $ra
