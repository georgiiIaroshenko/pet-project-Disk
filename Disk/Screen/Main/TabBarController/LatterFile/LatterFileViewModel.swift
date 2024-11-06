
import UIKit

class LatterFileViewModel: GoogleDriveRequest {
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var files: [Files] = []
    @Published private(set) var error: Error?
    var onFilesUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    var coordinator: LatterFileCoordinator
    
    required init(coordinator: LatterFileCoordinator?) {
        self.coordinator = coordinator!
    }
    
    func requestAllFile() {
            guard !isLoading else { return }
            isLoading = true
            requestsAllFile(nameStorage: .google) { result in
                self.isLoading = false
                switch result {
                case .success(let newFile):
                    self.files = newFile
                case .failure(let error):
                    self.error = error
                }
            }
        }
    
    
    func nameMenuCell(indexPath: IndexPath) -> String {
        guard files.indices.contains(indexPath.item) else { return "" }
        let nameService = files[indexPath.item].name
        return nameService
    }
    
    func massiveGoogleFileMainCell(indexPath: IndexPath) -> [GoogleFile] {
        guard files.indices.contains(indexPath.item) else { return [] }
        let groups = files[indexPath.item].googleFile
        return groups
    }
    
    func massiveFiles() -> Int {
        return files.count
    }
}

