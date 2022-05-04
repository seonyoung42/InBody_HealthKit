//
//  LoadCategoryTypeData.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/29.
//

import Foundation
import HealthKit

// MARK : 데이터처리 할 수 있는 CategoryType
enum CategoryValue {
    case sleepAnalysis(HKCategoryValueSleepAnalysis)
    case appleStandHour(HKCategoryValueAppleStandHour)
    case lowCardioFitnessEvent(HKCategoryValueLowCardioFitnessEvent)
    case cervicalMucusQuality(HKCategoryValueCervicalMucusQuality)
    case ovulationTestResult(HKCategoryValueOvulationTestResult)
    case menstrualFlow(HKCategoryValueMenstrualFlow)
    case contraceptive(HKCategoryValueContraceptive)
    case severity(HKCategoryValueSeverity)
    case presence(HKCategoryValuePresence)
    case appetiteChanges(HKCategoryValueAppetiteChanges)
    case undefined(HKCategoryValue)
}

open class LoadCategoryTypeData {
    // MARK : 수면 데이터 불러오기 - Category
    public class func getCategoryTypeData(sampleType: HKCategoryType,
                                           startTime: Date?,
                                           endTime: Date?,
                                           limit: Int,
                                           ascending: Bool,
                                           option: HKQueryOptions,
                                           completion: @escaping ([String]?, Error?) -> Swift.Void) {
        
        let dataName = sampleType.identifier.components(separatedBy: "Identifier")[1]
        
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
            

            guard let samples = samples as? [HKCategorySample] else {
                print("\(dataName) 데이터가 없거나 해당 데이터 접근 권한 없음")
                return
            }
            
            let jsonArray = encodeCategoryToJSON(dataArray: samples, dataName: dataName)
            DispatchQueue.main.async {
                completion(jsonArray,nil)
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
            let categoryCase = returnCategoryValueStringRepresentation(type: dataName, rawValue: $0.value)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            
            let data = Category(name: dataName,
                                case: categoryCase,
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
    
    
//    // MARK : 데이터 불러오기 - Category
//    public class func getCategoryData(for sampleType: HKCategoryType,
//                                      startTime: Date?,
//                                      endTime: Date?,
//                                      limit: Int,
//                                      ascending: Bool,
//                                      option: HKQueryOptions,
//                                      completion: @escaping ([HKCategorySample]?, Error?) -> Swift.Void) {
//
//        // start 시점부터 내림차순/오름차순으로 정렬
//        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
//                                              ascending: ascending)
//        let predicate = HKQuery.predicateForSamples(withStart: startTime,
//                                                    end: endTime,
//                                                    options: option)
//
//        let sampleQuery = HKSampleQuery(sampleType: sampleType,
//                                        predicate: predicate,
//                                        limit: limit,
//                                        sortDescriptors: [sortDescriptor]) { query, samples, error in
//
//            guard let samples = samples as? [HKCategorySample] else { return }
//            let dataName = sampleType.identifier.components(separatedBy: "Identifier")[1]
//
//
//            // sample.isEmpty -> 사용자의 데이터가 없거나, 접근 허가를 받지 못해서 데이터를 불러오지 못하는 경우
//            if samples.isEmpty {
//                print("\(dataName) 데이터가 없거나 해당 데이터 접근 권한 없음")
//                completion(nil,error)
//            } else {
//
//                let jsonArray = encodeCategoryToJSON(dataArray: samples, dataName: dataName)
//
//
////                let dataList = encodeCategoryToJSON(dataArray: samples, dataName: dataName)
////                DispatchQueue.main.async {
////                    completion(dataList,nil)
////                }
//
//                DispatchQueue.main.async {
//                    samples.forEach {
//                        let keyUser = $0.metadata?[HKMetadataKeyWasUserEntered]
//
//                        print("""
//                            < HKObject >
//                            UUID (HealthKit object 식별자) : \($0.uuid),
//                            sourceRevision (HealthKit object 생성한 app 또는 기기)
//                                - sourceName (sample source의 이름) : \($0.sourceRevision.source.name),
//                                - bundleIdentifier (sample source의 식별자) : \($0.sourceRevision.source.bundleIdentifier),
//                                - version (sample 저장한 app이나 기기의 버전, optional) : \($0.sourceRevision.version),
//                                - productType(sample저장하는데 사용한 기기, optional) : \($0.sourceRevision.productType),
//                                - operatingSystem (sample 저장하는데 사용된 운영체제) : \($0.sourceRevision.operatingSystemVersion),
//                            device (HealthKit object에 대한 데이터를 생성한 장치, optional) : \($0.device),
//                            metadata (optional, 데이터마다 다른 metadata 출력) : \($0.metadata)
//                                - metadataWasUserEntered (sample이 사용자에 의해 입력된 건지) :\(keyUser),
//
//                            < Sample >
//                            startDate (sample 시작 시간) : \($0.startDate),
//                            endDate (sample 끝난 시간) : \($0.endDate),
//                            hasUndeterminedDuration (sample에 알 수 없는 기간 있는지 여부) : \($0.hasUndeterminedDuration),
//                            sampleType : \($0.sampleType)
//
//                            < Category >
//                            categoryType : \($0.categoryType),
//                            value (카테고리 value ex. 0,1,2) : \($0.value)
//
//                            """)
//                    }
//                    completion(samples,nil)
//                }
//            }
//        }
//        HKHealthStore().execute(sampleQuery)
//    }
   
}

private extension LoadCategoryTypeData {
    
    // MARK : Category Case 값 문자열로 변환
    class func returnCategoryValueStringRepresentation(type: String, rawValue: Int) -> String {
        let categoryValue = getCategoryValue(type: type, rawValue: rawValue)
        
        switch categoryValue {
        case .sleepAnalysis(let value): return value.stringRepresentation
        case .appleStandHour(let value): return value.stringRepresentation
        case .lowCardioFitnessEvent(let value): return value.stringRepresentation
        case .cervicalMucusQuality(let value): return value.stringRepresentation
        case .ovulationTestResult(let value): return value.stringRepresentation
        case .menstrualFlow(let value): return value.stringRepresentation
        case .contraceptive(let value): return value.stringRepresentation
        case .severity(let value): return value.stringRepresentation
        case .presence(let value): return value.stringRepresentation
        case .appetiteChanges(let value): return value.stringRepresentation
        case .undefined(let value): return value.stringRepresentation
        }
    }
    
    // MARK : CategoryType의 CategoryValue 찾기
    class func getCategoryValue(type: String, rawValue: Int) -> CategoryValue {
        switch type {
        case "SleepAnalysis": return CategoryValue.sleepAnalysis(HKCategoryValueSleepAnalysis(rawValue: rawValue)!)
        case "AppleStandHour": return CategoryValue.appleStandHour(HKCategoryValueAppleStandHour(rawValue: rawValue)!)
        case "LowCardioFitnessEvent": return CategoryValue.lowCardioFitnessEvent(HKCategoryValueLowCardioFitnessEvent(rawValue: rawValue)!)
        case "CervicalMucusQuality": return CategoryValue.cervicalMucusQuality(HKCategoryValueCervicalMucusQuality(rawValue: rawValue)!)
        case "OvulationTestResult": return CategoryValue.ovulationTestResult(HKCategoryValueOvulationTestResult(rawValue: rawValue)!)
        case "MenstrualFlow": return CategoryValue.menstrualFlow(HKCategoryValueMenstrualFlow(rawValue: rawValue)!)
        case "Contraceptive": return CategoryValue.contraceptive(HKCategoryValueContraceptive(rawValue: rawValue)!)
        case "Severity": return CategoryValue.severity(HKCategoryValueSeverity(rawValue: rawValue)!)
        case "Presence": return CategoryValue.presence(HKCategoryValuePresence(rawValue: rawValue)!)
        case "AppetiteChanges": return CategoryValue.appetiteChanges(HKCategoryValueAppetiteChanges(rawValue: rawValue)!)
        default:
            return CategoryValue.undefined(HKCategoryValue(rawValue: rawValue)!)
        }
    }
}
