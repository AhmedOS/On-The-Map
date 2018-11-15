//
//  UdacityGETUserResponse.swift
//  OnTheMap
//
//  Created by Ahmed Osama on 11/11/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import Foundation

struct UdacityGETUserResponse: Codable {
    
    let firstName: String?
    let lastName: String?
    let nickname: String?
    let imageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
        case imageURL = "_image_url"
    }

}
