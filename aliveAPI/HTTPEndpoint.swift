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
    var placeholder:String = ""
    var secure: Bool = false
    var route: Bool = true
    init(placeholder: String, secure: Bool, route: Bool){
        self.placeholder = placeholder
        self.secure = secure
        self.route = route
    }
}
class HTTPEndpoint {

    
    let authenticate: Bool
    let title: String
    let message: String?
    let method: Alamofire.Method // get or post
    let route: String // without base url
    let textFields: [fieldName]? // placeholdername : secure or not
    let encoding: ParameterEncoding!
    let completionHandler: ( ( message: String?, package: NSDictionary? )-> Void )?
    
    
    init(title:String!, message:String?, method:Alamofire.Method!, route:String!, authenticate: Bool!,
        textFields:[fieldName]?,
        encoding: ParameterEncoding!,
        completionHandler: ((message: String?, package: NSDictionary? ) -> Void )?) {
            self.title = title
            if let m = message {
                self.message = message
            }
            self.method = method
            self.authenticate = authenticate
            self.route = route
            self.encoding = encoding
            if let t = textFields{
                self.textFields = t
            }
            if let c = completionHandler {
                self.completionHandler = c
            }
    }
}