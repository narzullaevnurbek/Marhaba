//
//  SettingsViewController.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 10/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SettingsViewControllerType: AnyObject {
    func displayData(viewModel: Settings.Model.ViewModel.ViewModelData)
}

protocol CitySelectionDelegate {
    func didSelectCity()
}

class SettingsViewController: UIViewController, UITextFieldDelegate, SettingsViewControllerType {

    var interactor: SettingsInteractorType?
    var router: (NSObjectProtocol & SettingsRouterType)?
    
    
    var cities = ["Tashkent", "Samarkand", "Bukhara", "Khiva"]
    
    var cityPicker = UIPickerView()
    var cityTextField = CustomTextField(style: .picker, placeholdeer: "Pick your location city", iconName: "city")
    let logOutBtn = CustomButton(style: .black, title: "Log out from Account", shadow: .none)
    let deleteAccountBtn = CustomButton(style: .white, title: "Delete my Account", shadow: .none)
    let backButton = UIButton()
    
    var delegate: CitySelectionDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        [cityTextField, deleteAccountBtn, logOutBtn].forEach { item in
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        views()
        layout()
        backButtonConfig()
        setup()
    }
    
  
    // MARK: Setup

    private func setup() {
        let viewController        = self
        let interactor            = SettingsInteractor()
        let presenter             = SettingsPresenter()
        let router                = SettingsRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }

    func displayData(viewModel: Settings.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .internetStatus(let isConnected):
            router?.networkConnection(isConnected: isConnected)
        case .fetchedLocalUserData(let user):
            let cityId = user.cityID
            cityTextField.text = cities[Int(user.cityID) - 1]
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
    
    @objc func backToExplore() {
        navigationController?.popViewController(animated: true)
    }
    
    func views() {
        cityPicker.delegate = self
        cityPicker.dataSource = self
        
        cityTextField.delegate = self
        cityTextField.inputAccessoryView = locationToolBar()
        cityTextField.inputView = cityPicker
        
        logOutBtn.addTarget(self, action: #selector(logOutClick), for: .touchUpInside)
        deleteAccountBtn.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        deleteAccountBtn.setTitleColor(.systemRed, for: .normal)
        deleteAccountBtn.titleLabel?.font = .systemFont(ofSize: buttonTitleSize, weight: .medium)
    }
    
    func layout() {
        
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            cityTextField.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            logOutBtn.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 10),
            logOutBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            logOutBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            logOutBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            deleteAccountBtn.topAnchor.constraint(equalTo: logOutBtn.bottomAnchor, constant: 10),
            deleteAccountBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            deleteAccountBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            deleteAccountBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }
    
    
    func locationToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(cityDoneClick))
        toolbar.setItems([flexButton, doneBtn], animated: true)
        
        return toolbar
    }
    
    
    @objc func cityDoneClick() {
        cityTextField.resignFirstResponder()
        let city = cities[cityPicker.selectedRow(inComponent: 0)]
        cityTextField.text = city
        let cityID = Int64(cityPicker.selectedRow(inComponent: 0) + 1)
        
        interactor?.makeRequest(request: .update(value: cityID, selection: .cityID))
        delegate?.didSelectCity()
    }
    
    
    @objc func logOutClick() {
        let alert = UIAlertController(title: "Sign out", message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Sign out", style: .destructive, handler: { _ in
            self.interactor?.makeRequest(request: .eraseCoreData)
            
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController = UINavigationController(rootViewController: AuthViewController())
            
            self.interactor?.makeRequest(request: .logOut)
        }))
        self.present(alert, animated: true)
    }
    
    
    @objc func deleteAccount() {
        let alert = UIAlertController(title: "Account Deletion", message: "Are you sure you want to permanently delete your Account?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.interactor?.makeRequest(request: .eraseCoreData)
            self.interactor?.makeRequest(request: .deleteAccount)
            
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController = UINavigationController(rootViewController: AuthViewController())
            
            self.interactor?.makeRequest(request: .logOut)
        }))
        self.present(alert, animated: true)
    }
  
}


extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityTextField.text = cities[row]
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= 15
    }
}
