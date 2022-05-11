//
//  LoadWorkoutTypeData.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/28.
//

import Foundation
import HealthKit

open class LoadWorkoutTypeData {
    
    // MARK : 데이터 불러오기 - Workout
    public class func getWorkoutData(startDate: Date?,
                                     endDate: Date?,
                                     limit: Int,
                                     ascending: Bool,
                                     option: HKQueryOptions,
                                     completion: @escaping ([String]?, Error?) -> Void) {
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                            ascending: ascending)
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: endDate,
                                                    options: option)
        
        let query = HKSampleQuery(sampleType: .workoutType(),
                                  predicate: predicate,
                                  limit: limit,
                                  sortDescriptors: [sortDescriptor]) { query, samples, error in
            
            guard let samples = samples as? [HKWorkout] else { return }
            
            if samples.isEmpty {
                print("Workout 데이터가 없거나 해당 데이터 접근 권한 없음")
                completion(nil,error)
            } else {
                let jsonArray = encodeWorkoutToJSON(dataArray: samples)
                DispatchQueue.main.async {
                    completion(jsonArray,nil)
                }
            }
        }
        HKHealthStore().execute(query)
    }
    
    // MARK : WorkoutType -> JSON 으로 인코딩
    private static func encodeWorkoutToJSON(dataArray: [HKWorkout]) -> [String]? {
        var dataList = [String]()
        
        dataArray.forEach {
            let name = $0.workoutActivityType.stringRepresentation
            let start = $0.startDate.toStringWithTime()
            let end = $0.endDate.toStringWithTime()
            let source = $0.sourceRevision.source.name
            let product = $0.sourceRevision.productType
            let totalDistance = $0.totalDistance?.doubleValue(for: HKUnit.mile())
            let totalEnergyBurned = $0.totalEnergyBurned?.doubleValue(for: .joule())
            let duration = $0.duration.description
            let workoutEvent = $0.workoutEvents?.count
            let totalFlightsClimbed = $0.totalFlightsClimbed?.doubleValue(for: .count())
            let totalSwimingStrokeCount = $0.totalSwimmingStrokeCount?.doubleValue(for: .count())
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            
            let data = Workout(workoutName: name,
                               startTime: start,
                               endTime: end,
                               dataSource: source,
                               duration: duration,
                               totalDistance: totalDistance,
                               totalEnergyBurned: totalEnergyBurned,
                               workoutEvent: workoutEvent,
                               totalFlightsClimbed: totalFlightsClimbed,
                               totalSwimmingStrokecount: totalSwimingStrokeCount)
            
            let jsonData = try? encoder.encode(data)
            
            if let jsonData = jsonData,
               let jsonString = String(data: jsonData, encoding: .utf8) {
                dataList.append(jsonString)
            } else {
                print("오류 : Workout -> JSON")
            }
        }
        return dataList
    }
}
