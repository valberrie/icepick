// call cpuid with args in eax, ecx
// store eax, ebx, ecx, edx to p

.section .text
_InterlockedCompareExchange128:
		// fastcall conventions:
		// RCX = Destination
		// RDX = Exchange High
		// R8 = Exchange Lo
		// R9 = ComparandResult

		// CMPXCHG16B refernece:
		// http://download.intel.com/design/processor/manuals/253666.pdf

		// Stash RBX in R11
		movq %rbx, %r11

		// Destination ptr to r10
		movq %rcx, %r10

		// RCX:RBX Exchange
		movq %rdx, %rcx
		movq %r8, %rbx

		// RDX:RAX Comparand
		movq (%r9), %rax
		movq 8(%r9), %rdx

		// Do the atomic operation
		lock
		cmpxchg16b (%r10)

		// RDX:RAX now contains the value of the destination, before the atomic operation.
		// (Either it already matched and was not changed, or it did not match, in which case
		// the value has been loaded into RDX:RAX.) The _InterlockedCompareExchange128 intrinsic
		// semantics specify that this is always written out to CompareResult, so give it
		// back to the caller.
		movq %rax, (%r9)
		movq %rdx, 8(%r9)

		// Return value is in AL, set it equal to the zero flag
		setz %al

		// Restore RBX and get out
		movq %r11, %rbx
        ret