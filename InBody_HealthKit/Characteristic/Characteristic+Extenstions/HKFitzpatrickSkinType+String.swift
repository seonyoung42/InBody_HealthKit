//
//  HKFitzpatrickSkinType+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/29.
//

import HealthKit

extension HKFitzpatrickSkinType {
    var stringRepresentation: String {
        switch self {
        case .I: return "I"
        case .II: return "II"
        case .III: return "III"
        case .IV: return "IV"
        case .V: return "V"
        case .VI: return "VI"
        case .notSet: return "notSet"
        @unknown default:
            return "unknown"
        }
    }
}

