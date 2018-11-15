//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Ahmed Osama on 11/11/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import Foundation

class ParseClient {
    
    private static let appID = ""
    private static let apiKey = ""
    private static let endpointURL = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
    
    static func GETStudentLocation(completionHandler: @escaping ([StudentLocationGETResponse]?, String?) -> Void) {
        let limit = URLQueryItem(name: "limit", value: "300")
        let order = URLQueryItem(name: "order", value: "-updatedAt")
        var urlComponents = URLComponents(string: endpointURL.absoluteString)
        urlComponents?.queryItems = [limit, order]
        performGETStudentLocation(url: (urlComponents?.url)!, completionHandler: completionHandler)
    }
    
    static func GETStudentLocation(
        with userID: String,
        completionHandler: @escaping ([StudentLocationGETResponse]?, String?) -> Void) {
        let url = endpointURL.appendingPathComponent("where={\"uniqueKey\":\"\(userID)\"}")
        print(url.absoluteString)
        performGETStudentLocation(url: url, completionHandler: completionHandler)
    }
    
    private static func performGETStudentLocation(
                            url: URL,
                            completionHandler: @escaping ([StudentLocationGETResponse]?, String?) -> Void) {
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["X-Parse-Application-Id": ParseClient.appID,
                                       "X-Parse-REST-API-Key": ParseClient.apiKey]
        Helpers.performDataTask(with: request, responseType: [String: [StudentLocationGETResponse]].self, secured: false) {
            (response, message) in
            let cleanedResponse = response?["results"]
            completionHandler(cleanedResponse, message)
        }
    }
    
    static func POSTStudentLocation(
                    mapString: String, mediaURL: String,
                    latitude: Float, longitude: Float,
                    completionHandler: @escaping (StudentLocationPOSTResponse?, String?) -> Void) {
        
        performPOSTorPUTStudentLocation(url: endpointURL, method: "POST", mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, completionHandler: completionHandler)
        
    }
    
    static func PUTStudentLocation(objectID: String,
                    mapString: String, mediaURL: String,
                    latitude: Float, longitude: Float,
                    completionHandler: @escaping (StudentLocationPUTResponse?, String?) -> Void) {
        
        let url = endpointURL.appendingPathComponent(objectID)
        performPOSTorPUTStudentLocation(url: url, method: "PUT", mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, completionHandler: completionHandler)
        
    }
    
    private static func performPOSTorPUTStudentLocation<T: Decodable>(
                            url: URL,
                            method: String,
                            mapString: String, mediaURL: String,
                            latitude: Float, longitude: Float,
                            completionHandler:
                            @escaping (T?, String?) -> Void) {
        
        guard (T.self == StudentLocationPOSTResponse.self || T.self == StudentLocationPUTResponse.self)
              && (method == "POST" || method == "PUT") else {
                completionHandler(nil, "Internal local error: Invalid request.")
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        request.allHTTPHeaderFields = ["X-Parse-Application-Id": ParseClient.appID,
                                       "X-Parse-REST-API-Key": ParseClient.apiKey,
                                       "Content-Type": "application/json"]
        
        let bodyJson: [String : Any] = ["uniqueKey": NetworkingManager.Udacity.accountKey!,
                                        "firstName": (NetworkingManager.Udacity.user?.firstName ?? ""),
                                        "lastName": (NetworkingManager.Udacity.user?.lastName ?? ""),
                                        "mapString": mapString,
                                        "mediaURL": mediaURL,
                                        "latitude": latitude,
                                        "longitude": longitude]
        
        let bodyJsonData = try? JSONSerialization.data(withJSONObject: bodyJson)
        request.httpBody = bodyJsonData
        
        Helpers.performDataTask(with: request, responseType: T.self, secured: false,
                                completionHandler: completionHandler)
        
    }
    
}
