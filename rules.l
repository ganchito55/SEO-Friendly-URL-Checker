%{

//-------------------------------------------------------------------------------------|
//  Created by Jorge Durán (aka ganchito55)                                            |
//  github: https://github.com/ganchito55/SEO-Friendly-URL-Checker                     |
//  Version: 1.0                                                                       |
//-------------------------------------------------------------------------------------|
#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <string.h>
#include "queue.h" 

//Colors for terminal output
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KWHT  "\x1B[37m"

#define PATHSIZE 100

int allFiles=0,goodFiles=0,badFiles=0;
%}


images	(jpg|gif|png)
styles		(css|less|sass)
web			(js|html|php)
others		(md|json)

%%
[a-z]+(-[a-z]+)*"."({images}|{styles}|{web})		{printf("The name %s is " KGRN "SEO friendly" KWHT "\n" ,yytext); goodFiles++;}
.*																			{printf("The name %s is not " KRED "SEO friendly" KWHT "\n" ,yytext); badFiles++;}
%%

int main(int argc, char * argv[]){
		int i,numFiles;
		Queue q;  //See queue.c and queue.h
		char path[PATHSIZE];
		struct dirent **files=NULL;
		Node *n=NULL;

		//Create the Queue
		if(createQ(&q)==-1){
			fprintf(stderr,"Error: we can't create the queue '");
			return 1;
		}

		//Create the path
		if(argc==1){
			strcpy(path,"./");         //Executable directory
		}
		if(argc>1){
			strcpy(path,argv[1]);       //Path from command line FIRST ARGUMENT
     	}


		if(enqueue(&q, path)==-1){
			fprintf(stderr,"Error: we couldn't' enqueue");
			return 1;
		}
		while(emptyQ(&q)!=0){
			n=dequeue(&q);			

			if((numFiles=scandir(n->info,&files,NULL, alphasort ))==-1){  //read all objects in this folder (files, pipes, directories,...)
				perror("Error using scandir: ");
				return 1;		
			}

		 	for(i=0;i<numFiles;i++){ //Read each object and create a switch-case expression
					if(files[i]->d_type==DT_REG){		//if it is a file do:
							allFiles++;							
							  yy_scan_string(files[i]->d_name); //put the name in the buffer of the parser
							  yylex(); //run the parser
							  yy_delete_buffer( YY_CURRENT_BUFFER );
					}
					if(files[i]->d_type==DT_DIR){		//if it is a directory do:
						
						if((strcmp(files[i]->d_name,".")==0)|| (strcmp(files[i]->d_name,"..")==0))  //avoid cycles
							continue;
	
						strcpy(path,n->info); //actual path
						strcat(path,"/"); //separator
						strcat(path,files[i]->d_name); //concatenation the folder name	
						if(enqueue(&q, path)==-1){
							fprintf(stderr,"Error: we couldn't' enqueue");
								return 1;
						}
					}

			}
			free(n); //free the node
		}
	printf("\n\nYou have %d files: "KGRN"%d SEO friendly " KRED "%d NOT SEO friendly" KWHT"\n",allFiles,goodFiles,badFiles);
	return 0;
}

yywrap()
{
}