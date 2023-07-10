//
//  Auth Page.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 16/01/23.
//

import UIKit
import Network

protocol AuthViewControllerType: AnyObject {
    func displayData(viewModel: Auth.Model.ViewModel.ViewModelData)
}

class AuthViewController: UIViewController, AuthViewControllerType {
    
    var interactor: AuthInteractorType?
    var router: AuthRouterType?
    
    let welcomeImage = UIImageView()
    let bottomView = UIView()
    let logInBtn = CustomButton(style: .white, title: "Login", shadow: .none)
    let signUpBtn = CustomButton(style: .black, title: "Sign Up", shadow: .none)
    let agreementLabel = UILabel()
    let agreementBtn = UIButton()
    let skipBtn = CustomButton(style: .clear, title: "Skip", shadow: .none)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        [welcomeImage, bottomView, logInBtn, signUpBtn, agreementLabel, agreementBtn, skipBtn].forEach { item in
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setup()
        views()
        layout()
        
    }
    
    private func setup() {
        let viewController          = self
        let interactor              = AuthInteractor()
        let presenter               = AuthPresenter()
        let router                  = AuthRouter()
        viewController.interactor   = interactor
        viewController.router       = router
        interactor.presenter        = presenter
        presenter.viewController    = viewController
        router.viewController       = viewController
        
        interactor.makeRequest(request: .deleteUserData)
        interactor.makeRequest(request: .checkInternet)
    }
    
    func displayData(viewModel: Auth.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .internetStatus(let isConnected):
            if !isConnected {
                router?.navigateTo(toVC: NetworkError(), animated: true)
            }
        }
        
    }
    
    
    func views() {
        
        welcomeImage.image = UIImage(named: "samarkand")
        welcomeImage.clipsToBounds = true
        welcomeImage.contentMode = .scaleAspectFill
        
        bottomView.backgroundColor = .white
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 15
        bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        logInBtn.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        signUpBtn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        agreementLabel.text = "By creating your account, you agree with our"
        agreementLabel.font = .systemFont(ofSize: captionSize, weight: .medium)
        agreementLabel.textColor = .darkGray
        
        agreementBtn.setTitle("Privacy Policy", for: .normal)
        agreementBtn.titleLabel?.font = .systemFont(ofSize: captionSize, weight: .medium)
        agreementBtn.setTitleColor(.systemBlue, for: .normal)
        agreementBtn.addTarget(self, action: #selector(showAgreement), for: .touchUpInside)
        
        skipBtn.addTarget(self, action: #selector(skipAuth), for: .touchUpInside)
        
    }
    
    func layout() {
        
        NSLayoutConstraint.activate([
            welcomeImage.topAnchor.constraint(equalTo: view.topAnchor),
            welcomeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            welcomeImage.heightAnchor.constraint(equalToConstant: view.bounds.height),

            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: CGFloat(welcomeImage.image!.size.height / BVDevider)),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            logInBtn.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15),
            logInBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            logInBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            logInBtn.heightAnchor.constraint(equalToConstant: buttonHeight),

            signUpBtn.topAnchor.constraint(equalTo: logInBtn.bottomAnchor, constant: 10),
            signUpBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            signUpBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            signUpBtn.heightAnchor.constraint(equalToConstant: buttonHeight),

            agreementLabel.topAnchor.constraint(equalTo: signUpBtn.bottomAnchor, constant: 15),
            agreementLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            agreementBtn.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor),
            agreementBtn.centerXAnchor.constraint(equalTo: agreementLabel.centerXAnchor),

            skipBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            skipBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            skipBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
        
        if screenHeight < 812 {
            skipBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        } else {
            skipBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        
    }
    
    
    @objc func showAgreement() {
        let agreementVC = Agreement()
        if let sheet = agreementVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        present(agreementVC, animated: true)
    }
    
    
    @objc func skipAuth() {
        router?.navigateTo(toVC: SkipViewController(), animated: true)
    }
    

    @objc func signUp() {
        router?.navigateTo(toVC: SignupViewController(), animated: true)
    }
    

    @objc func logIn() {
        router?.navigateTo(toVC: LoginViewController(), animated: true)
    }
    
}
