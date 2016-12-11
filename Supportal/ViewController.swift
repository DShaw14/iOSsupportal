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
        // Do any additional setup after loading the view, typically from a nib.
        let button = UIButton()
        button.addShadowView()
        //UsernameTextField.text = ""
        //PasswordTextField.text = ""
        //UsernameTextField.textColor = UIColor.lightGray
        //PasswordTextField.textColor = UIColor.lightGray
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
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    @nonobjc func textFieldDidEndEditing(textField: UITextField) {
        UsernameTextField.text = textField.text
        PasswordTextField.text = textField.text
    }
    @IBAction func loginButton(_ sender: UIButton) {
        let parameters: [String: Any] = [
            "username" : "\(UsernameTextField.text!)",
            "email" : "email@email.com",
            "password" : "\(PasswordTextField.text!)"
        ]
   
        let myheader:HTTPHeaders = [
            //"Authorization": "Basic",
            "Accept": "application/json",
            "application-type":"REST",
            "Content-Type":"application/json",
        ]
        //Remove all cache
        URLCache.shared.removeAllCachedResponses()
        
        // deleting any associated cookies
        if let cookies = HTTPCookieStorage.shared.cookies {
        for cookie in cookies {
            HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        //.authenticate(user: "\(UsernameTextField.text!)" , password:"\(PasswordTextField.text!)")
        Alamofire.request("http://hurst.pythonanywhere.com/supportal/rest-auth/login/", method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: myheader).validate(contentType: ["application/json"]).responseJSON { response in
            //print(response.result)
            //print(response)
            switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json)")
                    }
                case .failure(let error):
                    print(error)
            }
            
            /*
            //to get status code
            if let status = response.response?.statusCode {
                switch(status){
                case 201:
                    print("example success")
                default:
                    print("error with response status: \(status)")
                }
            }
           
            //to get JSON return value
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                print(JSON)
            }
            */
        }
    }
    /*
    - (void)textFieldDidBeginEditing:(UITextField *)textField {
    UsernameTextField.placeholder = nil;
    }
    
    - (void)textFieldDidEndEditing:(UITextField *)textField
    {
    if ([UsernameTextFiled.text isEqualToString:@""] || [[UsernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0))
    {
    [UsernameTextField setText:@""];
    UsernameTextField.placeholder = @"Enter Username";
    }
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        self.UsernameTextField.delegate = self
        self.PasswordTextField.delegate = self
     
        if UsernameTextField.textColor == UIColor.lightGray
        {
            UsernameTextField.text = nil
            UsernameTextField.textColor = UIColor.black
        }
        if PasswordTextField.textColor == UIColor.lightGray
        {
            self.PasswordTextField.text = nil
            PasswordTextField.textColor = UIColor.black
        }
    }
    */


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
}
