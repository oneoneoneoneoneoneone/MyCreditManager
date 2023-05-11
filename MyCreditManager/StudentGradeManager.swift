//
//  StudentGradeManager.swift
//  MyCreditManager
//
//  Created by hana on 2023/04/27.
//

import Foundation

protocol StudentGradeManagerProtocol{
    func addStudent(_ inputName: String?) throws
    func removeStudent(_ inputName: String?) throws
    func addGrade(_ inputGrade: String?) throws
    func removeGrade(_ inputGrade: String?) throws
    func getAverage(_ inputName: String?) throws
}

class StudentGradeManager: StudentGradeManagerProtocol{
    private var students: [Student] = []
    private var studentGrades: [StudentGrade] = []
    
    func addStudent(_ inputName: String?) throws{
        guard let studentName = inputName,
              studentName != "", studentName.contains(" ") == false else {
            throw InputError.wrongValue
        }
        
        if students.first(where: {$0.name == studentName}) != nil {
            throw InputError.duplicatedStudent(name: studentName)
        }
        
        students.append(Student(name: studentName))
        
        print("\(studentName) 학생을 추가했습니다.")
    }
    
    func removeStudent(_ inputName: String?) throws{
        guard let studentName = inputName,
              studentName != "", studentName.contains(" ") == false else {
            throw InputError.wrongValue
        }
        
        if students.first(where: {$0.name == studentName}) == nil {
            throw InputError.nonexistentStudent(name: studentName)
        }
        
        students.removeAll(where: {$0.name == studentName})
        
        print("\(studentName) 학생을 삭제했습니다.")
    }

    func addGrade(_ inputGrade: String?) throws{
        guard let inputGrade = inputGrade,
              inputGrade != "" else {
            throw InputError.wrongValue
        }
        
        let studentGrade = inputGrade.components(separatedBy: " ")
        guard studentGrade.count == 3 else{
            throw InputError.wrongValue
        }
        guard try isValidGradeString(inputGrade: studentGrade[2]) == true else {
            throw InputError.wrongValue
        }
        guard let student = students.first(where: {$0.name == studentGrade[0]}) else {
            throw InputError.nonexistentStudent(name: studentGrade[0])
        }
        
        if studentGrades.first(where: {$0.student.name == student.name && $0.subject == studentGrade[1]}) != nil{
            studentGrades.removeAll(where: {$0.student.name == student.name && $0.subject == studentGrade[1]})
        }
        studentGrades.append(StudentGrade(student: student, subject: studentGrade[1], grade: studentGrade[2]))
        
        print("\(student.name) 학생의 \(studentGrade[1]) 과목이 \(studentGrade[2])로 추가(변경)되었습니다.")
    }

    func removeGrade(_ inputGrade: String?) throws{
        guard let inputGrade = inputGrade,
              inputGrade != "" else {
            throw InputError.wrongValue
        }
        
        let studentGrade = inputGrade.components(separatedBy: " ")
        guard studentGrade.count == 2 else{
            throw InputError.wrongValue
        }
        guard let student = students.first(where: {$0.name == studentGrade[0]}) else {
            throw InputError.nonexistentStudent(name: studentGrade[0])
        }
        
        studentGrades.removeAll(where: {$0.student.name == student.name && $0.subject == studentGrade[1]})
        
        print("\(student.name) 학생의 \(studentGrade[1]) 과목의 성적이 삭제되었습니다.")
    }

    func getAverage(_ inputName: String?) throws{
        guard let studentName = inputName,
              studentName != "", studentName.contains(" ") == false else {
            throw InputError.wrongValue
        }
        
        guard let student = students.first(where: {$0.name == studentName}) else {
            throw InputError.nonexistentStudent(name: studentName)
        }
        
        let studentGrades = studentGrades.filter({$0.student.name == student.name})
        
        let averageScore = studentGrades.map{getScore($0.grade)}
            .reduce(0){$0 + $1} / Double(studentGrades.count)
        
        studentGrades.forEach{print("\($0.subject) : \($0.grade)")}
        print(String(format: "평점 : %.2f", averageScore))
    }
    
    private func getScore(_ grade: String) -> Double{
        return (grade.first == "A" ? 4 : grade.first == "B" ? 3 : grade.first == "C" ? 2 : grade.first == "D" ? 1 : 0) + (grade.last == "+" ? 0.5 : 0)
    }
    
    private func isValidGradeString(inputGrade: String) throws -> Bool{
        let regex = /^[A-D][+]$|^[A-D|F]$/
        if try regex.wholeMatch(in: inputGrade)?.isEmpty == false{
            return true
        }
        return false
    }
}
