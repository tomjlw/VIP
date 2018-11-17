
#include <stdio.h> 

#include <string.h> 

int read(float *z, float *b) 

{
    char szTest[100000] = {0};
    int index=0;

    FILE *fp = fopen("../data/filter.txt", "r"); 

    if(NULL == fp) 

    { printf("failed to open dos.txt\n"); return 1; } 

    while(!feof(fp)) 

    {	
        char* token;
        float var;
	char seps[] = " ";

        memset(szTest, 0, sizeof(szTest)); 
        fgets(szTest, sizeof(szTest) - 1, fp);

        token =strtok(szTest, seps);
        while(token != NULL)
        {
	index++;
	sscanf(token,"%f",&var);
        if (1<=index<=1201){z[index-1]=var;}
	if(1203<=index<=1267){b[index-1203]=var;}
        //if (index == 1){memcpy(z, input, sizeof z);}
	//else {memcpy(b, input, sizeof b);}
        token = strtok (NULL, seps);
	}
    }

	fclose(fp);
	return 0;
}

int len(float *a)
{
  return sizeof(a)/sizeof(a[0]);
}
