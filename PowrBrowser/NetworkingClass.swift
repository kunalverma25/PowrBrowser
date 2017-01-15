//
//  NetworkingClass.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 15/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import Foundation

class NetworkingClass {
    
    static func saveDataAPI(string: String) {
        let data = string.data(using: .utf8)
        let url = URL(string: "http://localhost:8080/sessions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("RESP",responseJSON)
            }
        }
        
        task.resume()
    }
}
