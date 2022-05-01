//
//  Quantity.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/28.
//

import Foundation

struct Quantity: Codable {
    let dataName: String
    let value: String
    let startTime: String
    let endTime: String
    let source: String
}
