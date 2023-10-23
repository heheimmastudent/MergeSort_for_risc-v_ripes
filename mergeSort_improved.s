.data
arr: .word 8, 6, 7, -5, -1, 3, 2, -4, -12, 14, -15, 16, -9, 11, 10, -13
n: .word 16

.text
.globl main
main:
    la a0, arr                  # Load the address of 'arr' into a0
    lw a1, n                    # Load the value of 'n' into a1
    jal x1, mergesort           # Jump and link to mergesort function
loop: j loop                    # Infinite loop

mergesort:
    add t0, x0, sp
    addi sp, sp, -32            # Allocate space on the stack
    sw s0, 0(sp)               # Store the previous frame pointer (s0)
    add s0, x0, t0             # Set the frame pointer to the current stack pointer
    sw x1, -4(s0)              # Store return address on the stack
    sw a0, -8(s0)              # Store arguments and registers on the stack
    sw a1, -12(s0)            
    addi t0, x0, 2              # Initialize t0 with 2 for comparison
    blt a1, t0, else_return     # Compare 'n' in a1 with t0 and branch to 'else_return'
    
    add t1, x0, a1              # t1 = a1 = n
    srli t1, t1, 1              # t1 = t1 / 2 (calculate mid)
    sw t1, -20(s0)              # Store mid on the stack
    sub t2, a1, t1              # t2 = a1 - t1 (calculate n - mid)
    sw t2, -28(s0)              # Store n - mid on the stack
    slli t1, t1, 2              # Shift left by 2 (multiply by 4 for byte indexing)
    slli t2, t2, 2              # Shift left by 2 (multiply by 4 for byte indexing)
    sub sp, sp, t1              # Allocate space for left[mid]
    sw sp, -16(s0)              # Store the address of Left onto the stack
    sub sp, sp, t2              # Allocate space for right[n - mid]
    sw sp, -24(s0)              # Store the address of Right onto the stack
    
    lw a0, -16(s0)              # Load 'left' into a0 as an argument for the copy
    lw a1, -8(s0)               # Load 'arr' into a1 for copy
    add a2, x0, x0              # Set 'start' value / for 'left', start = 0
    lw a3, -20(s0)              # Set 'end' value / for 'left', end = mid
    jal x1, copy                # Call the copy function for 'left'
    
    lw a0, -24(s0)              # Load 'right' into a0 as an argument for copy
    lw a1, -8(s0)               # Load 'arr' into a1 for copy
    lw a2, -20(s0)              # Set 'start' value / for 'right', start = mid
    lw a3, -12(s0)              # Set 'end' value / for 'right', end = n
    jal x1, copy                # Call the copy function for 'right'
    
    lw a0, -16(s0)              # Restore and pass 'left' into mergesort from the stack
    lw a1, -20(s0)              # Pass 'mid'
    jal x1, mergesort           # Recursive call to mergesort for 'left'
    
    lw a0, -24(s0)              # Restore and pass 'right' into mergesort from the stack
    lw a1, -28(s0)              # Pass 'n - mid'
    jal x1, mergesort           # Recursive call to mergesort for 'right'
    
    lw a0, -8(s0)               # Restore arguments
    lw a1, -16(s0)
    lw a2, -24(s0)
    lw a3, -20(s0)
    lw a4, -28(s0)
    jal x1, merge               # Call the merge function
    
    lw x1, -4(s0)               # Restore the return address
    lw t0, -12(s0)
    lw s0, -32(s0)
    slli t0, t0, 2
    add sp, sp, t0
    addi sp, sp, 32             # Restore the stack
    jalr x0, x1, 0              # Return to the caller
    j loop

else_return:
    lw x1, -4(s0)               # Restore the return address
    lw s0, -32(s0)
    addi sp, sp, 32
    jalr x0, x1, 0              # Return

copy:
    slli a2, a2, 2              # Multiply start index by 4 (word size)
    slli a3, a3, 2              # Multiply end index by 4 (word size)
    add t0, a1, a2              # Load start index into t0
    add t1, a1, a3              # Load end index into t1
    add t2, a0, x0              # Initialize j = 0
copy_loop:
    beq t0, t1, copy_done       # Check if i == end
    lw t6, 0(t0)                # Load value from the source (b[i])
    sw t6, 0(t2)                # Store value to the destination (a[j])
    addi t0, t0, 4              # Increment i
    addi t2, t2, 4              # Increment j
    j copy_loop
copy_done:
    jalr x0, x1, 0              # Return

merge:
    add t0, x0, a3              # Load 'leftSize' into t0
    add t1, x0, a4              # Load 'rightSize' into t1
    add t2, a1, x0              # Initialize i = 0 at 'left'
    add t3, a2, x0              # Initialize j = 0 at 'right'
    add t4, a0, x0              # Initialize k = 0 at 'arr'
    slli t0, t0, 2              # Multiply leftSize by 4 (word size)
    slli t1, t1, 2              # Multiply rightSize by 4 (word size)
    add t0, a1, t0              # Calculate the address of 'left' array
    add t1, a2, t1              # Calculate the address of 'right' array
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
    jalr x0, x1, 0              # Return
