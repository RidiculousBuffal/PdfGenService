# 使用 Puppeteer 官方镜像
FROM ghcr.io/puppeteer/puppeteer:19.11.1

# 切换到 root 用户
USER root

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      fontconfig \
      fonts-wqy-zenhei \
      fonts-wqy-microhei && \
    rm -rf /var/lib/apt/lists/*

# 将本地的宋体字体文件复制到容器中
COPY fonts/SimSun.ttc /usr/share/fonts/truetype/simsun/

# 更新字体缓存
RUN fc-cache -f -v

# 安装 Puppeteer 所需的浏览器
RUN npx puppeteer browsers install chrome

# 复制应用代码
COPY package.json package-lock.json ./
COPY src ./src

# 安装项目依赖
RUN npm install

# 暴露服务端口
EXPOSE 8080

# 启动服务
CMD ["npm", "start"]