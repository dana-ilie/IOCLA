#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_INPUT_LINE_SIZE 300
#define DELIM "\n "

struct Dir;
struct File;

typedef struct Dir{
	char *name;
	struct Dir* parent;
	struct File* head_children_files;
	struct Dir* head_children_dirs;
	struct Dir* next;
} Dir;

typedef struct File {
	char *name;
	struct Dir* parent;
	struct File* next;
} File;

Dir *dir_create(Dir *parent, char *name) {
	Dir *dir = calloc(1, sizeof(*dir));

	dir->name = calloc(1, strlen(name) + 1);
	memcpy(dir->name, name, strlen(name) + 1);

	dir->parent = parent;
	dir->head_children_files =NULL;
	dir->head_children_dirs = NULL;
	dir->next = NULL;

	return dir;
}

File *file_create(Dir *parent, char *name) {
	File *file = calloc(1, sizeof(*file));

	file->name = calloc(1, strlen(name) + 1);
	memcpy(file->name, name, strlen(name) + 1);

	file->parent = parent;
	file->next = NULL;

	return file;
}

int check_file_name(Dir *parent, char *name) {
	int name_exists = 0;
	File *head_files = parent->head_children_files;

	while (head_files != NULL && name_exists == 0) {
		if (strcmp(head_files->name, name) == 0) {
			name_exists = 1;
		}
		head_files = head_files->next;
	}

	return name_exists;
}

int check_dir_name(Dir *parent, char *name) {
	int name_exists = 0;
	Dir *head_dirs = parent->head_children_dirs;

	while (head_dirs != NULL && name_exists == 0) {
		if (strcmp(head_dirs->name, name) == 0) {
			name_exists = 1;
		}
		head_dirs = head_dirs->next;
	}

	return name_exists;
}

int check_name(Dir *parent, char *name) {
	int name_exists = 0;

	name_exists = check_dir_name(parent, name);
	if (name_exists == 0) {
		name_exists = check_file_name(parent, name);
	}

	return name_exists;
}

void touch (Dir* parent, char* name) {
	if (check_name(parent, name) == 1) {
		printf("File already exists\n");
	} else {
		File *file = file_create(parent, name);
		File *aux = parent->head_children_files;
		if (aux != NULL) {
			while (aux->next != NULL) {
				aux = aux->next;
			}
			aux->next = file;
		} else {
			parent->head_children_files = file;
		}
	}
}

void mkdir (Dir* parent, char* name) {
	if (check_name(parent, name) == 1) {
		printf("Directory already exists\n");
	} else {
		Dir *dir = dir_create(parent, name);
		Dir *aux = parent->head_children_dirs;
		if (aux != NULL) {
			while (aux->next != NULL) {
				aux = aux->next;
			}
			aux->next = dir;
		} else {
			parent->head_children_dirs = dir;
		}
	}
}

void ls (Dir* parent) {
	// print directories
	Dir *aux_dir = parent->head_children_dirs;
	while (aux_dir != NULL) {
		printf("%s\n", aux_dir->name);
		aux_dir = aux_dir->next;
	}

	// print files
	File *aux_file = parent->head_children_files;
	while (aux_file != NULL) {
		printf("%s\n", aux_file->name);
		aux_file = aux_file->next;
	}
}

void rm (Dir* parent, char* name) {
	if (check_file_name(parent, name) == 0) {
		printf("Could not find the file\n");
	} else {
		File *prev = parent->head_children_files;
		File *last = parent->head_children_files->next;

		// if the file is first in the file list
		if (strcmp(prev->name, name) == 0) {
			parent->head_children_files = prev->next;
			free(prev->name);
			free(prev);
		} else {
			// search the file
			while (last->next != NULL) {
				if (strcmp(last->name, name) == 0) {
					break;
				} else {
					prev = prev->next;
					last = last->next;
				}
			}
			prev->next = last->next;
			free(last->name);
			free(last);
		}
		
	}
}

void rm_all_files (Dir *parent) {
	File *aux = parent->head_children_files;

	while (aux != NULL) {
		parent->head_children_files = aux->next;
		free(aux->name);
		free(aux);
		aux = parent->head_children_files;
	}
}

void rmdir (Dir* parent, char* name) {
	Dir *prev = parent->head_children_dirs;

	if (prev == NULL) {
		return;
	}

	Dir *last = prev->next;

	// if the directory is first in the list
	if (strcmp(prev->name, name) == 0) {
		parent->head_children_dirs = parent->head_children_dirs->next;
		// remove all sub-directories
		Dir *aux_dir = prev->head_children_dirs;
		while (aux_dir != NULL) {
			Dir *aux = aux_dir;
			aux_dir = aux_dir->next;
			rmdir(prev, aux->name);
		}
		// remove all files
		rm_all_files(prev);
		free(prev->name);
		free(prev);
	} else {
		// search the directory in the list
		while (last->next != NULL) {
			if (strcmp(last->name, name) == 0) {
				break;
			} else {
				prev = prev->next;
				last = last->next;
			}
		}
		prev->next = last->next;
		// remove all sub-directories
		Dir *aux_dir = last->head_children_dirs;
		while (aux_dir != NULL) {
			Dir *aux = aux_dir;
			aux_dir = aux_dir->next;
			rmdir(last, aux->name);
		}
		// remove all files
		rm_all_files(last);
		free(last->name);
		free(last);
	}
}

