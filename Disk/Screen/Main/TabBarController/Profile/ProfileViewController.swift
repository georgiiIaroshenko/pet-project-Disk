import UIKit
import DGCharts

class ProfileViewController: UIViewController, Storyboardable, ActivityViewFullScreen {
    
    @IBOutlet weak var publicFile: UIButton!
    @IBOutlet weak var yandexAuth: UIButton!
    @IBOutlet weak var appleAuth: UIButton!
    @IBOutlet weak var googleAuth: UIButton!
    @IBOutlet weak var stackButtomAuth: UIStackView!
    @IBOutlet weak var imageViewGoogleUser: UIImageView!
    @IBOutlet weak var pieCollectionView: UICollectionView!
    @IBOutlet weak var menuPieCollectionView: UICollectionView!
    private var selectedGroupIndex = 0

        
    var profileViewModel: ProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        loadProfileData()
    }
    
    // MARK: - Setup Methods
    
    func setupUI() {
        setupNavigationBar()
//        setupCharts()
        setupPublicFile()
        setupStackButtomAuth()
        setupImageViewGoogleUser()
        setupConstraints()
        applyShadows()
        publicFile.setTitle("Опубликованые файлы", for: .normal)
    }
    //MARK: - Setup Menu CollectionView

    func setupMenuPieCollectionView() {
        view.addSubview(menuPieCollectionView)
        menuPieCollectionView.backgroundColor = .white
        menuPieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        menuPieCollectionView.dataSource = self
        menuPieCollectionView.delegate = self
        menuPieCollectionView.register(MenuPieCollectionViewCell.self, forCellWithReuseIdentifier: "\(MenuPieCollectionViewCell.self)")
    }
    //MARK: - Setup Main CollectionView
    func setupPieCollectionView() {
        view.addSubview(pieCollectionView)
        pieCollectionView.backgroundColor = .white
        pieCollectionView.dataSource = self
        pieCollectionView.delegate = self
        pieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pieCollectionView.register(PieCollectionViewCell.self, forCellWithReuseIdentifier: "\(PieCollectionViewCell.self)")
    }
    
//    func setupCharts() {
//        view.addSubview(pieChart)
//        pieChart.translatesAutoresizingMaskIntoConstraints = false
//        pieChart.holeColor = UIColor.clear
//        pieChart.transparentCircleColor = UIColor.clear
//        pieChart.chartDescription.enabled = false
//        pieChart.legend.enabled = false
//        pieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeInCubic)
//        updateChartData()
//    }
    
    func setupNavigationBar() {
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "person.fill.xmark"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(rightNavigationBarButtonAction))
        rightButton.tintColor = .darkGray
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.title = "Профиль"
    }
    
    func setupStackButtomAuth() {
        view.addSubview(stackButtomAuth)
        stackButtomAuth.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupPublicFile() {
        view.addSubview(publicFile)
        publicFile.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupImageViewGoogleUser() {
        view.addSubview(imageViewGoogleUser)
        imageViewGoogleUser.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Constraints
    
    func setupConstraints() {
        pieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(5)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(360)
        }
        
        menuPieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pieCollectionView.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        publicFile.snp.makeConstraints { make in
            make.top.equalTo(menuPieCollectionView.snp.bottom).offset(50)
            make.left.equalTo(16)
            make.centerX.equalToSuperview()
        }
        
        stackButtomAuth.snp.makeConstraints { make in
            make.top.equalTo(publicFile.snp.bottom).offset(25)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        imageViewGoogleUser.snp.makeConstraints { make in
            make.top.equalTo(stackButtomAuth.snp.bottom).offset(25)
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
    
//    // MARK: - Data Loading
//    
//    func loadProfileData() {
//        showActivityIndicator(view: self.view)
//        profileViewModel?.requestAbout(imageViewGoogleUser: imageViewGoogleUser) {
//            DispatchQueue.main.async {
//                self.updateChartData()
//                self.hideActivityIndicator()
//            }
//        }
//    }

//    // MARK: - Helper Methods
//    
//    func createCenterText(fullSize: String?) -> NSAttributedString {
//        let fullSizeText = fullSize ?? "Общий размер"
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .center
//        
//        return NSAttributedString(
//            string: fullSizeText,
//            attributes: [
//                .foregroundColor: UIColor.black,
//                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
//                .paragraphStyle: paragraphStyle
//            ]
//        )
//    }
    
    func applyShadows() {
        [publicFile, stackButtomAuth, imageViewGoogleUser].forEach { $0?.applyShadow() }
    }
    
    // MARK: - Actions
    
    @objc func rightNavigationBarButtonAction() {
        profileViewModel?.rightNavigationBarButtonAction(viewController: self)
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuPieCollectionView {
            //   SETUP MENU CollectionView
            let group = profileViewModel!.massiveStorage
            return group()
        } else
        //   SETUP MAIN CollectionView
        {
            let group = profileViewModel!.massiveStorage
            return group()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuPieCollectionView {
            //   SETUP MENU CollectionView
            guard let menuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MenuPieCollectionViewCell.self)", for: indexPath) as? MenuPieCollectionViewCell else {
                return UICollectionViewCell()
            }
            let nameCell = profileViewModel!.nameMenuCell(indexPath: indexPath)
            menuCell.setupNameService(nameService: nameCell)
            return menuCell
        } else {
            //   SETUP MAIN CollectionView
            guard let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PieCollectionViewCell.self)", for: indexPath) as? PieCollectionViewCell else {
                return UICollectionViewCell()
            }
//            let massiveGoogleFile = latterFileViewModel.massiveGoogleFileMainCell(indexPath: indexPath)
            mainCell.setup(pieMassiveViewCell: (profileViewModel?.createPieMassiveViewCell())!)
            
            return mainCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //   SETUP MENU CollectionView
        if collectionView == menuPieCollectionView {
            let groupName = latterFileViewModel.nameMenuCell(indexPath: indexPath)
            let width = groupName.widthOfString(usingFront: UIFont.systemFont(ofSize: 17))
            return CGSize(width: width + 20 , height: collectionView.frame.height )
        } else
        //   SETUP MAIN CollectionView
        {
            return CGSize(width: collectionView.frame.width + 20, height: collectionView.frame.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //   SETUP MENU CollectionView
        if collectionView == menuPieCollectionView {
            return 5
        } else
        //   SETUP MAIN CollectionView
        {
            return 5
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //   SETUP MENU CollectionView
        if collectionView == menuPieCollectionView {
            return 10
        } else
        //   SETUP MAIN CollectionView
        {
            return 10
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //   SETUP MENU CollectionView
        if collectionView == menuPieCollectionView {
            return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
        } else
        //   SETUP MAIN CollectionView
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //   SETUP MENU CollectionView
        if collectionView == menuPieCollectionView {
            selectedGroupIndex = indexPath.item
            menuPieCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            menuPieCollectionView.reloadData()
            pieCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //   SETUP MENU CollectionView
        if scrollView == pieCollectionView {
            let cells = pieCollectionView.visibleCells
            if let cell = cells.first, let indexPath = pieCollectionView.indexPath(for: cell) {
                selectedGroupIndex = indexPath.item
                menuPieCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                menuPieCollectionView.reloadData()
            }
        }
    }
}
