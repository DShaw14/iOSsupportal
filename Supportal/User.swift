//
//  User.swift

import UIKit
import Foundation

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
