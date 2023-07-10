//
//  SearchEngineViewController.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 10/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchEngineCellType: AnyObject {
    func displayData(viewModel: SearchEngine.Model.ViewModel.ViewModelData)
}

class SearchEngineCell: UICollectionViewCell, UITextFieldDelegate, SearchEngineCellType {

    var interactor: SearchEngineCellInteractorType?
    var router: (NSObjectProtocol & SearchEngineCellRouterType)?
    
    static let identifier = "SearchEngine"
    var ExploreVC: UIViewController!
    
    var locationPicker = UIPickerView()
    var cities = ["Tashkent", "Samarkand", "Bukhara", "Khiva"]
    
    var checkInPicker = UIDatePicker()
    var checkOutPicker = UIDatePicker()
    var guestsPicker = UIPickerView()
    var adults = [String]()
    var children = ["0 child"]
    var rooms = [String]()
    
    let greeting = UILabel()
    let settingBtn = UIButton()
    
    let location = CustomTextField(style: .picker, placeholdeer: "Where are you going to?", iconName: "search")
    let searchIcon = UIImageView()
    
    let checkIn = CustomTextField(style: .picker, placeholdeer: "Check-in", iconName: "checkIn")
    let checkInIcon = UIImageView()
    let nightsView = UIView()
    let nightCount = UILabel()
    let checkOut = CustomTextField(style: .picker, placeholdeer: "Check-out", iconName: "checkOut")
    let checkOutIcon = UIImageView()
    
    let guests = CustomTextField(style: .picker, placeholdeer: "0 adult · 0 child · 0 room", iconName: "guests")
    let guestsIcon = UIImageView()
    let searchBtn = CustomButton(style: .black, title: "Search", shadow: .shadow)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [greeting, settingBtn, location, searchIcon, checkIn, checkInIcon, checkOut, checkOutIcon, nightsView, nightCount, guests, guestsIcon, searchBtn].forEach { item in
            addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setup()
        fillDataToGuestsPicker()
        views()
        layout()
        
    }
    
  
    // MARK: Setup

    private func setup() {
        let viewController        = self
        let interactor            = SearchEngineCellInteractor()
        let presenter             = SearchEngineCellPresenter()
        let router                = SearchEngineCellRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        
        interactor.makeRequest(request: .fetchUserFromLocalDB)
    }

