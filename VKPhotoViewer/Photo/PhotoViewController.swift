//
//  PhotoViewController.swift
//  VKPhotoViewer
//
//  Created by PenguinRaja on 01.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PhotoDisplayLogic: class {
    func displayPhotoDetails(viewModel: PhotoItem.ShowItem.ViewModel)
}

class PhotoViewController: UIViewController, PhotoDisplayLogic {
    
    var interactor: PhotoBusinessLogic?
    var router: (NSObjectProtocol & PhotoRoutingLogic & PhotoDataPassing)?
    
    var photoImageView: ImageViewManager = {
        let image = ImageViewManager()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    } ()
    
    var navigationTitle: String? {
        didSet {
            title = navigationTitle
        }
    }
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handleZoom))
        photoImageView.addGestureRecognizer(pinch)
        
        setupNavBar()
        layoutSubviews()
        passRequest()
    }
    
    // Setup
    
    func setup() {
        let viewController = self
        let interactor = PhotoInteractor()
        let presenter = PhotoPresenter()
        let router = PhotoRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func passRequest() {
//        let request = CourseDetails.ShowDetails.Request()
//        interactor?.provideCourseDetails(request: request)
    }

    func displayPhotoDetails(viewModel: PhotoItem.ShowItem.ViewModel) {
        photoImageView.fetchImage(from: viewModel.imgSrc)
//        title = viewModel.date
    }
    
    private func setupNavBar(){
        
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareAction))
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backAction))
        
        shareButton.tintColor = .black
        backButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = shareButton
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc func shareAction() {
        guard let image = photoImageView.image else {
            print("No image found")
            return
        }
        
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        shareController.completionWithItemsHandler = { _, bool, _, error in
            if bool {
                let alert = AlertViewController(title: "Сохранено", message: "Изображение загружено в Фотогалерею", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        present(shareController, animated: true)
    }
    
    @objc func backAction() {
        dismiss(animated: true)
    }
    
    func layoutSubviews() {
        
        view.addSubview(photoImageView)
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            photoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    @objc private func handleZoom(recognizer: UIPinchGestureRecognizer){
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
}
