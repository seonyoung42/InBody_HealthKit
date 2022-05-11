//
//  Workout.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/28.
//

import Foundation

struct Workout: Codable {
    let workoutName: String
    let startTime: String
    let endTime: String
    let dataSource: String
    let duration: String
    let totalDistance: Double?
    let totalEnergyBurned: Double?
    let workoutEvent: Int?
    let totalFlightsClimbed: Double?
    let totalSwimmingStrokecount: Double?
}
