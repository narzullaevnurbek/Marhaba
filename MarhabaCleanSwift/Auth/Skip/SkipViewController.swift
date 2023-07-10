//
//  Skip.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 16/01/23.
//

import UIKit
import Network

protocol SkipViewControllerType {
    func displayData(viewModel: Skip.Model.ViewModel.ViewModelData)
}

class SkipViewController: UIViewController, UITextFieldDelegate, SkipViewControllerType {
    
    var interactor: SkipInteractorType?
    var router: SkipRouterType?
    
    let backButton = UIButton()
    let nameEnter = CustomTextField(style: .info, placeholdeer: nil, iconName: nil)
    let namePrs = UILabel()
    let continueBtn = CustomButton(style: .black, title: "Continue", shadow: .shadow)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        [nameEnter, namePrs, continueBtn].forEach { item in
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setup()
        backButtonSetup()
        views()
        layout()
    }
    
    
    private func setup() {
        let viewController          = self
        let interactor              = SkipInteractor()
        let presenter               = SkipPresenter()
        let router                  = SkipRouter()
        viewController.interactor   = interactor
        viewController.router       = router
        interactor.presenter        = presenter
        presenter.viewController    = viewController
        router.viewController       = viewController
        
        interactor.makeRequest(request: .checkInternet)
    }
    

    func displayData(viewModel: Skip.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .internetStatus(let isConnected):
            router?.networkConnection(isConnected: isConnected)
        }
        
    }
    
    
    func backButtonSetup() {
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.contentVerticalAlignment = .fill
        backButton.contentHorizontalAlignment = .fill
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backToAuth), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    
    func views() {
        title = "Registration"
        
        nameEnter.addTarget(self, action: #selector(upPrs), for: .editingDidBegin)
        nameEnter.addTarget(self, action: #selector(downPrs), for: .editingDidEnd)
        nameEnter.addTarget(self, action: #selector(checkName), for: .allEditingEvents)
        nameEnter.delegate = self
        nameEnter.layer.borderColor = UIColor.smokyWhite.cgColor
        nameEnter.autocapitalizationType = .words
        
        namePrs.text = "First name"
        namePrs.textAlignment = .center
        namePrs.backgroundColor = .white
        namePrs.textColor = .grey
        namePrs.font = .systemFont(ofSize: PRSize, weight: .medium)
        
        continueBtn.disabled()
        continueBtn.addTarget(self, action: #selector(finishSkip), for: .touchUpInside)
    }
    
    
    func layout() {
        NSLayoutConstraint.activate([
            nameEnter.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            nameEnter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            nameEnter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            nameEnter.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            namePrs.leadingAnchor.constraint(equalTo: nameEnter.leadingAnchor, constant: gridSize),
            namePrs.centerYAnchor.constraint(equalTo: nameEnter.centerYAnchor),
            namePrs.widthAnchor.constraint(equalToConstant: namePrs.intrinsicContentSize.width + 10),
            
            continueBtn.topAnchor.constraint(equalTo: nameEnter.bottomAnchor, constant: 15),
            continueBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            continueBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            continueBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }
    
    
    
    @objc func backToAuth() {
        router?.popViewController(animated: true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
    
    
    
    @objc func upPrs() {
        UIView.animate(withDuration: 0.3, animations: {
            self.namePrs.transform = CGAffineTransform(translationX: 0, y: -CGFloat(self.nameEnter.frame.height / 2))
        })
    }
    
    
    
    @objc func downPrs() {
        guard let userName = nameEnter.text else { return }
        
        if !userName.isValidName() {
            UIView.animate(withDuration: 0.3, animations: {
                self.namePrs.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    
    
    @objc func checkName() {
        guard let userName = nameEnter.text else { return }
        
        if userName.isValidName() {
            nameEnter.layer.borderColor = UIColor.deepBlack.cgColor
            namePrs.textColor = .deepBlack
            continueBtn.enabled()
        } else {
            nameEnter.layer.borderColor = UIColor.smokyWhite.cgColor
            namePrs.textColor = .grey
            continueBtn.disabled()
        }
    }
    
    
    
    @objc func finishSkip() {
        guard let userName = nameEnter.text else {
            print("Error in userName Skip page")
            return
        }
        
        interactor?.makeRequest(request: .saveUser(userName: userName))
        router?.setPageTo(VC: ExploreViewController(), animated: true)
    }
}
