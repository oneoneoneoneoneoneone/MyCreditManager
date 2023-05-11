//
//  MyCreditManager.swift
//  MyCreditManager
//
//  Created by hana on 2023/04/27.
//

import Foundation

class MyCreditManager: MyCreditManagerType{
    private var students: [Student]
    
    init(students: [Student] = []){
        self.students = students
    }
    
    final let gradeStandard = ["A+":4.5, "A":4.0, "B+":3.5, "B":3.0, "C+":2.5, "C":2.0, "D+":1.5, "D":1.0, "F":0.0]
    
    func start(){
        while true{
            do{
                printTaskHelp()
                let inputData = readLine()!
                
                try orderTask(inputData)
            }
            catch{
                print(error)
            }
        }
    }
    
    private func printTaskHelp(){
        print("원하는 기능을 입력해주세요")
        print(Task.allCases.map{"\($0.rawValue): \($0.title)"}.joined(separator: ", "))
    }
    
    private func orderTask(_ inputCommand: String) throws{
        guard let task = Task(rawValue: inputCommand) else {
            throw InputError.wrongStartValue
        }
        print(task.description)
        if task == .exit{
            endProgram()
        }
        
        let inputData = readLine()
        
        switch task{
        case .studentAdd:
            try addStudent(inputData)
        case .studentRemove:
            try removeStudent(inputData)
        case .gradeAdd:
            try addGrade(inputData)
        case .gradeRemove:
            try removeGrade(inputData)
        case .getAverage:
            try getAverage(inputData)
        case .exit:
            endProgram()
        }
    }
    
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
        guard gradeStandard.keys.contains(studentGrade[2]) else {
            throw InputError.wrongValue
        }
        guard var student = students.first(where: {$0.name == studentGrade[0]}) else {
            throw InputError.nonexistentStudent(name: studentGrade[0])
        }
        
        if student.grades.first(where: {$0.subject == studentGrade[1]}) != nil{
            student.grades.removeAll(where: {$0.subject == studentGrade[1]})
        }
        student.grades.append(Student.Grade(subject: studentGrade[1], grade: studentGrade[2]))
        
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
        guard var student = students.first(where: {$0.name == studentGrade[0]}) else {
            throw InputError.nonexistentStudent(name: studentGrade[0])
        }
        
        student.grades.removeAll(where: {$0.subject == studentGrade[1]})
        
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
        
        let averageScore = student.grades.map{gradeStandard[$0.grade] ?? 0.0}
            .reduce(0){$0 + $1} / Double(student.grades.count)
        
        student.grades.forEach{print("\($0.subject) : \($0.grade)")}
        print(String(format: "평점 : %.2f", averageScore))
    }
    
    func endProgram(){
        exit(0)
    }
}


//MARK: Enum Task

enum Task: String, CaseIterable{
    case studentAdd = "1"
    case studentRemove = "2"
    case gradeAdd = "3"
    case gradeRemove = "4"
    case getAverage = "5"
    case exit = "X"
    
    var title: String{
        switch self{
        case .studentAdd:
            return "학생추가"
        case .studentRemove:
            return "학생삭제"
        case .gradeAdd:
            return "성적추가(변경)"
        case .gradeRemove:
            return "성적삭제"
        case .getAverage:
            return "평점보기"
        case .exit:
            return "종료"
        }
    }
    
    var description: String {
        switch self{
        case .studentAdd:
            return "추가할 학생의 이름을 입력해주세요"
        case .studentRemove:
            return "삭제할 학생의 이름을 입력해주세요"
        case .gradeAdd:
            return "성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Micky Swift A+\n만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다."
        case .gradeRemove:
            return "성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift"
        case .getAverage:
            return "평점을 알고싶은 학생의 이름을 입력해주세요"
        case .exit:
            return "프로그램을 종료합니다..."
        }
    }
}
