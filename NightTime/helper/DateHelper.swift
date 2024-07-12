//
//  DateHelper.swift
//  Todo App
//
//  Created by Florian Bauer on 03.01.24.
//

import SwiftUI

func getDateString(date: Date) -> String {
    let formatterDate = DateFormatter()
    formatterDate.timeStyle = .none
    formatterDate.dateStyle = .full

    return formatterDate.string(from: date)
}

func getTimeString(date: Date) -> String {
    let formatterDate = DateFormatter()
    formatterDate.timeStyle = .full
    formatterDate.dateStyle = .none

    return formatterDate.string(from: date)
}

func hourString(start: Date, end: Date) -> String {
    let diffs = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)

    return "\(Int(diffs.hour ?? 0)):\(Int(diffs.minute ?? 0))hrs"
}

func timeString(start: Date, end: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"

    let start = formatter.string(from: start)
    let end = formatter.string(from: end)

    return "\(start) - \(end)"
}

func calculateHoursPerDay(day: Date, tasks: [Task]?) -> String {
    if tasks == nil {
        return "0:0hrs"
    }
    let dateString = getDateString(date: day)

    let tasksPerDay = tasks!.filter { task in
        task.endDate == dateString
    }

    let minutes = tasksPerDay.reduce(0) { result, task in
        result + calculateTotalMinutesOfTask(start: task.getStartAsDate(), end: task.getEndAsDate())
    }

    let minutesLeft = minutes % 60
    let hours = (minutes - minutesLeft) / 60

    return "\(hours):\(minutesLeft)hrs"
}

// function that calcualtes hours
func calculateHoursOfTask(start: Date, end: Date) -> String {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: start, to: end)

    let hours = components.hour ?? 0
    let minutes = components.minute ?? 0

    return "\(hours)h \(minutes)m"
}

func calculateTotalMinutesOfTask(start: Date, end: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: start, to: end)

    let hours = components.hour ?? 0
    let minutes = components.minute ?? 0

    return hours * 60 + minutes
}

func getStartDate(tasks: [Task], date: Date) -> Date {
    // Step 1
    // check if there is already a Task created for requested day
    let requestedDate = date
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .full

    let requestedDateString = formatter.string(from: requestedDate)

    let task = tasks.last(where: { $0.endDate == requestedDateString })

    // we have an enddate of the requested day, return the endtime as start date
    if let task = task {
        return task.getEndAsDate()
    }

    // Step 2
    // Check if it is today
    let today = Date.now
    let todaysFormatter = DateFormatter()
    todaysFormatter.timeStyle = .none
    todaysFormatter.dateStyle = .full

    let todayString = formatter.string(from: today)

    if requestedDateString == todayString {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: today)
        let midnight = calendar.startOfDay(for: today)

        if hour < 9 {
            return midnight
        } else if hour < 13 {
            // return 09:00
            return midnight.addingTimeInterval(9 * 60 * 60)
        } else {
            // return 13:00
            return midnight.addingTimeInterval(13 * 60 * 60)
        }
    }

    // Step 3
    // It is another day without entry, so we return the full day
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: requestedDate)
    let midnight = calendar.startOfDay(for: requestedDate)

    // return 09:00
    return midnight.addingTimeInterval(9 * 60 * 60)
}

// end date is now
func getEndDate(date: Date) -> Date {
    return date
}

extension Date {
    func dayOfWeek(withFormatter dateFormatter: DateFormatter) -> String? {
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }

    func nameOfMonth(withFormatter dateFormatter: DateFormatter) -> String? {
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: self).capitalized
    }
}

struct Day: Identifiable {
    var id = UUID()
    var weekday: String
    var day: String
    var month: String
    var date: Date
}

class DateState: ObservableObject {
    @Published var allDays: [Day] = []

    func generateDays(number: Int) {
        let today = Date()
        let formatter = DateFormatter()
        self.allDays = (0 ..< number).map { index -> Day in
            let date = Calendar.current.date(byAdding: .day, value: index * -1, to: today) ?? Date()
            return Day(
                weekday: date.dayOfWeek(withFormatter: formatter) ?? "",
                day: "\(Calendar.current.component(.day, from: date))",
                month: date.nameOfMonth(withFormatter: formatter) ?? "",
                date: date
            )
        }
    }
}
