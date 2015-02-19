//
//  MainViewController.swift
//  aliveAPI
//
//  Created by Pete Kim on 2/16/15.
//  Copyright (c) 2015 Pete Kim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var endpoints = [HTTPEndpoint]()
    var accessToken: String?
    let cellReuseIdentifier = "apiEndpointCell"
    let baseURL = "http://localhost:8080"
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.endpoints.append(HTTPEndpoint(title: "Login", message: nil, method: Alamofire.Method.POST,
            route: "/login",
            authenticate: false,
            textFields: [
                fieldName(placeholder: "username", secure: false, route: false),
                fieldName(placeholder: "password", secure: true, route: false)
            ],
            encoding: .JSON,
            completionHandler: nil))
        self.endpoints.append(HTTPEndpoint(title: "Signup", message: nil,
            method: Alamofire.Method.POST,
            route: "/signup",
            authenticate: false,
            textFields: [
                fieldName(placeholder: "username", secure: false, route: false),
                fieldName(placeholder: "password", secure: true, route: false)
            ],
            encoding: .JSON,
            completionHandler: nil))
        self.endpoints.append(HTTPEndpoint(title: "Create room", message: nil,
            method: Alamofire.Method.POST,
            route: "/room",
            authenticate: true,
            textFields: [
                fieldName(placeholder: "room_name", secure: false, route: false)
            ],
            encoding: .JSON,
            completionHandler: nil))
        
        self.endpoints.append(HTTPEndpoint(title: "Search for rooms",
            message: nil,
            method: Alamofire.Method.GET,
            route: "/search",
            authenticate: false,
            textFields: [
                fieldName(placeholder: "query", secure: false, route: true)
            ],
            encoding: .URL,
            completionHandler: nil))
        
        self.endpoints.append(HTTPEndpoint(title: "enter room",
            message: nil,
            method: Alamofire.Method.GET,
            route: "/room",
            authenticate: true,
            textFields: [
                fieldName(placeholder: "id", secure: false, route: true)
            ],
            encoding: .URL,
            completionHandler: nil))
        
        self.endpoints.append(HTTPEndpoint(title: "get info on user",
            message: nil,
            method: Alamofire.Method.GET,
            route: "/user",
            authenticate: true,
            textFields: [
                fieldName(placeholder: "username", secure: false, route: true)
            ],
            encoding: .URL,
            completionHandler: nil))
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endpoints.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell
        let endpoint: HTTPEndpoint! = self.endpoints[indexPath.row]
        
        cell.textLabel?.text = endpoint.title
        if let m = endpoint.message as String? {
            cell.detailTextLabel?.text = m
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // GET ENDPOINT SELECTED AND CREATE AN ALERT
        let endpoint: HTTPEndpoint! = endpoints[indexPath.row]
        let alert: UIAlertController! = UIAlertController(title: endpoint.title, message: endpoint.message, preferredStyle: .Alert)

        // ADD CANCEL BUTTON
        let cancelAction: UIAlertAction! = UIAlertAction(title: "cancel", style: .Cancel, handler: { (action) in
            dispatch_async(dispatch_get_main_queue(), {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
        })
        alert.addAction(cancelAction)
       
        // ADD GO BUTTON
        let goAction: UIAlertAction! = UIAlertAction(title: "go", style: UIAlertActionStyle.Default , handler: { (action) in
            var params = [String : String]()
            
            var urlString = self.baseURL.stringByAppendingString(endpoint.route)
            
            // RETRIEVE INPUTS FROM TEXTFIELDS
            for field in alert.textFields as [UITextField] {
                if let f = field as UITextField? {
                    let fieldObj:fieldName! = endpoint.textFields?.filter{$0.placeholder == f.placeholder}.first
                    if fieldObj.route == true {
                        urlString = urlString.stringByAppendingString("/\(f.text)");
                    } else {
                        params[f.placeholder!] = f.text;
                    }
                }
            }
           
            // TODO temporary until we have a handler for /login and /signup
            if endpoint.authenticate == true {
                params["access_token"] = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6InBldGUiLCJ0aW1lc3RhbXAiOjE0MjQzNzUzMzg4OTl9.MDX0r2gm4rgjNjvFOesVmaH0B9dz58K2-x5fOLrCtzg"
            }
            
            
            println(params)
            
            // MAKE REQUEST
            Alamofire.request(endpoint.method, urlString, parameters: params, encoding: endpoint.encoding)
                .responseJSON({ (request, response, json, err) -> Void in
                    if err != nil {
                        // system or network error
                        println("SYS ERROR")
                        println(err)
                        return
                    }
                  
                    if let r = response as NSHTTPURLResponse!{
                        if r.statusCode != 200 {
                            println("SERVER RESPONDED WITH A \(r.statusCode)")
                            return
                        }
                    }
                    
                    let parsedJson = JSON(json!)
                    
                    if parsedJson["success"] == true {
                        // success: pass the package to the handler
                        println(parsedJson["package"])
                    } else if parsedJson["success"] == false {
                        println()
                        return
                    }
            })
                
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        })
        alert.addAction(goAction)
        
        for i in 0...(endpoint.textFields?.count as Int! - 1){
            if let fieldname = endpoint.textFields?[i] {
                alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                    textField.placeholder = fieldname.placeholder
                    textField.secureTextEntry = fieldname.secure
                })
            }
        }
       
        // present alert controller
        self.presentViewController(alert, animated: true, completion: {() in})
    }
    

}

