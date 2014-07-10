#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "queue.h"


int createQ(Queue *q){
Node *n;
	if((n=malloc(sizeof(Node)))==NULL){
		fprintf(stderr,"Error: no enough memory");		
		return -1;
	}
	n->next=NULL;
	strcpy(n->info,"FRONT");
	q->back=n;
  	q->front=n;
	return 0;
}

int emptyQ(Queue *q){
	if(q->front==q->back){
		return 0;
	}
	else{
		return -1;
	}
}

int enqueue(Queue *q, char info[100]){
Node * n;
	if((n=malloc(sizeof(Node)))==NULL){
		fprintf(stderr,"Error: no enough memory");
		return -1;
	}

	n->next=NULL;
	strcpy(n->info,info);	
	q->back->next=n;
	q->back=n;
	return 0;
}

Node * dequeue(Queue *q){
	Node * n;	
	if(emptyQ(q)==0){
		fprintf(stderr,"Error: queue empty");
	}		
	n=q->front->next;	
	q->front->next=q->front->next->next;
        if(q->front->next==NULL){
            q->back=q->front;
        }
	return n;
}



