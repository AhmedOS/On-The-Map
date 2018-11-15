//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Ahmed Osama on 11/11/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import Foundation

struct StudentLocationGETResponse: Codable {
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let nickname: String?
    let latitude: Float?
    let longitude: Float?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
}
