//
//  HKCategoryValuePresence+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/04.
//

import HealthKit

extension HKCategoryValuePresence {
    var stringRepresentation: String {
        switch self {
        case .notPresent: return "notPresent"
        case .present: return "present"
        default:
            return "unknow"
        }
    }
}
