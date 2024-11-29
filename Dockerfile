# 使用 Puppeteer 官方镜像
FROM ghcr.io/puppeteer/puppeteer:19.11.1

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY package.json package-lock.json ./
COPY src ./src

# 切换到 root 用户
USER root

# 安装项目依赖
RUN npm install
RUN npx puppeteer browsers install chrome
# 切换回非 root 用户
USER pptruser

# 暴露服务端口
EXPOSE 8080

# 启动服务
CMD ["npm", "start"]
