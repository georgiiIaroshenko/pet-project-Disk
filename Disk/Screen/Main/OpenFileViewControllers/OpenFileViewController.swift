//
//  OpenFileViewController.swift
//  Disk
//
//  Created by Георгий on 04.08.2024.
//

import Foundation
import UIKit

class OpenFileViewController: UIViewController, Storyboardable {
    
    var collectionView: UICollectionView!
    var shareButtom: UIButton!
    var deleteButtom: UIButton!
    var rightBarButtonReName: UIButton!
    
    var openFileViewModel: OpenFileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = openFileViewModel?.nameFile
        ActivityFactory.shared.showActivityIndicator(in: self.view)
        switch openFileViewModel?.mimeType {
        case .none:
            break
        case .some(let mime):
            switch mime {
            case "application/vnd.google-apps.folder":
                openFileViewModel!.requestFolderFileId(){
                    DispatchQueue.main.async { [unowned self] in
                        setupCollectionView()
                        setupRightBarButtonReName()
                        view.backgroundColor = .white
                        ActivityFactory.shared.hideActivityIndicator()
                    }
                }
            default:
                setupCollectionView()
                setupShareButtom()
                setupRightBarButtonReName()
                setupDeleteButtom()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ActivityFactory.shared.showActivityIndicator(in: self.view)
        switch openFileViewModel?.mimeType {
        case .none:
            break
        case .some(let mime):
            switch mime {
            case "application/vnd.google-apps.folder":
                openFileViewModel!.requestFolderFileId(){
                    DispatchQueue.main.async { [unowned self] in
                        ActivityFactory.shared.hideActivityIndicator()
                    }
                }
            default: break
            }
        }
    }
    


    
    func setupShareButtom() {
        shareButtom = UIButton()
        view.addSubview(shareButtom)
        shareButtom.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButtom.tintColor = .systemGray
        shareButtom.addTarget(self, action: #selector(actionShareButtom), for: .touchDown)
        
        shareButtom.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButtom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            shareButtom.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 54),
            shareButtom.widthAnchor.constraint(equalToConstant: 26),
            shareButtom.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    @objc func actionShareButtom() {
        openFileViewModel!.actionShareButton(viewController: self)
    }
    
    func setupRightBarButtonReName() {
        rightBarButtonReName = UIButton(type: .custom)
        rightBarButtonReName.contentMode = .scaleAspectFit
        rightBarButtonReName.setImage(UIImage(systemName: "pencil"), for: .normal)
        rightBarButtonReName.tintColor = .systemGray
        rightBarButtonReName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionRightBarButtomReName)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonReName)
    }
    
    @objc func actionRightBarButtomReName() {
        openFileViewModel!.renameActionRightBarButton(navigationItem: navigationItem, viewController: self)
    }
    
    func setupDeleteButtom() {
        deleteButtom = UIButton()
        view.addSubview(deleteButtom)
        deleteButtom.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButtom.tintColor = .systemGray
        deleteButtom.addTarget(self, action: #selector(deleteItem), for: .touchDown)
        deleteButtom.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButtom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            deleteButtom.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -54),
            deleteButtom.widthAnchor.constraint(equalToConstant: 26),
            deleteButtom.heightAnchor.constraint(equalToConstant: 26),
        ])
    }
    
    @objc func deleteItem() {
        openFileViewModel?.deleteGoogleFile(navigationItem: navigationItem, viewController: self)
        navigationController?.popViewController(animated: true)
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLoyout())
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .black
        collectionView.register(OpenFileCollectionViewImageCell.self, forCellWithReuseIdentifier: "\(OpenFileCollectionViewImageCell.self)")
        collectionView.register(OpenFileCollectionViewFolderCell.self, forCellWithReuseIdentifier: "\(OpenFileCollectionViewFolderCell.self)")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupFlowLoyout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.bounds.width, height: view.bounds.height)
        return layout
    }
}

extension OpenFileViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch openFileViewModel?.mimeType {
        case .none:
            return UICollectionViewCell()
        case .some(let mime):
            switch mime {
            case "application/vnd.google-apps.folder","application/vnd.google-apps.snapshot":
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(OpenFileCollectionViewFolderCell.self)", for: indexPath) as? OpenFileCollectionViewFolderCell else {
                    return UICollectionViewCell()
                }
                cell.setup(files: (self.openFileViewModel?.file)!, coordinator: self.openFileViewModel!.coordinator)
                return cell
                
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(OpenFileCollectionViewImageCell.self)", for: indexPath) as? OpenFileCollectionViewImageCell else {
                    return UICollectionViewCell()
                }
                openFileViewModel?.requestOneFileId(viewController: self, imageView: cell.imageView)
                return cell
            }
        }
    }
}
