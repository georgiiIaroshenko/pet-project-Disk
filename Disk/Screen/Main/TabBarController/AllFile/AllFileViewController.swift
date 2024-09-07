//
//import UIKit
//
//class AllFileViewController: UIViewController, Storyboardable {
//    
//    @IBOutlet weak var tableView: UITableView!
//    var activityIndicator: UIActivityIndicatorView!
//
//    var allFileViewModel: AllFileViewModel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(tableView)
//        tableView.delegate = self
//        tableView.dataSource = self
//        let nib = UINib(nibName: "CastomTableViewCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "CastomTableViewCell")
//        
//        setupActivityIndicator()
//        
//        setupConstraints()
//
//        self.allFileViewModel?.requestAllFile(tableView: tableView, activityIndicator: activityIndicator)
//
////        backBarButtonItem = UIButton(type: .custom)
////        backBarButtonItem.contentMode = .scaleAspectFit
////        backBarButtonItem.setImage(UIImage(systemName: "pencil"), for: .normal)
////        backBarButtonItem.tintColor = .systemGray
////        
////        navigationItem.backBarButtonItem = UIBarButtonItem(customView: backBarButtonItem)
//
//        
//                
////        self.tableView.rowHeight = UITableView.automaticDimension
////        tableViewSeach.sectionHeaderHeight = UITableView.automaticDimension
////        tableViewSeach.estimatedSectionHeaderHeight = 1
////        tableViewSeach.register(UINib(nibName: "Header", bundle: nil),
////                                forHeaderFooterViewReuseIdentifier: "Header")
//
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tabBarController?.tabBar.isHidden = false
//        self.allFileViewModel?.requestAllFile(tableView: tableView, activityIndicator: activityIndicator)
//
//    }
//    
//    func setupActivityIndicator() {
//        activityIndicator = UIActivityIndicatorView()
//        activityIndicator.style = .large
//        activityIndicator.backgroundColor = .white
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(activityIndicator)
//        
//    }
//    
//    func setupConstraints() {
//        tableView.snp.makeConstraints { make in
//            make.top.leftMargin.rightMargin.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
//        activityIndicator.snp.makeConstraints { make in
//            make.top.leftMargin.rightMargin.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
//    
//}
//
//extension AllFileViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        allFileViewModel.numberOfRowsInSection(section: section)
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//    }
//
//extension AllFileViewController: UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        allFileViewModel.cellForRowAt(tableView: tableView, indexPath: indexPath)
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let idFile = allFileViewModel.fileID(indexPath: indexPath)
//        let nameFile = allFileViewModel.fileName(indexPath: indexPath)
//        let mimeType = allFileViewModel.mimeType(indexPath: indexPath)
//        allFileViewModel.openIDFile(idFile: idFile, nameFile: nameFile, mimeType: mimeType)
//        }
//    }
//
