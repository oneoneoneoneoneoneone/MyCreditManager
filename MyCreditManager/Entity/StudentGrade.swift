//
//  StudentGrade.swift
//  MyCreditManager
//
//  Created by hana on 2023/04/26.
//

import Foundation

struct StudentGrade{
    let student: Student
    let subject: String
    var grade: Grade
}

enum Task: String{
    case studentAdd = "1"
    case studentRemove = "2"
    case gradeAdd = "3"
    case gradeRemove = "4"
    case getAverage = "5"
    case exit = "X"
}

enum Grade: String {
    case Ap = "A+"
    case A = "A"
    case Am = "A-"
    case Bp = "B+"
    case B = "B"
    case Bm = "B-"
    case Cp = "C+"
    case C = "C"
    case Cm = "C-"
    case Dp = "D+"
    case D = "D"
    case Dm = "D-"
    case F = "F"
}
