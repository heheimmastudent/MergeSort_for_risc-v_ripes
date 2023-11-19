.data
arr: .word 5, 2, 4, 7, 5, 3, 8, 2, 9, 5, 1, 6, 3, 7, 4, 1, 6, 8, 9
n: .word 18

.text
.globl main
main:
    la a0, arr                # Load the address of 'arr' into a0
    lw a1, n                  # Load the value of 'n' into a1
    li a2, 0x05000000         # Load 0x05000000 into a2
    li a3, 0x02500000         # Load 0x02500000 into a3
    jal x1, mergesort         # Jump and link to mergesort function
loop: j loop                  # Infinite loop

mergesort:
    addi sp, sp, -28          # Allocate space on the stack
    sw x1, 24(sp)             # Store return address in stack
    sw a0, 20(sp)             # Store arguments and registers on the stack
    sw a1, 16(sp)
    sw a2, 12(sp)
    sw a3, 4(sp)
    addi t0, x0, 2            # Initialize t0 with 2 for comparison
    blt a1, t0, else_return   # Compare 'n' in a1 with t0 and branch to 'else_return'
    
    add t1, x0, a1            # t1 = a1 = n
    srli t1, t1, 1            # t1 = t1 / 2 (calculate mid)
    sw t1, 8(sp)              # Store mid on the stack
    sub t2, a1, t1            # t2 = a1 - t1 (calculate n - mid)
    sw t2, 0(sp)              # Store n - mid on the stack
    slli t1, t1, 2            # Shift left by 2 (multiply by 4 for byte indexing)
    slli t2, t2, 2            # Shift left by 2 (multiply by 4 for byte indexing)
    sub a2, a2, t1            # Allocate space for left[mid]
    sub a3, a3, t2            # Allocate space for right[n - mid]
    sw a2, 12(sp)             # Store left address on the stack
    sw a3, 4(sp)              # Store right address on the stack
    lw a0, 12(sp)             # Load 'left' into a0 as an argument for the copy
    lw a1, 20(sp)             # Load 'arr' into a1 for copy
    add a2, x0, x0            # Set 'start' value / for 'left', start = 0
    lw a3, 8(sp)              # Set 'end' value / for 'left', end = mid
    jal x1, copy              # Call the copy function for 'left'
    
    lw a0, 4(sp)              # Load 'right' into a0 as an argument for copy
    lw a1, 20(sp)             # Load 'arr' into a1 for copy
    lw a2, 8(sp)              # Set 'start' value / for 'right', start = mid
    lw a3, 16(sp)            # Set 'end' value / for 'right', end = n
    jal x1, copy              # Call the copy function for 'right'
    
    lw a0, 12(sp)             # Restore and pass 'left' into mergesort from the stack
    lw a1, 8(sp)              # Pass 'mid'
    lw a2, 12(sp)             # 'left'
    lw a3, 4(sp)              # 'right'
    jal x1, mergesort         # Recursive call to mergesort for 'left'
    
    lw a0, 4(sp)              # Restore and pass 'right' into mergesort from the stack
    lw a1, 0(sp)              # Pass 'n - mid'
    lw a2, 12(sp)             # 'left'
    lw a3, 4(sp)              # 'right'
    jal x1, mergesort         # Recursive call to mergesort for 'right'
    
    lw a0, 20(sp)             # Restore arguments
    lw a1, 12(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    lw a4, 0(sp)
    jal x1, merge             # Call the merge function
    
    lw x1, 24(sp)             # Restore the return address
    addi sp, sp, 28           # Restore the stack
    jalr x0, x1, 0            # Return to the caller
    j loop

else_return:
    lw x1, 24(sp)             # Restore the return address from the stack
    addi sp, sp, 28           # Restore the stack
    jalr x0, x1, 0            # Return

copy:
    add t0, x0, a2            # Load start index into t0
    add t1, x0, a3            # Load end index into t1
    addi t2, x0, 0            # Initialize j = 0
    slli t0, t0, 2            # Multiply start index by 4
    slli t1, t1, 2            # Multiply end index by 4
    slli t2, t2, 2            # Initialize j index by 4
copy_loop:
    beq t0, t1, copy_done     # Check if i == end
    add t4, a1, t0            # Calculate source address (b[i])
    add t5, a0, t2            # Calculate destination address (a[j])
    lw t6, 0(t4)              # Load value from the source (b[i])
    sw t6, 0(t5)              # Store value to the destination (a[j])
    addi t0, t0, 4            # Increment i
    addi t2, t2, 4            # Increment j
    j copy_loop

copy_done:
    jalr x0, x1, 0            # Return

merge:
    add t0, x0, a3            # Load 'leftSize' into t0
    add t1, x0, a4            # Load 'rightSize' into t1
    add t2, a1, x0            # Initialize i = 0 at 'left'
    add t3, a2, x0            # Initialize j = 0 at 'right'
    add t4, a0, x0            # Initialize k = 0 at 'arr'
    slli t0, t0, 2            # Multiply leftSize by 4 (word size)
    slli t1, t1, 2            # Multiply rightSize by 4 (word size)
    add t0, a1, t0            # Calculate the address of 'left' array
    add t1, a2, t1            # Calculate the address of 'right' array
merge_loop:
    beq t2, t0, merge_left_done   # Check if i == leftSize
    beq t3, t1, merge_right_done  # Check if j == rightSize
    lw t5, 0(t2)               # Load left[i] into t5
    lw t6, 0(t3)               # Load right[j] into t6
    blt t5, t6, merge_copy_left  # If left[i] < right[j], copy left[i]
    j merge_copy_right
merge_copy_left:
    lw t5, 0(t2)               # Load left[i] into t5
    sw t5, 0(t4)               # Copy left[i] to arr[k]
    addi t2, t2, 4             # Increment i
    addi t4, t4, 4             # Increment k
    j merge_loop

merge_copy_right:
    lw t6, 0(t3)               # Load right[j] into t6
    sw t6, 0(t4)               # Copy right[j] to arr[k]
    addi t3, t3, 4             # Increment j
    addi t4, t4, 4             # Increment k
    j merge_loop

merge_left_done:
    beq t3, t1, merge_done     # Check if j == rightSize
merge_copy_right_remaining:
    lw t5, 0(t3)               # Load the remaining elements from 'right'
    sw t5, 0(t4)               # Copy to arr[k]
    addi t3, t3, 4             # Increment j
    addi t4, t4, 4             # Increment k
    j merge_left_done

merge_right_done:
    beq t2, t0, merge_done     # Check if i == leftSize
merge_copy_left_remaining:
    lw t6, 0(t2)               # Load the remaining elements from 'left'
    sw t6, 0(t4)               # Copy to arr[k]
    addi t2, t2, 4             # Increment i
    addi t4, t4, 4             # Increment k
    j merge_right_done

merge_done:
    jalr x0, x1, 0            # Return
