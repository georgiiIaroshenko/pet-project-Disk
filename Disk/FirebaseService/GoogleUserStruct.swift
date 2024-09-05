
import Foundation

struct GoogleUserStruct: Identifiable {
    var id: String
    var repositories: Storage
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        
        return repres
    }
}
    struct Storage {
        var nameStorage: String
        var accessToken: String
        var refreshToken: String
        var idAccessToken: String
        
        var representation: [String: Any] {
            var repres = [String: Any]()
            repres["accessToken"] = self.accessToken
            repres["refreshToken"] = self.refreshToken
            repres["idAccessToken"] = self.idAccessToken

            
            return repres
        }
    }
