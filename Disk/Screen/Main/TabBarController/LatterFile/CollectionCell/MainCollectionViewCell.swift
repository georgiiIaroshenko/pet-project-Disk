//
//  MainCollectionViewCell.swift
//  Disk
//
//  Created by Георгий on 17.08.2024.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell, ImageRequestProtocol {
    
    private var tableView = UITableView()
    private var files: [GoogleFile]?
    private var coordinator: LatterFileCoordinator!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        self.contentView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: "CastomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CastomTableViewCell")
        tableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func setup(massiveGoogleFile: [GoogleFile], coordinator: LatterFileCoordinator) {
        self.files = massiveGoogleFile
        self.coordinator = coordinator
        self.tableView.reloadData()
    }
}

extension MainCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
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
        Task {
            do {
                let data = try await universalGetImage(stringURL: file.iconLink! )
                DispatchQueue.main.async {
                    cell.optionImage.image = UIImage(data: data)
                }
            } catch {
                DispatchQueue.main.async {
                    cell.optionImage.image = UIImage(systemName: "questionmark")
                }
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idFile = files![indexPath.item].id
        let nameFile = files![indexPath.item].name
        let mimeType = files![indexPath.item].mimeType
        let webContentLink = files![indexPath.item].webContentLink ?? ""
        coordinator.startDeteil(idFile: idFile!, nameFile: nameFile!, mimeType: mimeType!, webContentLink: webContentLink)
    }
}

