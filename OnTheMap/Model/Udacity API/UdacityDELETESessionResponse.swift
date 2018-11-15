//
//  UdacityDELETESessionResponse.swift
//  OnTheMap
//
//  Created by Ahmed Osama on 11/11/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import Foundation

struct UdacityDELETESessionResponse: Codable {
    
    let session: Session?
    
    struct Session: Codable {
        let id: String?
        let expiration: String?
    }
    
}
