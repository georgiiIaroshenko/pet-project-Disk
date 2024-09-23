
enum MIMEType {
    //MARK: - Списки форматов
    // Папки
    private static let folderTypes: [String] = [
        "application/vnd.google-apps.folder",
        "application/vnd.google-apps.snapshot"
    ]
    
    // Аудио форматы
    private static let audioTypes: [String] = [
        "audio/mp3",
        "audio/wav",
        "audio/mpeg",
        "audio/aac",
        "audio/flac"
    ]
    
    // Видео форматы
    private static let videoTypes: [String] = [
        "video/mp4",
        "video/quicktime",
        "video/x-matroska"
    ]
    
    // Изображения
    private static let imageTypes: [String] = [
        "image/jpeg",
        "image/png",
        "image/gif",
        "image/tiff"
    ]
    // Документы
    private static let documentTypes: [String] = [
        "application/msword",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document", // DOCX
        "application/vnd.ms-excel",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", // XLSX
        "application/vnd.ms-powerpoint",
        "application/vnd.openxmlformats-officedocument.presentationml.presentation", // PPTX
        "text/plain",
        "application/pdf"
    ]
    
    //MARK: - Проверка по категориям
    
    static func isFolderType(_ mimeType: String) -> Bool {
        return folderTypes.contains(mimeType)
    }
    
    static func isAudioType(_ mimeType: String) -> Bool {
        return audioTypes.contains(mimeType)
    }
    
    static func isVideoType(_ mimeType: String) -> Bool {
        return videoTypes.contains(mimeType)
    }
    
    static func isImageType(_ mimeType: String) -> Bool {
        return imageTypes.contains(mimeType)
    }
    
    static func isDocumentType(_ mimeType: String) -> Bool {
        return documentTypes.contains(mimeType)
    }
}
