//
//  ViewController.swift
//  SignInWithApple
//
//  Created by Junio Moquiuti on 23/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import AuthenticationServices

final class ViewController: UIViewController {

    @IBOutlet weak var userAuthenticationLabel: UILabel!
    @IBOutlet weak var authorizationButton: ASAuthorizationAppleIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAuthenticationLabel.text = nil
        authorizationButton.layer.borderWidth = 1
        authorizationButton.layer.cornerRadius = 8
        authorizationButton.layer.borderColor = UIColor.black.cgColor
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
    }
    
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension ViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            var userCredentials = "User id is \(appleIDCredential.user)"
            
            if let fullName = appleIDCredential.fullName {
                userCredentials.append(contentsOf: "\nFull Name is \(fullName)")
            }
            
            if let email = appleIDCredential.email {
                userCredentials.append(contentsOf: "\nEmail id is \(email)")
            }
            
            userAuthenticationLabel.text = userCredentials
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}
