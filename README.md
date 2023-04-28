# MyCreditManager
#원티드 프리온보딩 챌린지 iOS과정 사전과제


- 기능<br>
학생성적관리 프로그램입니다.<br>

- 딕셔너리 구조<br>
  <img width="495" alt="image" src="https://user-images.githubusercontent.com/94464179/234638807-18b4c99d-f33f-4c3c-9039-057a5ba59b89.png">

- 고민한 부분
  - 오류 처리
    - 기존 코드
      - switch-case문으로 분기처리하는 메소드를 만들어 사용
    - 수정 코드
      - 오류 상황을 구분하는 Error Type의 enum 추가
        ~~~ Swift
          enum InputError: Error{
            case wrongStartValue
            ...
          }
        ~~~
      - Main클래스의 시작 메소드에서 do-catch 문 사용
        ~~~ Swift
          do{
              ...
              try commandOperate(inputData)

          }catch InputError.wrongStartValue{
              print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
          }
          ...
        ~~~
      - 로직 메소드에 throw 키워드를 사용하여 내부 오류를 던짐
        ~~~ Swift
          private func commandOperate(_ command: String) throws {
              if let task = Task(rawValue: command){
                  ...
              }
              else{
                  throw InputError.wrongStartValue
              }
          }
        ~~~
    
