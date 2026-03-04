# [Colors]
RED     = \033[1;31m
GREEN   = \033[1;32m
YELLOW  = \033[1;33m
BLUE    = \033[1;34m
END     = \033[0m

# Project info
NAME    = inception
SRCS    = ./srcs/docker-compose.yml
DATA    = /home/blade/data

# Rules

.PHONY: all
all: build

# Create host directories and launch
.PHONY: build
build:
	@echo "$(YELLOW)Preparing volumes for $(NAME)...$(END)"
	@mkdir -p $(DATA)/mariadb
	@mkdir -p $(DATA)/wordpress
	@echo "$(BLUE)Building and starting containers...$(END)"
	@docker-compose -f $(SRCS) up -d --build
	@echo "$(GREEN)Stack $(NAME) is up and running!$(END)"

# Stop and remove containers/networks
.PHONY: down
down:
	@echo "$(YELLOW)Stopping containers...$(END)"
	@docker-compose -f $(SRCS) down

# Clean unused docker resources
.PHONY: clean
clean: down
	@echo "$(RED)Cleaning Docker resources...$(END)"
	@docker system prune -a

# Deep clean: remove volumes and physical data folders
.PHONY: fclean
fclean: clean
	@echo "$(RED)Deleting all data and volumes...$(END)"
	@sudo rm -rf $(DATA)
	@if [ -n "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q); \
	fi

.PHONY: re
re: fclean all
