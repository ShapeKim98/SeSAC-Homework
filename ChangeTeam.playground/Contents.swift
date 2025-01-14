import UIKit

/*
 [팀별 좌석 배치도]
 잭님  TV  빔프로젝터
  5    3      1
       4      2
 */

func 돌려돌려돌림판() {
    // 기존 팀별 좌석 배치
    var 팀좌석 = [1, 2, 3, 4, 5]
    for i in 0..<5 {
        print("\(i + 1)팀의 좌석은 \(팀좌석[i]) 입니다.")
    }
    
    /*
     기존의 팀이 동일한 자리에 앉지 않도록 랜덤하게 팀좌석을 바꿔주세요
     하단 출력 형태에 맞게 동작하도록, 코드를 이곳에 작성해주세요.
     */
    let rollerCount = 70
    let sleepStream = AsyncStream<Int> { continuation in
        Task {
            for i in 1..<(rollerCount + 1) {
                try? await Task.sleep(nanoseconds: UInt64(100000 * i * i))
                continuation.yield(i)
            }
            continuation.finish()
        }
    }
    
    Task {
        for await count in sleepStream {
            while (isNotValid(팀좌석: &팀좌석)) { }
            
            print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
            print("---------------------------------------")
            for i in 0..<5 {
                print("\(i + 1)팀의 좌석은 \(팀좌석[i]) 입니다.")
            }
            print("---------------------------------------")
            if count == 70 {
                print("좌석 돌리기 완료!")
            } else {
                print("좌석 돌리는 중...")
            }
        }
    }
}

func isNotValid(팀좌석: inout [Int]) -> Bool {
    팀좌석.shuffle()
    for (index, 팀) in 팀좌석.enumerated() {
        guard index != (팀 - 1) else { return true }
    }
    return false
}

돌려돌려돌림판()
/*
 출력결과 예시
 1팀의 좌석은 1 입니다.
 2팀의 좌석은 2 입니다.
 3팀의 좌석은 3 입니다.
 4팀의 좌석은 4 입니다.
 5팀의 좌석은 5 입니다.
 ---------------------------------------
 1팀의 좌석은 5 입니다.
 2팀의 좌석은 3 입니다.
 3팀의 좌석은 1 입니다.
 4팀의 좌석은 2 입니다.
 5팀의 좌석은 4 입니다.
 */
