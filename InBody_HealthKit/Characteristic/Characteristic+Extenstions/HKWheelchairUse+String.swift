//
//  HKWheelchairUse+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/04.
//

import HealthKit

extension HKWheelchairUse {
    var stringRepresentation: String {
        switch self {
        case .no: return "no"
        case .yes: return "yes"
        case .notSet: return "notSet"
        @unknown default:
            return "unknown"
        }
    }
}
