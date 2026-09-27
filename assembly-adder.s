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
    movq    8(%rsi), %rax       # Gets the pointer to argv[1]; 8 bytes after pointer to argv[0] (since all memory addresses are 64 bits)
	movl	$0, %eax
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
