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
    
    // - 생물학적 성별
    public static func getBiologicalSex() -> String {
        
        do {
            let biologicalSex = try healthStore.biologicalSex().biologicalSex.stringRepresentation
            return biologicalSex
        } catch {
            return "오류 : CharacteristicType(성별 데이터) - \(error.localizedDescription)"
        }
    }
    
    // - 생일
    public static func getDateOfBirth() -> String? {
        
        do {
            let dateOfBirth = try healthStore.dateOfBirthComponents().date!.toStringWithoutTime()
            return dateOfBirth
        } catch {
            return "오류 : CharacteristicType(생일) - \(error.localizedDescription)"
        }
    }
    
    // - 혈액형
    public static func getBloodType() -> String {
        
        do {
            let bloodType = try healthStore.bloodType().bloodType.stringRepresentation
            return bloodType
        } catch {
            return "오류 : CharacteristicType(혈액형) - \(error.localizedDescription)"
        }
    }
    
    // - 피부타입 (피츠패트릭피부타입)
    public static func getSkinType() -> String {
        
        do {
            let skinType = try healthStore.fitzpatrickSkinType().skinType.stringRepresentation
            
            return skinType
        } catch {
            return "오류 : CharacteristicType(피부타입) - \(error.localizedDescription)"
        }
    }
    
    // - 사용자 활동 모드
    public static func getActivityMoveMode() -> String {
        do {
            let activityMoveMode = try healthStore.activityMoveMode().activityMoveMode.stringRepresentation
            return activityMoveMode
        } catch {
            return "오류 : CharacteristicType(사용자 활동 모드) - \(error.localizedDescription)"
        }
    }
    
    // 휠체어 사용 유무
    public static func getWheelChairUsage() -> String {
        do {
            let wheelChairUse = try healthStore.wheelchairUse().wheelchairUse.stringRepresentation
            return wheelChairUse
        } catch {
            return "오류 : CharacteristicType(휠체어 사용 유무) - \(error.localizedDescription)"
        }
    }
}
