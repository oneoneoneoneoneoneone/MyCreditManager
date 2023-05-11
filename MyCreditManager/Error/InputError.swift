//
//  InputError.swift
//  MyCreditManager
//
//  Created by hana on 2023/04/26.
//

import Foundation

enum InputError: Error, CustomDebugStringConvertible{
    case wrongStartValue
    case wrongValue
    case duplicatedStudent(name: String)
    case nonexistentStudent(name: String)
    
    var debugDescription: String{
        switch self{
        case .wrongStartValue:
            return "뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요."
        case .wrongValue:
            return "입력이 잘못되었습니다. 다시 확인해주세요."
        case .duplicatedStudent(name: let name):
            return "\(name) 학생은 이미 존재하는 학생입니다. 추가하지 않습니다."
        case .nonexistentStudent(name: let name):
            return "\(name) 학생을 찾지 못했습니다."
        }
    }
}
