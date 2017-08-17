//
//  ViewController.swift
//  iSocial
//
//  Created by Alejandro Mamchur on 8/14/17.
//  Copyright © 2017 Alejandro Mamchur. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper


class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func facebookButtonPressed(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("JESS: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("JESS: User cancelled Facebook authentication")
            } else {
                print("JESS: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("JESS: Unable to authenticate with Firebase - \(error)")
            } else {
                print("JESS: Successfully authenticated with Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                }
            }
        })
    }
    
}

