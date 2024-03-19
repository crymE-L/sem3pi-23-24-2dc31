.section .text
    .global move_num_vec

move_num_vec:
    # prologue
    pushq %rbp
    movq %rsp, %rbp
    pushq %r12
    pushq %r13

	# Clean the indexes
    movq $0, %r12
    movq $0, %r13
    movq $0, %rax

	# Move the read index to %r12 and
	# the write index to %r13
    movl (%rdx), %r12d
    movl (%rcx), %r13d

    cmp %r12d, %r13d
    jge check_enough_to_write

	# Add the write index to the size
    addl %esi, %r13d

check_enough_to_write:
	# Write = write - reading which is part of the circular buffer
    subl %r12d, %r13d
    cmp %r8d, %r13d

	# If we don't have enough elements to copy
    jl end

    incq %rax

    movq $0, %r10
    movq $0, %r11 # r11 (r11d) vai ser o elemento atual

copy_array_loop:
	# The elements to verify if we copied enough values
    cmp %r8d, %r10d
    jge end

    movl (%rdi, %r12, 4), %r11d
    movl %r11d, (%r9, %r10, 4)

    incl %r12d
	# Verify if we haven't reach the limit
    cmp %esi, %r12d
    jl increment_array_address

    movq $0, %r12

increment_array_address:
    incl %r10d
    jmp copy_array_loop

end:
    # epilogue
    movl %r12d, (%rdx)

    popq %r13
    popq %r12
    movq %rbp, %rsp
    popq %rbp

    ret
