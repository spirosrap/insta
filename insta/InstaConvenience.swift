//
//  InstaConvenience.swift
//  instaplaces
//
//  Created by Spiros Raptis on 05/05/2015.
//  Copyright (c) 2015 Spiros Raptis. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Convenient Resource Methods

extension InstaClient {
    
    func loginWithToken(hostViewController: UIViewController,completionHandler:(success: Bool,errorString:String?) -> Void){
        getAccessToken(hostViewController, completionHandler: { (success, accessToken, errorString) -> Void in
            if success {
                self.accessToken = accessToken
                println(accessToken!)
                completionHandler(success: success, errorString: nil)
            }else{
                completionHandler(success: false, errorString: "Couldn't get access Token")
            }
        })
    }
    
    /* This function opens a TMDBAuthViewController to handle Step 2a of the auth flow */
    func getAccessToken(hostViewController: UIViewController, completionHandler: (success: Bool,accessToken:String?, errorString: String?) -> Void) {
        
        var modifiedURLString = String(format:"%@?client_id=%@&redirect_uri=%@&response_type=token", InstaClient.Constants.AuthorizationURL,InstaClient.Constants.ClientID,InstaClient.Constants.RedirectURI)
        
        let authorizationURL = NSURL(string: modifiedURLString)
        
        let request = NSURLRequest(URL: authorizationURL!)
        let webAuthViewController = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("InstaAuthViewController") as! InstaAuthViewController
        webAuthViewController.urlRequest = request
        
        webAuthViewController.completionHandler = completionHandler
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        dispatch_async(dispatch_get_main_queue(), {
            hostViewController.presentViewController(webAuthNavigationController, animated: true, completion: nil)
        })
    }
    
    func getLocations(var latitude:Double,var longitude:Double,var distance:Int,completionHandler: (result: [InstaLocation]?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = ["lat":latitude,"lng":longitude,"distance":distance]
        var mutableMethod : String = Methods.Locations
        
        /* 2. Make the request */
        taskForGETMethod(mutableMethod, parameters: parameters as! [String : AnyObject]) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                println(JSONResult)
                if let results = JSONResult.valueForKey("data") as? [[String : AnyObject]] {
                    
                    var locations = InstaLocation.locationsFromResults(results)
                    completionHandler(result: locations, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getLocations"]))
                }
            }
        }
    }


}
