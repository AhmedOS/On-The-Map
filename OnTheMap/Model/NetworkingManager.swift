//
//  NetworkingManager.swift
//  OnTheMap
//
//  Created by Ahmed Osama on 11/12/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import Foundation

final class NetworkingManager {
    
    private init () { }
    
    fileprivate static func loggedIn() {
        Udacity.getUserPublicInfo()
        Parse.getStudentLocation(type: .myLocation) { (location, errorMessage) in
            if let location = location?.first {
                Parse.objectID = location.objectId
            }
        }
    }
    
    fileprivate static func loggedOut() {
        Udacity.resetValues()
        Parse.resetValues()
    }
    
    enum Udacity {
        
        static private(set) var accountKey: String?
        private static var sessionID: String?
        static private(set) var user: UdacityGETUserResponse?
        
        static fileprivate func resetValues() {
            accountKey = nil
            sessionID = nil
            user = nil
        }
        
        static func login(username: String, password: String,
                   completionHandler: @escaping (_ error: String?) -> Void) {
            UdacityClient.POSTSession(username: username, password: password) {
                (response, errorMessage) in
                guard let response = response else {
                    completionHandler(errorMessage)
                    return
                }
                if let account = response.account, account.registered ?? false {
                    Udacity.accountKey = account.key
                    Udacity.sessionID = response.session?.id
                    NetworkingManager.loggedIn()
                    completionHandler(nil)
                }
                else {
                    completionHandler("Invalid Entries.")
                }
            }
        }
        
        static func logout(completionHandler: @escaping (_ error: String?) -> Void) {
            UdacityClient.DELETESession { (response, errorMessage) in
                loggedOut()
                completionHandler(errorMessage)
            }
        }
        
        fileprivate static func getUserPublicInfo() {
            if let id = Udacity.accountKey {
                UdacityClient.GETUser(userID: id) { (response, errorMessage) in
                    Udacity.user = response
                }
            }
        }
        
    }
    
    enum Parse {
        
        fileprivate static var objectID: String?
        static private(set) var studentLocations: [StudentLocationGETResponse]?
        
        enum LocationType {
            case myLocation
            case allLocations
        }
        
        static fileprivate func resetValues() {
            objectID = nil
        }
        
        static func getStudentLocation(
                type: LocationType,
                completionHandler: @escaping ([StudentLocationGETResponse]?, String?) -> Void) {
            switch type {
            case .allLocations:
                ParseClient.GETStudentLocation(completionHandler: completionHandler)
            case .myLocation:
                ParseClient.GETStudentLocation(with: Udacity.accountKey!,
                                               completionHandler: completionHandler)
            }
        }
        
        static func getUniqueStudentLocation(
            type: LocationType,
            completionHandler: @escaping ([StudentLocationGETResponse]?, String?) -> Void) {
            
            getStudentLocation(type: type) { (response, errorMessage) in
                if errorMessage != nil {
                    completionHandler(response, errorMessage)
                }
                else {
                    let filteredResponse = getfilteredResponse(studentLocations: response!)
                    switch type {
                    case .allLocations:
                        studentLocations = filteredResponse
                    case .myLocation:
                        break
                    }
                    completionHandler(filteredResponse, errorMessage)
                }
            }
        }
        
        private static func getfilteredResponse(
            studentLocations: [StudentLocationGETResponse]) -> [StudentLocationGETResponse] {
            var set = Set<String>()
            var filtered = [StudentLocationGETResponse]()
            for item in studentLocations {
                if let key = item.uniqueKey, !set.contains(key) {
                    filtered.append(item)
                    set.insert(key)
                }
            }
            return filtered
        }
        
        static func setStudentLocation(mapString: String, mediaURL: String,
                                latitude: Float, longitude: Float,
                                completionHandler: @escaping (_ error: String?) -> Void) {
            
            if let objectID = objectID {
                ParseClient.PUTStudentLocation(objectID: objectID, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude) { (response, errorMessage) in
                    completionHandler(errorMessage)
                }
            }
            else {
                ParseClient.POSTStudentLocation(mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude) { (response, errorMessage) in
                    guard let response = response else {
                        completionHandler(errorMessage)
                        return
                    }
                    Parse.objectID = response.objectId
                    completionHandler(nil)
                }
            }
            
        }
        
    }
    
}
