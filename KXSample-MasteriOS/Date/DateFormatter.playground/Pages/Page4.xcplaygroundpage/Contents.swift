//: [Previous](@previous)
import Foundation

let now = Date()
let weekdaySymbols = ["☀️", "🌕", "🔥", "💧", "🌲", "🥇", "🌏"]
let am = "🌅"
let pm = "🌇"

let formatter = DateFormatter()
formatter.dateStyle = .full
formatter.timeStyle = .full

print(formatter.string(from: now))

formatter.amSymbol = am
formatter.pmSymbol = pm

formatter.weekdaySymbols = weekdaySymbols

print(formatter.string(from: now))


//: [Next](@next)
