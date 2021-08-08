//
//  SignInWithAppleViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-07-15.
//

import UIKit
import AuthenticationServices

class SignInWithAppleViewController: UIViewController, ASAuthorizationControllerDelegate {

    @IBAction func signInWithAppleBtn(_ sender: Any) {
        print("button clicked")
        
    }

    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var buttonView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        appLogo.layer.cornerRadius = 5
signInWIthAppleButton()
        // Do any additional setup after loading the view.
    }
    
    func signInWIthAppleButton() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.cornerRadius = 5
        self.buttonView.backgroundColor = .black
        self.buttonView.layer.cornerRadius = 5
        authorizationButton.constraints.forEach({
            $0.isActive = false
        })
        self.buttonView.addSubview(authorizationButton)
       
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([authorizationButton.centerXAnchor.constraint(equalTo: self.buttonView.centerXAnchor),authorizationButton.centerYAnchor.constraint(equalTo: self.buttonView.centerYAnchor), authorizationButton.leftAnchor.constraint(equalTo: self.buttonView.leftAnchor, constant: 1), authorizationButton.rightAnchor.constraint(equalTo: self.buttonView.rightAnchor, constant: -1),authorizationButton.heightAnchor.constraint(equalTo: self.buttonView.heightAnchor, constant: -2)])
        
      
    }
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
        
      
    }
    /* this function is called after icloud account is signed in.*/
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            if !userIdentifier.isEmpty {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
            }
            print("UserId:\(userIdentifier)")
            print("FullName:\(fullName)")
            print("email:\(email)")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
