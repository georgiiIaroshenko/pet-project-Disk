
import UIKit
import SwiftUI

class ProfileViewController: UIViewController, Storyboardable {

    @IBOutlet weak var publicFile: UIButton!
    @IBOutlet weak var yandexAuth: UIButton!
    @IBOutlet weak var appleAuth: UIButton!
    @IBOutlet weak var googleAuth: UIButton!
    @IBOutlet weak var stackButtomAuth: UIStackView!
    @IBOutlet weak var imageViewGoogleUser: UIImageView!
    private var activityIndicator: UIActivityIndicatorView!
    
    var profileViewModel: ProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPublicFile()
        setupStackButtomAuth()
        setupImageViewGoogleUser()
        setupConstraints()
        setupNavigationBar()

        print("Скачиваю файлы")
        publicFile.setTitle("Опубликованые файлы", for: .normal)
        
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
        profileViewModel?.requestAbout(imageViewGoogleUser: imageViewGoogleUser)
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
        publicFile.snp.makeConstraints { make in
            make.top.equalTo(500)
            make.left.equalTo(16)
            make.centerX.equalToSuperview()
        }
        
        stackButtomAuth.snp.makeConstraints { make in
            make.top.equalTo(publicFile.snp_bottomMargin).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.centerX.equalToSuperview()
        }
        imageViewGoogleUser.snp.makeConstraints { make in
            make.top.equalTo(stackButtomAuth.snp_bottomMargin).offset(32)
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
}

