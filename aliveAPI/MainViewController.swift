//
//  MainViewController.swift
//  aliveAPI
//
//  Created by Pete Kim on 2/16/15.
//  Copyright (c) 2015 Pete Kim. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var endpoints = [HTTPEndpoint]()
    let cellReuseIdentifier = "apiEndpointCell"
    let baseURL = "http://localhost:8080"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.endpoints.append(HTTPEndpoint(title: "Login", message: nil, method: Alamofire.Method.POST,
            route: "/login",
            textFields: ["username":false, "password":true], completionHandler: nil))
        self.endpoints.append(HTTPEndpoint(title: "Signup", message: nil, method: Alamofire.Method.POST,
            route: "/signup",
            textFields: ["username":false, "password":true], completionHandler: nil))
        self.endpoints.append(HTTPEndpoint(title: "Create room", message: nil, method: Alamofire.Method.POST,
            route: "/room",
            textFields: ["room_name":false], completionHandler: nil))
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
        let goAction: UIAlertAction! = UIAlertAction(title: "go", style: UIAlertActionStyle.Default , handler: {
            (action) in
            
            var params = [String : String]()
           
            // RETRIEVE INPUTS FROM TEXTFIELDS
            if let t = alert.textFields as [UITextField]? {
                for field in t {
                    if let f = field as UITextField? {
                        params[f.placeholder!] = f.text;
                    }
                }
            }
            
            println(params)
            
            // MAKE REQUEST
            let urlString = self.baseURL.stringByAppendingString(endpoint.route)
            Alamofire.request(endpoint.method, urlString, parameters: params,
                encoding: .JSON).responseJSON({
                (request, response, json, err) -> Void in
                println(response!)
                println(json)
                if err != nil {
                    // system or network error
                    println("SYS ERROR")
                    println(err)
                }
            })
                
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        })
        alert.addAction(goAction)
       
        // ADD TEXT FIELDS
        if let t = endpoint.textFields as [String:Bool]? {
            for (placeHolder, secure) in t {
                alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                    textField.placeholder = placeHolder
                    textField.secureTextEntry = secure
                })
                
            }
        }
        
        // present alert controller
        self.presentViewController(alert, animated: true, completion: {() in})
    }
    

}

