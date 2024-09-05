//
//  OpenFileCollectionViewFolderCell.swift
//  Disk
//
//  Created by Георгий on 23.08.2024.
//

import UIKit

class OpenFileCollectionViewFolderCell: UICollectionViewCell {
    
    let tableView = UITableView()
    var coordinator: LatterFileCoordinator!
    var files: [GoogleFile]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: "CastomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CastomTableViewCell")
        tableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(files: [GoogleFile], coordinator: LatterFileCoordinator) {
        self.files = files
        self.coordinator = coordinator
        self.tableView.reloadData()
    }
}

extension OpenFileCollectionViewFolderCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CastomTableViewCell") as! CastomTableViewCell
        let file = files![indexPath.item]
        let name = file.name
        cell.nameLabel.text = name
        
        if file.size == nil{
            let date = file.modifiedTime
            let fixDate = ChangeDate.init(dateString: date!).changeDate()
            let weightDataTimeLabel = fixDate
            cell.weightDataTimeLabel.text = weightDataTimeLabel
        } else {
            let weight = ConvertWeight.init(sizeString: file.size ?? "0").convertWeight()
            let date = file.modifiedTime
            let fixDate = ChangeDate.init(dateString: date!).changeDate()
            let weightDataTimeLabel = weight + " " + fixDate
            cell.weightDataTimeLabel.text = weightDataTimeLabel
        }
        UniversalRequest.shared.universalSetImageFromStringrURL(imageView: cell.optionImage, stringURL: file.iconLink! )
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.files?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch  files?[indexPath.item].mimeType {
        case .none:
            return
        case .some(let mime):
            switch mime {
            case "application/vnd.google-apps.folder","application/vnd.google-apps.snapshot":
                guard 
                    let idFile = files?[indexPath.item].id,
                    let nameFile = files?[indexPath.item].name,
                    let mimeType = files?[indexPath.item].mimeType
                else { return }
                coordinator.startDeteil(idFile: idFile, nameFile: nameFile, mimeType: mimeType, webContentLink: nil)
            default:
                guard 
                    let idFile = files?[indexPath.item].id,
                    let nameFile = files?[indexPath.item].name,
                    let mimeType = files?[indexPath.item].mimeType,
                    let webContentLink = files?[indexPath.item].webContentLink
                else { return }
                coordinator.startDeteil(idFile: idFile, nameFile: nameFile, mimeType: mimeType, webContentLink: webContentLink)
            }
        }
    }
}
