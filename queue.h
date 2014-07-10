#ifndef __QUEUE_H
#define __QUEUE_H

typedef struct typeNode{ 
	char info[100]; 
	struct typeNode * next; 
	} Node;

typedef struct {
        Node *back, *front;
} Queue;

int createQ(Queue *q);

int emptyQ(Queue *q); //0 if empty

int enqueue(Queue *q, char info[100]);

Node *dequeue(Queue *q);

#endif