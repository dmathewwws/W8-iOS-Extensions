//
//  ShareViewController.swift
//  Sharesies
//
//  Created by Daniel Mathews on 2015-12-06.
//  Copyright © 2015 Daniel Mathews. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = kUTTypeImage as String
        
        for attachment in content.attachments as! [NSItemProvider] {
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                
                attachment.loadItemForTypeIdentifier(contentType, options: nil, completionHandler: { (itemURL, error) in
                    if let url = itemURL as? NSURL,
                    let data = NSData(contentsOfURL: url),
                    let image = UIImage(data: data) {
                        
                        self.sendImageToParse(image)
                        
                        
                    }else{
                        print ("no image :(")
                    }
                })
                
            }
        }

        
        
        
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        
        
        
    }
    
    func sendImageToParse(image:UIImage) {
        if let parseBaseString = NSURL(string: "https://api.parse.com/1/files/photo.jpg"){
            let urlRequest = NSMutableURLRequest(URL: parseBaseString, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData , timeoutInterval: 60)
            urlRequest.HTTPMethod = "POST"
            urlRequest.setValue("rFWXuTDZscVOpiXvVT5ZPBhayqRNZUwa2tQZJ09d", forHTTPHeaderField: "X-Parse-Application-Id")
            urlRequest.setValue("BkZTx4JSFhiK5wiZcH1grlZW34ydAPJWt0RjqtiG", forHTTPHeaderField: "X-Parse-REST-API-Key")
            urlRequest.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
            urlRequest.HTTPBody = UIImageJPEGRepresentation(image, 0.5)
            
            
            let configuation = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            configuation.requestCachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            let session = NSURLSession(configuration: configuation)
            
            session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) -> Void in
                
                if let data = data {
                    
                    if let jsonResult = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject],
                        let name = jsonResult["name"] as? String {
                        
                            if let parseBaseString = NSURL(string: "https://api.parse.com/1/classes/Photo"){
                                let urlRequest = NSMutableURLRequest(URL: parseBaseString, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData , timeoutInterval: 60)
                                urlRequest.HTTPMethod = "POST"
                                urlRequest.setValue("rFWXuTDZscVOpiXvVT5ZPBhayqRNZUwa2tQZJ09d", forHTTPHeaderField: "X-Parse-Application-Id")
                                urlRequest.setValue("BkZTx4JSFhiK5wiZcH1grlZW34ydAPJWt0RjqtiG", forHTTPHeaderField: "X-Parse-REST-API-Key")
                                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                
                                var pictureDict = [String:AnyObject]()
                                pictureDict["name"] = name
                                pictureDict["__type"] = "File"
                                
                                var overallDict = [String:AnyObject]()
                                overallDict["photo"] = pictureDict

                                let paramsJSON = try? NSJSONSerialization.dataWithJSONObject(overallDict, options: NSJSONWritingOptions.PrettyPrinted)
                                urlRequest.HTTPBody = paramsJSON
                                
                                session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) -> Void in
                                    
                                    print("\(error) is error")
                                    
                                }).resume()

                                
                            }
                            

                            
                        }
                        
                    }
                
                print("error is \(error)")
                
            }).resume()
        }
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
