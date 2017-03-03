//
//  FeedVC.swift
//  socialapp
//
//  Created by Jason Buhagiar on 3/3/17.
//  Copyright © 2017 Jason Buhagiar. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signInTapped(_ sender: Any) {
        //let keychainResult = KeychainWrapper.removeObjectForKey(KEY_UID)
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.remove(key: KEY_UID)
        print("Jase: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

}
