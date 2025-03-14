import express, {Request, Response} from "express";
import bodyParser from "body-parser";
import {generatePDFFromHTML} from "./pdfService";
import multer from "multer";
import cors from 'cors'

const app = express();
const PORT = 8080;
app.use(cors()); // 允许特定的前端地址访问
app.use(express.json({ limit: "1000mb" }));
app.use(express.urlencoded({ extended: true, limit: "1000mb" })); // 配置 URL-
const upload = multer({
    dest: "uploads/", // 文件临时存储目录
     limits: {
        fileSize: 1000 * 1024 * 1024, // 设置文件大小限制为 10MB
    },
});

app.post(
    "/api/generate-pdf-from-html",
    async (req: Request, res: Response): Promise<void> => {
        const {html} = req.body;
        if (!html) {
            res.status(400).send({error: "HTML content is required!"});
            return;
        }

        try {
            const pdfBuffer = await generatePDFFromHTML(html);
            res.set({
                "Content-Type": "application/pdf",
                "Content-Disposition": "attachment; filename=generated.pdf",
            });
            res.send(pdfBuffer);
        } catch (error) {
            console.error("Error generating PDF:", error);
            res.status(500).send({error: "Failed to generate PDF."});
        }
    }
);
app.post(
    "/api/generate-pdf-from-file",
    upload.single("htmlFile"), // 处理上传的单个文件，字段名为 "htmlFile"
    async (req: Request, res: Response): Promise<void> => {
        try {
            // 从上传的文件中读取 HTML 内容
            const uploadedFile = req.file;
            if (!uploadedFile) {
                res.status(400).send({error: "No file provided!"});
                return;
            }

            // 使用 fs 读取上传文件的内容
            const fs = await import("fs/promises");
            const htmlContent = await fs.readFile(uploadedFile.path, "utf-8");

            // 生成 PDF
            const pdfBuffer = await generatePDFFromHTML(htmlContent);

            // 删除临时文件
            await fs.unlink(uploadedFile.path);

            // 返回生成的 PDF 文件
            res.set({
                "Content-Type": "application/pdf",
                "Content-Disposition": `attachment; filename=${uploadedFile.filename.replace(/\.html?$/, '.pdf')}`,
            });
            res.send(pdfBuffer);
        } catch (error) {
            console.error("Error generating PDF from uploaded file:", error);
            res.status(500).send({error: "Failed to generate PDF from file."});
        }
    }
);
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
