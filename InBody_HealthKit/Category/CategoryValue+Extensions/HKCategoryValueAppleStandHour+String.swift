//
//  HKCategoryValueAppleStandHour+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/04.
//

import HealthKit

extension HKCategoryValueAppleStandHour {
    var stringRepresentation: String {
        switch self {
        case .idle: return "idle"
        case .stood: return "stood"
        @unknown default:
            return "unknown"
        }
    }
}
