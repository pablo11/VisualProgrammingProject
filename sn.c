#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define N(x) (sizeof(x)/sizeof(*x))

typedef char* (* Function)(char const* str);

/* PROTOTYPES */

char* copy(char const* str);
char* to_upper_case_all_a(char const* str);
char* split_at_third_space(char const* str);
char* append_hello(char const* str);

void iterate_over_functions(const char* strs[], size_t nb_strs, Function* f, size_t nb_f);

/* MAIN */

int main() {
    const char* inputs[] = {
      "Hallo Anno! Cammant ca va ? Ahlala...",
      "aaaaa",
      " a a a a a ",
      "Une phrose sons oucun o"
    };
	
    Function my_functions[] = {
		copy, 
		to_upper_case_all_a, 
		split_at_third_space, 
		append_hello
	};
    
    iterate_over_functions(inputs, N(inputs), my_functions, N(my_functions));
	
    return 0;
}

/* FUNCTIONS IMPLEMENTATION */

char*
copy(char const* str)
{
	size_t size = strlen(str) ;
	char* ret = malloc(size * sizeof(char) + 1);
	ret = strcpy(ret, str);
	ret[size] = '\0';
	return ret;
}

char*
to_upper_case_all_a(char const* str)
{
	char* ret = copy(str);
	for (int i = 0; i < strlen(ret); ++i) {
		if (ret[i] == 'a') {
			ret[i] = 'A';
		}
	}
	return ret;
}

char*
split_at_third_space(char const* str) 
{	
	size_t space_count = 0;
	size_t n = 0;
	
	for (int i = 0; (i < strlen(str)) && (space_count < 3); ++i) {
		n += 1;
		if (str[i] == ' ') {
			space_count += 1;
		}
	}
	
	char* ret = malloc(n * sizeof(char));
	n -= 1;
	
	ret = strncpy(ret, str, n);
	ret[n] = '\0';
	
	return ret;
}

char*
append_hello(char const* str)
{
	char* hello = "hello";
	
	size_t size = strlen(str) + strlen(hello);
	char* ret = malloc(size * sizeof(char) + 1);
	ret[0] = '\0';
	ret = strcat(ret, str);
	ret = strcat(ret, hello);
	
	ret[size] = '\0';
	
	return ret;
}

void
iterate_over_functions(const char* strs[], size_t nb_strs, Function* f, size_t nb_f)
{
	for (int i_func = 0; i_func < nb_f; ++i_func) {
		printf("Applying transformation #%d:\n", i_func);
		for (int i_strs = 0; i_strs < nb_strs; ++i_strs) {
			char* str = f[i_func](strs[i_strs]);
			printf("\t-> \"%s\"\n", str);
			free(str);
			str = NULL;
		}
	}
}
	
