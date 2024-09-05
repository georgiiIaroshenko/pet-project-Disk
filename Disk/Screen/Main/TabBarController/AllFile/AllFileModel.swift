
import Foundation

struct GoogleStructeFileList: Decodable {
    let nextPageToken: String?
    let files: [GoogleFile]
}

struct GoogleFile: Decodable {
    let id: String?
    let name: String?
    let mimeType: String?
    let size: String?
    let thumbnailLink: String?
    let iconLink: String?
    let modifiedTime: String?
    let viewedByMeTime: String?
    let webContentLink: String?
}

struct FileAbout: Decodable {
    let size: String?
    let iconLink: String?
    let name: String?
    let createdTime: String?
    let modifiedByMeTime: String?
    let viewedByMeTime: String?
}
