//
//  ViewController.swift
//  iOSApp
//
//  Created by Ngendo Muhayimana on 2020-10-03.
//

import UIKit
import Amplify
import AWSMobileClient

let isSignedIn: () -> Bool = { AWSMobileClient.default().isSignedIn }

class ViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    let logTitle: () -> String = {
        if isSignedIn() {
            return AWSMobileClient.default().username ?? "No ID"
        } else {
            return "Login"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAWSMobileClient()
        
        // Do any additional setup after loading the view.
    }
    
    
    func initializeAWSMobileClient() {
        
        AWSMobileClient.default().initialize { (userState, error) in
            self.loginBtn.setTitle(self.logTitle(), for: .normal)
        }
    }

    @IBAction func touchedLogin(_ sender: Any) {        
        isSignedIn() ? showLogout() : showSignedIn()
    }
    
    func showSignedIn() {
        
        _ = Amplify.Auth.signInWithWebUI(presentationAnchor: self.view.window!) { result in
            switch result {
            case .success(_):
                print("Sign in succeeded")
            case .failure(let error):
                print("Sign in failed \(error)")
            }
            
            DispatchQueue.main.async {
                self.loginBtn.setTitle(self.logTitle(), for: .normal)
            }
        }
    }
    
    
    func showLogout() {
        _ = Amplify.Auth.signOut { result in
            DispatchQueue.main.async {
                self.loginBtn.setTitle(self.logTitle(), for: .normal)
            }
        }
    }
    
}

