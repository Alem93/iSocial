//
//  FeedViewController.swift
//  iSocial
//
//  Created by Alejandro Mamchur on 8/18/17.
//  Copyright © 2017 Alejandro Mamchur. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        KeychainWrapper.defaultKeychainWrapper.remove(key: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
}
