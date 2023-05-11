//
//  MyCreditManagerType.swift
//  MyCreditManager
//
//  Created by hana on 2023/05/12.
//

import Foundation

protocol MyCreditManagerType{
    func addStudent(_ inputName: String?) throws
    func removeStudent(_ inputName: String?) throws
    func addGrade(_ inputGrade: String?) throws
    func removeGrade(_ inputGrade: String?) throws
    func getAverage(_ inputName: String?) throws
    func endProgram()
}
