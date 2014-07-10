seoFriendly: queue.o lex.yy.o
	gcc lex.yy.o queue.o -lfl -o seoFriendly
queue.o: queue.c queue.h
	gcc -c queue.c
lex.yy.o: lex.yy.c
	gcc -c -lfl lex.yy.c 
lex.yy.c: rules.l
	lex rules.l
