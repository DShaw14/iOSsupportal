//
//  User.swift

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class User: NSObject {
    //MARK: - SET USER LOGGED IN
    class func set_IsUserLoggedIn(state : Bool) {
        var userloggedin:     UserDefaults?
        userloggedin        = UserDefaults.standard
        userloggedin?.set(state, forKey: "IS_USER_LOGGED_IN")
    }
    
    //MARK: - GET USER LOGGED IN
    class func get_IsUserLoggedIn() -> Bool {
        
        var userloggedin:     UserDefaults?
        userloggedin        = UserDefaults.standard
        
        var checkUser:Bool? = false
        checkUser           = userloggedin?.bool(forKey: "IS_USER_LOGGED_IN")
        
        return checkUser!
    }
    
    //MARK: - GET USER NAME
    class func get_UserName() -> String {
        let parameters: [String: Any] = [
            "" : ""
        ]
        
        let myheader:HTTPHeaders = [
            //"Authorization": "Basic",
            "Accept": "application/json",
            "application-type":"REST",
            "Content-Type":"application/json",
        ]
        
        var loginUser = "Test User" // Dummy Username
        let myUser = JSON(loginUser)
        if (User.get_IsUserLoggedIn() == true)
        {
            // Attempt to get a token
            Alamofire.request("http://hurst.pythonanywhere.com/supportal/rest-auth/user/", method: .get, parameters: parameters,encoding: JSONEncoding.default, headers: myheader).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                    
                case .success:
                    //var json: JSON = [:]
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        let primaryKey = json["pk"]
                        let username = json["username"]
                        let email = json["email"]
                        let firstName = json["first_name"]
                        let lastName = json["last_name"]
                        
                        print("JSON: primaryKey: \(primaryKey)")
                        print("JSON: username: \(username)")
                        print("JSON: email: \(email)")
                        print("JSON: firstName: \(firstName)")
                        print("JSON: lastName: \(lastName)")
                        
                        loginUser = "\(username)"
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        return String(describing: myUser)
    }
}

/*
class User: NSObject {
    var user_token:String?
    var email:String?
    
    override init() {
        
    }
    
    func isLogined() -> Bool {
        let storage = HTTPCookieStorage.shared
        let apiURL = NSURL(string: "http://hurst.pythonanywhere.com/supportal/rest-auth/login/")
        var cookies = isLogined()
        cookies = HTTPCookieStorage.cookies(for: storage)(apiURL! as URL)
        
        if (cookies.count > 0) {
            return true
        }
        
        return false
    }
    
    func logout() {
        
        var cookie: HTTPCookie
        //var storage: HTTPCookieStorage = HTTPCookieStorage.shared
        
      //  let storage = HTTPCookieStorage.shared
        let apiURL = NSURL(string: "http://hurst.pythonanywhere.com/supportal/rest-auth/login/")
        //var cookies = isLogined()
        cookie = HTTPCookieStorage.cookies(<#T##HTTPCookieStorage#>)(for: apiURL! as URL)//(apiURL! as URL)
        
        for cookie:AnyObject in cookie {
            storage.deleteCookie(cookie as HTTPCookie)
        }
 
        /*
        var cookie: HTTPCookie
        var storage: HTTPCookieStorage = HTTPCookieStorage.shared
        
        for cookie in storage.cookies! {
            var domainName: String = cookie.domain
            var domainRange: Range = domainName.rangeOfString("pythonanywhere")
            if domainRange.length > 0 {
                storage.deleteCookie(cookie)
            }
        }
        */
        
    }
 
}
*/
