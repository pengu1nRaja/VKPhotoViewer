//
//  MainViewController.swift
//  VKPhotoViewer
//
//  Created by PenguinRaja on 25.07.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private var authService: AuthService!
    
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var mainTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        authService = SceneDelegate.shared().authService
        mainViewSetup()
    }
    
    @IBAction func logInActionButton(_ sender: UIButton) {
        authService.wakUpSession()
    }
    
    func mainViewSetup() {

        logInButton.backgroundColor = .black
        logInButton.setTitle("Вход через VK", for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.layer.cornerRadius = 10
        
        mainTitleLabel.text = "Mobile Up \nGallery"
        mainTitleLabel.numberOfLines = 2
        
    }
    
}
