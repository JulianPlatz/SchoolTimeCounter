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

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            VStack {
                HStack {
                    BoldText("⏳ Next minute")
                    Spacer()
                    BoldText("\(nextMinuteSecondsLeft) seconds left")
                }
                VStack {
                    ProgressView(value: calculateProgressForNextMinute())
                }
            }.padding(.bottom)
            
            VStack {
                HStack {
                    BoldText("🕑 Next hour")
                    Spacer()
                    BoldText("\(nextHourMinutesLeft) minutes left")
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
                    BoldText("\(nextFridayDaysLeft) days left")
                }
                VStack {
                    ProgressView(value: calculateProgressForNextFriday())
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
        
        Link("WebUntis", destination: URL(string: "https://mese.webuntis.com/timetable-students-my")!)
            .foregroundStyle(.gray)
            .padding(.bottom)
            .underline()
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
}
