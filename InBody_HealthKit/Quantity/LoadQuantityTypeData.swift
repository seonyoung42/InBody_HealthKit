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
        
        
        let dataName = sampleType.identifier.components(separatedBy: "Identifier")[1]

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
            // sample.isEmpty -> 사용자의 데이터가 없거나, 접근 허가를 받지 못해서 데이터를 불러오지 못하는 경우
            guard let samples = samples as? [HKQuantitySample] else {
                print("\(dataName) 데이터가 없거나 해당 데이터 접근 권한 없음")
                return
            }
            
            let jsonArray = encodeQuantityToJSON(dataArray: samples, dataName: dataName)
            
            DispatchQueue.main.async {
                completion(jsonArray,nil)
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
                    
                    < Quantity >
                    quantity (값) : \($0.quantity),
                    quantityType : \($0.quantityType),
                    count (sample에 포함된 quantity의 수) : \($0.count)
                                        
                    """)
            } else {
                print("오류 : QuantityType -> JSON")
            }
        }
        return dataList
    }
}
