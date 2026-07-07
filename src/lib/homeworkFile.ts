// Shared file-type handling for the "homework_upload" quiz question type.
// Students may submit an image, a PDF, or a common office document (Word/Excel/PowerPoint).

export const HOMEWORK_UPLOAD_ACCEPT = "image/*,.pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx";

export const HOMEWORK_MAX_DOC_SIZE = 500 * 1024; // 500 KB, same cap previously applied to PDFs

const DOC_EXTENSIONS = ["pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx"] as const;
export type HomeworkDocExt = typeof DOC_EXTENSIONS[number];

const DOC_MIME_TYPES = new Set([
  "application/pdf",
  "application/msword",
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  "application/vnd.ms-excel",
  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  "application/vnd.ms-powerpoint",
  "application/vnd.openxmlformats-officedocument.presentationml.presentation",
]);

export const HOMEWORK_FILE_ICON: Record<string, string> = {
  pdf: "📄", doc: "📝", docx: "📝", xls: "📊", xlsx: "📊", ppt: "📽️", pptx: "📽️",
};

function getExt(filename: string): string {
  return filename.split(".").pop()?.toLowerCase() ?? "";
}

export function isDocExt(value: string): value is HomeworkDocExt {
  return (DOC_EXTENSIONS as readonly string[]).includes(value);
}

// Classifies a picked File for the homework upload widget.
export function classifyHomeworkFile(file: File): { isImage: boolean; isDoc: boolean; ext: string } {
  const isImage = file.type.startsWith("image/");
  const ext = getExt(file.name);
  const isDoc = DOC_MIME_TYPES.has(file.type) || isDocExt(ext);
  return { isImage, isDoc, ext: isDocExt(ext) ? ext : "pdf" };
}

// Derives a stored file_type ("image" or a doc extension) from an uploaded file's public URL.
export function fileTypeFromUrl(url: string): string {
  const clean = url.split("?")[0];
  const ext = clean.split(".").pop()?.toLowerCase() ?? "";
  if (["jpg", "jpeg", "png", "gif", "webp"].includes(ext)) return "image";
  return isDocExt(ext) ? ext : "file";
}
