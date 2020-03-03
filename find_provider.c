#include <stdio.h>
#include <stdlib.h>

int main(void)
{
	char cardNb[] = "5663"; // $a0
	int numeroCarte[] = {55, 56}; // $a1
	int i = 0; // $s3

	while (i < 2) // checkCardProvider.loop
	{
		int master = numeroCarte[i]; 
		int valid = 0;
		// $t7 = *(master + j)
		while (master % 10 != 0) // checkCardProvider.loop.while
		{

			if((int)cardNb[j] == master % 10)
			{
				valid = 1;
			} else {
				valid = 0;
				break;
			}

			master /= 10;
		}

		if(valid > 0) // checkCardProvider.loop.checkFound:
		{
			printf("Trouvé: %s\n", master);
			return 0;
		}

		i++;

	}

	printf("Non trouvé\n");

	return 0;
}