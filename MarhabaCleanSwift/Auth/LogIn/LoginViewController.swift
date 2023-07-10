//
//  Skip.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 16/01/23.
//

import UIKit
import Network
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

protocol LoginViewControllerType {
    func displayData(viewModel: Login.Model.viewModel.viewModelData)
}

class LoginViewController: UIViewController, UITextFieldDelegate, LoginViewControllerType {
    
    var interactor: LoginInteractorType?
    var router: LoginRouterType?

    let backButton = UIButton()
    let emailEnter = CustomTextField(style: .info, placeholdeer: nil, iconName: nil)
    let emailPr = CustomPlaceholder(title: "Email address")
    let continueBtn = CustomButton(style: .black, title: "Continue", shadow: .shadow)
    
    let orLine = UIView()
    let orLabel = UILabel()
    
    let GoogleBtn = UIButton()
    let GoogleIcon = UIImageView()
    
    let AppleBtn = UIButton()
    let AppleIcon = UIImageView()
    
    let signUpBtn = CustomButton(style: .clear, title: "Does not have an account?", shadow: .none)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        [backButton, emailEnter, emailPr, continueBtn, orLine, orLabel, GoogleBtn, GoogleIcon, AppleBtn, AppleIcon, signUpBtn].forEach { item in
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setup()
        backButtonSetup()
        views()
        layout()
    }
    
    
    
