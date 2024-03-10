#include <string.h>
#include "ex1.h"

/* Returns the number of times LETTER appears in STR.
There are two different ways to iterate through a string.
1st way hint: strlen() may be useful
2nd way hint: all strings end in a null terminator */
int num_occurrences(char *str, char letter) {
    /* TODO: implement num_occurances */
    int len = strlen(str), res = 0;
    for (int i = 0; i < len; i++) res += str[i] == letter;
    return res;
}

/* Populates DNA_SEQ with the number of times each nucleotide appears.
Each sequence will end with a NULL terminator and will have up to 20 nucleotides.
All letters will be upper case. */
void compute_nucleotide_occurrences(DNA_sequence *dna_seq) {
    if (dna_seq == NULL) return;
    dna_seq->A_count = dna_seq->C_count = dna_seq->T_count = dna_seq->G_count = 0;
    for (int i = 0; dna_seq->sequence[i]; i++) {
        switch (dna_seq->sequence[i]) {
            case 'A' : dna_seq->A_count++; break;
            case 'C' : dna_seq->C_count++; break;
            case 'T' : dna_seq->T_count++; break;
            case 'G' : dna_seq->G_count++; break;
        }
    }
    return;
}
