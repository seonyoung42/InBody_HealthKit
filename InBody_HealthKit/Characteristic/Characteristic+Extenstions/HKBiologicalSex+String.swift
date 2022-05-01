//
//  HKBiologicalSex+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/29.
//

import HealthKit

extension HKBiologicalSex {
    var stringRepresentation: String {
        switch self {
        case .notSet: return "Unknown"
        case .female: return "Female"
        case .male: return "Male"
        case .other: return "Other"
        }
    }
}

