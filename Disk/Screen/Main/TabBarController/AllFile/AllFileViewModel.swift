//
//import UIKit
//
//class AllFileViewModel:GoogleDriveRequest, ImageRequestProtocol {
//
//    var googleUser: GoogleUserStruct?
//    var file: [Files]?
//    var coordinator: AllFileCoordinator
//    
//    init(coordinator: AllFileCoordinator) {
//        self.coordinator = coordinator
//    }
//    
//    func numberOfRowsInSection(section: Int) -> Int {
//       return file?.count ?? 0
//    }
//    
//    func cellForRowAt (tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
//        guard let massiveFile = file else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CastomTableViewCell", for: indexPath) as! CastomTableViewCell
//            return cell
//        }
//        let file = massiveFile[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CastomTableViewCell", for: indexPath) as! CastomTableViewCell
//        
//        let name = file.name
//        cell.nameLabel.text = name
//
//        if file.googleFile[indexPath.item].size == nil{
//            let date = file.googleFile[indexPath.item].modifiedTime
//            let fixDate = ChangeDate(dateString: date!).changeDate()
//            let weightDataTimeLabel = fixDate
//            cell.weightDataTimeLabel.text = weightDataTimeLabel
//        } else {
//            let weight = ConvertWeight(sizeString: file.googleFile[indexPath.item].size ?? "0").convertWeight()
//            let date = file.googleFile[indexPath.item].modifiedTime
//            let fixDate = ChangeDate(dateString: date!).changeDate()
//            let weightDataTimeLabel = weight + " " + fixDate
//            cell.weightDataTimeLabel.text = weightDataTimeLabel
//        }
//
//        if file.googleFile[indexPath.item].thumbnailLink == nil {
//            universalGetImage(imageView: cell.optionImage, stringURL: file.googleFile[indexPath.item].iconLink!)
//        } else {
//            universalGetImage(imageView: cell.optionImage, stringURL: file.googleFile[indexPath.item].thumbnailLink!)
//        }
//        return cell
//    }
//    
//    func requestAllFile(tableView: UITableView, activityIndicator: UIActivityIndicatorView) {
//        activityIndicator.startAnimating()
//        requestsAllFile(nameStorage: .google) { result in
//            switch result {
//            case .success(let newFile):
//                self.file?.append(contentsOf: newFile)
//                DispatchQueue.main.async {
//                    tableView.reloadData()
//                    activityIndicator.stopAnimating()
//                }
//            case .failure(let error):
//                print(" User error \(error)")
//            }
//        }
//    }
//    
//    func fileID(indexPath: IndexPath) -> String {
//        let idFile = file![indexPath.section].googleFile[indexPath.item].id
//        return idFile!
//    }
//    
//    func fileName(indexPath: IndexPath) -> String {
//        let idFile = file![indexPath.section].googleFile[indexPath.item].name!
//        return idFile
//    }
//    func mimeType(indexPath: IndexPath) -> String {
//        let idFile = file![indexPath.section].googleFile[indexPath.item].mimeType
//        return idFile!
//    }
//    
//    func openIDFile(idFile: String, nameFile: String, mimeType: String) {
////        self.coordinator.startDeteil(idFile: idFile, nameFile: nameFile, mimeType: mimeType)
//        
//    }
//}
