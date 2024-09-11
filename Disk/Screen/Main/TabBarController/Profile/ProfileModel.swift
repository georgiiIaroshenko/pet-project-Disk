import Foundation

struct FilesAbout: Decodable {
    let nameStorage: String
    let userAbout: UserAbout
}

struct UserAbout: Decodable {
    let storageQuota: StorageQuota
    let user: UserGoogle
}

struct UserGoogle: Decodable {
    let displayName: String
    let kind: String
    let me: Bool
    let permissionId: String
    let emailAddress: String
    let photoLink: String
    
}
struct StorageQuota: Decodable {
    let limit: String
    let usage: String
    let usageInDrive: String
    let usageInDriveTrash: String
}

struct PieMassiveViewCell: Decodable {
    let usedSizeDouble: Double
    let usedSizeString: String
    let freeSizeDouble: Double
    let freeSizeString: String
    let fullSizeString: String
}
