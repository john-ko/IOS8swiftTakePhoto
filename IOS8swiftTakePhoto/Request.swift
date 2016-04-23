//
//  API.swift
//  IOS8swiftTakePhoto
//
//  Created by John Ko on 2/21/16.
//  Copyright © 2016 John Ko. All rights reserved.
//

import Foundation
import UIKit

class Request {
    
    var finished = false
    var url : String
    init(url: String) {
        self.url = url
    }
    
    func post(image: UIImage?, completion: () -> Void!) {
        self.postImage(image, completion: completion)
    }
    
    func getTags(image_id: String) {
        let url = NSURL(string: "https://api.imagga.com/v1/tagging?content=" + image_id)
        

        let headers = [
            "accept": "application/json",
            "authorization": "Basic YWNjXzZhNjBjY2Q3N2I5YmU2MzplZWJhMTk1YjgyNzMwOWI1OTBiM2U0NjZkNjc1M2I3Zg=="
        ]
        
        let request = NSMutableURLRequest( URL: url!)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                print(httpResponse)
                do {
                    let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary
                    print(jsonDict)
                } catch {
                    print(error)
                }
                

            }
        })
        
        dataTask.resume()
    }
    
    func postImage(myImage: UIImage?, completion: ()->Void!) {
        let imageData = UIImageJPEGRepresentation(myImage!.resizeToWidth(500), 1)
        
        // api config
        let request = self.factory("imagga", method:"POST")
        
        let param = [
            "abc"  : "12345",
            "yup" : "321",
        ]
        //let postString : String = "uid=59&asdf=123"
        //request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        // File
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            } else {

                print("finished")
                print(response)
                print(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
                //completion();
            }
        }
        task.resume()
        
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func get() {
        let url = NSURL(string: self.url)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (data, response, error) -> Void in
            print("finishing")
            print(response)
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            print(data)
            self.finished = true
        }
        
        task.resume()
    }
    
    func factory(site: String, method: String) -> NSMutableURLRequest {
        
        var urlString = ""
        var headers = ["accept":"application/json"]
        
        if (site == "google") {
            urlString = "https://www.google.com/api/url/goes/here"
        } else if (site == "imagga") {
            urlString = "https://api.imagga.com"
            headers["authorization"] = "Basic YWNjXzZhNjBjY2Q3N2I5YmU2MzplZWJhMTk1YjgyNzMwOWI1OTBiM2U0NjZkNjc1M2I3Zg=="
        } else if (site == "johnko") {
            urlString = "https://www.johnko.org/ios"
        }
        
        let request = NSMutableURLRequest( URL: NSURL(string: urlString)!)
        request.HTTPMethod = method
        request.allHTTPHeaderFields = headers
        
        return request
        
        
    }
    
    func getAuthenticatedRequest() -> NSMutableURLRequest {
        let url = NSURL(string: self.url)
        let request = NSMutableURLRequest( URL: url!)
        
        /* authentication here */
        let headers = [
            "accept": "application/json",
        ]
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers

        return request
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
    //func createBodyWithParameters(parameters: [String: String]?, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
         if filePathKey != nil {
             let filename = "user-profile.jpg"
        
             let mimetype = "image/jpg"
        
             body.appendString("--\(boundary)\r\n")
             body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
             body.appendString("Content-Type: \(mimetype)\r\n\r\n")
             body.appendData(imageDataKey)
             body.appendString("\r\n")
         }
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}


