//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Ahmed Osama on 11/11/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import Foundation

class UdacityClient {
    
    private enum Endpoints {
        static let sessionURL = URL(string: "https://www.udacity.com/api/session")!
        static let userURL = URL(string: "https://www.udacity.com/api/users")!
    }
    
    static func GETUser(userID: String,
                        completionHandler: @escaping (UdacityGETUserResponse?, String?) -> Void) {
        
        let url = UdacityClient.Endpoints.userURL.appendingPathComponent(userID)
        let request = URLRequest(url: url)
        Helpers.performDataTask(with: request, responseType: [String: UdacityGETUserResponse].self, secured: true) {
            (response, errorMessage) in
            completionHandler(response?["user"], errorMessage)
        }
        
    }
    
    static func POSTSession(username: String, password: String, completionHandler: @escaping (UdacityPOSTSessionResponse?, String?) -> Void) {
        let bodyJson = ["udacity": ["username": username, "password": password]]
        let bodyJsonData = try? JSONSerialization.data(withJSONObject: bodyJson)
        var request = URLRequest(url: UdacityClient.Endpoints.sessionURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "Accept": "application/json"]
        request.httpBody = bodyJsonData
        Helpers.performDataTask(with: request,
                                responseType: UdacityPOSTSessionResponse.self,
                                secured: true,
                                completionHandler: completionHandler)
    }
    
    static func DELETESession(completionHandler: @escaping (UdacityDELETESessionResponse?, String?) -> Void) {
        var request = URLRequest(url: UdacityClient.Endpoints.sessionURL)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
                break
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        Helpers.performDataTask(with: request,
                                responseType: UdacityDELETESessionResponse.self,
                                secured: true,
                                completionHandler: completionHandler)
    }
    
}