void cd(Dir** target, char *name) {
	if (strcmp(name, "..") == 0){
		if ((*target)->parent != NULL) {
			*target = (*target)->parent;
		}
	} else if (check_dir_name(*target, name) == 0) {
		printf("No directories found!\n");
	} else {
		// search the dir by name
		Dir *aux = (*target)->head_children_dirs;
		while (aux != NULL) {
			if (strcmp(aux->name, name) == 0) {
				*target = aux;
				break;
			} else {
				aux = aux->next;
			}
		}
	}
}

char *pwd (Dir* target) {
	char *path = calloc(1000,1);
	char tmp[100];
	Dir *aux = target;

	while(aux != NULL) {
		char bslash[100] = "/";
		strcpy(tmp, path);
		strcat(bslash, aux->name);
		strcpy(path, bslash);
		strcat(path, tmp);
		aux = aux->parent;
	}

	return path;
}

void stop (Dir* target) {
	// remove all files from target
	rm_all_files(target);

	// remove all dirs from target
	Dir *aux = target->head_children_dirs;
	while (aux != NULL) {
		rmdir(target, aux->name);
		aux = target->head_children_dirs;
	}

	free(target->name);
	free(target);

}

void tree (Dir* target, int level) {
	if (target == NULL) {
		return;
	}

	// print directories
	Dir *aux_dir = target->head_children_dirs;
	while (aux_dir != NULL) {
		for (int i = 0; i < level; i++) {
			printf("    ");
		}
		printf("%s\n", aux_dir->name);
		Dir *aux = aux_dir;
		tree(aux, level + 1);
		aux_dir = aux_dir->next;
	}

	// print files
	File *file = target->head_children_files;
	while (file != NULL) {
		for (int i = 0; i < level; i++) {
			printf("    ");
		}
		printf("%s\n", file->name);
		file = file->next;
	}
}

void mv(Dir* parent, char *oldname, char *newname) {
	if (check_name(parent, oldname) == 0) {
		printf("File/Director not found\n");
	} else {
		if (check_name(parent, newname) == 1) {
			printf("File/Director already exists\n");
		} else {
			// check if oldname is a file
			int found = 0;
			File *aux_file = parent->head_children_files;

			while (aux_file != NULL) {
				if (strcmp(aux_file->name, oldname) == 0) {
					rm(parent, oldname);
					touch(parent, newname);
					found = 1;
					break;
				} else {
					aux_file = aux_file->next;
				}
			}

			// if it's not a file, search in the directories list
			if (found == 0) {
				Dir *first = parent->head_children_dirs;
				Dir *last = first->next;

				// if it's first in the list
				if (strcmp(first->name, oldname) == 0) {
					// move from beginning of the list to the end of the list
					if (first->next != NULL) {
						parent->head_children_dirs = parent->head_children_dirs->next;
						Dir *aux = parent->head_children_dirs;
						while (aux ->next != NULL) {
							aux = aux->next;
						}
						aux->next = first;
						first->next = NULL;
					}
					// change name
					free(first->name);
					first->name = calloc(1, strlen(newname) + 1);
					memcpy(first->name, newname, strlen(newname) + 1);
				} else {
					// search in the list
					while (last != NULL) {
						if (strcmp(last->name, oldname) == 0) {
							// move to the end of the list
							first->next = last->next;
							Dir *aux = parent->head_children_dirs;
							while (aux->next != NULL) {
								aux = aux->next;
							}
							aux->next = last;
							last->next = NULL;
							// chane name
							free(last->name);
							last->name = calloc(1, strlen(newname) + 1);
							memcpy(last->name, newname, strlen(newname) + 1);
							break;
						} else {
							last = last->next;
							first = first->next;
						}
					}
				}

			}
		}
	}
}

int main () {
	Dir *home_dir = dir_create(NULL, "home");
	Dir *current_dir = home_dir;

	do
	{
		char *arg;
		char input[MAX_INPUT_LINE_SIZE];

		fgets(input, MAX_INPUT_LINE_SIZE, stdin);
		arg = strtok(input, DELIM);

		if (strcmp(arg, "touch") == 0) {
			char *filename = strtok(NULL, DELIM);
			touch(current_dir, filename);

		} else if (strcmp(arg, "mkdir") == 0) {
			char *dirname = strtok(NULL, DELIM);
			mkdir(current_dir, dirname);

		} else if (strcmp(arg, "ls") == 0) {
			ls(current_dir);

		} else if (strcmp(arg, "rm") == 0) {
			char *filename  = strtok(NULL, DELIM);
			rm(current_dir, filename);

		} else if (strcmp(arg, "rmdir") == 0) {
			char *dirname = strtok(NULL, DELIM);
			if (check_dir_name(current_dir, dirname) == 0) {
				printf("Could not find the dir\n");
			} else {
				rmdir(current_dir, dirname);
			}

		} else if (strcmp(arg, "cd") == 0) {
			char *dirname = strtok(NULL, DELIM);
			cd(&current_dir, dirname);

		} else if (strcmp(arg, "tree") == 0) {
			tree(current_dir, 0);

		} else if (strcmp(arg, "pwd") == 0) {
			char *path = pwd(current_dir);
			printf("%s\n", path);
			free(path);

		} else if (strcmp(arg, "mv") == 0) {
			char *oldname = strtok(NULL, DELIM);
			char *newname = strtok(NULL, DELIM);
			mv(current_dir, oldname, newname);

		} else if (strcmp(arg, "stop") == 0) {
			stop(home_dir);
			exit(0);
		}
	} while (1);
	
	return 0;
}
