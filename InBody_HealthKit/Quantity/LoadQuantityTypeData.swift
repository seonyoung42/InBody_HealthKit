//
//  LoadQuantityTypeData.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/28.
//

import Foundation
import HealthKit

open class LoadQuantityTypeData {
    
    static var data: Double? = nil
    
    // MARK : 데이터 불러오기 - DailyQuantity
    public class func getDailyQuantityData(sampleType: HKQuantityType,
                                       startDate: Date,
                                       endDate: Date,
                                       limit: Int,
                                       ascending: Bool,
                                       option: HKQueryOptions,
                                       completion: @escaping ([String], Error?) -> Swift.Void) {
        
        var jsonArray = [String]()

        let dataName = sampleType.identifier.components(separatedBy: "Identifier")[1]
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: option)
        let daily = DateComponents(day:1)
        
        /// anchorDate : 데이터 시간간격의 기준 날짜, intervalComponents : 시간 간격(현재는 1일)
        let query = HKStatisticsCollectionQuery(quantityType: sampleType,
                                                quantitySamplePredicate: predicate,
                                                options: [.cumulativeSum],
                                                anchorDate: startDate,
                                                intervalComponents: daily)
    
        
        query.initialResultsHandler = { query, results, error in
            
            if let results = results {
                DispatchQueue.main.async {
                    jsonArray = self.printDailyQuantityData(results, startDate: startDate, endDate: endDate, sampleType: sampleType, limit: limit, ascending: ascending, option: option)
                }
            }
            completion(jsonArray,nil)
        }
        HKHealthStore().execute(query)
    }
    
    public static func printDailyQuantityData(_ results: HKStatisticsCollection, startDate: Date, endDate: Date, sampleType: HKQuantityType, limit: Int, ascending: Bool, option: HKQueryOptions) -> [String] {
        
        let dataName = sampleType.identifier.components(separatedBy: "Identifier")[1]
        var jsonArray = [String]()

            results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                
                if let quantity = statistics.sumQuantity() {
                    let startDate = statistics.startDate
                    let endDate = statistics.endDate
                    
                    returnDataType(sampleType: sampleType, statistics: quantity)
                                    
                    /// 기간(1일) 내 모든 Quantity 데이터 가져오기
                    getQuantityData(sampleType: sampleType,
                                    startDate: startDate,
                                    endDate: endDate,
                                    option: option,
                                    limit: limit,
                                    ascending: ascending) { quantities, error in
                        guard let quantities = quantities else { return }
                                                    
                        let jsonResult = encodeDailyQuantityToJSON(date: statistics.startDate.toStringWithTime(),
                                                                   dataName: dataName,
                                                                   totalData: data!,
                                                                   quantities: quantities)
                        
                        
                        guard let jsonResult = jsonResult else { return }
                        jsonArray.append(jsonResult)
                    }
                }
            }
        return jsonArray
    }
    
    
    // MARK : 데이터 불러오기 - Quantity
    public static func getQuantityData(sampleType: HKQuantityType,
                                       startDate: Date,
                                       endDate: Date,
                                       option: HKQueryOptions,
                                       limit: Int,
                                       ascending: Bool,
                                       completion: @escaping ([String]?, Error?) -> Swift.Void) {
        
        /// start 시점부터 내림차순/오름차순으로 정렬
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: ascending)
        let dataName = sampleType.identifier.components(separatedBy: "Identifier")[1]
        
        /// 시간 범위 설정, option(strictStartDate 0r strictEndDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: option)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: predicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { query, samples, error in
            
            /// sample.isEmpty -> 사용자의 데이터가 없거나, 접근 허가를 받지 못해서 데이터를 불러오지 못하는 경우
            guard let samples = samples as? [HKQuantitySample] else {
                print("\(dataName) 데이터가 없거나 해당 데이터 접근 권한 없음")
                return
            }
            /// JSON으로 변환한 Quantity 배열 받기
            guard let jsonArray = LoadQuantityTypeData.encodeQuantityToJSON(dataArray: samples, dataName: dataName) else {
                completion(nil,error)
                return
            }
            completion(jsonArray,nil)
        }
        HKHealthStore().execute(sampleQuery)
    }

}

