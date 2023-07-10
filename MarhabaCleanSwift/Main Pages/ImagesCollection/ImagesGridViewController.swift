//
//  ImagesGridViewController.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Kingfisher

protocol ImagesGridViewControllerType: AnyObject {
    func displayData(viewModel: ImagesGrid.Model.ViewModel.ViewModelData)
}

class ImagesGridViewController: UIViewController, ImagesGridViewControllerType {

    var interactor: ImagesGridInteractorType?
    var router: (NSObjectProtocol & ImagesGridRouterType)?
    
    var collectionView: UICollectionView!
    let spinner = UIActivityIndicatorView()
    var hotelImages = [HotelImage]()
    var roomImages = [RoomImage]()
    let id: Int
    let selection: ImagesGrid.ImagesGridSelection
    
    init(id: Int, selection: ImagesGrid.ImagesGridSelection) {
        self.id = id
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ImageCache.default.clearMemoryCache()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setup()
        collectionViewConfig()
        spinnerConfig()
        layoutConfig()
    }
    
  
    // MARK: Setup

    private func setup() {
        let viewController        = self
        let interactor            = ImagesGridInteractor()
        let presenter             = ImagesGridPresenter()
        let router                = ImagesGridRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        
        switch selection {
        case .hotel:
            interactor.makeRequest(request: .getHotelImages(id: id))
        case .room:
            interactor.makeRequest(request: .getRoomImages(id: id))
        }
    }

    func displayData(viewModel: ImagesGrid.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .receiveHotelImages(let images):
            self.hotelImages = images
            reloadPage()
        case .receiveRoomImages(let images):
            self.roomImages = images
            reloadPage()
        }
    }
    
    
    func reloadPage() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    
    func spinnerConfig() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .large
        spinner.color = .deepBlack
        spinner.startAnimating()
        view.addSubview(spinner)
    }
    
    
    func collectionViewConfig() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width / 3) - 1, height: (view.frame.size.width / 3) - 1)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.register(ImagesCell.self, forCellWithReuseIdentifier: ImagesCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = collectionView
    }
    
    func layoutConfig() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    deinit {
        print("ImagesGridViewController is terminated")
    }
  
}


extension ImagesGridViewController: collD, collDS {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selection {
        case .hotel:
            return hotelImages.count
        case .room:
            return roomImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCell.identifier, for: indexPath) as! ImagesCell
        
        switch selection {
        case .hotel:
            
            let url = URL(string: hotelImages[indexPath.row].imageURL)
            KingfisherManager.shared.retrieveImage(with: url!) { result in
                switch result {
                case .success(let value):
                    cell.image.image = value.image
                default:
                    cell.image.kf.setImage(with: URL(string: self.hotelImages[1].imageURL))
                }
            }
            
        case .room:
            cell.image.kf.setImage(with: URL(string: roomImages[indexPath.row].url))
        }
        
        return cell
    }
}
