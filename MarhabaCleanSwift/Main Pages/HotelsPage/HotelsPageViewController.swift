//
//  HotelsPageViewController.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Kingfisher

protocol HotelsPageViewControllerType: AnyObject {
    func displayData(viewModel: HotelsPage.Model.ViewModel.ViewModelData)
}

protocol DescriptionEditionDelegate {
    func changeDesc(isFull: Bool)
}

class HotelsPageViewController: UIViewController, HotelsPageViewControllerType {

    var interactor: HotelsPageInteractorType?
    var router: (NSObjectProtocol & HotelsPageRouterType)?
    var delegate: DescriptionEditionDelegate?

    let spinner = UIActivityIndicatorView()
    var collectionView: UICollectionView!
    let backButton = UIButton()
    
    var hotelData = [Hotel]()
    var hotelAmenities = [Amenities]()
    var hotelRooms = [HotelRooms]()
    var roomImages = [RoomImage]()
    
    let hotelID: Int
    var descheight: CGFloat = 230
    var readMoreState = false
    
    init(hotelID: Int) {
        self.hotelID = hotelID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        collectionViewSetup()
        setup()
        spinnerConfig()
        getSingleHotelData()
        backButtonConfiguration()
        
    }
    
  
    // MARK: Setup

    private func setup() {
        let viewController        = self
        let interactor            = HotelsPageInteractor()
        let presenter             = HotelsPagePresenter()
        let router                = HotelsPageRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        
        interactor.makeRequest(request: .checkInternet)
    }

    func displayData(viewModel: HotelsPage.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .internetStatus(let isConnected):
            router?.networkConnection(isConnected: isConnected)
        case .receiveHotel(let hotel):
            self.hotelData = hotel
        case .receiveAmens(let amens):
            self.hotelAmenities = amens
        case .receiveRooms(let rooms):
            self.hotelRooms = rooms
        case .receiveRoomImages(let roomImages):
            self.roomImages = roomImages
            reloadPage()
        }
    }
    
    
    func getSingleHotelData() {
        
        interactor?.makeRequest(request: .getHotel(hotelID: hotelID))
        interactor?.makeRequest(request: .getAmens(hotelID: hotelID))
        interactor?.makeRequest(request: .rooms(hotelID: hotelID))
        interactor?.makeRequest(request: .roomImages(hotelID: hotelID))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            if self.hotelData.isEmpty || self.hotelAmenities.isEmpty && self.hotelRooms.isEmpty || self.roomImages.isEmpty {
                print("Error has occured")
                let alert = UIAlertController(title: "Loading Error", message: "An error has occured, please try to close the app and launch it again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    exit(0)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    func reloadPage() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.spinner.stopAnimating()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
    }
    
    
    func spinnerConfig() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .large
        spinner.color = .deepBlack
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    func backButtonConfiguration() {
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.contentVerticalAlignment = .fill
        backButton.contentHorizontalAlignment = .fill
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backToExplore), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    
    func collectionViewSetup() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout())
        collectionView.contentInsetAdjustmentBehavior = .never
        view.addSubview(collectionView)
        collectionView.register(HotelImageCell.self, forCellWithReuseIdentifier: HotelImageCell.identifier)
        collectionView.register(HotelDesc.self, forCellWithReuseIdentifier: HotelDesc.identifier)
        collectionView.register(HotelAmensLabel.self, forCellWithReuseIdentifier: HotelAmensLabel.identifier)
        collectionView.register(HotelAmens.self, forCellWithReuseIdentifier: HotelAmens.identifier)
        collectionView.register(RoomsLabel.self, forCellWithReuseIdentifier: RoomsLabel.identifier)
        collectionView.register(AvailableRooms.self, forCellWithReuseIdentifier: AvailableRooms.identifier)
        collectionView.register(LocationLabel.self, forCellWithReuseIdentifier: LocationLabel.identifier)
        collectionView.register(LocationMap.self, forCellWithReuseIdentifier: LocationMap.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = collectionView
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    
    func flowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            if sectionIndex == 0 {
                return self.headerImages()
            } else if sectionIndex == 1 {
                return self.description()
            } else if sectionIndex == 2 {
                return self.amensLabel()
            } else if sectionIndex == 3 {
                return self.amens()
            } else if sectionIndex == 4 {
                return self.roomsLabel()
            } else if sectionIndex == 5 {
                return self.availableRooms()
            } else if sectionIndex == 6 {
                return self.locationLabel()
            } else {
                return self.locationMap()
            }
        }
        return layout
    }
    
    
    func headerImages() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let headerItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(view.frame.height / 2.8))
        let headerGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [headerItem])
        
        // section
        let headerSection = NSCollectionLayoutSection(group: headerGroup)
        
        return headerSection
    }
    
    
    func description() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let searchItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(descheight))
        let searchGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [searchItem])
        
        // section
        let searchSection = NSCollectionLayoutSection(group: searchGroup)
        
        return searchSection
    
    }
    
    
    func amensLabel() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let searchItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let searchGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [searchItem])
        
        // section
        let searchSection = NSCollectionLayoutSection(group: searchGroup)
        
        return searchSection
    }
    
    
    func amens() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(view.frame.size.width / 2), heightDimension: .fractionalHeight(1))
        let headerItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let headerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [headerItem])
        
        // section
        let headerSection = NSCollectionLayoutSection(group: headerGroup)
        
        return headerSection
    
    }
    
    
    func roomsLabel() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let searchItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let searchGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [searchItem])
        
        // section
        let searchSection = NSCollectionLayoutSection(group: searchGroup)
        
        return searchSection
    
    }
    
    
    func availableRooms() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let nearbyItem = NSCollectionLayoutItem(layoutSize: itemSize)
        nearbyItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(NBWidth-30), heightDimension: .absolute(230))
        let nearbyGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: nearbyItem, count: 1)
        
        // section
        let nearbySection = NSCollectionLayoutSection(group: nearbyGroup)
        nearbySection.orthogonalScrollingBehavior = .continuous
        nearbySection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: gridSize-10, bottom: 0, trailing: gridSize-10)
        
        return nearbySection
    }
    
    
    func locationLabel() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let searchItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        let searchGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [searchItem])
        
        // section
        let searchSection = NSCollectionLayoutSection(group: searchGroup)
        
        return searchSection
    
    }
    
    
    func locationMap() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let searchItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        let searchGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [searchItem])
        
        // section
        let searchSection = NSCollectionLayoutSection(group: searchGroup)
        
        return searchSection
    }
  
}


