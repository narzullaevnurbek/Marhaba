//
//  Explore.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 29/01/23.
//

import UIKit
import Kingfisher
import Alamofire
import Network

protocol ExploreViewControllerType {
    func displayData(viewModel: Explore.Model.ViewModel.ViewModelData)
}

class ExploreViewController: UIViewController, ExploreViewControllerType {
    
    var interactor: ExploreInteractorType?
    var router: ExploreRouterType?
    
    let destinations = [
        Destinations(id: 1, name: "Tashkent", image: "tashkent", hotelsCount: 190),
        Destinations(id: 2, name: "Samarkand", image: "samarkand1", hotelsCount: 240),
        Destinations(id: 3, name: "Bukhara", image: "bukhara", hotelsCount: 240),
        Destinations(id: 4, name: "Khiva", image: "khiva", hotelsCount: 80)
    ]
    
    var collectionView: UICollectionView!
    var spinner = UIActivityIndicatorView()
    let logOutBtn = UIButton()
    var bestAndAffordableHotels = [Hotel]()
    var recommendedHotels = [Hotel]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        
        interactor?.makeRequest(request: .clearMemoryCache)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        
        collectionViewConfig()
        setup()
        spinnerConfig()
        layout()
    }
    
    
    private func setup() {
        let viewController          = self
        let interactor              = ExploreInteractor()
        let presenter               = ExplorePresenter()
        let router                  = ExploreRouter()
        viewController.interactor   = interactor
        viewController.router       = router
        interactor.presenter        = presenter
        presenter.viewController    = viewController
        router.viewController       = viewController
        
        interactor.makeRequest(request: .checkInternet)
        interactor.makeRequest(request: .setSigned)
        interactor.makeRequest(request: .fetchHotels(selection: .bestAndAffordable))
        interactor.makeRequest(request: .fetchHotels(selection: .recommended))
    }
    
    
    func displayData(viewModel: Explore.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .internetStatus(let isConnected):
            router?.networkConnection(isConnected: isConnected)
        case .fetchedHotelsData(let hotels, let selection):
            updateHotels(hotelsData: hotels, selection: selection)
        case .fetchedDestinationHotels(let data, let cityName):
            setDestinationHotels(hotelsData: data, cityName: cityName)
        }
        
    }
    
    
    private func updateHotels(hotelsData: [Hotel], selection: HotelSelectionType) {
        switch selection {
        case .bestAndAffordable:
            self.bestAndAffordableHotels = hotelsData
        case .recommended:
            self.recommendedHotels = hotelsData
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.spinner.stopAnimating()
        }
    }
    
    
    private func setDestinationHotels(hotelsData: [Hotel], cityName: String) {
        let VC = HotelsListViewController(hotelsData: hotelsData, pageTitle: cityName, selection: .notSearch)
        spinner.stopAnimating()
        router?.navigate(toVC: VC, animated: true)
    }
    
    
    func spinnerConfig() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .large
        spinner.color = .deepBlack
        spinner.backgroundColor = .smokyGrey
        spinner.layer.cornerRadius = 5
        spinner.startAnimating()
        view.addSubview(spinner)
    }
    
    
    func getHotelsData() {
        interactor?.makeRequest(request: .fetchHotels(selection: .bestAndAffordable))
        interactor?.makeRequest(request: .fetchHotels(selection: .recommended))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            if self.bestAndAffordableHotels.isEmpty || self.recommendedHotels.isEmpty {
                let alert = UIAlertController(title: "Loading Error", message: "An error has occured, please try to close the app and launch it again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    exit(0)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    func collectionViewConfig() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout())
        view.addSubview(collectionView)
        collectionView.register(Header.self, forCellWithReuseIdentifier: Header.identifier)
        collectionView.register(SearchEngineCell.self, forCellWithReuseIdentifier: SearchEngineCell.identifier)
        collectionView.register(BestAffordableLabel.self, forCellWithReuseIdentifier: BestAffordableLabel.identifier)
        collectionView.register(BestAffordable.self, forCellWithReuseIdentifier: BestAffordable.identifier)
        collectionView.register(RecommendedLabel.self, forCellWithReuseIdentifier: RecommendedLabel.identifier)
        collectionView.register(Recommended.self, forCellWithReuseIdentifier: Recommended.identifier)
        collectionView.register(TrendingLabel.self, forCellWithReuseIdentifier: TrendingLabel.identifier)
        collectionView.register(TrendingPlaces.self, forCellWithReuseIdentifier: TrendingPlaces.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = collectionView
    }
    
    func layout() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            spinner.widthAnchor.constraint(equalToConstant: 80),
            spinner.heightAnchor.constraint(equalToConstant: 80),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
    
    func flowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            if sectionIndex == 0 {
                return self.searchLayout()
            } else if sectionIndex == 1 {
                return self.nearbyLabelLayout()
            } else if sectionIndex == 2 {
                return self.nearbyLayout()
            } else if sectionIndex == 3 {
                return self.recLabelLayout()
            } else if sectionIndex == 4 {
                return self.recommendedLayout()
            } else if sectionIndex == 5 {
                return self.trendLabelLayout()
            } else {
                return self.trendingLayout()
            }
        }
        return layout
    }
    
    func searchLayout() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let searchItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(SEGSize))
        let searchGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [searchItem])
        
        // section
        let searchSection = NSCollectionLayoutSection(group: searchGroup)
        
        return searchSection
    
    }
    
    func nearbyLabelLayout() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let nearbyLabelItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupLabelSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let nearbyLabelGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupLabelSize, repeatingSubitem: nearbyLabelItem, count: 1)
        
        // section
        let nearbyLabelSection = NSCollectionLayoutSection(group: nearbyLabelGroup)
        nearbyLabelSection.orthogonalScrollingBehavior = .continuous
        
        return nearbyLabelSection
    
    }
    
    func nearbyLayout() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let nearbyItem = NSCollectionLayoutItem(layoutSize: itemSize)
        nearbyItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(NBWidth), heightDimension: .absolute(290))
        let nearbyGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: nearbyItem, count: 1)
        
        // section
        let nearbySection = NSCollectionLayoutSection(group: nearbyGroup)
        nearbySection.orthogonalScrollingBehavior = .continuous
        nearbySection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: gridSize-10, bottom: 0, trailing: gridSize-10)
        
        return nearbySection
    
    }
    
    func recLabelLayout() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let RecLabelItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupLabelSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let RecLabelGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupLabelSize, repeatingSubitem: RecLabelItem, count: 1)
        
        // section
        let RecLabelSection = NSCollectionLayoutSection(group: RecLabelGroup)
        RecLabelSection.orthogonalScrollingBehavior = .continuous
        
        return RecLabelSection
    
    }
    
    func recommendedLayout() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(95))
        let recommendedItem = NSCollectionLayoutItem(layoutSize: itemSize)
        recommendedItem.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 0, bottom: 7, trailing: 0)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(285))
        let recommendedGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [recommendedItem])
        
        // section
        let recommendedSection = NSCollectionLayoutSection(group: recommendedGroup)
        recommendedSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: gridSize, bottom: 0, trailing: gridSize)
        
        return recommendedSection
    
    }
    
    func trendLabelLayout() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let TrendLabelItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupLabelSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let TrendLabelGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupLabelSize, repeatingSubitem: TrendLabelItem, count: 1)
        
        // section
        let TrendLabelSection = NSCollectionLayoutSection(group: TrendLabelGroup)
        
        return TrendLabelSection
    
    }
    
    func trendingLayout() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(240))
        let trendingItem = NSCollectionLayoutItem(layoutSize: itemSize)
        trendingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(250), heightDimension: .absolute(250))
        let trendingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [trendingItem])
        
        // section
        let trendingSection = NSCollectionLayoutSection(group: trendingGroup)
        trendingSection.orthogonalScrollingBehavior = .continuous
        trendingSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: gridSize-10, bottom: 0, trailing: gridSize-10)
        
        return trendingSection
    
    }
    
    deinit {
        print("Explore is terminated")
    }

}

