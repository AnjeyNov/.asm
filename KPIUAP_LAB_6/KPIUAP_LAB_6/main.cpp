#include <stdio.h>
#include <stdlib.h>
#include <Windows.h>
long double mas[10];

int main(int argc, char *argv[]) {

	long double sum = 0;
	int iteration = 10;
	int one = 1;
	int DE = 0, OE = 0, UE = 0, PE= 0;

	for (int i = 0; i < 10; i++) {
		printf("mas[%d]", i);
		scanf("%lf", mas + i);
	}

	_asm{
		finit			// init mat. proc.

		fild iteration	// ST(0) = 10

		fldz			// ST(0) = 0 (iteration)
						// ST(1) = 0

		xor EDI, EDI
		loop_start:
			fcom				// compare ST(0) and ST(1)
			fstsw ax			// copy status word(SW) to AX
			and ah, 00000101b	// check C3, C2, C1
			jz to_exit

			fld sum				// ST(0) = sum
								// ST(1) = iteration
								// ST(2) = 10

			fadd mas[EDI]		// ST(0) = sum + mas[EDI]
								// ST(1) = iteration
								// ST(2) = 10

			fstsw ax
			and al, 00001000b
				jnz owerflow

			and al, 00010000b
				jnz unowerflow

			and al, 00100000b
				jnz incorrect_result

			and al, 00000010b
				jnz denormalized_result

			fstp sum			// sum = ST(0)
								// ST(0) = iteration
								// St(1) = 10

			fiadd one			// ST(0) = iteration + 1
								// ST(1) = 10
				
			add EDI, 08h

			jmp loop_start
		loop_end:
		
		owerflow:

		fld1
		fistp OE
		jmp to_exit

		unowerflow:

		fld1
		fistp UE
		jmp to_exit

		incorrect_result:

		fld1
		fistp PE
		jmp to_exit

		denormalized_result:

		fld1
		fistp DE
		jmp to_exit

		to_exit:

		fwait

	}

	if (OE == 0 && UE == 0 && DE == 0 && PE == 0) {
		printf("Result = %lf \n", sum);
	}
	else if (OE) {
		printf("Overflow\n");
	}
	else if (UE) {
		printf("Unowerflow\n");
	}
	else if (DE) {
		printf("Denormalized result\n");
	}
	else if (PE) {
		printf("Incorrect result\n");
	}
	sum = 0;
	for (int i = 0; i < 10; i++) {
		sum += mas[i];
	}
	printf("Result = %lf \n", sum);
	system("pause");
}