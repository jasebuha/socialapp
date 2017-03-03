//
//  ViewController.swift
//  socialapp
//
//  Created by Jason Buhagiar on 3/2/17.
//  Copyright © 2017 Jason Buhagiar. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {

        let loginManager = LoginManager()
        loginManager.logIn([ ReadPermission.publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("Jase: Unable to authenticate with Facebook.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Jase: Successfully authenticated with Facebook!")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let error = error {
                print("Jase: Unable to authenticate with Firebase - \(error)")
            } else {
                print("Jase: Successfully authenticated with Firebase!")
            }
        }
    }
}


















