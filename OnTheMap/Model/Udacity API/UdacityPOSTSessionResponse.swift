//
//  UdacityPOSTSessionResponse.swift
//  OnTheMap
//
//  Created by Ahmed Osama on 11/11/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import Foundation

struct UdacityPOSTSessionResponse: Codable {
    
    let account: Account?
    let session: Session?
    
    struct Account: Codable {
        let registered: Bool?
        let key: String?
    }
    
    struct Session: Codable {
        let id: String?
        let expiration: String?
    }
    
}
