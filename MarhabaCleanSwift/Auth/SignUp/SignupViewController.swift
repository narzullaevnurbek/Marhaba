//
//  SignUp.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 17/01/23.
//

import UIKit
import Network
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

protocol SignupViewControllerType {
    func displayData(viewModel: Signup.Model.ViewModel.ViewModelData)
}

class SignupViewController: UIViewController, UITextFieldDelegate, SignupViewControllerType {
    
    var interactor: SignupInteractorType?
    var router: SignupRouterType?
        
    let backButton = UIButton()
    
    let emailEnter = CustomTextField(style: .info, placeholdeer: nil, iconName: nil)
    let emailPr = CustomPlaceholder(title: "Email address")
    
    let nameEnter = CustomTextField(style: .info, placeholdeer: nil, iconName: nil)
    let namePr = CustomPlaceholder(title: "First name")
    
    let continueBtn = CustomButton(style: .black, title: "Continue", shadow: .shadow)
    let orLine = UIView()
    let orLabel = UILabel()
    
    let GoogleBtn = UIButton()
    let GoogleIcon = UIImageView()
    
    let AppleBtn = UIButton()
    let AppleIcon = UIImageView()
    
    let logInBtn = CustomButton(style: .clear, title: "Have an account?", shadow: .none)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        [emailEnter, emailPr, nameEnter, namePr, continueBtn, orLine, orLabel, GoogleBtn, GoogleIcon, AppleBtn, AppleIcon, logInBtn].forEach { item in
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
        let interactor              = SignupInteractor()
        let presenter               = SignupPresenter()
        let router                  = SignupRouter()
        viewController.interactor   = interactor
        viewController.router       = router
        interactor.presenter        = presenter
        presenter.viewController    = viewController
        router.viewController       = viewController
        
        interactor.makeRequest(request: .checkInternet)
    }
    
    
    func displayData(viewModel: Signup.Model.ViewModel.ViewModelData) {
        
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
        let alert = UIAlertController(title: "Account is in use", message: "There is an account for the provided info, try to log in", preferredStyle: .alert)
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
        title = "Sign Up"
        
        emailEnter.addTarget(self, action: #selector(upPrs(sender:)), for: .editingDidBegin)
        emailEnter.addTarget(self, action: #selector(downPrs(sender:)), for: .editingDidEnd)
        emailEnter.addTarget(self, action: #selector(entryCheck), for: .allEditingEvents)
        emailEnter.delegate = self
        emailEnter.keyboardType = .emailAddress
        emailEnter.returnKeyType = .next
        
        nameEnter.addTarget(self, action: #selector(upPrs(sender:)), for: .editingDidBegin)
        nameEnter.addTarget(self, action: #selector(downPrs(sender:)), for: .editingDidEnd)
        nameEnter.addTarget(self, action: #selector(entryCheck), for: .allEditingEvents)
        nameEnter.delegate = self
        nameEnter.autocapitalizationType = .words
        nameEnter.returnKeyType = .done
        
        continueBtn.disabled()
        continueBtn.addTarget(self, action: #selector(finishSignUp), for: .touchUpInside)
        
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
        GoogleBtn.setTitle("Sign up with Google", for: .normal)
        GoogleBtn.addTarget(self, action: #selector(signUpWithGoogle), for: .touchUpInside)
        GoogleIcon.image = UIImage(named: "google")
        
        AppleBtn.addTarget(self, action: #selector(appleSignUpClick), for: .touchUpInside)
        AppleBtn.layer.cornerRadius = buttonCornerRadius
        AppleBtn.setTitle("Sign up with Apple", for: .normal)
        AppleBtn.setTitleColor(.deepBlack, for: .normal)
        AppleBtn.titleLabel?.font = .systemFont(ofSize: BTSize, weight: .medium)
        AppleBtn.backgroundColor = .smokyWhite
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold, scale: .large)
        AppleIcon.image = UIImage(systemName: "apple.logo", withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        
        logInBtn.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            emailEnter.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            emailEnter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            emailEnter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            emailEnter.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            emailPr.leadingAnchor.constraint(equalTo: emailEnter.leadingAnchor, constant: PRLeftMargin),
            emailPr.centerYAnchor.constraint(equalTo: emailEnter.centerYAnchor),
            emailPr.widthAnchor.constraint(equalToConstant: emailPr.intrinsicContentSize.width + 10),
            
            nameEnter.topAnchor.constraint(equalTo: emailEnter.bottomAnchor, constant: 15),
            nameEnter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            nameEnter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            nameEnter.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            namePr.leadingAnchor.constraint(equalTo: nameEnter.leadingAnchor, constant: PRLeftMargin),
            namePr.centerYAnchor.constraint(equalTo: nameEnter.centerYAnchor),
            namePr.widthAnchor.constraint(equalToConstant: namePr.intrinsicContentSize.width + 10),
            
            continueBtn.topAnchor.constraint(equalTo: nameEnter.bottomAnchor, constant: 15),
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
            
            logInBtn.topAnchor.constraint(equalTo: AppleBtn.bottomAnchor, constant: 15),
            logInBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            logInBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            logInBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }
    
    @objc func backToAuth() {
        router?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 40
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
    
    @objc func upPrs(sender: UIView) {
        
        if sender == emailEnter {
            UIView.animate(withDuration: 0.3, animations: {
                self.emailPr.transform = CGAffineTransform(translationX: 0, y: -CGFloat(self.emailEnter.frame.height / 2))
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.namePr.transform = CGAffineTransform(translationX: 0, y: -CGFloat(self.nameEnter.frame.height / 2))
            })
        }
        
    }
    
    @objc func downPrs(sender: UIView) {
        
        if sender == emailEnter {
            guard let emailInputLength = emailEnter.text?.count else { return }
            if emailInputLength == 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.emailPr.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            }
        } else {
            guard let nameInputLength = nameEnter.text?.count else { return }
            if nameInputLength == 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.namePr.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            }
        }
        
    }
    
    @objc func entryCheck() {
        
        guard let userEmail = emailEnter.text else { return }
        guard let userName = nameEnter.text else { return }
        
        if userEmail.isValidEmail() {
            emailEnter.layer.borderColor = UIColor.deepBlack.cgColor
            emailPr.textColor = .deepBlack
        } else {
            emailEnter.layer.borderColor = UIColor.smokyWhite.cgColor
            emailPr.textColor = .grey
        }
        
        if userName.isValidName() {
            nameEnter.layer.borderColor = UIColor.deepBlack.cgColor
            namePr.textColor = .deepBlack
        } else {
            nameEnter.layer.borderColor = UIColor.smokyWhite.cgColor
            namePr.textColor = .grey
        }
        
        if userEmail.isValidEmail() && userName.isValidName() {
            self.continueBtn.enabled()
        } else {
            self.continueBtn.disabled()
        }
        
    }
    
    @objc func finishSignUp() {
        
        continueBtn.disabled()
        guard let userEmail = emailEnter.text?.lowercased() else { return }
        guard let userName = nameEnter.text else { return }

        if userEmail == "demoaccount@demo.com" {
            interactor?.makeRequest(request: .saveDemoAccount(email: userEmail, name: "Apple"))
        } else {
            interactor?.makeRequest(request: .checkUser(email: userEmail, name: userName))
        }
        
    }
    
    @objc func goToLogin() {
        router?.navigateTo(toVC: LoginViewController(), animated: true)
    }
    
    
    @objc func signUpWithGoogle() {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in

            guard let user = result?.user else { return }

            guard error == nil else {
                print("error in logging with Google account: \(error)")
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
            
            self.interactor?.makeRequest(request: .googleSignup(email: userEmail, name: userName))
        }
    }
    
    
    @objc func appleSignUpClick() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
}


extension SignupViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user

            guard let userName = appleIDCredential.fullName?.givenName else { return }
            guard let userEmail = appleIDCredential.email else { return }

            self.interactor?.makeRequest(request: .appleSignup(email: userEmail, name: userName))
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error while signing in with Apple")
    }
}


extension SignupViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
