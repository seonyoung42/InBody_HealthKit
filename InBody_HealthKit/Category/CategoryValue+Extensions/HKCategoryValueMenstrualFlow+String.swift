//
//  HKCategoryValueMenstrualFlow+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/04.
//

import HealthKit

extension HKCategoryValueMenstrualFlow {
    var stringRepresentation: String {
        switch self {
        case .unspecified: return "unspecified"
        case .light: return "light"
        case .medium: return "medium"
        case .heavy: return "heavy"
        case .none: return "none"
        @unknown default:
            return "unknown"
        }
    }
}
