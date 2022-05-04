//
//  HKCategoryValueAppetiteChanges+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/04.
//

import HealthKit

extension HKCategoryValueAppetiteChanges {
    var stringRepresentation: String {
        switch self {
        case .unspecified: return "unspecified"
        case .noChange: return "noChange"
        case .decreased: return "decreased"
        case .increased: return "increased"
        default:
            return "unknown"
        }
    }
}
