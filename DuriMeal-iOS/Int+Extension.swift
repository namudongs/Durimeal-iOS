//
//  Int+Extension.swift
//  DuriMeal-iOS
//
//  Created by namdghyun on 8/18/24.
//

import Foundation

extension Int {
    func timeIndexToString() -> String {
        switch self {
        case 2:
            return "아침"
        case 3:
            return "점심"
        case 4:
            return "저녁"
        default:
            return "없음"
        }
    }
    
    func placeIndexToSelector() -> String {
        switch self {
        case 1:
            return "#latest02"
        case 2:
            return "#latest03"
        default:
            return "없음"
        }
    }
    
    func placeIndexToString() -> String {
        switch self {
        case 1:
            return "새롬관"
        case 2:
            return "이룸관"
        default:
            return "없음"
        }
    }
    
    func dayIndexToString() -> String {
        switch self {
        case 0:
            return "월"
        case 1:
            return "화"
        case 2:
            return "수"
        case 3:
            return "목"
        case 4:
            return "금"
        default:
            return "없음"
        }
    }
    
    func paramToPlace() -> String {
        switch self {
        case 10:
            return "천지관"
        case 20:
            return "백록관"
        default:
            return "두리관"
        }
    }
}
