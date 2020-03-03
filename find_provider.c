#include <stdio.h>
#include <stdlib.h>

int main(void)
{
	char cardNb[] = "5663"; // $a0
	char* numeroCarte[] = {"55", "56"}; // $a1
	int i = 0; // $s3

	while (i < 2) // checkCardProvider.loop
	{
		char* master = numeroCarte[i]; 
		int j = 0;
		int valid = 0;
		// $t7 = *(master + j)
		while (*(master + j) != '\0') // checkCardProvider.loop.while
		{

			if(cardNb[j] == master[j])
			{
				valid = 1;
			} else {
				valid = 0;
				break;
			}

			j++;
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