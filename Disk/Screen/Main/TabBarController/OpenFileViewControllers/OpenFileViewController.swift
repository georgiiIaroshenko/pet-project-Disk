
import Foundation
import UIKit

class OpenFileViewController: UIViewController, Storyboardable, ActivityViewFullScreen, ShowAlert {
    
    // MARK: - UI Components
    var collectionView: UICollectionView!
    var shareButton: UIButton!
    var deleteButton: UIButton!
    var rightBarButtonRename: UIButton!
    
    // MARK: - ViewModel
    var openFileViewModel: OpenFileViewModel?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = openFileViewModel?.nameFile
        showActivityIndicator(view: self.view)
        configureView() // Настройка интерфейса
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showActivityIndicator(view: self.view)
        refreshView() // Обновление данных
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAudioPlaybackIfNeeded() // Остановка воспроизведения аудио при исчезновении экрана
    }
    
    // MARK: - View Setup
    
    /// Настройка всего интерфейса
    private func configureView() {
        guard let viewModel = openFileViewModel else { return }
        showActivityIndicator(view: self.view)

        switch viewModel.mimeType {
        case _ where MIMEType.isFolderType(viewModel.mimeType): // Если MIME тип - папка
            viewModel.requestFolderFileId { [weak self] in
                DispatchQueue.main.async {
                    self?.setupCollectionView() // Настройка коллекции
                    self?.setupRightBarButtonRename() // Настройка кнопки редактирования
                    self?.hideActivityIndicator() // Скрытие индикатора загрузки
                }
            }
        default: // Все остальные типы файлов
            setupCollectionView() // Настройка коллекции
            setupShareButton() // Настройка кнопки "Поделиться"
            setupRightBarButtonRename() // Настройка кнопки редактирования
            setupDeleteButton() // Настройка кнопки удаления
        }
    }
    
    /// Обновление данных на экране
    private func refreshView() {
        guard let viewModel = openFileViewModel,
              MIMEType.isFolderType(viewModel.mimeType) else {
            hideActivityIndicator()
            return
        }
        
        viewModel.requestFolderFileId { [weak self] in
            DispatchQueue.main.async {
                self?.hideActivityIndicator() // Скрытие индикатора загрузки
            }
        }
    }
    
    // MARK: - Button Setup
    
    /// Универсальный метод создания кнопки
    private func createButton(imageName: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    /// Настройка кнопки "Поделиться"
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
    
    /// Настройка кнопки удаления
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
    
    /// Настройка кнопки редактирования
    func setupRightBarButtonRename() {
        rightBarButtonRename = UIButton(type: .custom)
        rightBarButtonRename.contentMode = .scaleAspectFit
        rightBarButtonRename.setImage(UIImage(systemName: "pencil"), for: .normal)
        rightBarButtonRename.tintColor = .systemGray
        rightBarButtonRename.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionRightBarButtonRename)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonRename)
    }
    
    // MARK: - Button Actions
    
    @objc func actionShareButton() {
        openFileViewModel?.actionShareButton(viewController: self)
    }
    
    @objc func actionRightBarButtonRename() {
        openFileViewModel?.renameActionRightBarButton(navigationItem: navigationItem, viewController: self)
    }
    
    @objc func deleteItem() {
        openFileViewModel?.deleteGoogleFile(navigationItem: navigationItem, viewController: self)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - CollectionView Setup
    
    /// Настройка коллекции для отображения файлов
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        
        // Регистрация ячеек для различных типов файлов
        collectionView.register(OpenFileCollectionViewImageCell.self, forCellWithReuseIdentifier: "\(OpenFileCollectionViewImageCell.self)")
        collectionView.register(OpenFileCollectionViewFolderCell.self, forCellWithReuseIdentifier: "\(OpenFileCollectionViewFolderCell.self)")
        collectionView.register(OpenFileCollectionViewAudioCell.self, forCellWithReuseIdentifier: "\(OpenFileCollectionViewAudioCell.self)")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    /// Настройка лейаута для CollectionView
    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.bounds.width, height: view.bounds.height)
        return layout
    }
    
    // MARK: - Helper Methods
    
    /// Остановка воспроизведения аудио, если ячейка содержит аудиофайл
    private func stopAudioPlaybackIfNeeded() {
        for cell in collectionView.visibleCells {
            if let audioCell = cell as? OpenFileCollectionViewAudioCell {
                audioCell.stopPlaying()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource Implementation

extension OpenFileViewController: UICollectionViewDataSource {
    
    /// Количество ячеек в секции (здесь всегда 1)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    /// Настройка ячейки в зависимости от MIME-типа файла
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = openFileViewModel else {
            return UICollectionViewCell()
        }
        
        let cellIdentifier: String
        
        // Определение типа ячейки по MIME типу
        switch viewModel.mimeType {
        case _ where MIMEType.isFolderType(viewModel.mimeType):
            cellIdentifier = "\(OpenFileCollectionViewFolderCell.self)"
        case _ where MIMEType.isAudioType(viewModel.mimeType):
            cellIdentifier = "\(OpenFileCollectionViewAudioCell.self)"
        default:
            cellIdentifier = "\(OpenFileCollectionViewImageCell.self)"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        // Настройка ячеек в зависимости от их типа
        if let folderCell = cell as? OpenFileCollectionViewFolderCell {
            guard let file = viewModel.file else { return UICollectionViewCell() }
            folderCell.setup(files: file, coordinator: viewModel.coordinator)
        } else if let imageCell = cell as? OpenFileCollectionViewImageCell {
            viewModel.requestImageFileId(viewController: self, imageView: imageCell.imageView)
        } else if let audioCell = cell as? OpenFileCollectionViewAudioCell {
            Task {
                await viewModel.requestAudioFileId(viewController: self) { result in
                    guard collectionView.indexPath(for: audioCell) == indexPath else { return }
                    switch result {
                    case .success(let data):
                        audioCell.setup(audioData: data)
                        DispatchQueue.main.async {
                            self.hideActivityIndicator()
                        }
                    case .failure(let error):
                        self.showErrorAlert(viewController: self, message: error)
                    }
                }
            }
        }
        
        return cell
    }
}

