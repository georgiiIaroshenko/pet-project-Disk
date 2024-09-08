
import UIKit
import SwiftUI
import DGCharts

class ProfileViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var publicFile: UIButton!
    @IBOutlet weak var yandexAuth: UIButton!
    @IBOutlet weak var appleAuth: UIButton!
    @IBOutlet weak var googleAuth: UIButton!
    @IBOutlet weak var stackButtomAuth: UIStackView!
    @IBOutlet weak var imageViewGoogleUser: UIImageView!
    private var activityIndicator: UIActivityIndicatorView!
    let pieChart = PieChartView()

    
    var profileViewModel: ProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        publicFile.setTitle("Опубликованые файлы", for: .normal)
        
        
    }
    
    func setupCharts() {
        view.addSubview(pieChart)
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        
        var entries: [PieChartDataEntry] = []
        entries.append(PieChartDataEntry(value: (profileViewModel?.usedSpace())!, label: "Используется"))
        entries.append(PieChartDataEntry(value: (profileViewModel?.freeSpace())!, label: "Свободно"))
        pieChart.legend.orientation = .vertical
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = [UIColor.red, UIColor.green]
        
        
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
        let attributedText = NSAttributedString(string: (profileViewModel?.fullSize())!, attributes: attributes)
        
        pieChart.centerAttributedText = attributedText
        
    }
    
    func setupStackButtomAuth() {
        view.addSubview(stackButtomAuth)
        stackButtomAuth.translatesAutoresizingMaskIntoConstraints = false
        
        stackButtomAuth.addSubview(yandexAuth)
        stackButtomAuth.addSubview(appleAuth)
        stackButtomAuth.addSubview(googleAuth)
    }
    
    func setupPublicFile() {
        view.addSubview(publicFile)
        
    }
    
    func setupImageViewGoogleUser() {
        view.addSubview(imageViewGoogleUser)
        imageViewGoogleUser.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        profileViewModel?.requestAbout(imageViewGoogleUser: imageViewGoogleUser) {
            DispatchQueue.main.async {
                self.setupCharts()
                self.setupPublicFile()
                self.setupStackButtomAuth()
                self.setupImageViewGoogleUser()
                self.setupConstraints()
            }
        }
        print("ProfileViewController will appear")
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.xmark"), 
                                                                                          style: .plain,
                                                                                          target: self,
                                                                                          action: #selector(rightNavirationBarButtomAction))
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = .darkGray
        navigationController?.navigationBar.topItem?.title = "Профиль"
    }
    
    @objc func rightNavirationBarButtomAction() {
        profileViewModel?.rightNavirationBarButtomAction(viewController: self)
    }
    
    func setupConstraints() {
        
        pieChart.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).inset(-5)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(350)
        }
        
        publicFile.snp.makeConstraints { make in
            make.top.equalTo(pieChart.snp_bottomMargin).inset(-50)
            make.left.equalTo(16)
            make.centerX.equalToSuperview()
        }
        
        stackButtomAuth.snp.makeConstraints { make in
            make.top.equalTo(publicFile.snp_bottomMargin).inset(-25)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.centerX.equalToSuperview()
        }
        imageViewGoogleUser.snp.makeConstraints { make in
            make.top.equalTo(stackButtomAuth.snp_bottomMargin).inset(-25)
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
}

