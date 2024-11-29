# 使用 Puppeteer 官方基础镜像（或其他 Node 镜像）
FROM ghcr.io/puppeteer/puppeteer:19.11.1

# 创建应用程序用户和应用程序组
RUN groupadd -r appgroup && useradd -r -g appgroup -m appuser

# 创建工作目录并为非 root 用户添加权限
WORKDIR /app
RUN mkdir /app && chown -R appuser:appgroup /app

# 切换为非 root 用户（appuser）
USER appuser

# 复制项目代码到工作目录中
COPY --chown=appuser:appgroup package.json package-lock.json /app/
COPY --chown=appuser:appgroup src /app/src

# 安装项目依赖
RUN npm install

# 设置 Puppeteer 环境变量以跳过 Chromium 安装
ENV PUPPETEER_SKIP_DOWNLOAD=true

# 暴露运行的服务端口
EXPOSE 8080

# 启动应用程序
CMD ["npm", "start"]
