import Foundation

struct UserAbout: Decodable {
    let storageQuota: StorageQuota
    let user: UserGL
}

struct UserGL: Decodable {
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



