//
//  HTTPEndpoint.swift
//  aliveAPI
//
//  Created by Pete Kim on 2/16/15.
//  Copyright (c) 2015 Pete Kim. All rights reserved.
//

import Foundation
import Alamofire

class HTTPEndpoint {
    let title: String
    let message: String?
    let method: Alamofire.Method // get or post
    let route: String // without base url
    let textFields: [String:Bool]? // placeholdername : secure or not
    let completionHandler: ( ( message: String?, package: NSDictionary? )-> Void )?
    
    init(title:String!, message:String?, method:Alamofire.Method!, route:String!, textFields:[String:Bool]?,
        completionHandler: ((message: String?, package: NSDictionary? ) -> Void )?) {
        
        self.title = title
        if let m = message {
            self.message = message
        }
        self.method = method
        self.route = route
        if let t = textFields{
            self.textFields = t
        }
        if let c = completionHandler {
            self.completionHandler = c
        }
    }
}