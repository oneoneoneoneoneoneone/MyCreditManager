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
        
        //학생 찾기
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
        
        //학생 찾기
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
        guard inputGrade.components(separatedBy: " ").count == 3 else{
            throw InputError.wrongValue
        }
        let studentGrade = inputGrade.components(separatedBy: " ")
        
        //성적값 검증. Regex literal
        let regex = /^[A-D][+]$|^[A-F]$/
        guard let grade = try regex.firstMatch(in: studentGrade[2])?.output else {
            throw InputError.wrongValue
        }
        //학생 찾기
        guard let student = students.first(where: {$0.name == studentGrade[0]}) else {
            throw InputError.nonexistentStudent(name: studentGrade[0])
        }
        
        if studentGrades.first(where: {$0.student.name == student.name && $0.subject == studentGrade[1]}) != nil{
            studentGrades.removeAll(where: {$0.student.name == student.name && $0.subject == studentGrade[1]})
        }
        
        studentGrades.append(StudentGrade(student: student, subject: studentGrade[1], grade: String(grade)))
        print("\(studentGrade[0]) 학생의 \(studentGrade[1]) 과목이 \(grade)로 추가(변경)되었습니다.")
    }

    func removeGrade(_ inputGrade: String?) throws{
        guard let inputGrade = inputGrade,
              inputGrade != "" else {
            throw InputError.wrongValue
        }
        guard inputGrade.components(separatedBy: " ").count == 2 else{
            throw InputError.wrongValue
        }
        let studentGrade = inputGrade.components(separatedBy: " ")

        //학생 찾기
        guard let student = students.first(where: {$0.name == studentGrade[0]}) else {
            throw InputError.nonexistentStudent(name: studentGrade[0])
        }
        
        studentGrades.removeAll(where: {$0.student.name == student.name && $0.subject == studentGrade[1]})
        print("\(studentGrade[0]) 학생의 \(studentGrade[1]) 과목의 성적이 삭제되었습니다.")
    }

    func getAverage(_ inputName: String?) throws{
        guard let studentName = inputName,
              studentName != "", studentName.contains(" ") == false else {
            throw InputError.wrongValue
        }
        
        //학생 찾기
        guard let student = students.first(where: {$0.name == studentName}) else {
            throw InputError.nonexistentStudent(name: studentName)
        }
        //성적 찾기
        let studentGrades = studentGrades.filter({$0.student.name == student.name})
        
        let totalScore = studentGrades.map{getNuberScore($0.grade)}
            .reduce(0){$0 + $1}
        
        studentGrades.forEach{print("\($0.subject) : \($0.grade)")}
        print(String(format: "평점 : %.2f", totalScore/Double(studentGrades.count)))
    }
    
    private func getNuberScore(_ grade: String) -> Double{
        var score = 0.0
        switch grade.first{
        case "A": score += 4
        case "B": score += 3
        case "C": score += 2
        case "D": score += 1
        default:
            break
        }
        if grade.last == "+"{
            score += 0.5
        }
        
        return score
    }
}
