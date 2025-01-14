# HTML to PDF API

这是一个基于 Node.js 和 Puppeteer 的 RESTful API，可将 HTML 文件转换为 PDF 文件。您可以通过两个端点上传 HTML 文件或直接提供 HTML 字符串，生成的 PDF 文件会以二进制流的形式返回。

---

## 🚀 **功能说明**

### 支持的功能：
1. **HTML 文件转换**：接受二进制 HTML 文件并返回生成的 PDF 文件。
2. **HTML 字符串转换**：接受 HTML 字符串并返回生成的 PDF 文件。

---

## 🛠️ **项目设置**

### **克隆此项目**
```bash
git clone <repository-url>
cd <project-name>
```

### **安装依赖**
```bash
npm install
```

### **启动项目**
```bash
npm start
```

---

## 🛣️ **API 端点**

### **1. 上传 HTML 文件**
- **端点**: `/api/generate-pdf-from-file`
- **请求方法**: `POST`
- **请求类型**: `multipart/form-data`
- **字段**:
  - `htmlFile` (必填): HTML 文件，支持 `.html` 和 `.htm` 文件。

- **响应**: PDF 二进制流（`application/pdf`）。

#### 示例 CURL 请求：
```bash
curl -X POST http://localhost:3000/api/generate-pdf-from-file \
  -H "Content-Type: multipart/form-data" \
  -F "htmlFile=@example.html" \
  --output example.pdf
```

---

### **2. HTML 字符串生成 PDF**
- **端点**: `/api/generate-pdf-from-html`
- **请求方法**: `POST`
- **请求类型**: `application/json`
- **字段**:
  - `html` (必填): HTML 内容字符串。

- **响应**: PDF 二进制流（`application/pdf`）。

#### 示例 CURL 请求：
```bash
curl -X POST http://localhost:3000/api/generate-pdf-from-html \
  -H "Content-Type: application/json" \
  -d '{
        "html": "<html><body><h1>Hello, PDF!</h1></body></html>"
      }' \
  --output example.pdf
```

---

## 📜 **响应说明**

对于成功的请求，服务器会返回生成的 PDF 文件流，HTTP 响应状态为 `200 OK`，文件类型为 `application/pdf`。

#### 错误响应：
1. **`400 Bad Request`**:
   - 请求参数不完整。
   - 上传 HTML 文件为空。
   
   **响应示例**：
   ```json
   {
     "error": "No file provided!"
   }
   ```

2. **`500 Internal Server Error`**:
   - 服务器内部错误，如文件解析失败、HTML 内容无效等。
   
   **响应示例**：
   ```json
   {
     "error": "Failed to generate PDF."
   }
   ```

---

## 🧪 **测试**

1. **本地测试**：
   - 启动服务：`npm start`。
   - 使用工具，如 Postman 或 Apifox，测试 API：
     - **上传 HTML 文件**：发送 `multipart/form-data` 格式的 `POST` 请求。
     - **上传 HTML 字符串**：发送 `application/json` 格式的 `POST` 请求。

2. **验证输出**：
   - 成功请求后，PDF 文件将直接下载到本地。
   - 使用 PDF 查看工具验证内容是否正确。

---

## ⚙️ **项目配置**

### **跨域 (CORS)**

默认支持来自 `http://localhost:5173` 的跨域请求，可以通过以下代码自定义允许的跨域来源：
```javascript
app.use(cors({ origin: "http://your-frontend-domain.com" }));
```

---

## 🌐 **前端集成示例**

### **1. 上传文件并转换 PDF**
以下是一个使用 Fetch 的前端代码示例：

```javascript
const convertHTMLToPDF = async (file) => {
  const formData = new FormData();
  formData.append('htmlFile', file);

  const response = await fetch('http://localhost:3000/api/generate-pdf-from-file', {
    method: 'POST',
    body: formData,
  });

  if (!response.ok) {
    throw new Error('Failed to convert HTML to PDF');
  }

  const pdfBlob = await response.blob();
  const downloadLink = document.createElement('a');
  downloadLink.href = URL.createObjectURL(pdfBlob);
  downloadLink.download = file.name.replace(/\.(html|htm)$/, '.pdf');
  downloadLink.click();
};
```

### **2. 提交 HTML 字符串并转换 PDF**
```javascript
const convertHTMLStringToPDF = async (htmlString) => {
  const response = await fetch('http://localhost:3000/api/generate-pdf-from-html', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ html: htmlString }),
  });

  if (!response.ok) {
    throw new Error('Failed to convert HTML to PDF');
  }

  const pdfBlob = await response.blob();
  const downloadLink = document.createElement('a');
  downloadLink.href = URL.createObjectURL(pdfBlob);
  downloadLink.download = 'generated.pdf';
  downloadLink.click();
};
```

---

## ⚡ **常见问题**

### 1. **API 请求跨域问题**
确保后端启用了 CORS，并正确设置了允许的 `origin`。

### 2. **文件内容无法正确显示**
确保上传的 HTML 文件格式正确，并且所有需要的样式和资源能够被正确解析。

### 3. **如何限制上传文件大小？**
可以通过 `multer` 配置 `limits.fileSize` 参数，例如：
```javascript
const upload = multer({
  dest: "uploads/",
  limits: { fileSize: 5 * 1024 * 1024 } // 限制为 5 MB
});
```

---

## 🛡️ **安全建议**
1. 限制允许上传的文件大小和文件类型，避免上传恶意文件。
2. 在生产环境中，严格验证来源的 `origin`，避免任意跨域访问。

---

## 📑 **项目结构**

```
project/
├── src/
│   ├── server.ts          # 主服务器文件
│   ├── pdfService.ts      # 处理 HTML 转 PDF 的核心逻辑
├── uploads/               # 临时文件存储目录
├── package.json           # 项目配置文件
├── tsconfig.json          # TypeScript 配置文件
```

---

## 💡 **未来优化**
- 支持批量文件上传与压缩后的 PDF 批量下载。
- 提升转换性能，支持多线程任务队列。
- 部署生产环境，提供负载均衡支持。

---

## 📝 **总结**

这个 API 是一个简单但高效的工具，用于将 HTML 文件转换为 PDF 文件，适用于多种场景。通过结合前端与后端的功能，可以快速实现 HTML 到 PDF 的自动化生产服务。
