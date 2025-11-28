CC      = gcc
CFLAGS  = -Wall -Wextra -Werror -Iinclude

SRC = \
    src/main.c \
    src/csv.c \
    src/avl.c \
    src/tree.c \
    src/utils.c

EXEC = Saitama

.PHONY: all compile run clean

all: $(EXEC)

$(EXEC): $(SRC)
	@echo "Compilation..."
	@$(CC) $(CFLAGS) -o $(EXEC) $(SRC)

compile: clean all

run: all
	@echo "Exécution..."
	@./$(EXEC)

clean:
	@echo "Nettoyage..."
	@rm -f $(EXEC)
