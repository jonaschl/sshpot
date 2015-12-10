CC = gcc
#CFLAGS = -g -Wall
CFLAGS = -O3 -ljansson
CHMOD := $(shell which chmod)
SETCAP := $(shell which setcap)
USER := $(shell whoami)

all: sshpot

sshpot: main.o auth.o
	$(CC) $(CFLAGS) $^ -lssh -pthread -o $@

main.o: main.c config.h
	$(CC) $(CFLAGS) -c main.c

auth.o: auth.c auth.h config.h
	$(CC) $(CFLAGS) -c auth.c

install:
	@if [ $(USER) != "root" ]; then echo make install must be run as root.; false; fi
	$(CHMOD) 755 sshpot
	$(SETCAP) 'cap_net_bind_service=+ep' sshpot

clean:
	\/bin/rm -f *.o
mrproper:
	\/bin/rm -f sshpot
