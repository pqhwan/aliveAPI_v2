//
//  HTTPEndpoint.swift
//  aliveAPI
//
//  Created by Pete Kim on 2/16/15.
//  Copyright (c) 2015 Pete Kim. All rights reserved.
//

import Foundation
import Alamofire

class fieldName{
    var pholder:String = ""
    var scure: Bool = false
    init(placeholder: String, secure: Bool){
        pholder = placeholder
        scure = secure
    }
}
class HTTPEndpoint {

    
    let title: String
    let message: String?
    let method: Alamofire.Method // get or post
    let route: String // without base url
    let textFields: [fieldName]? // placeholdername : secure or not
    let completionHandler: ( ( message: String?, package: NSDictionary? )-> Void )?
    
    
    init(title:String!, message:String?, method:Alamofire.Method!, route:String!, textFields:[fieldName]?,
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