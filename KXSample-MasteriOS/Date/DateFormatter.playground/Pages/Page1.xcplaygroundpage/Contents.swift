import UIKit

let now = Date()
//print(now)

let formatter = DateFormatter()

formatter.dateStyle = .full
formatter.timeStyle = .medium

formatter.locale = Locale(identifier: "ko_KR")

var result = formatter.string(from: now)

print(result)

formatter.string(for: now)

DateFormatter.localizedString(from: now, dateStyle: .long, timeStyle: .short)
//: [Next](@next)
