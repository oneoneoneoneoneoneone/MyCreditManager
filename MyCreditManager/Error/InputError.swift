//
//  InputError.swift
//  MyCreditManager
//
//  Created by hana on 2023/04/26.
//

import Foundation

enum InputError: Error{
    case wrongStartValue
    case wrongValue
    case duplicationStudent(student: String)
    case nonexistentStudent(student: String)
    case Exit
}
