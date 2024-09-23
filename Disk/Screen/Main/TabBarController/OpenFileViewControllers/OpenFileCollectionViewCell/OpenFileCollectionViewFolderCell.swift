//
//  OpenFileCollectionViewFolderCell.swift
//  Disk
//
//  Created by Георгий on 23.08.2024.
//

import UIKit

class OpenFileCollectionViewFolderCell: UICollectionViewCell, ImageRequestProtocol {
    
    private let tableView = UITableView()
    private var coordinator: LatterFileCoordinator?
    private var files: [GoogleFile]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white

        let nib = UINib(nibName: "CastomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CastomTableViewCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(files: [GoogleFile], coordinator: LatterFileCoordinator?) {
        self.files = files
        self.coordinator = coordinator
        self.tableView.reloadData()
    }
}

extension OpenFileCollectionViewFolderCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastomTableViewCell") as? CastomTableViewCell,
              let file = files?[indexPath.row] else {
            return UITableViewCell()
        }
        Task {
            await configureCell(cell, with: file)
        }
        
        return cell
    }
    
    private func configureCell(_ cell: CastomTableViewCell, with file: GoogleFile) async {
        cell.nameLabel.text = file.name
        
        let date = ChangeDate(dateString: file.modifiedTime ?? "").changeDate()
        let weight = file.size.map { ConvertWeight(sizeString: $0).convertWeight() } ?? ""
        cell.weightDataTimeLabel.text = "\(weight) \(date)"
        
        if let iconLink = file.iconLink {
            do {
                let data = try await universalGetImage(stringURL: iconLink)
                DispatchQueue.main.async {
                    cell.optionImage.image = UIImage(data: data)
                }
            } catch {
                DispatchQueue.main.async {
                    cell.optionImage.image = UIImage(systemName: "questionmark")
                }
            }
        } else {
            cell.optionImage.image = UIImage(systemName: "questionmark")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let file = files?[indexPath.row],
              let idFile = file.id,
              let nameFile = file.name,
              let mimeType = file.mimeType else {
            return
        }
        handleFileSelection(file, idFile: idFile, nameFile: nameFile, mimeType: mimeType, webContentLink: file.webContentLink)
    }
    
    private func handleFileSelection(_ file: GoogleFile, idFile: String, nameFile: String, mimeType: String, webContentLink: String?) {
        
        switch  file.mimeType {
        case .none:
            return
        case .some(let mime):
            switch mime {
            case _ where MIMEType.isFolderType(file.mimeType!):
                coordinator?.startDeteil(idFile: idFile, nameFile: nameFile, mimeType: mimeType, webContentLink: nil)
            default:
                coordinator?.startDeteil(idFile: idFile, nameFile: nameFile, mimeType: mimeType, webContentLink: webContentLink)
            }
        }
    }
}
