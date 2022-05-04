//
//  HealthKitSetupManager.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/28.
//

import Foundation
import HealthKit

open class HealthKitSetupManager {
        
    // MARK : HealthKit setup시 에러 타입
    private enum HealthkitSetupError: Error {
      case notAvailableOnDevice
    }
    
    // MARK : HealthKit 데이터 접근 권한 요청
    public class func requestHealthKitAuthorization(shareTypes: Set<HKSampleType>?,
                                                    readTypes: Set<HKObjectType>?,
                                                    completion: @escaping (Bool, Error?) -> Swift.Void) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("오류 : HealthKit 데이터 사용 불가")
            completion(false,HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        print("성공 : HealthKit 데이터 사용 가능")
        
        DispatchQueue.main.async {
            HKHealthStore().requestAuthorization(toShare: shareTypes,
                                                 read: readTypes) { success, error in
                completion(success,error)
            }
        }
    }
}
