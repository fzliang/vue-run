.PHONY: build
default: build

install:
	yarn install

dev:
	npm run serve

build:
	npm run build

help:
	@echo "   \033[35mmake\033[0m \033[1m命令使用说明\033[0m"
	@echo "   \033[35mmake install\033[0m\t\033[0m\t\033[0m\t\033[0m\t---  安装依赖"
	@echo "   \033[35mmake dev\033[0m\t\033[0m\t\033[0m\t\033[0m\t---  开发模式"
	@echo "   \033[35mmake build\033[0m\t\033[0m\t\033[0m\t\033[0m\t---  编译项目，生成目标文件"