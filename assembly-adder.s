	.file	"template.c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp               
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp          
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)      # edi holds argc, the number of arguments, this adds that value at memory in stack (edi instead of rdi because int argc is c giving a 32-bit int)
	movq	%rsi, -16(%rbp)     # rsi holds pointer to argv[0], this adds that value at memory in the stack as well 
    # End of start, has allocated the stack now

    # Need to push the registers we are using on to the stack so we can restore their values (they may be used and be expected to have values outside of this function, from before
    # this function was called, so we need to save and restore them)
    pushq %rbx
    pushq %r12

    movq    16(%rsi), %r12      # Save the pointer to arg[2], since calling atoi will overwrite where rsi is so cannot call 16(%rsi) after that call and get the right mem address
        # We use register r12 above because it is callee-saved and will not be overwritten by atoi call
    movq    8(%rsi), %rbx       # Gets the pointer to argv[1]; 8 bytes after pointer to argv[0] (since all memory addresses are 64 bits); rbx is callee-saved
	# Now %rbx holds the memory address that is offset 8 from %rsi, and r12 holds memory address that is offset 16 from rsi (argv[2])
    # Now we call atoi
    movq    %rbx, %rdi          # Move %rbx into %rdi, because the first argument of function goes into %rdi
    call    atoi@PLT            # Call the atoi function on %rdi / returns the vlalue into %rax
    movq    %rax, %rbx          # Save the value returned from atoi into %rax in %rbx

    # Now we do the same thing we just did to the second program argument, which is saved at %r12
    movq    %r12, %rdi          # Move that pointer into the function argument register rdi
    call    atoi@PLT            # Call atoi on rdi, return it to rax
    # Value gets returned into %rax, don't need to save it because we're gonna return %rax anyway

    # Now we can do the actual adding with our returned values: rbx into rax, then return rax
    addq %rbx, %rax
    
    # Do not need to move into %eax, that's the lower 32 of %rax, so the number will be there anyway
    
    # Now we restore rbx and r12 to their original states before this function was called, so that whatever was using them (the caller of this function) gets their correct values
    popq    %r12                # Do this pop first because LIFO, so need to get the last pushed first
    popq    %rbx                # THEN do this to preserve correct values
    popq	%rbp                
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
