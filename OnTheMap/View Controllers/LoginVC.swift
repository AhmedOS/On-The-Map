//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Ahmed Osama on 11/11/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    let loginSuccessSegueID = "loginSuccess"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        enableUIControllers(true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        enableUIControllers(false)
        NetworkingManager.Udacity.login(username: emailTextField.text!,
                                        password: passwordTextField.text!) { (errorMessage) in
            if let errorMessage = errorMessage {
                self.enableUIControllers(true)
                Helpers.showSimpleAlert(viewController: self,
                                        title: "Failed to Login", message: errorMessage)
            }
            else {
                self.performSegue(withIdentifier: self.loginSuccessSegueID, sender: self)
            }
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        let url = URL(string: "https://auth.udacity.com/sign-up")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func enableUIControllers(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = enabled
            self.passwordTextField.isEnabled = enabled
            self.loginButton.isEnabled = enabled
            self.signupButton.isEnabled = enabled
            enabled ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
        }
    }
    
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
