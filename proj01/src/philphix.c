/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philphix.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
#ifndef _PHILPHIX_UNITTEST
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 1;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(0x61C, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}
#endif /* _PHILPHIX_UNITTEST */

/* Task 3 */
void readDictionary(char *dictName) {
  // -- TODO --
  FILE* fd = fopen(dictName, "r");
  if (fd == NULL) {
    fprintf(stderr, "open %s fail.", dictName);
    exit(61);
  }

  static char key[1000086], val[1000086];
  while (fscanf(fd, "%s", key) == 1) {
    fscanf(fd, "%s", val);

    char *pKey = malloc(sizeof(char) * (strlen(key) + 2)), *pVal = malloc(sizeof(char) * (strlen(val) + 2));
    memcpy(pKey, key, strlen(key) + 1), memcpy(pVal, val, strlen(val) + 1);
    insertData(dictionary, pKey, pVal);
  }
  fclose(fd);
}

static inline int is_alphanumeric(char v) {
  if (v <= '9' && v >= '0') return 1;
  if (v <= 'z' && v >= 'a') return 1;
  if (v <= 'Z' && v >= 'A') return 1;
  return 0;
}
static inline void utol(char* c) {
  if (*c <= 'Z' && *c >= 'A') *c += 32;
}

/* Task 4 */
void processInput() {
  static char stack[1000086], ch;
  int len = 0;

  while (ch = getchar(), 1) {
    if (!is_alphanumeric(ch)) {
      if (len) {
        char* tmp = malloc(sizeof(char) * (len + 2));
        if (tmp == NULL) exit(1);
        stack[len] = 0;
        memcpy(tmp, stack, sizeof(char) * (len + 1));
        char* data = NULL;
        data = findData(dictionary, tmp);
        if (data) { printf("%s", data); goto release_; }
        for (int i = 1; tmp[i]; i++) { utol(tmp + i); }
        data = findData(dictionary, tmp);
        if (data) { printf("%s", data); goto release_; }
        utol(tmp);
        data = findData(dictionary, tmp);
        if (data) { printf("%s", data); goto release_; }
        printf("%s", stack);

        release_:
        len = 0;
        free(tmp);
      }
      if (ch != -1) putchar(ch);
      else break;
    } else stack[len++] = ch;
  }
}