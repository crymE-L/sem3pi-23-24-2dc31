.section .text
    .global sort_array

sort_array:
    movq $0, %rdx                   # Outer loop index (%rdx)
    movq $0, %rax                   # Clean %rax register

outer_loop:
    cmpl %edx, %esi                 # Compare the outer loop index with the array size
    je end                          # Jump to end if equal

    movl (%rdi, %rdx, 4), %ecx      # Array element that will be compared

    movl $0, %eax                   # Inner loop index (%eax)

inner_loop:
    cmpl %eax, %esi                 # Compare the inner loop index with the array size
    je end_inner_loop               # Jump to end_inner_loop if equal

    movl (%rdi, %rax, 4), %r8d      # Move the inner loop element to %r8d register

    cmpl %r8d, %ecx                 # Compare the inner loop array element with the outer loop array element
    jge no_swap                     # If greater or equal, jump to no_swap

    # Make the swap
    movl (%rdi, %rdx, 4), %r9d      # Move the outer loop element to %r9d register (temporary variable)
    movl %r8d, (%rdi, %rdx, 4)      # Move the inner loop element to the outer loop position
    movl %r9d, (%rdi, %rax, 4)      # Move the temporary variable (outer loop element) to the inner loop position

no_swap:
    incl %eax                       # Increment the inner loop index
    jmp inner_loop                  # Continue the inner loop

end_inner_loop:
    incl %edx                       # Increment the outer loop index
    jmp outer_loop                  # Continue the outer loop

end:
    ret
