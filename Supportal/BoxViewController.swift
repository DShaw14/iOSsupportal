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
import RequestKit
import TrashCanKit

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
        /*
        let nameInput = self.nameField.text
        let issueInput = self.issueField.text
        let descriptonInput = self.descriptionField.text
        */
        
        let config = OAuthConfiguration(token: "PdEp6B7WVzEnZe5XKg", secret: "Sq7PN7wbtNmdgjDwbXfAyHGCfebRKQd8", scopes: ["issue"]) // Scopes are not supported by the API yet
        
        let auth = config.authenticate()
        print("auth= " + "\(auth!)");
        
        func loadCurrentUser(config: TokenConfiguration) {
            let myresult = TrashCanKit(config).me() { response in
                switch response
                {
                case .success(let user):
                    print("user = " + "\(user.login!)")
                case .failure(let error):
                    print("error = " + "\(error)")
                }
            }
            print("myresult = " + "\(myresult!)");
        }
        let myconfig = TokenConfiguration("PdEp6B7WVzEnZe5XKg")
        print("myconfig = " + "\(myconfig)")
        let usercurrent = loadCurrentUser(config : myconfig)
        print("Current User = " + "\(usercurrent)");
        
                /*
        let request = OAuthRouter.authorize(config).URLRequest
        print("request= " + "\(request!)");
        print("\r\n");
        
       let repository = TrashCanKit().repositories() { response in
            switch response
            {
            case .success(let repositories):
                print("repositories= " + "\(repositories)");
                print("response= " + "\(response)");
            case .failure(let error):
                print("error= " + "\(error)");
            }
        }
        print("repository" + "\(repository!)");
        
        let myauth = "PdEp6B7WVzEnZe5XKg"
        print("myauth = " + "\(myauth)");
        
        func loadCurrentUser(myauth: TokenConfiguration) {
            let trashman = TrashCanKit(myauth).me() { response in
                switch response {
                case .success(let user):
                    print(user.login!)
                case .failure(let error):
                    print(error)
                }
            }
            print(trashman!);
        }
        */
        /*
        let myuser = TrashCanKit(myauth).me() {
            response in
            switch response
            {
                case .success(let user):
                    print(user.login!)
                case .failure(let error):
                    print(error)
            }
        }
        print(myuser!);
         */
        
        /*
        func loadCurrentUser(config: TokenConfiguration) {
            TrashCanKit(config).me() { response in
                switch response {
                case .Success(let user):
                    println(user.login)
                case .Failure(let error):
                    println(error)
                }
            }
        }
        */
        /*
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
        */
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
