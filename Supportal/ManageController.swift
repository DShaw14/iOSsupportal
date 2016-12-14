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
    /*
    // MARK: BitBucket
    func doOAuthBitBucket(_ serviceParameters: [String:String]){
        let oauthswift = OAuth1Swift(
            consumerKey:    serviceParameters["consumerKey"]!,
            consumerSecret: serviceParameters["consumerSecret"]!,
            requestTokenUrl: "https://bitbucket.org/api/1.0/oauth/request_token",
            authorizeUrl:    "https://bitbucket.org/api/1.0/oauth/authenticate",
            accessTokenUrl:  "https://bitbucket.org/api/1.0/oauth/access_token"
        )
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = getURLHandler()
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/bitbucket")!,
            success: { credential, response, parameters in
                self.showTokenAlert(name: serviceParameters["name"], credential: credential)
                self.testBitBucket(oauthswift)
        },
            failure: { error in
                print(error.description)
        }
        )
    }
    func testBitBucket(_ oauthswift: OAuth1Swift) {
        let _ = oauthswift.client.get(
            "https://bitbucket.org/api/1.0/user", parameters: [:],
            success: { response in
                let dataString = response.string!
                print(dataString)
        },
            failure: { error in
                print(error)
        }
        )
    }
    */
    
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
                print(credential.oauthTokenSecret)
                self.getUser(oauthswift)
                self.getRepository(oauthswift)
                //self.getIssues(oauthswift, completionHandler: nil)
                
                self.getIssues(oauthswift, completionHandler: { (response) -> () in
                    print(response)
                })
            },failure: { error in print(error.localizedDescription)})
        }
    
    func getIssues(_ oauthswift: OAuth2Swift,completionHandler:@escaping (Bool) -> ())
    {
         let _ = oauthswift.client.get(("https://api.bitbucket.org/1.0/repositories/\(currentUsername)/\(currentRepo)/issues"), parameters: [:],
                success: { response in
                    let dataString = response.string!
                        if let data = dataString.data(using: String.Encoding.utf8) {
                            let json = JSON(data: data)
                            print(dataString)
                            print("JSON SLUG: \(json["slug"])") // slug = repository name
                        }
                    completionHandler(true)
        },failure: {
            error in print(error.localizedDescription)
            completionHandler(false)
         })
    }
    func getUser(_ oauthswift: OAuth2Swift)
    {
        let _ = oauthswift.client.get("https://bitbucket.org/api/2.0/user", parameters: [:],
            success: { response in
                let dataString = response.string!
                    if let data = dataString.data(using: String.Encoding.utf8) {
                        let json = JSON(data: data)
                        //let json = JSON(dataString)
                        print("USERNAME: " + "\(json["username"])")
                        print("JSON: \(json)")
                        self.currentUsername = "\(json["username"])"
                        //print(dataString)
                        //print(self.currentUsername)
                    }
                
        },failure: { error in print(error.localizedDescription)})
    }
    func getRepository(_ oauthswift: OAuth2Swift)
    {
        
         let _ = oauthswift.client.get("https://bitbucket.org/!api/2.0/repositories/\(currentUsername)", parameters: [:],
         success: { response in
                let dataString = response.string!
                    if let data = dataString.data(using: String.Encoding.utf8) {
                        let json = JSON(data: data)
                        self.currentRepo = "\(json["slug"])"
                        print(dataString)
                        print("JSON SLUG: \(json["slug"])") // slug = repository name
                        //print("THIS IS MY STRING: " + myString)
                    }
        },failure: { error in print(error.localizedDescription)})
    }
}
