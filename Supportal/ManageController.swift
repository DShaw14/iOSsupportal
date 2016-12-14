//
//  ManageController.swift
//  Supportal
//
//  Created by Zachary A. Menken on 12/13/16.
//  Copyright © 2016 Oak Labs. All rights reserved.
//

import UIKit
import Starscream
import SlackKit
import Alamofire
import SwiftyJSON
import Foundation
import OAuthSwift

class ManageController: UIViewController, UITextFieldDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var bitbucketIssues: UITableView!
    @IBOutlet weak var closeIssue: UIButton!
    
    // MARK: BitBucket
    var currentUsername = ""
    var currentRepo = ""
 
    @IBAction func closeIssue(_ sender: UIButton)
    {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if let _ = cookie.domain.range(of: "bitbucket.org") {
                    print("\(#function): deleted cookie: \(cookie)")
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
        }
        print("User is not logged into BitBucket")
        let oauthswift = OAuth2Swift(
            consumerKey:    "PdEp6B7WVzEnZe5XKg",
            consumerSecret: "mv8egn6ADHCYu9d2xdNr4kL7fRbXAVAq",
            authorizeUrl:   "https://bitbucket.org/site/oauth2/authorize",
            responseType:   "token"
        )
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/bitbucket")!,
            scope: "issue+issue:write", state:"BITBUCKET",
            success: { credential, response, parameters in
                print(credential.oauthToken)
                //print(credential.oauthTokenSecret)
              
                self.getUser(oauthswift, completionHandler: { (response) -> () in
                    print("getUser: ")
                    print(response)
                })
                    
                self.getRepository(oauthswift, completionHandler: { (response) -> () in
                    print("getRepository: ")
                    print(response)
                })
                    
                self.getIssues(oauthswift, completionHandler: { (response) -> () in
                    print("getIssues")
                    print(response)
                })
            },failure: { error in print(error.localizedDescription)})
    }
    func getUser(_ oauthswift: OAuth2Swift, completionHandler:@escaping (Bool) -> ())
    {
        let _ = oauthswift.client.get("https://bitbucket.org/api/2.0/user", parameters: [:],
            success: { response in
                let dataString = response.string!
                    if let data = dataString.data(using: String.Encoding.utf8) {
                        let json = JSON(data: data)
                        //let json = JSON(dataString)
                        print("USERNAME: " + "\(json["username"])")
                        print("getUser JSON: \(json)")
                        self.currentUsername = "\(json["username"])"
                        //print(dataString)
                        //print(self.currentUsername)
                    }
                completionHandler(true)
                
        },failure: { error in print(error.localizedDescription)
                        completionHandler(false)
                    })
    }
    func getRepository(_ oauthswift: OAuth2Swift, completionHandler:@escaping (Bool) -> ())
    {
        print(currentUsername)
         let _ = oauthswift.client.get("https://bitbucket.org/!api/2.0/repositories/\(currentUsername)", parameters: [:],
         success: { response in
                        let dataString = response.string!
                        if let data = dataString.data(using: String.Encoding.utf8) {
                        let json = JSON(data: data)
                        print("\(json["values"])")
                            
                            if let userArray = json["values"].array
                            {
                                for userDict in userArray {
                                    let repo: String! = userDict["slug"].string
                                    print(repo)
                                    self.currentRepo = repo
                            }
                        }
                        print("getRepository JSON: \(json)")
                        print("repository JSON slug: \(self.currentRepo)") // slug = repository name
                }
        },failure: {
            error in print(error.localizedDescription)
            completionHandler(false)
        })
    }
    func getIssues(_ oauthswift: OAuth2Swift,completionHandler:@escaping (Bool) -> ())
    {
        let _ = oauthswift.client.get(("https://api.bitbucket.org/1.0/repositories/\(currentUsername)/\(currentRepo)/issues"), parameters: [:],
                success: { response in
                    let dataString = response.string!
                        if let data = dataString.data(using: String.Encoding.utf8) {
                            let json = JSON(data: data)
                            //print(dataString)
                            print("getIssues JSON: \(json)")
                            print(json)
                            // print("JSON SLUG: \(json["slug"])") // slug = repository name
                        }
        completionHandler(true)
        },failure: {
            error in print(error.localizedDescription)
            completionHandler(false)
        })
    }
}
