#include <stdio.h>
#include <string.h>

void display_tab(int *test, int taille);

int main()
{
	int test[] = {3,7,6,7,0,1,4,4,9,0,4,3,0,3,2};

	display_tab(test, 15);
	//"376701449043032";
	int somme = 0;

	for(int i = 13, a = 0; i >= 0; i--, a++)
	{
		int temp = (a % 2 == 0) ? test[i] * 2 : test[i];
		if(temp > 9) temp -= 9;
		somme += temp;
	}

	printf("Somme: %d\n", somme);
	somme %= 10;
	printf("Somme modulo 10: %d\n", somme);
	int resultat = 10 - somme;
	printf("10 - %d = %d\n", somme, resultat);
	char valide[] = "Non";
	if(resultat == test[14]) strcpy(valide, "Oui");
	printf("Valide? %s\n", valide);
}

void display_tab(int* test, int taille)
{
	for(int i = 0; i < taille; i++)
		printf("%d, ", *(test + i));

	printf("\n");
}