//
//  AllFileCoordinator.swift
//  Disk
//
//  Created by Георгий on 07.08.2024.
//
//
//import Foundation
//
//class AllFileCoordinator: Coordinator {
//    
//    private let factory = ScreenFactory.self
//
//    override func start() {
//        showAllFile()
//    }
//    
//    override func startDeteil(idFile: String, nameFile: String, mimeType: String, webContentLink: String?) {
////        showOpenFile(idFile: idFile, nameFile: nameFile, mimeType: mimeType)
//    }
//    
//    override func finish() {
//        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
//        print("AppCoordinator - AllFile - finish!")
//    }
//}
//
//private extension AllFileCoordinator {
//    func showAllFile() {
//        let vc = factory.makeAllFileScreen(coordinator: self)
//        navicationController?.pushViewController(vc, animated: false)
//    }
//    
//    func showOpenFile(idFile: String, nameFile: String, mimeType: String) {
//        let vc = OpenFileViewController.createNaviObject()
////        let viewModel = OpenFileViewModel(idFile: idFile, nameFile: nameFile, coordinator: self, mimeType: mimeType)
//        vc.openFileViewModel = viewModel
//        navicationController?.pushViewController(vc, animated: true)
//    }
//}
