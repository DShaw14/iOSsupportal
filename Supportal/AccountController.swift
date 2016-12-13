//
//  AccountController.swift
//  Supportal
//
//  Created by Zachary A. Menken on 12/12/16.
//  Copyright © 2016 Oak Labs. All rights reserved.
//

import UIKit
import Starscream
import SlackKit
import Alamofire
import SwiftyJSON
import Foundation

class AccountController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        desiredUsername.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        email.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Create Account Text Fields
    @IBOutlet weak var desiredUsername: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var createAccount: UIButton!
    
    @IBAction func createAccount(_ sender: UIButton) {
        let parameters: [String: Any] = [
            "username"  : "\(desiredUsername.text!)",
            "email"     : "\(email.text!)",
            "password1" : "\(password.text!)",
            "password2" : "\(confirmPassword.text!)"
        ]
        
        let myheader:HTTPHeaders = [
            //"Authorization": "Basic",
            "Accept": "application/json",
            "application-type":"REST",
            "Content-Type":"application/json",
            ]
        
        var myCookie = 0
        for cookie in HTTPCookieStorage.shared.cookies! {
            myCookie += 1
            print("EXTRACTED COOKIE: \(cookie)")
        }
        if myCookie > 1
        {
            User.set_IsUserLoggedIn(state: true)
        }
        else
        {
            User.set_IsUserLoggedIn(state: false)
        }
        
        if (User.get_IsUserLoggedIn() == true)
        {
            // Logout and change the button to read "Log in"
            //Remove all cache
            URLCache.shared.removeAllCachedResponses()
            URLCache.shared.diskCapacity = 0
            URLCache.shared.memoryCapacity = 0
            
            if let cookies = HTTPCookieStorage.shared.cookies {
                for cookie in cookies {
                    if let _ = cookie.domain.range(of: "pythonanywhere.com") {
                        print("\(#function): deleted cookie: \(cookie)")
                        HTTPCookieStorage.shared.deleteCookie(cookie)
                    }
                }
            }
            print("User is not logged in")
        }
        else if (User.get_IsUserLoggedIn() == false && (password.text == confirmPassword.text))
        {
            // Attempt to get a token
            Alamofire.request("http://hurst.pythonanywhere.com/supportal/rest-auth/registration/", method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: myheader).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json)")
                        User.set_IsUserLoggedIn(state: true)
                        print("User Account " + "\(self.desiredUsername.text!)" + " Created")
                    }
                case .failure(let error):
                    User.set_IsUserLoggedIn(state: false)
                    print(error)
                }
                if let cookies = HTTPCookieStorage.shared.cookies {
                    for cookie in cookies {
                        NSLog("\(cookie)")
                    }
                }
                
    }
    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
   //  }
        }
        }
}
