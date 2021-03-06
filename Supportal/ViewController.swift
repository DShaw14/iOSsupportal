//
//  ViewController.swift
//  Supportal
//
//  Created by Suresh Machetti on 9/26/16.
//  Copyright © 2016 Oak Labs. All rights reserved.
//

import UIKit
import Starscream
import SlackKit
import Alamofire
import SwiftyJSON
import Foundation

//workspace "Supportal"

extension UIView {
    
    func addShadowView(width:CGFloat=0.2, height:CGFloat=0.2, Opacidade:Float=0.7, maskToBounds:Bool=false, radius:CGFloat=0.5){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Opacidade
        self.layer.masksToBounds = maskToBounds
    }
}
class ViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var enteredValue: UILabel!
    
    // MARK: Properties
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet var buttons : [UIView]!
    
    func loginAlert(alertMessage: String)
    {
        let loginAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        loginAlert.addAction(okAction)
        
        self.present(loginAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        UsernameTextField.delegate = self
        PasswordTextField.delegate = self
        
        // Do any additional setup after loading the view
        let button = UIButton()
        button.addShadowView()
        loginButton.layer.cornerRadius = 4
        forgotPassword.layer.cornerRadius = 4
        createAccount.layer.cornerRadius = 4
        loginButton.addShadowView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func buttonClicked(sender: AnyObject) {
        textField.resignFirstResponder();
        enteredValue.text = textField.text;
    }
    @nonobjc func textFieldDidBeginEditing(textField: UITextField) {
        UsernameTextField.placeholder = nil
        PasswordTextField.placeholder = nil
    }
    @nonobjc func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard on return key
        textField.resignFirstResponder()
        return true
    }
    @nonobjc func textFieldDidEndEditing(textField: UITextField) {
        UsernameTextField.text = textField.text
        PasswordTextField.text = textField.text
    }
    
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButton(_ sender: UIButton) {
        let parameters: [String: Any] = [
            "username" : "\(UsernameTextField.text!)",
            "password" : "\(PasswordTextField.text!)"
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
        else if (User.get_IsUserLoggedIn() == false)
        {
            // Attempt to get a token
            Alamofire.request("http://hurst.pythonanywhere.com/supportal/rest-auth/login/", method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: myheader).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json)")
                        User.set_IsUserLoggedIn(state: true)
                        print("User is logged in")
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

class TextField : UITextField {
    
    override func draw(_ rect: CGRect) {
        
        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 2.0
        
        tintColor.setStroke()
        
        path.stroke()
    }
    
}