    func displayData(viewModel: SearchEngine.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .fetchedLocalUserData(let user):
            self.greeting.text = "Good Evening, \(user.name!)"
        case .receiveSearchedHotels(let data):
            router?.navigate(fromVC: ExploreVC, toVC: HotelsListViewController(hotelsData: data, pageTitle: "Search Result", selection: .searchResult), animated: true)
            self.searchBtn.enabled()
        }
    }
    
    
    func fillDataToGuestsPicker() {
        for i in 1...30 {
            if i > 1 {
                rooms.append(String(i) + " rooms")
                adults.append(String(i) + " adults")
                if i <= 10 {
                    children.append(String(i) + " children")
                }
            } else {
                rooms.append(String(i) + " room")
                adults.append(String(i) + " adult")
                if i <= 10 {
                    children.append(String(i) + " child")
                }
            }
        }
    }
    
    
    @objc func searchClick() {
        searchBtn.disabled()
        guard let city = location.text else { return }
        guard let nightsCount = Int((nightCount.text?.components(separatedBy: " ")[0])!) else { return }
        guard let adults = Int(adults[guestsPicker.selectedRow(inComponent: 0)].components(separatedBy: " ")[0]) else { return }
        guard let children = Int(children[guestsPicker.selectedRow(inComponent: 1)].components(separatedBy: " ")[0]) else { return }
        guard let rooms = Int(rooms[guestsPicker.selectedRow(inComponent: 2)].components(separatedBy: " ")[0]) else { return }
        
        interactor?.makeRequest(request: .searchHotels(city: city, nightsCount: nightsCount, adults: adults, children: children, rooms: rooms))
    }
    
    func views() {
        
        greeting.font = .systemFont(ofSize: LFSize, weight: .bold)
        greeting.lineBreakMode = .byTruncatingTail
        
        settingBtn.setImage(UIImage(named: "settingsdark"), for: .normal)
        settingBtn.layer.shadowColor = UIColor.darkGray.cgColor
        settingBtn.layer.shadowOpacity = 0.5
        settingBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        settingBtn.layer.shadowRadius = 5
        searchBtn.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        
        location.delegate = self
        location.inputAccessoryView = locationToolBar()
        location.inputView = locationPicker
        
        locationPicker.delegate = self
        locationPicker.dataSource = self
        
        checkIn.inputView = checkInPicker
        checkIn.inputAccessoryView = checkInToolBar()
        checkIn.delegate = self
        checkIn.disabled()
        checkInPicker.datePickerMode = .date
        checkInPicker.preferredDatePickerStyle = .inline
        checkInPicker.minimumDate = Date()
        checkInPicker.addTarget(self, action: #selector(checkInPickerChanged), for: .valueChanged)
        
        nightsView.backgroundColor = .white
        nightsView.layer.cornerRadius = 10
        nightsView.layer.shadowColor = UIColor.deepBlack.cgColor
        nightsView.layer.shadowOffset = CGSize(width: 0, height: 0)
        nightsView.layer.shadowRadius = 2
        nightsView.layer.shadowOpacity = 0.6
        nightCount.text = "0 nights"
        nightCount.font = .systemFont(ofSize: 14, weight: .medium)
        
        checkOut.inputView = checkOutPicker
        checkOut.inputAccessoryView = checkOutToolBar()
        checkOut.delegate = self
        checkOut.disabled()
        checkOutPicker.datePickerMode = .date
        checkOutPicker.preferredDatePickerStyle = .inline
        checkOutPicker.addTarget(self, action: #selector(checkOutPickerChanged), for: .valueChanged)
        
        guests.inputView = guestsPicker
        guests.inputAccessoryView = guestsToolBar()
        guests.disabled()
        guestsPicker.delegate = self
        guestsPicker.dataSource = self
        
        searchBtn.disabled()
        
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            greeting.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            greeting.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            greeting.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            
            settingBtn.centerYAnchor.constraint(equalTo: greeting.centerYAnchor),
            settingBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize),
            
            location.topAnchor.constraint(equalTo: greeting.bottomAnchor, constant: 10),
            location.heightAnchor.constraint(equalToConstant: buttonHeight),
            location.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            location.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize),
            
            searchIcon.centerYAnchor.constraint(equalTo: location.centerYAnchor),
            searchIcon.leadingAnchor.constraint(equalTo: location.leadingAnchor, constant: gridSize),
            
            checkIn.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10),
            checkIn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            checkIn.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -20),
            checkIn.heightAnchor.constraint(equalTo: location.heightAnchor),
            
            nightsView.leadingAnchor.constraint(equalTo: checkIn.trailingAnchor, constant: -17),
            nightsView.trailingAnchor.constraint(equalTo: checkOut.leadingAnchor, constant: 17),
            nightsView.heightAnchor.constraint(equalToConstant: 25),
            nightsView.centerYAnchor.constraint(equalTo: checkIn.centerYAnchor),
            
            nightCount.centerYAnchor.constraint(equalTo: nightsView.centerYAnchor),
            nightCount.centerXAnchor.constraint(equalTo: nightsView.centerXAnchor),
            
            checkOut.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10),
            checkOut.leadingAnchor.constraint(equalTo: centerXAnchor, constant: gridSize),
            checkOut.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize),
            checkOut.heightAnchor.constraint(equalTo: location.heightAnchor),
            
            guests.topAnchor.constraint(equalTo: checkIn.bottomAnchor, constant: 10),
            guests.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            guests.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize),
            guests.heightAnchor.constraint(equalTo: location.heightAnchor),
            
            searchBtn.topAnchor.constraint(equalTo: guests.bottomAnchor, constant: 10),
            searchBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            searchBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize),
            searchBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
            searchBtn.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error has occured")
    }
  
}


