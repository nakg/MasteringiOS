//: [Previous](@previous)


import UIKit

let now = Date()
let formatter = DateFormatter()


formatter.locale = Locale(identifier: "en_US")
formatter.setLocalizedDateFormatFromTemplate("yyyyMMMMdE") // locale 변환 하면, 포맷도 다시 설정해주어야 적용이 된다.

var result = formatter.string(from: now)

print(result)
print(formatter.dateFormat)


formatter.locale = Locale(identifier: "ko_KR")
formatter.setLocalizedDateFormatFromTemplate("yyyyMMMMdE")

result = formatter.string(from: now)
print(result)
print(formatter.dateFormat)




formatter.dateFormat = "yyyyMMMMde"
result = formatter.string(from: now)
print(result)
//: [Next](@next)
