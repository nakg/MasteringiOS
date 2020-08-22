//: [Previous](@previous)

import Foundation

let now = Date()
let yesterday = now.addingTimeInterval(3600 * -24)
let tomorrow = now.addingTimeInterval(3600 * 24)

let formatter = DateFormatter()
formatter.locale = Locale(identifier: "ko_KR")
formatter.dateStyle = .full
formatter.timeStyle = .none

formatter.doesRelativeDateFormatting = true // 48시간 내의 날짜를 오늘 어제 그저께 모래 내일 이렇게 출력하게 한다.

print(formatter.string(from: now))
print(formatter.string(from: yesterday))
print(formatter.string(from: tomorrow))

//: [Next](@next)
