//
//  LoadCharacteristicTypeData.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/29.
//

import Foundation
import HealthKit

open class LoadCharacteristicTypeData {
    
    static let healthStore = HKHealthStore()
    
    // - BiologicalSex
    public static func getBiologicalSex() -> String {
        
        do {
            let biologicalSex = try healthStore.biologicalSex().biologicalSex.stringRepresentation
            return biologicalSex
        } catch {
            return "오류 : 성별 데이터 \(error.localizedDescription)"
        }
    }
    
    // - DateOfBirth
    public static func getDateOfBirth() -> String {

        do {
            let dateOfBirth = try healthStore.dateOfBirthComponents().date!.toStringWithoutTime()
            return dateOfBirth
        } catch {
            return "오류 : 성별 데이터 \(error.localizedDescription)"
        }
    }
    
    // - BloodType
    public static func getBloodType() -> String {
        
        do {
            let bloodType = try healthStore.bloodType().bloodType.stringRepresentation
            return bloodType
        } catch {
            return "오류 : 혈액형 데이터 \(error.localizedDescription)"
        }
    }
    
    // - SkinType
    public static func getSkinType() -> String {
        
        do {
            let skinType = try healthStore.fitzpatrickSkinType().skinType.stringRepresentation
            
            return skinType
        } catch {
            return "오류 : 피부타입 데이터 \(error.localizedDescription)"
        }
    }
}
