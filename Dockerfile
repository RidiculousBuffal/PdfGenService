# 使用 Puppeteer 官方基础镜像
FROM ghcr.io/puppeteer/puppeteer:19.11.1

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器
COPY package.json package-lock.json ./
COPY src ./src

# 修复权限，确保非 root 用户可操作
RUN chown -R pptruser:pptruser /app

# 切换到 Puppeteer 镜像内置用户（pptruser）
USER pptruser

# 运行 npm 安装包
RUN npm install

# 设置 Puppeteer 的环境
ENV PUPPETEER_SKIP_DOWNLOAD=true

# 暴露端口
EXPOSE 8080

# 启动服务
CMD ["npm", "start"]
