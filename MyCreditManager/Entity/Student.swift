//
//  Student.swift
//  MyCreditManager
//
//  Created by hana on 2023/04/26.
//

import Foundation

struct Student{
    let name: String
    var grades: [Grade] = []
    
    struct Grade{
        let subject: String
        var grade: String
    }
}
