//
//  LoadQuantityTypeData.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/28.
//

import Foundation
import HealthKit

open class LoadQuantityTypeData {
    
    // MARK : 데이터 불러오기 - QuantityType
    public class func getQuantityData(for sampleType: HKQuantityType,
                                       start: Date?,
                                       end: Date?,
                                       limit: Int,
                                       ascending: Bool,
                                       option: HKQueryOptions,
                                       completion: @escaping ([String]?, Error?) -> Swift.Void) {
        
        // start 시점부터 내림차순/오름차순으로 정렬
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: ascending)
        
        // start와 end 모두 nil인 경우 모든 데이터 중 limit만큼의 데이터 불러옴
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: option)
        
        // predicate(시간범위) nil => 모든 데이터, 데이터 개수 제한은 maxCount로 받음
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: predicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { [self] query, samples, error in
            
            guard let samples = samples as? [HKQuantitySample] else { return }
            let dataName = sampleType.identifier.components(separatedBy: "Identifier")[1]
            
            // sample.isEmpty -> 사용자의 데이터가 없거나, 접근 허가를 받지 못해서 데이터를 불러오지 못하는 경우
            if samples.isEmpty {
                
                print("\(dataName) 데이터가 없거나 해당 데이터 접근 권한 없음")
                completion(nil,error)
            } else {
                let dataArray = encodeQuantityToJSON(dataArray: samples, dataName: dataName)
                
                DispatchQueue.main.async {
                    completion(dataArray,nil)
                }
            }
        }
        HKHealthStore().execute(sampleQuery)
    }

    
    // MARK : QuantityType -> JSON 으로 인코딩
    private static func encodeQuantityToJSON(dataArray: [HKQuantitySample], dataName: String) -> [String]? {
        var dataList = [String]()
        
        dataArray.forEach {
            let start = $0.startDate.toStringWithTime()
            let end = $0.endDate.toStringWithTime()
            let source = $0.sourceRevision.source.name
            let value = $0.quantity
            
            let etc = $0.sourceRevision
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            
            let data = Quantity(dataName: dataName,
                                value: "\(value)",
                                startTime: start,
                                endTime: end,
                                source: source)
            
            let jsonData = try? encoder.encode(data)
            
            if let jsonData = jsonData,
               let jsonString = String(data: jsonData, encoding: .utf8) {
                dataList.append(jsonString)
            } else {
                print("오류 : QuantityType -> JSON")
            }
        }
        return dataList
    }
}
