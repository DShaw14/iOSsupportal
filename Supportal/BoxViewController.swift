//
//  BoxViewController.swift
//  Supportal
//
//  Created by Zachary A. Menken on 10/20/16.
//  Copyright © 2016 Oak Labs. All rights reserved.
//

import UIKit
import Starscream
import SlackKit

class BoxViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var highPriority: UISwitch!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var issueField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        let nameInput = self.nameField.text
        let issueInput = self.issueField.text
        let descriptonInput = self.descriptionField.text
        
        if !nameInput!.isEmpty && !issueInput!.isEmpty && !descriptonInput!.isEmpty {
            if highPriority.isOn {
                let incoming = IncomingWebhook(url: "https://hooks.slack.com/services/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", channel:"#random", username:"\(nameInput!)")
                let message = Response(text: "Issue:\r\n" + "\(issueInput!)\r\n" + "\r\n" + "Description:\r\n" + "\(descriptonInput!)")
                incoming.postMessage(message)
                highPriority.setOn(false, animated:true)
            } else {
                highPriority.setOn(false, animated:true)
            }
        }
        else{
            print("Needs to contain information.")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
