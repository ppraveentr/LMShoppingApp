//
//  LMNetworkManager.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 01/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

//typealias
//public typealias JSON = Dictionary<String, Any>

class LMNetworkManager {
    
    class func fetchProductList(completion: @escaping (NSDictionary?) -> Void) {
        
        //unwrap API endpoint
        guard let url = URL(string: "http://a2b7cf8676394fda75de-6e0550a16cd96615f7274fd70fa77109.r93.cf3.rackcdn.com/common/json/assignment.json") else {
            print("Error unwrapping URL"); return }
        
        //create a session and dataTask on that session to get data/response/error
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            //unwrap returned data
            guard let unwrappedData = data else { print("Error getting data"); return }
            
            do {
                //create an object of JSON data and cast it as a NSDictionary
                // .allowFragments specifies that the json parser should allow top-level objects that aren't NSArrays or NSDictionaries.
                if let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as? NSDictionary {
                    completion(responseJSON)
                }
            } catch {
                //9 - if we have an error, set our completion with nil
                completion(nil)
                print("Error getting API data: \(error.localizedDescription)")
            }
        }
        //10 -
        dataTask.resume()
    }
    
}
