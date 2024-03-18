import SwiftUI

@main
struct SchoolTimeCounterApp: App {
    
    var body: some Scene {
        MenuBarExtra("SchoolTimeCounter", systemImage: "clock.fill") {
            AppMenu()
        }.menuBarExtraStyle(.window)
    }
}

struct AppMenu: View {
    @State private var nextMinuteSecondsLeft: Int = 0
    @State private var nextHourMinutesLeft: Int = 0
    
    @State private var nextFridayDaysLeft: Int = 0
    
    @State private var lessonEndHoursLeft: Int = 0
    @State private var lessonEndMinutesLeft: Int = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            VStack {
                HStack {
                    BoldText("⏳ Next minute")
                    Spacer()
                    BoldText("\(nextMinuteSecondsLeft) seconds")
                }
                VStack {
                    ProgressView(value: calculateProgressForNextMinute())
                }
            }.padding(.bottom)
            
            VStack {
                HStack {
                    BoldText("🕑 Next hour")
                    Spacer()
                    BoldText("\(nextHourMinutesLeft) minutes")
                }
                VStack {
                    ProgressView(value: calculateProgressForNextHour())
                }
            }
            
            PaddingDivider()
            
            VStack {
                HStack {
                    BoldText("🏠 Next Friday")
                    Spacer()
                    BoldText("\(nextFridayDaysLeft) days")
                }
                VStack {
                    ProgressView(value: calculateProgressForNextFriday())
                }
            }
            
            PaddingDivider()
            
            VStack {
                HStack {
                    BoldText("🏫 Lesson End")
                    Spacer()
                    BoldText("\(lessonEndHoursLeft)h \(lessonEndMinutesLeft)m")
                }
                VStack {
                    ProgressView(value: calculateProgressForLessonEnd())
                }
            }
        }
        .padding()
        .onReceive(timer) { _ in
            updateCountdowns()
        }
        .onAppear {
            updateCountdowns()
        }
    }
    
    func updateCountdowns() {
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

    func calculateProgressForNextMinute() -> Double {
        return Double(60 - nextMinuteSecondsLeft) / 60.0
    }

    func calculateProgressForNextHour() -> Double {
        return Double(60 - nextHourMinutesLeft) / 60.0
    }

    func calculateProgressForNextFriday() -> Double {
        return Double(5 - nextFridayDaysLeft) / 5.0
    }
    
    func calculateProgressForLessonEnd() -> Double {
        let now = Date()
        let lessonTimes = [
            (startHour: 8, startMinute: 0, endHour: 9, endMinute: 30),
            (startHour: 9, startMinute: 45, endHour: 11, endMinute: 15),
            (startHour: 11, startMinute: 35, endHour: 13, endMinute: 5),
            (startHour: 13, startMinute: 30, endHour: 15, endMinute: 0),
            (startHour: 15, startMinute: 15, endHour: 16, endMinute: 45)
        ]
        
        guard let currentLessonTime = lessonTimes.first(where: { lessonTime in
            let lessonStartTime = Calendar.current.date(bySettingHour: lessonTime.startHour, minute: lessonTime.startMinute, second: 0, of: now)!
            let lessonEndTime = Calendar.current.date(bySettingHour: lessonTime.endHour, minute: lessonTime.endMinute, second: 0, of: now)!
            return now >= lessonStartTime && now < lessonEndTime
        }) else {
            return 0.0
        }
        
        let totalLessonTime = (currentLessonTime.endHour - currentLessonTime.startHour) * 60
        let timeDifference = Calendar.current.dateComponents([.minute], from: now, to: Calendar.current.date(bySettingHour: currentLessonTime.endHour, minute: 0, second: 0, of: now)!)
        let remainingTime = timeDifference.minute ?? 0
        
        return 1.0 - Double(remainingTime) / Double(totalLessonTime)
    }
}

/*
 *
 * 08:00 - 09:30
 *
 * 09:45 - 11:15
 *
 * 11:35 - 13:05
 *
 * 13:30 - 15:00
 *
 * 15:15 - 16:45
 *
 */
