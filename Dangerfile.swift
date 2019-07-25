import Danger
import Foundation
let danger = Danger()
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
if editedFiles.contains("CHANGELOG") {
    message("CHANGELOG exists")
    let file = danger.utils.readFile("CHANGELOG")
    let sub = file.split(separator: "\n").drop { !$0.hasPrefix("## Upcoming") }.dropFirst().drop { !$0.hasPrefix("## ") }[0].drop { $0 != "]" }.dropFirst(4)
    let str = String(sub)
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    let date = df.date(from: str) ?? Date.distantPast
    var c = Calendar.init(identifier: .gregorian)
    c.timeZone = TimeZone(abbreviation: "GMT-4") ?? c.timeZone

    let changelogDate = c.date(from: c.dateComponents([.year, .month, .day], from: date))!
    let actualDate = c.date(from: c.dateComponents([.year, .month, .day], from: Date()))!

    if actualDate != changelogDate {
        fail("The latest date in the CHANGELOG is not today!")
        //convert to fail(message:file:line:)
    } else {
        message("The latest date in the CHANGELOG is today, \(changelogDate.description)")
    }
} else {
    warn("There is no CHANGELOG!")
}
message("These files have changed: \(editedFiles)")
