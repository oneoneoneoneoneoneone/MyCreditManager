//
//  CoreFunction.swift
//  MyCreditManager
//
//  Created by hana on 2023/04/27.
//

import Foundation

protocol StudentGradeManagerProtocol{
    func addStudent(_ studentName: String) throws
    func removeStudent(_ studentName: String) throws
    func addGrade(_ studentGrade: String) throws
    func removeGrade(_ studentGrade: String) throws
    func getAverage(_ studentName: String) throws
}

class StudentGradeManager: StudentGradeManagerProtocol{
    private var students: [Student] = []
    private var studentGrades: [StudentGrade] = []
    
    func addStudent(_ studentName: String) throws{
        if studentName == "" || studentName.contains(" ") {
            throw InputError.wrongValue
        }
        
        if students.first(where: {$0.name == studentName}) != nil {
            throw InputError.duplicationStudent(student: studentName)
        }
        
        students.append(Student(name: studentName))
        
        print("\(studentName) 학생을 추가했습니다.")
    }
    
    func removeStudent(_ studentName: String) throws{
        if studentName == "" || studentName.contains(" ") {
            throw InputError.wrongValue
        }
        
        if students.first(where: {$0.name == studentName}) == nil {
            throw InputError.nonexistentStudent(student: studentName)
        }
        
        students.removeAll(where: {$0.name == studentName})
        
        print("\(studentName) 학생을 삭제했습니다.")
    }

    func addGrade(_ studentGrade: String) throws{
        if studentGrade == "" {
            throw InputError.wrongValue
        }
        
        //쪼개기
        let studentGrade = studentGrade.components(separatedBy: " ")
        if studentGrade.count != 3{
            throw InputError.wrongValue
        }
        //성적값 검증
        guard let grade = Grade(rawValue:studentGrade[2]) else {
            throw InputError.wrongValue
        }
        
        guard let student = students.first(where: {$0.name == studentGrade[0]}) else {
            throw InputError.nonexistentStudent(student: studentGrade[0])
        }
        
        if studentGrades.first(where: {$0.student.name == student.name && $0.subject == studentGrade[1]}) != nil{
            studentGrades.removeAll(where: {$0.student.name == student.name && $0.subject == studentGrade[1]})
        }
        studentGrades.append(StudentGrade(student: student, subject: studentGrade[1], grade: grade))
        
        print("\(studentGrade[0]) 학생의 \(studentGrade[1]) 과목이 \(grade.rawValue)로 추가(변경)되었습니다.")
    }

    func removeGrade(_ studentGrade: String) throws{
        if studentGrade == "" {
            throw InputError.wrongValue
        }
        //쪼개기
        let studentGrade = studentGrade.components(separatedBy: " ")
        if studentGrade.count != 2{
            throw InputError.wrongValue
        }
        
        guard let student = students.first(where: {$0.name == studentGrade[0]}) else {
            throw InputError.nonexistentStudent(student: studentGrade[0])
        }
        
        studentGrades.removeAll(where: {$0.student.name == student.name && $0.subject == studentGrade[1]})
        
        print("\(studentGrade[0]) 학생의 \(studentGrade[1]) 과목의 성적이 삭제되었습니다.")
    }

    func getAverage(_ studentName: String) throws{
        if studentName == "" || studentName.contains(" ") {
            throw InputError.wrongValue
        }
        
        guard let student = students.first(where: {$0.name == studentName}) else {
            throw InputError.nonexistentStudent(student: studentName)
        }
        
        let studentGrades = studentGrades.filter({$0.student.name == student.name})
        studentGrades.forEach{sg in
            print("\(sg.subject) : \(sg.grade.rawValue)")
        }
        print("평점 : \("")")
    }
}

