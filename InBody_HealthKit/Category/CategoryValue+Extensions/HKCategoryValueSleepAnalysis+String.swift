//
//  HKCategoryValueSleepAnalysis+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/03.
//

import HealthKit

extension HKCategoryValueSleepAnalysis {
    var stringRepresentation: String {
        switch self {
        case .asleep: return "asleep"
        case .awake: return "awake"
        case .inBed: return "inBed"
        @unknown default:
            return "unknown"
        }
    }
}
