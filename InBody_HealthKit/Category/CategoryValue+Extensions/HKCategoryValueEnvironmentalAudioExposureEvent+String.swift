//
//  HKCategoryValueEnvironmentalAudioExposureEvent+String.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/05/04.
//

import HealthKit

extension HKCategoryValueEnvironmentalAudioExposureEvent {
    var stringRepresentation: String {
        switch self {
        case .momentaryLimit: return "momentaryLimit"
        }
    }
}
