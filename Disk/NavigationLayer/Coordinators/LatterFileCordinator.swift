//
//  LatterCordinator.swift
//  Disk
//
//  Created by Георгий on 07.08.2024.
//

import Foundation

class LatterFileCoordinator: Coordinator {
    
    private let factory = ScreenFactory.self

    override func start() {
        showLatterFile()
    }
    
    override func startDeteil(idFile: String, nameFile: String, mimeType: String, webContentLink: String?) {
        showOpenFile(idFile: idFile, nameFile: nameFile, mimeType: mimeType, webContentLink: webContentLink)
    }
    
    override func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        print("AppCoordinator - LatterFile - finish!")
    }
}

private extension LatterFileCoordinator {
    func showLatterFile() {
        let vc = factory.makeLatterFileScreen(coordinator: self)
        navicationController?.pushViewController(vc, animated: false)
    }
    func showOpenFile(idFile: String, nameFile: String, mimeType: String, webContentLink: String?) {
        let vc = OpenFileViewController.createNaviObject()
        let viewModel = OpenFileViewModel(idFile: idFile, nameFile: nameFile, coordinator: self, mimeType: mimeType, webContentLink: webContentLink)
        vc.openFileViewModel = viewModel
        navicationController?.pushViewController(vc, animated: true)
    }
}
