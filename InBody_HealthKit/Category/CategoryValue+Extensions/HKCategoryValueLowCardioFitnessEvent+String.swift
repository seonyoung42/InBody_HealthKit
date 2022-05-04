//
//  HKCategoryValueLowCardioFitnessEvent+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/04.
//

import HealthKit

extension HKCategoryValueLowCardioFitnessEvent {
    var stringRepresentation: String {
        switch self {
        case .lowFitness: return "lowFitness"
        @unknown default:
            return "unknown"
        }
    }
}
