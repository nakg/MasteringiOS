//: [Previous](@previous)

import Foundation

let str = "2017-09-02"

let formatter = ISO8601DateFormatter()

formatter.formatOptions = [.withFullDate]

if let date = formatter.date(from: str) {
	formatter.formatOptions = .withInternetDateTime
	print(formatter.string(from: date))
}
else {
	print("invalid format")
}

//: [Next](@next)