extension HotelsPageViewController: collD, collDS, collDFL {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if hotelData.count > 0 && hotelAmenities.count > 0 && hotelRooms.count > 0 && roomImages.count > 0 {
            return 8
        } else {
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return hotelAmenities.count
        } else if section == 4 {
            return 1
        } else if section == 5 {
            return hotelRooms.count
        } else if section == 6 {
            return 1
        } else {
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hotelData = self.hotelData[0]
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelImageCell.identifier, for: indexPath) as! HotelImageCell
            
            cell.image.kf.setImage(with: URL(string: hotelData.thumbImageUrl))
            cell.showAllPhotos.addAction {
                self.showHotelImages(hotelID: hotelData.id)
            }
            return cell
            
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelDesc.identifier, for: indexPath) as! HotelDesc
            
            self.delegate = cell
            cell.name.text = hotelData.name
            cell.rate.text = "\(hotelData.rating)"
            if cell.starsArray.isEmpty { cell.starsSetup(rating: hotelData.rating) }
            cell.address.text = hotelData.address
            cell.desc.text = hotelData.description
            cell.readMoreBtn.addAction {
                self.changeDescHeight(text: hotelData.description)
            }
            
            return cell
            
        } else if indexPath.section == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelAmensLabel.identifier, for: indexPath)
            return cell
            
        } else if indexPath.section == 3 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelAmens.identifier, for: indexPath) as! HotelAmens
            
            cell.text.text = hotelAmenities[indexPath.row].name
            cell.icon.image = UIImage(named: "icon\(hotelAmenities[indexPath.row].iconID)")
            
            return cell
            
        } else if indexPath.section == 4 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomsLabel.identifier, for: indexPath)
            return cell
            
        } else if indexPath.section == 5 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvailableRooms.identifier, for: indexPath) as! AvailableRooms
            
            let imageURL = URL(string: roomImages[indexPath.row].url)
            cell.image.kf.setImage(with: imageURL)
            cell.name.text = hotelRooms[indexPath.row].name
            cell.addAction {
                self.showRoomImages(roomID: self.hotelRooms[indexPath.row].roomID)
            }
            
            return cell
            
        } else if indexPath.section == 6 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationLabel.identifier, for: indexPath) as! LocationLabel
            cell.address.text = hotelData.address
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationMap.identifier, for: indexPath) as! LocationMap
            cell.openInMapsBtn.addTarget(self, action: #selector(openLocationInMaps), for: .touchUpInside)
            return cell
        }
    }
    
    
    func changeDescHeight(text: String) {
        let width = screenWidth - gridSize - gridSize
        let height = text.height(width: width, font: .systemFont(ofSize: 18, weight: .regular))
        
        if readMoreState {
            delegate?.changeDesc(isFull: readMoreState)
            self.descheight -= height - 90
            readMoreState = false
        } else {
            delegate?.changeDesc(isFull: readMoreState)
            self.descheight += height - 90
            readMoreState = true
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    func showRoomImages(roomID: Int) {
        let imagesVC = ImagesGridViewController(id: roomID, selection: .room)
        if let sheet = imagesVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        present(imagesVC, animated: true)
    }
    
    
    func showHotelImages(hotelID: Int) {
        let imagesVC = ImagesGridViewController(id: hotelID, selection: .hotel)
        if let sheet = imagesVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        present(imagesVC, animated: true)
    }
    
    @objc func openLocationInMaps() {
        let latitude = hotelData[0].latitude
        let longitude = hotelData[0].longitude
        router?.openMaps(URL: URL(string: "https://www.google.com/maps?q=\(latitude),\(longitude)")!)
    }
    
    @objc func backToExplore() {
        router?.popViewController(animated: true)
    }
}
