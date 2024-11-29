# 使用基于 Debian 的官方 Puppeteer 镜像，已内置 Chromium 和必要依赖
FROM ghcr.io/puppeteer/puppeteer:19.11.1

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY package.json package-lock.json ./
COPY src ./src

# 安装项目依赖
RUN npm install

# 暴露服务端口
EXPOSE 8080

# 设置启动命令
CMD ["npm", "start"]
