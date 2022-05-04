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
    public class func getWorkoutData(start: Date?,
                                     end: Date?,
                                     limit: Int,
                                     ascending: Bool,
                                     option: HKQueryOptions,
                                     completion: @escaping ([String]?, Error?) -> Void) {
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                            ascending: ascending)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: option)
        
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
                
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            
            let data = Workout(name: name,
                               startTime: start,
                               endTime: end,
                               source: source,
                               product: product ?? "unknown")
            
            let jsonData = try? encoder.encode(data)
            
            if let jsonData = jsonData,
               let jsonString = String(data: jsonData, encoding: .utf8) {
                let keyUser = $0.metadata?[HKMetadataKeyWasUserEntered]
                dataList.append(jsonString)
                print("""
                    
                    < HKObject >
                    UUID (HealthKit object 식별자) : \($0.uuid),
                    sourceRevision (HealthKit object 생성한 app 또는 기기)
                        - sourceName (sample source의 이름) : \($0.sourceRevision.source.name),
                        - bundleIdentifier (sample source의 식별자) : \($0.sourceRevision.source.bundleIdentifier),
                        - version (sample 저장한 app이나 기기의 버전, optional) : \($0.sourceRevision.version),
                        - productType(sample저장하는데 사용한 기기, optional) : \($0.sourceRevision.productType),
                        - operatingSystem (sample 저장하는데 사용된 운영체제) : \($0.sourceRevision.operatingSystemVersion),
                    device (HealthKit object에 대한 데이터를 생성한 장치, optional) : \($0.device),
                    metadata (optional, 데이터마다 다른 metadata 출력) : \($0.metadata)
                        - metadataWasUserEntered (sample이 사용자에 의해 입력된 건지) :\(keyUser),
                    
                    < Sample >
                    startDate (sample 시작 시간) : \($0.startDate),
                    endDate (sample 끝난 시간) : \($0.endDate),
                    hasUndeterminedDuration (sample에 알 수 없는 기간 있는지 여부) : \($0.hasUndeterminedDuration),
                    sampleType : \($0.sampleType)
                    
                    < Workout >
                    duration (운동 시간): \($0.duration),
                    totalDistance (운동 중 이동한 총 거리, optional): \($0.totalDistance),
                    totalEnergyBurned (운동 중 소모된 총 활성화에너지, optional): \($0.totalEnergyBurned),
                    workoutActivityType (운동 유형): \($0.workoutActivityType.stringRepresentation),
                    workoutEvent (운동 이벤트 개체의 유형, optional): \($0.workoutEvents),
                    totalFlightsClimbed (운동 중 올라간 총 계단 수, optional): \($0.totalFlightsClimbed),
                    totalSwimmingStrokeCount (운동의 총 stroke 수, optional): \($0.totalSwimmingStrokeCount)
                    """)
              
            } else {
                print("오류 : Workout -> JSON")
            }
        }
        return dataList
    }
}
