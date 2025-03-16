# 使用 Puppeteer 官方镜像
FROM ghcr.io/puppeteer/puppeteer:24.4.0

# 切换到 root 用户
USER root

# 设置工作目录
WORKDIR /app

# 安装宋体字体
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    fontconfig \
    ttf-mscorefonts-installer \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# 确保 Puppeteer 包含所需的依赖
RUN npx puppeteer browsers install chrome

# 复制项目文件
COPY package.json package-lock.json ./
COPY src ./src

# 安装项目依赖
RUN npm install

# 暴露服务端口
EXPOSE 8080

# 启动服务
CMD ["npm", "start"]