extension ExploreViewController: collD, collDS, collDFL, imagePCD, navCD, CitySelectionDelegate {
    
    func didSelectCity() {
        getHotelsData()
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if bestAndAffordableHotels.count > 0 && recommendedHotels.count > 0 {
            return 7
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 6
        } else if section == 3 {
            return 1
        } else if section == 4 {
            return 3
        } else if section == 5 {
            return 1
        } else {
            return 4
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchEngineCell.identifier, for: indexPath) as! SearchEngineCell
            
            cell.ExploreVC = self
            cell.settingBtn.addTarget(self, action: #selector(settingsClick), for: .touchUpInside)
            return cell
            
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BestAffordableLabel.identifier, for: indexPath) as! BestAffordableLabel
            
            cell.seeAllBtn.addAction {
                self.seeAllClick(data: self.bestAndAffordableHotels, title: "Best & Affordable", selection: .notSearch)
            }
            return cell
            
        } else if indexPath.section == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BestAffordable.identifier, for: indexPath) as! BestAffordable
            
            let attredText = NSMutableAttributedString()
            attredText.bold("US$\(bestAndAffordableHotels[indexPath.row].price)", fontSize: 22, textColor: .deepBlack)
            attredText.normal("/per night", fontSize: 16, textColor: .grey)
            cell.image.kf.setImage(with: URL(string: bestAndAffordableHotels[indexPath.row].thumbImageUrl))
            cell.price.attributedText = attredText
            cell.name.text = bestAndAffordableHotels[indexPath.row].name
            cell.rate.text = String(bestAndAffordableHotels[indexPath.row].rating)
            cell.address.text = bestAndAffordableHotels[indexPath.row].address
            cell.addAction {
                self.hotelClick(hotelID: self.bestAndAffordableHotels[indexPath.row].id)
            }
            return cell
            
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedLabel.identifier, for: indexPath) as! RecommendedLabel
            
            cell.seeAll.addAction {
                self.seeAllClick(data: self.recommendedHotels, title: "Recommended", selection: .notSearch)
            }
            return cell
            
        } else if indexPath.section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Recommended.identifier, for: indexPath) as! Recommended
            
            let attredText = NSMutableAttributedString()
            attredText.bold("US$\(recommendedHotels[indexPath.row].price)", fontSize: 22, textColor: .deepBlack)
            attredText.normal("/per night", fontSize: 16, textColor: .grey)
            cell.image.kf.setImage(with: URL(string: recommendedHotels[indexPath.row].thumbImageUrl))
            cell.price.attributedText = attredText
            cell.name.text = recommendedHotels[indexPath.row].name
            cell.rate.text = String(recommendedHotels[indexPath.row].rating)
            cell.address.text = recommendedHotels[indexPath.row].address
            cell.addAction {
                self.hotelClick(hotelID: self.recommendedHotels[indexPath.row].id)
            }
            return cell
            
        } else if indexPath.section == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingLabel.identifier, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingPlaces.identifier, for: indexPath) as! TrendingPlaces
            
            let cityID = destinations[indexPath.row].id
            let cityName = destinations[indexPath.row].name
            cell.image.image = UIImage(named: "\(destinations[indexPath.row].image)")
            cell.name.text = destinations[indexPath.row].name
            cell.hotelsCount.text = "+\(destinations[indexPath.row].hotelsCount) hotels"
            cell.addAction {
                self.destinationClick(cityID: cityID, cityName: cityName)
            }
            return cell
            
        }
    }
    
    
    func seeAllClick(data: [Hotel], title: String, selection: HotelsList.HotelSelection) {
        let VC = HotelsListViewController(hotelsData: data, pageTitle: title, selection: .notSearch)
        router?.navigate(toVC: VC, animated: true)
    }
    
    
    func hotelClick(hotelID: Int) {
        let VC = HotelsPageViewController(hotelID: hotelID)
        router?.navigate(toVC: VC, animated: true)
    }
    
    
    @objc func settingsClick() {
        let settingsVC = SettingsViewController()
        settingsVC.delegate = self
        if let sheet = settingsVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        present(settingsVC, animated: true)
    }
    
    
    func destinationClick(cityID: Int, cityName: String) {
        spinnerConfig()
        interactor?.makeRequest(request: .fetchDestinationHotels(cityID: cityID, cityName: cityName))
    }
    
    
}
