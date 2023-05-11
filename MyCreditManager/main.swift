//
//  main.swift
//  MyCreditManager
//
//  Created by hana on 2023/04/26.
//

import Foundation

Main().startMyCreditManager()

class Main{
    private var studentGradeManager: StudentGradeManagerProtocol?
    
    init(studentGradeManager: StudentGradeManagerProtocol? = StudentGradeManager()) {
        self.studentGradeManager = studentGradeManager
    }
    
    func startMyCreditManager(){
        while true{
            do{
                printTaskHelp()
                let inputData = readLine()!
                
                if try orderTask(inputData) == false {
                    return
                }
            }catch{
                print(error)
            }
        }
    }
    
    private func orderTask(_ inputCommand: String) throws -> Bool{
        guard let task = Task(rawValue: inputCommand) else {
            throw InputError.wrongStartValue
        }
        print(task.description)
        if task == .exit{
            return false
        }
        
        let inputData = readLine()
        
        switch task{
        case .studentAdd:
            try studentGradeManager?.addStudent(inputData)
        case .studentRemove:
            try studentGradeManager?.removeStudent(inputData)
        case .gradeAdd:
            try studentGradeManager?.addGrade(inputData)
        case .gradeRemove:
            try studentGradeManager?.removeGrade(inputData)
        case .getAverage:
            try studentGradeManager?.getAverage(inputData)
        case .exit:
            return false
        }
        return true
    }
    
    func printTaskHelp(){
        print("원하는 기능을 입력해주세요")
        print(Task.allCases.map{"\($0.rawValue): \($0.title)"}.joined(separator: ", "))
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
