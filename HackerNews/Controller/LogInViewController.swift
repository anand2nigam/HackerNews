//
//  LogInViewController.swift
//  HackerNews
//
//  Created by Anand Nigam on 30/12/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LogInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    

    

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
   
    
    @IBAction func SignUpButtonPressed(_ sender: UIButton) {
        
        if (emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false) {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    print("Registration Successful")
                    self.performSegue(withIdentifier: "goToNewsFeed", sender: self)
                }
                
            }
            
        }
        
        
        
    }
    
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        
        if (emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false) {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                
                if error != nil {
                    print("Problem in logging in \(String(describing: error))")
                } else {
                    print("\(String(describing: result?.user )) logged in")
                    self.performSegue(withIdentifier: "goToNewsFeed", sender: self)
                }
                
            }
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    

    // MARK:-  Delegate Method of GoogleSignIn
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        print(credential)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if error != nil {
                print(error!)
            } else {
                print("Registration Successful")
                self.performSegue(withIdentifier: "goToNewsFeed", sender: self)
            }
        }
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("An error occurred while signing out")
        }
    }


}
