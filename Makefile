start:
	@docker compose up -d

force:
	@docker compose up -d --force-recreate

stop:
	@docker compose down

restart:
	@docker compose down
	@docker compose up -d

clean_images: clean_containers clean_volumes clean_networks
	@docker rmi -f $(shell docker images -qa) 2>/dev/null 1>/dev/null || true
	@printf "\033[0;32mAll images have been removed.\033[0m\n"
	@docker buildx prune -f 2>/dev/null 1>/dev/null || true
	@printf "\033[0;32mAll buildx have been removed.\033[0m\n"

clean_containers:
	@docker rm -f $(shell docker ps -q) 2>/dev/null 1>/dev/null || true
	@printf "\033[0;32mAll containers have been removed.\033[0m\n"

clean_volumes:
	@docker volume rm $(shell docker volume ls -q) 2>/dev/null 1>/dev/null || true
	@printf "\033[0;32mAll volumes have been removed.\033[0m\n"

clean_networks:
	@docker network rm $(shell docker network ls -q) 2>/dev/null 1>/dev/null || true
	@printf "\033[0;32mAll networks have been removed.\033[0m\n"

clean_directories:
	@rm -rf ../volumes

clean: clean_images clean_directories
	@docker compose down