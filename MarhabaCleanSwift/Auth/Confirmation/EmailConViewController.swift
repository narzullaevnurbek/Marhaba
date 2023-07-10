//
//  OTPConfirmation.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 21/01/23.
//

import UIKit
import CoreData
import Network

protocol EmailConViewControllerType {
    func displayData(viewModel: Email.Model.ViewModel.ViewModelData)
}

class EmailConViewController: UIViewController, UITextFieldDelegate, EmailConViewControllerType {
    
    var interactor: EmailInteractorType?
    var router: EmailRouterType?
    
    var defaults = UserDefaults.standard
    let backButton = UIButton()
    let explanation = UILabel()
    
    let otpEnter = CustomTextField(style: .info, placeholdeer: nil, iconName: nil)
    let resendOTP = UILabel()
    let resendOTPBtn = UIButton()
    
    var userEmail: String?
    var timer = Timer()
    let attdDescription = NSMutableAttributedString()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [explanation, otpEnter, resendOTP, resendOTPBtn].forEach { item in
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        setup()
        views()
        layout()
        
    }
    
    
    private func setup() {
        let viewController        = self
        let interactor            = EmailInteractor()
        let presenter             = EmailPresenter()
        let router                = EmailRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        
        interactor.makeRequest(request: .checkInternet)
    }
    
    
    func displayData(viewModel: Email.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .internetStatus(let isConnected):
            router?.networkConnection(isConnected: isConnected)
        case .OTPChanged:
            changeOTPText()
        case .fetchedLocalUserData(user: let user):
            attdDescription.normal("Enter the code that we have send to your email address", fontSize: PRSize, textColor: .grey)
            attdDescription.bold("\(user.email!)", fontSize: PRSize, space: " ", decoration: Optional.none)
        case .OTPResult(let valid):
            otpResult(valid: valid)
        }
        
    }
    
    
    private func otpResult(valid: Bool) {
        if valid {
            self.otpEnter.layer.borderColor = UIColor.systemGreen.cgColor
            router?.setPageTo(VC: ExploreViewController(), animated: true)
        } else if valid == false {
            self.otpEnter.layer.borderColor = UIColor.systemRed.cgColor
        } else {
            self.otpEnter.layer.borderColor = UIColor.smokyWhite.cgColor
        }
    }
    
    
    func views() {
        interactor?.makeRequest(request: .fetchUserFromLocalDB)
        
        title = "Email Confirmation"
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.contentVerticalAlignment = .fill
        backButton.contentHorizontalAlignment = .fill
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backToAuth), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        explanation.attributedText = attdDescription
        explanation.lineBreakStrategy = .standard
        explanation.lineBreakMode = .byWordWrapping
        explanation.numberOfLines = .max
        explanation.textAlignment = .left
        
        otpEnter.font = .systemFont(ofSize: PRSize)
        otpEnter.delegate = self
        otpEnter.addTarget(self, action: #selector(checkOTP), for: .editingChanged)
        otpEnter.layer.borderColor = UIColor.smokyWhite.cgColor
        otpEnter.keyboardType = .numberPad
        
        resendOTP.text = "Resend code after 01:30 seconds"
        resendOTP.font = .systemFont(ofSize: PRSize, weight: .medium)
        resendOTP.textColor = .deepBlack
        timer(second: 90)
        
        resendOTPBtn.setTitle("Send the code again", for: .normal)
        resendOTPBtn.titleLabel?.font = .systemFont(ofSize: PRSize, weight: .medium)
        resendOTPBtn.setTitleColor(.systemBlue, for: .normal)
        resendOTPBtn.isHidden = true
        resendOTPBtn.addTarget(self, action: #selector(resendOTPClick), for: .touchUpInside)
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            explanation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            explanation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            explanation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            
            otpEnter.topAnchor.constraint(equalTo: explanation.bottomAnchor, constant: 30),
            otpEnter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            otpEnter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
            otpEnter.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            resendOTP.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            resendOTP.topAnchor.constraint(equalTo: otpEnter.bottomAnchor, constant: 30),
            
            resendOTPBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            resendOTPBtn.centerYAnchor.constraint(equalTo: resendOTP.centerYAnchor),
        ])
    }
    
    
    @objc func resendOTPClick() {
        interactor?.makeRequest(request: .resendOTP)
    }
    
    
    private func changeOTPText() {
        resendOTP.text = "Resend code after 01:30 seconds"
        timer(second: 90)
        self.resendOTP.isHidden = false
        self.resendOTPBtn.isHidden = true
    }
    
    
    @objc func backToAuth() {
        router?.popViewController(animated: true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
    
    
    @objc func checkOTP() {
        guard let otpInput = otpEnter.text else { return }
        interactor?.makeRequest(request: .checkOTP(otpCode: otpInput))
    }
    
    
    func timer(second: Int) {
        
        var timerSeconds = second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            timerSeconds = self.discounter(timerSeconds)
            let s = timerSeconds % 60
            let m = timerSeconds / 60
            var result = ""
            
            if s < 10 {
                result = "Resend code after 0\(m):0\(s) seconds"
            } else {
                result = "Resend code after 0\(m):\(s) seconds"
            }
            
            self.resendOTP.text = result
            
            if m == 0 && s == 0 {
                timer.invalidate()
                self.resendOTP.isHidden = true
                self.resendOTPBtn.isHidden = false
            }
        }
        
    }
    
    func discounter(_ n: Int) -> Int {
        var x = n
        x -= 1
        return x
    }
    
    @objc func appMovedToBackground() {
        interactor?.makeRequest(request: .appMovedToBackground)
        print("End App")
    }
    
}
