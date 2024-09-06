
import UIKit

class LatterFileViewModel {
    
    var googleUser: GoogleUserStruct?
    var file: [Files]?
    
    var coordinator: LatterFileCoordinator
    
    required init(coordinator: LatterFileCoordinator?) {
        self.coordinator = coordinator!
    }
    
    func requestAllFile(collection: UICollectionView,complited:@escaping () -> ()) {
        
        GoogleRequest.shared.requestsAllFile(nameStorage: .google) { result in
            switch result {
            case .success(let newFile):
                self.file = newFile
                complited()
            case .failure(let error):
                print(" User error \(error)")
            }
        }
    }
    
    
    func nameMenuCell(indexPath: IndexPath) -> String {
        let nameService = file![indexPath.item].name
        return nameService
    }
    
    func massiveGoogleFileMainCell(indexPath: IndexPath) -> [GoogleFile] {
        let groups = file![indexPath.item].googleFile
        return groups
    }
    
    func massiveFiles() -> Int {
        return file?.count ?? 0
    }
}

