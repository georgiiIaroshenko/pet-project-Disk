


enum MIMEType {
    static let folder = "application/vnd.google-apps.folder"
    static let snapshot = "application/vnd.google-apps.snapshot"
    static let audio = "audio/mp3"
    static let audio1 = "audio/wav"

}
protocol MimeType {
    func mimeTypeCategory(for mimeTypeString: String) -> MimeTypeCategory
}
extension MimeType {
    func mimeTypeCategory(for mimeTypeString: String) -> MimeTypeCategory {
        if let imageType = MimeTypeImage(rawValue: mimeTypeString) {
            return .image(imageType)
        } else if let videoType = MimeTypeVideo(rawValue: mimeTypeString) {
            return .video(videoType)
        } else if let documentType = MimeTypeDocument(rawValue: mimeTypeString) {
            return .document(documentType)
        } else {
            return .other(mimeTypeString)
        }
    }
}


enum MimeTypeCategory {
    case image(MimeTypeImage)
    case video(MimeTypeVideo)
    case document(MimeTypeDocument)
    case other(String)
    
    var mimeTypeString: String {
        switch self {
        case .image(let mimeType): return mimeType.rawValue
        case .video(let mimeType): return mimeType.rawValue
        case .document(let mimeType): return mimeType.rawValue
        case .other(let mimeType): return mimeType
        }
    }
}

// Вложенные enum для каждой категории
enum MimeTypeImage: String {
    case png = "image/png"
    case jpeg = "image/jpeg"
    case googlePhoto = "application/vnd.google-apps.photo"
}

enum MimeTypeVideo: String {
    case mkv = "video/mkv"
    case mp4 = "video/mp4"
}

enum MimeTypeDocument: String {
    case pdf = "application/pdf"
    case word = "application/msword"
    case googleDoc = "application/vnd.google-apps.document"
}

//func mimeTypeCategory(for mimeTypeString: String) -> MimeTypeCategory {
//    if let imageType = MimeTypeImage(rawValue: mimeTypeString) {
//        return .image(imageType)
//    } else if let videoType = MimeTypeVideo(rawValue: mimeTypeString) {
//        return .video(videoType)
//    } else if let documentType = MimeTypeDocument(rawValue: mimeTypeString) {
//        return .document(documentType)
//    } else {
//        return .other(mimeTypeString)
//    }
//}
