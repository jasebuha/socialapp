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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var pwdField: FancyField!
    
    
        //viewDidLoad cannot perform segues
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        //viewDidAppear can perform a segue
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID){
            print("Jase: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                
                }
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("Jase: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Jase: Unable to authenticate with Firebase using email")
                        } else {
                            print("Jase: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                            
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFibaseDBuser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
        print("Jasebuha: Data Saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

















