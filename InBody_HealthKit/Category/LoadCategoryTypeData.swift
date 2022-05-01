//
//  LoadCategoryTypeData.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/29.
//

import Foundation
import HealthKit
/*
open class LoadCategoryTypeData {
    
    // MARK : 데이터 불러오기 - Category
    public class func getCategoryData(for sampleType: HKCategoryType,
                                      startTime: Date?,
                                      endTime: Date?,
                                      limit: Int,
                                      ascending: Bool,
                                      option: HKQueryOptions,
                                      completion: @escaping ([String]?, Error?) -> Swift.Void) {
        
        // start 시점부터 내림차순/오름차순으로 정렬
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: ascending)
        let predicate = HKQuery.predicateForSamples(withStart: startTime,
                                                    end: endTime,
                                                    options: option)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: predicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { query, samples, error in
            
            guard let samples = samples as? [HKCategorySample] else { return }
            let dataName = sampleType.identifier.components(separatedBy: "Identifier")[1]

            // sample.isEmpty -> 사용자의 데이터가 없거나, 접근 허가를 받지 못해서 데이터를 불러오지 못하는 경우
            if samples.isEmpty {
                print("\(dataName) 데이터가 없거나 해당 데이터 접근 권한 없음")
                completion(nil,error)
            } else {
                
                let dataList = encodeCategoryToJSON(dataArray: samples, dataName: dataName)
                DispatchQueue.main.async {
                    completion(dataList,nil)
                }
            }
        }
        HKHealthStore().execute(sampleQuery)
    }
    
    // MARK : CategoryType -> JSON 으로 인코딩
    private static func encodeCategoryToJSON(dataArray: [HKCategorySample], dataName: String) -> [String]? {
        var dataList = [String]()

        dataArray.forEach {
            let start = $0.startDate.toStringWithTime()
            let end = $0.endDate.toStringWithTime()
            let source = $0.sourceRevision.source.name
            let `case` = $0.value

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]

            let data = Category(name: dataName,
                                case: <#T##String#>,
                                startTime: start,
                                endTime: end,
                                source: source)

            let jsonData = try? encoder.encode(data)

            if let jsonData = jsonData,
               let jsonString = String(data: jsonData, encoding: .utf8) {
                dataList.append(jsonString)
            } else {
                print("오류 : CategoryType -> JSON")
            }
        }

        return dataList
    }
}
 
 */

