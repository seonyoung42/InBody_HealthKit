//
//  Category.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/29.
//

import Foundation

struct Category: Codable {
    let name: String
    let `case` : String
    let startTime: String
    let endTime: String
    let source: String
}
