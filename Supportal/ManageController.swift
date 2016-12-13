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
import TrashCanKit
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
    
    @IBAction func closeIssue(_ sender: UIButton) {
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
        let handle = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/bitbucket")!,
            scope: "issue+issue:write", state:"BITBUCKET",
            success: { credential, response, parameters in
                print(credential.oauthToken)
                
                let handleme = oauthswift.client.get(
                    "https://bitbucket.org/api/2.0/user", parameters: [:],
                    success: { response in
                        let dataString = response.string!
                        print(dataString)
                },
                    failure: { error in
                        print(error)
                }
                )
                print(handleme!)

        },
            failure: { error in
                print(error.localizedDescription)
        }
        )
        print(handle!)
    }
    
}


