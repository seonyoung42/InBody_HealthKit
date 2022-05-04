//
//  HKActivityMoveMode+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/04.
//

import HealthKit

extension HKActivityMoveMode {
    var stringRepresentation: String {
        switch self {
        case .activeEnergy: return "activeEnergy"
        case .appleMoveTime: return "appleMoveTime"
        @unknown default:
            return "unknown"
        }
    }
}
