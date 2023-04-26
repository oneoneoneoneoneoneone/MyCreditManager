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
                print("원하는 기능을 입력해주세요")
                print("1: 학생추가, 2. 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
                let inputData = readLine()!
                
                try commandOperate(inputData)
                
            }catch InputError.wrongStartValue{
                print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
            }
            catch InputError.wrongValue{
                print("입력이 잘못되었습니다. 다시 확인해주세요.")
            }
            catch InputError.duplicationStudent(student: let student){
                print("\(student) 학생은 이미 존재하는 학생입니다. 추가하지 않습니다.")
            }
            catch InputError.nonexistentStudent(student: let student){
                print("\(student) 학생을 찾지 못했습니다.")
            }
            catch InputError.Exit{
                print("프로그램을 종료합니다...")
                return
            }
            catch{
                print("알 수 없는 에러로 프로그램을 종료합니다...")
                return
            }
        }
    }
    
    private func commandOperate(_ command: String) throws {
        if let task = Task(rawValue: command){
            switch task{
            case .studentAdd:
                print("추가할 학생의 이름을 입력해주세요")
                let inputData = readLine()!
                
                try studentGradeManager?.addStudent(inputData)
                
            case .studentRemove:
                print("삭제할 학생의 이름을 입력해주세요")
                let inputData = readLine()!
                
                try studentGradeManager?.removeStudent(inputData)
                
            case .gradeAdd:
                print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Micky Swift A+\n만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
                let inputData = readLine()!
                
                try studentGradeManager?.addGrade(inputData)
                
            case .gradeRemove:
                print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift")
                let inputData = readLine()!
                
                try studentGradeManager?.removeGrade(inputData)
            case .getAverage:
                print("평점을 알고싶은 학생의 이름을 입력해주세요")
                let inputData = readLine()!
                
                try studentGradeManager?.getAverage(inputData)
            case .exit:
                throw InputError.Exit
            }
        }
        else{
            throw InputError.wrongStartValue
        }
    }
}
