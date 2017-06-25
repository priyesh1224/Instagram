//
//  ViewController.swift
//  Instagram
//
//  Created by PRIYESH  on 02/04/17.
//  Copyright © 2017 PRIYESH . All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class ViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self as! UITextFieldDelegate
        password.delegate = self as! UITextFieldDelegate
       
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
        return true
    }
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "auth"){
            performSegue(withIdentifier: "gotofeed", sender: nil)
        }
        
    }



    @IBAction func fbBtnTapped(_ sender: Any) {
        let facebooklogin = FBSDKLoginManager()
    
        facebooklogin.logIn(withReadPermissions: ["email"], from: self) { (result , error) in
            if error != nil {
                print("JESS : unable to authenticated with facebook")
            }else if result?.isCancelled == true {
                print("permission denied by user")
            }else {
                print("JESS : Success connecting to facebook")
                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                print("-----------------------------------")
                print(credentials)
                self.firebaseauth(credentials: credentials)
            }
            
            }
    }
    @IBAction func signinBtnTapped(_ sender: Any) {
        if let email = self.email.text ,let pass = self.password.text
            {
            FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil {
                    print("JESS email user authenticated with firebase")
                    self.goahead()
                }
                else{
                    FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
                        if error != nil {
                            print(error.debugDescription)
                        
                        }else {
                            print("JESS user created")
                            KeychainWrapper.standard.set((user?.uid)!, forKey: "auth")
                            DataServices.ds.createUser(uid: (user?.uid)!, userdata: ["provider": (user?.providerID)!,"EMAIL": email,"password": pass])
                            self.goahead()
                        }
                    })
                }
            })
        }
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
    }

    
    
    func firebaseauth(credentials : FIRAuthCredential)
    {
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error)   in
            if error != nil {
                print("JESS : unable to authenticated with firebase")
            
            }else {
                print("JESS : Success connecting to facebook")
                DataServices.ds.createUser(uid: (user?.uid)!, userdata: ["provider": (user?.providerID)!])
                KeychainWrapper.standard.set((user?.uid)!, forKey: "auth")
                self.goahead()

            }

        })
    
        }
    
    func goahead()
    {
        performSegue(withIdentifier: "gotofeed", sender: nil)

    }
    
    
    
    
}

