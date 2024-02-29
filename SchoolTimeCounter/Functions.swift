import Foundation

func updateCountdowns(nextMinuteSecondsLeft: inout Int, nextHourMinutesLeft: inout Int, nextFridayDaysLeft: inout Int) {
    var calendar = Calendar(identifier: .gregorian)
    calendar.firstWeekday = 2
    
    let components = calendar.dateComponents([.second, .minute, .weekday], from: Date())
        
    if let currentSecond = components.second {
        nextMinuteSecondsLeft = 60 - currentSecond
    }

    if let currentMinute = components.minute {
        nextHourMinutesLeft = 60 - currentMinute
    }

    if let currentWeekday = components.weekday {
        nextFridayDaysLeft = 6 - currentWeekday
    }
}

func calculateProgressForNextMinute(nextMinuteSecondsLeft: Int) -> Double {
    return Double(60 - nextMinuteSecondsLeft) / 60.0
}

func calculateProgressForNextHour(nextHourMinutesLeft: Int) -> Double {
    return Double(60 - nextHourMinutesLeft) / 60.0
}

func calculateProgressForNextFriday(nextFridayDaysLeft: Int) -> Double {
    return Double(5 - nextFridayDaysLeft) / 5.0
}
