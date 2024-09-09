//
//  OpenFileViewController.swift
//  Disk
//
//  Created by Георгий on 04.08.2024.
//

import Foundation
import UIKit

class OpenFileViewController: UIViewController, Storyboardable, ActivityViewFullScreen {
    
    var collectionView: UICollectionView!
    var shareButton: UIButton!
    var deleteButton: UIButton!
    var rightBarButtonRename: UIButton!
    
    var openFileViewModel: OpenFileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = openFileViewModel?.nameFile
        showActivityIndicator(view: self.view)
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showActivityIndicator(view: self.view)
        refreshView()
    }
    
    private func configureView() {
        guard let viewModel = openFileViewModel else { return }
        showActivityIndicator(view: self.view)

        switch viewModel.mimeType {
        case MIMEType.folder, MIMEType.snapshot:
            viewModel.requestFolderFileId { [weak self] in
                DispatchQueue.main.async {
                    self?.setupCollectionView()
                    self?.setupRightBarButtonRename()
                    self?.hideActivityIndicator()
                }
            }
        default:
            setupCollectionView()
            setupShareButton()
            setupRightBarButtonRename()
            setupDeleteButton()
        }
    }
    
    private func refreshView() {
        guard let viewModel = openFileViewModel,
              viewModel.mimeType == MIMEType.folder || viewModel.mimeType == MIMEType.snapshot else {
            hideActivityIndicator()
            return
        }
        
        viewModel.requestFolderFileId { [weak self] in
            DispatchQueue.main.async {
                self?.hideActivityIndicator()
            }
        }
    }

    private func createButton(imageName: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    func setupShareButton() {
        shareButton = createButton(imageName: "square.and.arrow.up", action: #selector(actionShareButton))
        view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            shareButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 54),
            shareButton.widthAnchor.constraint(equalToConstant: 26),
            shareButton.heightAnchor.constraint(equalToConstant: 26),
        ])
    }
    
    func setupDeleteButton() {
        deleteButton = createButton(imageName: "trash", action: #selector(deleteItem))
        view.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -54),
            deleteButton.widthAnchor.constraint(equalToConstant: 26),
            deleteButton.heightAnchor.constraint(equalToConstant: 26),
        ])
    }
    
    @objc func actionShareButton() {
        openFileViewModel?.actionShareButton(viewController: self)
    }
    
    func setupRightBarButtonRename() {
        rightBarButtonRename = UIButton(type: .custom)
        rightBarButtonRename.contentMode = .scaleAspectFit
        rightBarButtonRename.setImage(UIImage(systemName: "pencil"), for: .normal)
        rightBarButtonRename.tintColor = .systemGray
        rightBarButtonRename.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionRightBarButtonRename)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonRename)
    }
    
    @objc func actionRightBarButtonRename() {
        openFileViewModel?.renameActionRightBarButton(navigationItem: navigationItem, viewController: self)
    }
    
    @objc func deleteItem() {
        openFileViewModel?.deleteGoogleFile(navigationItem: navigationItem, viewController: self)
        navigationController?.popViewController(animated: true)
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
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
    
    func setupFlowLayout() -> UICollectionViewFlowLayout {
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
        guard let viewModel = openFileViewModel else {
               return UICollectionViewCell()
           }
           let cellIdentifier: String
           switch viewModel.mimeType {
           case MIMEType.folder, MIMEType.snapshot:
               cellIdentifier = "\(OpenFileCollectionViewFolderCell.self)"
           default:
               cellIdentifier = "\(OpenFileCollectionViewImageCell.self)"
           }
           
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
           
           if let folderCell = cell as? OpenFileCollectionViewFolderCell {
               guard let file = viewModel.file else { return UICollectionViewCell() }
               folderCell.setup(files: file, coordinator: viewModel.coordinator)
           } else if let imageCell = cell as? OpenFileCollectionViewImageCell {
               viewModel.requestOneFileId(viewController: self, imageView: imageCell.imageView)
           }
           return cell
    }
}

