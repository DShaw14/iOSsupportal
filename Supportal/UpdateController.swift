//
//  UpdateController.swift
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

class UpdateController: UIViewController, UITextFieldDelegate {
    //Username Label
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUsername = User.get_UserName()
        usernameLabel.text = currentUsername
        changePassword.layer.cornerRadius = 4
        changeEmail.layer.cornerRadius = 4
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Update Account Info Text Fields
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    @IBOutlet weak var currentEmail: UITextField!
    @IBOutlet weak var newEmail: UITextField!
    
    @IBOutlet weak var changePassword: UIButton!
    @IBOutlet weak var changeEmail: UIButton!
    
    @IBAction func changeEmail(_ sender: UIButton) {
        let parameters: [String: Any] = [
            "email" : "\(newEmail.text!)"
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
        else if (User.get_IsUserLoggedIn() == false && (newPassword.text == confirmNewPassword.text))
        {
            // Attempt to get a token
            Alamofire.request("http://hurst.pythonanywhere.com/supportal/rest-auth/user/", method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: myheader).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json)")
                        User.set_IsUserLoggedIn(state: true)
                        print("User Account " + "\(self.currentPassword.text!)" + " Created")
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
        }
        
        
    }
    @IBAction func changePassword(_ sender: UIButton) {
        let parameters: [String: Any] = [
            "new_password1" : "\(newPassword.text!)",
            "new_password2" : "\(confirmNewPassword.text!)"
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
        else if (User.get_IsUserLoggedIn() == false && (newPassword.text == confirmNewPassword.text))
        {
            // Attempt to get a token
            Alamofire.request("http://hurst.pythonanywhere.com/supportal/rest-auth/registration/", method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: myheader).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json)")
                        User.set_IsUserLoggedIn(state: true)
                        print("User Account " + "\(self.currentPassword.text!)" + " Created")
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
        }
    }
}
