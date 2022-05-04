//
//  HKCategoryValueContraceptive+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/04.
//

import HealthKit

extension HKCategoryValueContraceptive {
    var stringRepresentation: String {
        switch self {
        case .unspecified: return "unspecified"
        case .implant: return "implant"
        case .injection: return "injection"
        case .intrauterineDevice: return "intrauterineDevice"
        case .intravaginalRing: return "intravaginalRing"
        case .oral: return "oral"
        case .patch: return "patch"
        @unknown default:
            return "unknown"
        }
    }
}
