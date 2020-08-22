//: [Previous](@previous)

import Foundation

let startDate = Date()
let endDate = startDate.addingTimeInterval(3600 * 24 * 30)

let formatter = DateComponentsFormatter()

formatter.unitsStyle = .full

if let result = formatter.string(from: startDate, to: endDate) {
	print(result)
}

var comps = DateComponents()
comps.day = 0
comps.hour = 1
comps.minute = 30
comps.second = 7

formatter.unitsStyle = .positional

formatter.zeroFormattingBehavior = .dropAll

//formatter.allowedUnits = [.minute]

//formatter.maximumUnitCount = 1

//formatter.includesTimeRemainingPhrase = true
//formatter.includesApproximationPhrase = true



if let result = formatter.string(from: comps) {
	print(result)
}
//: [Next](@next)
