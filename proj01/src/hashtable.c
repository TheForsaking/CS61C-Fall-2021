#include "hashtable.h"

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This creates a new hash table of the specified size and with
 * the given hash function and comparison function.
 */
HashTable *createHashTable(int size, unsigned int (*hashFunction)(void *),
                           int (*equalFunction)(void *, void *)) {
  int i = 0;
  HashTable *newTable = malloc(sizeof(HashTable));
  if (NULL == newTable) {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  newTable->size = size;
  newTable->buckets = malloc(sizeof(struct HashBucketEntry *) * size);
  if (NULL == newTable->buckets) {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  for (i = 0; i < size; i++) {
    newTable->buckets[i] = NULL;
  }
  newTable->hashFunction = hashFunction;
  newTable->equalFunction = equalFunction;
  return newTable;
}

/* Task 1.2 */
void insertData(HashTable *table, void *key, void *data) {
  // -- TODO --
  // HINT:
  // 1. Find the right hash bucket location with table->hashFunction.
  // 2. Allocate a new hash bucket entry struct.
  // 3. Append to the linked list or create it if it does not yet exist. 

  HashBucketEntry* entry = malloc(sizeof(struct HashBucketEntry));
  entry->key = key;
  entry->data = data;
  entry->next = NULL;

  unsigned int idx = table->hashFunction(key) % table->size;
  if (table->buckets[idx] == NULL) {
    table->buckets[idx] = entry;
  } else {
    HashBucketEntry* prev = table->buckets[idx];
    while (prev->next != NULL) prev = prev->next;
    prev->next = entry;
  }
}

/* Task 1.3 */
void *findData(HashTable *table, void *key) {
  // -- TODO --
  // HINT:
  // 1. Find the right hash bucket with table->hashFunction.
  // 2. Walk the linked list and check for equality with table->equalFunction.


  unsigned int idx = table->hashFunction(key) % table->size;
  if (table->buckets[idx] == NULL) return NULL;

  HashBucketEntry* ptr = table->buckets[idx];
  while (ptr) {
    // if (ptr->key == key) return ptr->data;
    if (strcmp(ptr->key, key) == 0) return ptr->data;
    ptr = ptr->next;
  }

  return NULL;
}

/* Task 2.1 */
unsigned int stringHash(void *s) {
  // -- TODO --
  /* To suppress compiler warning until you implement this function, */
  unsigned long long val = 0;
  static int MOD = 1e9 + 7;
  char* str = (char*)s;
  for (int i = 0; str[i]; i++) {
    val = (val * 256 + str[i]) % MOD;
  }
  return val;
}

/* Task 2.2 */
int stringEquals(void *s1, void *s2) {
  // -- TODO --
  /* To suppress compiler warning until you implement this function */
  return !strcmp((char*)s1, (char*)s2);
}