extension LoadQuantityTypeData {
    // MARK : - DailyCount -> JSON 으로 인코딩
    public static func encodeDailyQuantityToJSON(date: String,
                                                 dataName: String,
                                                 totalData: Double,
                                                 quantities: [String]?) -> String? {
        
        let dailyQuantity = DailyQuantity(date: date,
                                          dataName: dataName,
                                          totalValue: totalData,
                                          quantities: quantities ?? [])
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys ]
        
        let jsonData = try? encoder.encode(dailyQuantity)
        
        if let jsonData = jsonData,
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            print("오류 : DailyQuantity -> JSON")
            return nil
        }
    }
    
    
    // MARK : - Quantity -> JSON 으로 인코딩
    public static func encodeQuantityToJSON(dataArray: [HKQuantitySample], dataName: String) -> [String]? {
        var dataList = [String]()
        
        dataArray.forEach {
            let start = $0.startDate.toStringWithTime()
            let end = $0.endDate.toStringWithTime()
            let source = $0.sourceRevision.source.name
            let quantitySplit = "\($0.quantity)".split(separator:" ").map {String($0)}
            let value = quantitySplit[0]
            let unit = quantitySplit[1]

            let data = Quantity(value: value,
                                unit: unit,
                                startTime: start,
                                endTime: end,
                                dataSource: source)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            
            let jsonData = try? encoder.encode(data)
            
            if let jsonData = jsonData,
               let jsonString = String(data: jsonData, encoding: .utf8) {
                dataList.append(jsonString)
            } else {
                print("오류 : DailyQuantity -> JSON")
            }
        }
        return dataList
    }
    
    // MARK : - 각 데이터 타입에 맞는 단위 알려줌
    static func returnDataType (sampleType: HKQuantityType, statistics: HKQuantity) {
        switch sampleType {
                case HKSampleType.quantityType(forIdentifier: .environmentalAudioExposure),
                    HKSampleType.quantityType(forIdentifier: .headphoneAudioExposure):
                    data = statistics.doubleValue(for: HKUnit.decibelAWeightedSoundPressureLevel())
                case HKSampleType.quantityType(forIdentifier: .heartRate):
                    data = statistics.doubleValue(for: HKUnit(from: "count/min"))
                case HKObjectType.quantityType(forIdentifier: .oxygenSaturation):
                    data = statistics.doubleValue(for: HKUnit(from: "%")) * 100
                case HKObjectType.quantityType(forIdentifier: .bodyMass),
                    HKObjectType.quantityType(forIdentifier: .leanBodyMass):
                    data = statistics.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                case HKObjectType.quantityType(forIdentifier: .stepCount),
                    HKObjectType.quantityType(forIdentifier: .flightsClimbed),
                    HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
                    HKObjectType.quantityType(forIdentifier: .uvExposure):
                    data = statistics.doubleValue(for: HKUnit.count())
                case HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN):
                    data = statistics.doubleValue(for: HKUnit.secondUnit(with: .milli))
                case HKObjectType.quantityType(forIdentifier: .appleStandTime):
                    data = statistics.doubleValue(for: HKUnit.second())
                case HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage),
                    HKObjectType.quantityType(forIdentifier: .restingHeartRate):
                    data = statistics.doubleValue(for: HKUnit(from: "count/s"))
                case HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
                    HKObjectType.quantityType(forIdentifier: .distanceCycling):
                    data = statistics.doubleValue(for: HKUnit.meter())
                case HKObjectType.quantityType(forIdentifier: .basalBodyTemperature),
                    HKObjectType.quantityType(forIdentifier: .bodyTemperature):
                    data = statistics.doubleValue(for: HKUnit.degreeCelsius())
                case HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic),
                    HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic):
                    data = statistics.doubleValue(for: HKUnit.millimeterOfMercury())
                case HKObjectType.quantityType(forIdentifier: .peakExpiratoryFlowRate):
                    data = statistics.doubleValue(for: HKUnit(from: "L/min"))
                case HKObjectType.quantityType(forIdentifier: .vo2Max):
                    data = statistics.doubleValue(for: HKUnit(from: "ml/kg*min"))
                default:
                    break
        }
    }
}
