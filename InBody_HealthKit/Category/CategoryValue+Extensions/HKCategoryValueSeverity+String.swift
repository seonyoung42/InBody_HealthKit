//
//  HKCategoryValueSeverity+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/04.
//

import HealthKit

extension HKCategoryValueSeverity {
    var stringRepresentation: String {
        switch self {
        case .unspecified: return "unspecified"
        case .notPresent: return "notPresent"
        case .mild: return "mild"
        case .moderate: return "moderate"
        case .severe: return "severe"
        @unknown default:
            return "unknown"
        }
    }
}
