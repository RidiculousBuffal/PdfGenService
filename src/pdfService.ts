import puppeteer from "puppeteer";

/**
 * 从 HTML 字符串生成 PDF（返回二进制 Buffer）
 * @param htmlContent - HTML 字符串
 * @returns - PDF 的二进制 Buffer
 */
export const generatePDFFromHTML = async (htmlContent: string): Promise<Buffer> => {
  const browser = await puppeteer.launch({
  args: ['--no-sandbox', '--disable-setuid-sandbox'], // 适用于 Docker 环境
});
  const page = await browser.newPage();

  // 设置 HTML 内容
  await page.setContent(htmlContent, { waitUntil: "networkidle0" });

  // 生成 PDF 并返回 Buffer
  const pdfBuffer = await page.pdf({
    format: "A4",
    printBackground: true,
  });

  await browser.close();
  return Buffer.from(pdfBuffer);
};

/**
 * 从 HTML 文件生成 PDF（返回二进制 Buffer）
 * @param filePath - HTML 文件路径
 * @returns - PDF 的二进制 Buffer
 */
export const generatePDFFromFile = async (filePath: string): Promise<Buffer> => {
  const fs = await import("fs/promises");
  const htmlContent = await fs.readFile(filePath, "utf-8");
  return generatePDFFromHTML(htmlContent);
};
