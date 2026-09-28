.section .rodata
.fmtString:
    .string "Sum: %d\n"

.text
.globl main

main:
    pushq   %rbp                    # Initialize the stack base pointer
    movq    %rsp, %rbp              # Put the stack pointer where the base pointer is
    movl    %edi, -4(%rbp)          # Move the register that holds argc on to the stack (%edi instead of %rdi because argc is 32-bit int)
    movq    %rsi, -16(%rbp)         # Move the register that holds pointer to argv onto the stack (64-bit, so %rsi)
    # End of start, stack is set up and created

    # First, push the registers we are using on to the stack so they can be used and popped out for the caller to use their values again
    pushq   %rbx
    pushq   %r12

    movq    8(%rsi), %rbx           # Move the pointer to argv[1] into register %rbx to save it and prevent overwriting by changing %rsi position when atoi called
    movq    16(%rsi), %r12          # Move the pointer to argv[2] into register %r12 to save it and prevent overwriting by changing %rsi position when atoi called

    movq    %rbx, %rdi              # Move %rbx value into %rdi so it is in the first argument position for atoi call
    call    atoi@PLT                # Call atoi with %rdi as first argument (%rbx, which is argv[2])
    movq    %rax, %rbx              # Returns into %rax, move it back into %rbx to save the value for adding

    movq    %r12, %rdi              # Same as above, move %r12 into %rdi to call atoi on it
    call    atoi@PLT                # Call atoi with %rdi (argv[1])
                                    # No need to move, returns into %rax so we can just use that
    
    addq    %rbx, %rax              # Add the returned value from first atoi call (saved in %rbx) with returned value of second atoi call (auto return in %rax)

    leaq    .fmtString(%rip), %rdi  # Calculate address by adding fixed offset of label to value inside register; Add memory location of .fmtString to instruction pointer //
                                    # // then puts that memory address into first argument slot (%rdi), since printf first arg is const char *format (a pointer) 
    movq    %rax, %rsi              # Moves the actual value (sum from line 30 in %rax) into the second argument slot (%rsi)
    movq    $0, %rax                # Moves 0 into rax for... some sort of variadic reason I'm not too familiar with, but keeps printf more consistent apparently
    call    printf@PLT              # Calls printf with %rdi and %rsi to fill its two arguments

    # RETURN
    movl    $0, %eax                # Because main returns int, we movl (32-bit long since int is 32 bits) we are just returning 0 so we move 0 into %eax for 32 bit nums

    # POPS
    popq    %r12                    # Pop in reverse order of how we pushed (%rbx, %r12, %rbp) as seen above; gives values back to functions on the outside of this function
    popq    %rbx
    popq    %rbp    

    # End the program
    ret                             # Return which does assembly unique stuff to end the program

# This line apparently makes stack non-executable which is better for security, prevents a GCC warning when compiling, so I'll add it
.section .note.GNU-stack,"",@progbits

# This file was also helped by the same Claude conversation (may be private): https://claude.ai/share/104749b2-375d-4372-8c87-1cda69776a3f
# Otherwise, most knowledge came from Computer Architecture at Rutgers University taught by Bernhard Firner
