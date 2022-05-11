//
//  DailyQuantity.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/11.
//

import Foundation

public struct DailyQuantity: Codable {
    let date: String
    let dataName: String
    let totalValue: Double?
    let quantities: [String]
}

public struct Quantity: Codable {
    let value: String
    let unit: String
    let startTime: String
    let endTime: String
    let dataSource: String
}
