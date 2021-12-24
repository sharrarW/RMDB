//
//  RMLocation.swift
//  RMDB
//
//  Created by Sharrar Wasit on 12/21/21.
//

import Foundation

struct RMLocation: Decodable {
    let id: Int
    let name, type, dimension: String
    let residents: [String]
}
