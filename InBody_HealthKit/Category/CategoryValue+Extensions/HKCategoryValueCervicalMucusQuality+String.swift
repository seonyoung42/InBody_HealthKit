//
//  HKCategoryValueCervicalMucusQuality+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/04.
//

import HealthKit

extension HKCategoryValueCervicalMucusQuality {
    var stringRepresentation: String {
        switch self {
        case .creamy: return "creamy"
        case .dry: return "dry"
        case .eggWhite: return "eggWhite"
        case .sticky: return "sticky"
        case .watery: return "watery"
        @unknown default:
            return "unknown"
        }
    }
}
