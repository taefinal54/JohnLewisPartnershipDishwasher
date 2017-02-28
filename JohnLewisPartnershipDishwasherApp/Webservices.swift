//
//  Webservices.swift
//  JohnLewisPartnershipDishwasherApp
//
//  Created by TAE on 24/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WebServices{

    static let sharedInstance = WebServices()

    private var cachedProductsCollection: [ProductGrid] = []

    
    func getProductGrid(permalink: String, completion: @escaping ([ProductGrid]) -> Void) {
        if cachedProductsCollection.count > 0 {
            completion(cachedProductsCollection)
        }
        get(endpoint: permalink) { json in
            let result = JSON(json!)
            //    init(title: String!, price: String!, image: String!, productId: String!) {

            for productGrid in (result["products"].array)! {
                self.cachedProductsCollection.append(ProductGrid(productId: productGrid["productId"].string!,
                                                                 title: productGrid["title"].string!,
                                                                 price: productGrid["price"]["now"].string!,
                                                                 image:productGrid["image"].string!))
            }
            
            completion(self.cachedProductsCollection)
        }
    }
    
    
    // Convenience method to perform a GET request on an API endpoint.
    private func get(endpoint: String, completion: @escaping (AnyObject?) -> Void) {
        request(endpoint: endpoint, method: .get, parameters: nil, completion: completion)
    }
    
    // Convenience method to perform a POST request on an API endpoint.
    private func post(endpoint: String, parameters: [String: AnyObject]?, completion: @escaping (AnyObject?) -> Void) {
        request(endpoint: endpoint, method: .post, parameters: parameters, completion: completion)
    }
    
    
    // Perform a request on an API endpoint using Alamofire.
    private func request(endpoint: String, method: HTTPMethod, parameters: [String: AnyObject]?, completion: @escaping (AnyObject?) -> Void) {
        guard let URL = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        print("Starting \(method) \(URL) (\(parameters ?? [:]))")
        Alamofire.request(URL, method: method, parameters: parameters).responseJSON {response in
            switch response.result {
            case .success(let JSON):
                print("Request  with: \(method) \(URL) (\(parameters ?? [:]))")
                print("\(JSON)")
                completion(JSON as AnyObject?)
            case .failure(let error):
                print("Request failed with error: \(error)")
                //   completion(nil)
            }
            
        }
    }
    
    func HTTPRequest(session: URLSession, url: String, completion: @escaping ([String: AnyObject]) -> Void){
        // Set up the URL request
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        

        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                // now we have the todo, let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                completion(todo)
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
//                guard let todoTitle = todo["title"] as? String else {
//                    print("Could not get todo title from JSON")
//                    return
//                }
          //      print("The title is: " + todoTitle)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()
    }
    
    
}
