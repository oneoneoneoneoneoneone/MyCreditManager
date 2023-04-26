//
//  main.swift
//  MyCreditManager
//
//  Created by hana on 2023/04/26.
//

import Foundation

Main().startCreditManager()

struct Student{
    let name: String
}
struct StudentGrade{
    let student: Student
    let subject: String
    var grade: Grade
}

class Main{
    var students: [Student] = []
    var studentGrades: [StudentGrade] = []
    
    func startCreditManager(){
        while true{
            do{
                try commandOperate()
            }catch inputError.wrongStartValue{
                print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
            }catch inputError.wrongValue{
                print("입력이 잘못되었습니다. 다시 확인해주세요.")
            }catch inputError.duplicationStudent(student: let student){
                print("\(student) 학생은 이미 존재하는 학생입니다. 추가하지 않습니다.")
            }catch inputError.nonexistentStudent(student: let student){
                print("\(student) 학생을 찾지 못했습니다.")
            }catch inputError.Exit{
                print("프로그램을 종료합니다...")
                return
            }catch{
                print("문재내요..")
            }
        }
    }
    
    func commandOperate() throws {
        print("원하는 기능을 입력해주세요")
        print("1: 학생추가, 2. 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
        
        let inputData = readLine()!
        
        if let task = Task(rawValue: inputData){
            switch task{
            case .studentAdd: try addStudent()
            case .studentRemove: try removeStudent()
            case .gradeAdd: try addGrade()
            case .gradeRemove: try removeGrade()
            case .getAverage: try getAverage()
            case .exit:
                throw inputError.Exit
            }
        }
        else{
            throw inputError.wrongStartValue
        }
    }
    
    func addStudent() throws{
        print("추가할 학생의 이름을 입력해주세요")
        guard let inputData = readLine(), !inputData.contains(" ") else{
            throw inputError.wrongValue
        }
        
        if students.first(where: {$0.name == inputData}) != nil {
            throw inputError.duplicationStudent(student: inputData)
        }
        
        students.append(Student(name: inputData))
        print("\(inputData) 학생을 추가했습니다.")
        return
    }
    
    func removeStudent() throws{
        print("삭제할 학생의 이름을 입력해주세요")
        guard let inputData = readLine(), !inputData.contains(" ") else{
            throw inputError.wrongValue
        }
        
        if students.first(where: {$0.name == inputData}) == nil {
            throw inputError.nonexistentStudent(student: inputData)
        }
        
        students.removeAll(where: {$0.name == inputData})
            print("\(inputData) 학생을 삭제했습니다.")
            return
    }

    func addGrade() throws{
        print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Micky Swift A+\n만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
        guard let inputData = readLine() else{
            throw inputError.wrongValue
        }
        //쪼개기
        let studentData = inputData.components(separatedBy: " ")
        if studentData.count != 3{
            throw inputError.wrongValue
        }
        //성적값 검증
        guard let grade = Grade(rawValue:studentData[2]) else {
            throw inputError.wrongValue
        }
        
        guard let student = students.first(where: {$0.name == studentData[0]}) else {
            throw inputError.nonexistentStudent(student: inputData)
        }
        
        if studentGrades.first(where: {$0.student.name == student.name && $0.subject == studentData[1]}) != nil{
            studentGrades.removeAll(where: {$0.student.name == student.name && $0.subject == studentData[1]})
        }
        studentGrades.append(StudentGrade(student: student, subject: studentData[1], grade: grade))
        print("\(studentData[0]) 학생의 \(studentData[1]) 과목이 \(grade.rawValue)로 추가(변경)되었습니다.")
        return
    }

    func removeGrade() throws{
        print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift")
        guard let inputData = readLine() else{
            throw inputError.wrongValue
        }
        //쪼개기
        let studentData = inputData.components(separatedBy: " ")
        if studentData.count != 2{
            throw inputError.wrongValue
        }
        
        guard let student = students.first(where: {$0.name == studentData[0]}) else {
            throw inputError.nonexistentStudent(student: inputData)
        }
        
//        if studentGrades.first(where: {$0.student.name == student.name && $0.subject == studentData[1]}) == nil{
        studentGrades.removeAll(where: {$0.student.name == student.name && $0.subject == studentData[1]})
        print("\(studentData[0]) 학생의 \(studentData[1]) 과목의 성적이 삭제되었습니다.")
        return
    }

    func getAverage() throws{
        print("평점을 알고싶은 학생의 이름을 입력해주세요")
        guard let inputData = readLine() else{
            throw inputError.wrongValue
        }
        guard let student = students.first(where: {$0.name == inputData}) else {
            throw inputError.nonexistentStudent(student: inputData)
        }
        
        let studentGrades = studentGrades.filter({$0.student.name == student.name})
        studentGrades.forEach{sg in
            print("\(sg.subject) : \(sg.grade)")
        }
        print("평점 : \("")")
    }
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

enum inputError: Error{
    case wrongStartValue
    case wrongValue
    case duplicationStudent(student: String)
    case nonexistentStudent(student: String)
    case Exit
}
