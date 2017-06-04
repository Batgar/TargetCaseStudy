//
//  DealModelLoader.swift
//  ProductViewer
//
//  Created by Dan Edgar on 6/4/17.
//  Copyright © 2017 Target. All rights reserved.
//

import Foundation

class DealModelLoader {
    static func loadDeals(completion: @escaping (DealRoot) -> Void) {
        
        guard let url = URL(string:"http://target-deals.herokuapp.com/api/deals") else {
            completion(DealRoot.empty())
            return
        }
        
        let request = getURLRequest("GET", url: url)
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration:configuration)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            
            if let _ = error {
                completion(DealRoot.empty())
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(DealRoot.empty())
                return
            }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let validData = data else {
                        completion(DealRoot.empty())
                        return
                    }
                    
                    //Success! Process the JSON using Decodable!
                    if let j: Any = try? JSONSerialization.jsonObject(with: validData, options: []),
                        let dealRoot : DealRoot = try? DealRoot.decode(j) {
                        completion(dealRoot)
                        return
                    }
                    break
                default:
                    completion(DealRoot.empty())
                    break
                
            }
        })
        
        task.resume()
    }
    
    fileprivate static func getURLRequest(_ httpMethod: String, url: URL) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        
        //If needed can set header values here.
        request.httpMethod = httpMethod
        
        return request
    }

}
