//
//  ViewController.swift
//  Supportal
//
//  Created by Suresh Machetti on 9/26/16.
//  Copyright © 2016 Oak Labs. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UsernameTextField.delegate = self
        PasswordTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        let button = UIButton()
        button.addShadowView()
        UsernameTextField.text = "Enter Username"
        PasswordTextField.text = "Enter Password"
        UsernameTextField.textColor = UIColor.lightGray
        PasswordTextField.textColor = UIColor.lightGray
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
    */
    /*
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
