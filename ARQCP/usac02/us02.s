.section .text
    .global enqueue_value

enqueue_value:
	pushq %rbp
	movq %rsp, %rbp

	pushq %r10
	pushq %r11

	# Pass the write pointer to %r10d and
	# pass the read pointer to %r11d
	movl (%rcx), %r10d
    movl (%rdx), %r11d

	# Let's make sure that the return address
	# is 0. That way we solve a lot of time
	movq $0, %rax

	cmpl %r10d, %r11d
	jge write_value

	# Move the valye of the read pointer to
	# the return address
	movl %r10d, %eax
	incl %eax

	cmpl %eax, %r11d
	incl %r11d
	je write_value

write_value:
	movq $0, %rax

	movl %r8d, %eax
	# Determine the address we have to write to
	leaq (%rdi, %r10, 4), %r9

	movl %eax, (%r9)

	# Move the write pointer to the next position
	incl %r10d

	# Compare if we've reached the limit
    cmpl %r10d, %esi
    jne array_is_full

    movl $0, %r10d # write = 0

array_is_full:
	cmpl %r11d, %esi
    jne finish

    movl $0, %r11d

finish:
    movl %r10d, (%rcx)
    movl %r11d, (%rdx)

    popq %r10
    popq %r11

	# Here we're restoring the base pointer
    leave
    ret