    private func setup() {
        let viewController        = self
        let interactor            = LoginInteractor()
        let presenter             = LoginPreseneter()
        let router                = LoginRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        
        interactor.makeRequest(request: .checkInternet)
    }
    
    
    func displayData(viewModel: Login.Model.viewModel.viewModelData) {
        
        switch viewModel {
        case .internetStatus(let isConnected):
            router?.networkConnection(isConnected: isConnected)
        case .userIsChecked(let valid, let loginType):
            router?.userIsChecked(valid: valid, loginType: loginType)
        case .invalidUser:
            invalidUser()
        }
        
    }
    
    
    private func invalidUser() {
        let alert = UIAlertController(title: "Account does not exist", message: "There is no account for the provided info, try to sign up", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
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
        title = "Log In"
        
        emailEnter.addTarget(self, action: #selector(upPrs), for: .editingDidBegin)
        emailEnter.addTarget(self, action: #selector(downPrs), for: .editingDidEnd)
        emailEnter.addTarget(self, action: #selector(emailCheck), for: .allEditingEvents)
        emailEnter.delegate = self
        emailEnter.keyboardType = .emailAddress
        emailEnter.returnKeyType = .next
        
        continueBtn.addTarget(self, action: #selector(finishLogIn), for: .touchUpInside)
        continueBtn.disabled()
        
        orLine.backgroundColor = .smokyWhite
        orLabel.text = "OR"
        orLabel.textColor = .deepBlack
        orLabel.backgroundColor = .white
        orLabel.font = .systemFont(ofSize: 16, weight: .medium)
        orLabel.textAlignment = .center
        
        GoogleBtn.backgroundColor = .smokyWhite
        GoogleBtn.setTitleColor(.deepBlack, for: .normal)
        GoogleBtn.titleLabel?.font = .systemFont(ofSize: BTSize, weight: .medium)
        GoogleBtn.layer.cornerRadius = buttonCornerRadius
        GoogleBtn.setTitle("Log in with Google", for: .normal)
        GoogleBtn.addTarget(self, action: #selector(loginWithGoogle), for: .touchUpInside)
        GoogleIcon.image = UIImage(named: "google")
        
        AppleBtn.addTarget(self, action: #selector(appleSignInClick), for: .touchUpInside)
        AppleBtn.layer.cornerRadius = buttonCornerRadius
        AppleBtn.setTitle("Log in with Apple", for: .normal)
        AppleBtn.setTitleColor(.deepBlack, for: .normal)
        AppleBtn.titleLabel?.font = .systemFont(ofSize: BTSize, weight: .medium)
        AppleBtn.backgroundColor = .smokyWhite
        let largeAppleIcon = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold, scale: .large)
        AppleIcon.image = UIImage(systemName: "apple.logo", withConfiguration: largeAppleIcon)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        signUpBtn.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            emailEnter.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            emailEnter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            emailEnter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            emailEnter.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            emailPr.leadingAnchor.constraint(equalTo: emailEnter.leadingAnchor, constant: gridSize),
            emailPr.centerYAnchor.constraint(equalTo: emailEnter.centerYAnchor),
            emailPr.widthAnchor.constraint(equalToConstant: emailPr.intrinsicContentSize.width + 10),
            
            continueBtn.topAnchor.constraint(equalTo: emailEnter.bottomAnchor, constant: 15),
            continueBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            continueBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            continueBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            orLine.topAnchor.constraint(equalTo: continueBtn.bottomAnchor, constant: 30),
            orLine.heightAnchor.constraint(equalToConstant: 2),
            orLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            orLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            
            orLabel.centerXAnchor.constraint(equalTo: orLine.centerXAnchor),
            orLabel.centerYAnchor.constraint(equalTo: orLine.centerYAnchor),
            orLabel.widthAnchor.constraint(equalToConstant: 60),
            
            GoogleBtn.topAnchor.constraint(equalTo: orLine.bottomAnchor, constant: 30),
            GoogleBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            GoogleBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            GoogleBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
            GoogleIcon.centerYAnchor.constraint(equalTo: GoogleBtn.centerYAnchor),
            GoogleIcon.leadingAnchor.constraint(equalTo: GoogleBtn.leadingAnchor, constant: gridSize),
            GoogleIcon.widthAnchor.constraint(equalToConstant: 30),
            GoogleIcon.heightAnchor.constraint(equalToConstant: 30),
            
            AppleBtn.topAnchor.constraint(equalTo: GoogleBtn.bottomAnchor, constant: 15),
            AppleBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            AppleBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            AppleBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
            AppleIcon.centerYAnchor.constraint(equalTo: AppleBtn.centerYAnchor),
            AppleIcon.leadingAnchor.constraint(equalTo: AppleBtn.leadingAnchor, constant: gridSize),
            
            signUpBtn.topAnchor.constraint(equalTo: AppleBtn.bottomAnchor, constant: 15),
            signUpBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            signUpBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            signUpBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }
    
    
    @objc func backToAuth() {
        router?.popViewController(animated: true)
    }
    
    
    @objc func upPrs() {
        UIView.animate(withDuration: 0.3, animations: {
            self.emailPr.transform = CGAffineTransform(translationX: 0, y: -CGFloat(self.emailEnter.frame.height / 2))
        })
    }
    
    
    @objc func downPrs() {
        guard let userEmailLength = emailEnter.text?.count else { return }
        
        if userEmailLength == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.emailPr.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
        
    }
    
    
    @objc func emailCheck() {
        guard let userEmail = emailEnter.text else { return }
        
        if userEmail.isValidEmail() {
            emailEnter.layer.borderColor = UIColor.deepBlack.cgColor
            emailPr.textColor = .deepBlack
            continueBtn.enabled()
        } else {
            emailEnter.layer.borderColor = UIColor.smokyWhite.cgColor
            emailPr.textColor = .grey
            continueBtn.disabled()
        }
        
    }
    
    
    @objc func finishLogIn() {
        
        continueBtn.disabled()
        guard let userEmail = emailEnter.text?.lowercased() else { return }

        if userEmail == "demoaccount@demo.com" {
            //router?.navigateTo(toVC: Explore(), animated: true)
            interactor?.makeRequest(request: .saveDemoAccount(email: userEmail, name: "Apple"))
        } else {
            interactor?.makeRequest(request: .checkUser(email: userEmail))
        }
        
    }
    
    
    @objc func goToSignUp() {
        router?.navigateTo(toVC: SignupViewController(), animated: true)
    }
    
    
    @objc func loginWithGoogle() {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in

            guard let user = result?.user else { return }

            guard error == nil else {
                print("error in logging with Google account: \(String(describing: error))")
                return
            }

            guard let userName = user.profile?.givenName else {
                print("error in google givenName")
                return
            }

            guard let userEmail = user.profile?.email.lowercased() else {
                print("error in google email address")
                return
            }
            
            self.interactor?.makeRequest(request: .googleLogin(email: userEmail))
        }
        
    }
    
    
    @objc func appleSignInClick() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
}


extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            guard let userName = appleIDCredential.fullName?.givenName else { return }
            guard let userEmail = appleIDCredential.email else { return }
            
            interactor?.makeRequest(request: .appleLogin(email: userEmail))
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error while signing in with Apple")
    }
}


extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
