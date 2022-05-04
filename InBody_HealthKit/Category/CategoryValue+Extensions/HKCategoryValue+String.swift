//
//  HKCategoryValue+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/04.
//

import HealthKit

extension HKCategoryValue {
    var stringRepresentation: String {
        switch self {
        case .notApplicable: return "case not defined"
        default:
            return "unknown"
        }
    }
}