extension SearchEngineCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == locationPicker {
            return 1
        } else {
            return 3
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == locationPicker {
            return cities.count
            
        } else {
            if component == 0 {
                return adults.count
            } else if component == 1 {
                return children.count
            } else {
                return rooms.count
            }
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == locationPicker {
            return cities[row]
            
        } else {
            if component == 0 {
                return adults[row]
            } else if component == 1 {
                return children[row]
            } else {
                return rooms[row]
            }
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == locationPicker {
            let selectedCity = pickerView.selectedRow(inComponent: 0)
            let city = cities[selectedCity]
            location.text = "\(city)"
            checkIn.enabled()
        } else {
            let selectedAdult = pickerView.selectedRow(inComponent: 0)
            let selectedChild = pickerView.selectedRow(inComponent: 1)
            let selectedRoom = pickerView.selectedRow(inComponent: 2)
            let adult = adults[selectedAdult]
            let child = children[selectedChild]
            let room = rooms[selectedRoom]
            guests.text = "\(adult) · \(child) · \(room)"
            searchBtn.enabled()
        }
    }
    
    
    func locationToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(locationDoneClick))
        toolbar.setItems([flexButton, doneBtn], animated: true)
        
        return toolbar
    }
    
    
    @objc func locationDoneClick() {
        location.resignFirstResponder()
        let city = cities[locationPicker.selectedRow(inComponent: 0)]
        location.text = "\(city)"
        checkIn.enabled()
    }
    
    
    @objc func checkInPickerChanged() {
        checkOutPicker.maximumDate = .none
        checkOutPicker.date = Calendar.current.date(byAdding: .day, value: 1, to: checkInPicker.date)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        checkIn.text = dateFormatter.string(from: checkInPicker.date)
        checkOutPicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInPicker.date)
        checkOutPicker.maximumDate = Calendar.current.date(byAdding: .day, value: 90, to: checkInPicker.date)
        checkOut.text = dateFormatter.string(from: checkOutPicker.minimumDate!)
        let daysCount = calculateDays(checkInPicker.date, and: checkOutPicker.date)
        nightCount.text = "\(daysCount) nights"
        checkOut.enabled()
        guests.enabled()
    }
    
    
    func checkInToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(checkInDoneClick))
        toolbar.setItems([flexButton, doneBtn], animated: true)
        
        return toolbar
    }
    
    
    @objc func checkInDoneClick() {
        checkOutPicker.maximumDate = .none
        checkOutPicker.date = Calendar.current.date(byAdding: .day, value: 1, to: checkInPicker.date)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        checkIn.text = dateFormatter.string(from: checkInPicker.date)
        checkOutPicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInPicker.date)
        checkOutPicker.maximumDate = Calendar.current.date(byAdding: .day, value: 90, to: checkInPicker.date)
        checkOut.text = dateFormatter.string(from: checkOutPicker.minimumDate!)
        let daysCount = calculateDays(checkInPicker.date, and: checkOutPicker.date)
        nightCount.text = "\(daysCount) nights"
        checkIn.resignFirstResponder()
        checkOut.enabled()
        guests.enabled()
    }
    
    
    @objc func checkOutPickerChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        checkOut.text = dateFormatter.string(from: checkOutPicker.date)
        let daysCount = calculateDays(checkInPicker.date, and: checkOutPicker.date)
        nightCount.text = "\(daysCount) nights"
    }
    
    
    func checkOutToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(checkOutDoneClick))
        toolbar.setItems([flexButton, doneBtn], animated: true)
        
        return toolbar
    }
    
    
    @objc func checkOutDoneClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        checkOut.resignFirstResponder()
        checkOut.text = dateFormatter.string(from: checkOutPicker.date)
        let daysCount = calculateDays(checkInPicker.date, and: checkOutPicker.date)
        nightCount.text = "\(daysCount) nights"
    }
    
    
    func guestsToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(guestsDoneClick))
        toolbar.setItems([flexButton, doneBtn], animated: true)
        
        return toolbar
    }
    
    
    @objc func guestsDoneClick() {
        guests.resignFirstResponder()
        let selectedAdult = guestsPicker.selectedRow(inComponent: 0)
        let selectedChild = guestsPicker.selectedRow(inComponent: 1)
        let selectedRoom = guestsPicker.selectedRow(inComponent: 2)
        let adult = adults[selectedAdult]
        let child = children[selectedChild]
        let room = rooms[selectedRoom]
        guests.text = "\(adult) · \(child) · \(room)"
        searchBtn.enabled()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= 8
    }
    
    
}
