//
//  HotelsListViewController.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Kingfisher

protocol HotelsListViewControllerType: AnyObject {
  func displayData(viewModel: HotelsList.Model.ViewModel.ViewModelData)
}

class HotelsListViewController: UIViewController, HotelsListViewControllerType {

    var interactor: HotelsListInteractorType?
    var router: (NSObjectProtocol & HotelsListRouterType)?
    
    
    let defaults = UserDefaults.standard
    var collectionView: UICollectionView!
    let backButton = UIButton()
    
    let pageTitle: String
    let hotelsData: [Hotel]
    let selection: HotelsList.HotelSelection
    
    
    init(hotelsData: [Hotel], pageTitle: String, selection: HotelsList.HotelSelection) {
        self.hotelsData = hotelsData
        self.pageTitle = pageTitle
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        title = self.pageTitle
        
        
        setup()
        collectionViewConfig()
        backButtonConfig()
    }
    

    private func setup() {
        let viewController        = self
        let interactor            = HotelsListInteractor()
        let presenter             = HotelsListPresenter()
        let router                = HotelsListRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }

    
    
    func displayData(viewModel: HotelsList.Model.ViewModel.ViewModelData) {
     
        switch viewModel {
        case .internetStatus(let isConnected):
            router?.networkConnection(isConnected: isConnected)
        }
    }
    
    
    func backButtonConfig() {
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.contentVerticalAlignment = .fill
        backButton.contentHorizontalAlignment = .fill
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backToExplore), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    

    func collectionViewConfig() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.size.width) - 40, height: 335)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.register(HotelListCell.self, forCellWithReuseIdentifier: HotelListCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = collectionView
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    
    @objc func backToExplore() {
        router?.popViewController(animated: true)
    }
}


extension HotelsListViewController: collD, collDS {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotelsData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelListCell.identifier, for: indexPath) as! HotelListCell
        
        cell.image.kf.setImage(with: URL(string: hotelsData[indexPath.row].thumbImageUrl))
        cell.name.text = hotelsData[indexPath.row].name
        cell.address.text = hotelsData[indexPath.row].address
        cell.rate.text = String(hotelsData[indexPath.row].rating)
        cell.addAction {
            self.hotelClick(hotelID: self.hotelsData[indexPath.row].id)
        }
        
        switch selection {
        case .searchResult:
            let attredText = NSMutableAttributedString()
            attredText.bold("US$\(hotelsData[indexPath.row].price)", fontSize: 22, textColor: .deepBlack)
            attredText.normal("/per night", fontSize: 16, textColor: .grey)
            cell.price.attributedText = attredText
        case .notSearch:
            let attredText = NSMutableAttributedString()
            attredText.bold("Total US$\(hotelsData[indexPath.row].price)", fontSize: 22, textColor: .deepBlack)
            cell.price.attributedText = attredText
        }
        
        return cell
    }
    
    
    func hotelClick(hotelID: Int) {
        let VC = HotelsPageViewController(hotelID: hotelID)
        router?.navigate(toVC: VC, animated: true)
    }
}
