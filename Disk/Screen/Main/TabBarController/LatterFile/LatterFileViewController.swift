
import UIKit

class LatterFileViewController: UIViewController, Storyboardable, ShowAlert, ActivityViewFullScreen {
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    private var activityIndicator: UIActivityIndicatorView!
    private var selectedGroupIndex = 0

    var latterFileViewModel: LatterFileViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        navigationController?.navigationBar.tintColor = .gray
        navigationItem.title = "Последнее"
        setupMainColletionView()
        setupMenuColletionView()
        setupConstraints()
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showActivityIndicator(view: self.view)
        self.latterFileViewModel.requestAllFile(collecrion: self.menuCollectionView){ [unowned self] in
            DispatchQueue.main.async { [unowned self] in
                menuCollectionView.reloadData()
                mainCollectionView.reloadData()
                hideActivityIndicator()
            }
        }
        menuCollectionView.reloadData()
    }

    //MARK: - Setup Menu CollectionView
    func setupMenuColletionView() {
        view.addSubview(menuCollectionView)
        menuCollectionView.backgroundColor = .red
        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "\(MenuCollectionViewCell.self)")
    }
    //MARK: - Setup Main CollectionView
    func setupMainColletionView() {
        view.addSubview(mainCollectionView)
        mainCollectionView.backgroundColor = .blue
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "\(MainCollectionViewCell.self)")
    }
    
    //MARK: - Setup Constraints
    func setupConstraints() {
        menuCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.left.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(50)
        }
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(menuCollectionView.snp_bottomMargin).inset(-20)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.left.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
    }
}

    //MARK: - Setup All CollectionView Delegate
extension LatterFileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuCollectionView {
            //   SETUP MENU CollectionView
            let group = latterFileViewModel.massiveFiles
            return group()
        } else 
            //   SETUP MAIN CollectionView
        {
            let group = latterFileViewModel.massiveFiles
            return group()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView {
            //   SETUP MENU CollectionView
            guard let menuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MenuCollectionViewCell.self)", for: indexPath) as? MenuCollectionViewCell else {
                return UICollectionViewCell()
            }
            let nameCell = latterFileViewModel.nameMenuCell(indexPath: indexPath)
            menuCell.setupNameService(nameService: nameCell)
            return menuCell
        } else {
            //   SETUP MAIN CollectionView
            guard let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MainCollectionViewCell.self)", for: indexPath) as? MainCollectionViewCell else {
                return UICollectionViewCell()
            }
            let massiveGoogleFile = latterFileViewModel.massiveGoogleFileMainCell(indexPath: indexPath)
            mainCell.setup(massiveGoogleFile: massiveGoogleFile, coordinator: latterFileViewModel.coordinator)
            
            return mainCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //   SETUP MENU CollectionView
        if collectionView == menuCollectionView {
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
        if collectionView == menuCollectionView {
            return 5
        } else 
        //   SETUP MAIN CollectionView
        {
            return 5
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //   SETUP MENU CollectionView
        if collectionView == menuCollectionView {
            return 10
        } else 
        //   SETUP MAIN CollectionView
        {
            return 10
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //   SETUP MENU CollectionView
        if collectionView == menuCollectionView {
            return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
        } else 
        //   SETUP MAIN CollectionView
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //   SETUP MENU CollectionView
        if collectionView == menuCollectionView {
            selectedGroupIndex = indexPath.item
            menuCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            menuCollectionView.reloadData()
            mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //   SETUP MENU CollectionView
        if scrollView == mainCollectionView {
            let cells = mainCollectionView.visibleCells
            if let cell = cells.first, let indexPath = mainCollectionView.indexPath(for: cell) {
                selectedGroupIndex = indexPath.item
                menuCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                menuCollectionView.reloadData()
            }
        }
    }
}
//MARK: - Adjusting cell size to fit text size
extension String {
    func widthOfString(usingFront front: UIFont) -> CGFloat {
        let frontAttributes = [NSAttributedString.Key.font: front]
        let size = (self as NSString).size(withAttributes: frontAttributes)
        
        return ceil(size.width)
    }
    
    
}
