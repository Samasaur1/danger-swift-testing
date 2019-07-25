import Danger
import Foundation
let danger = Danger()
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
if editedFiles.contains("CHANGELOG") {
    let lineNumber = danger.utils.lines(for: "## ", inFile: "CHANGELOG")[1]
    let line = danger.utils.readFile("CHANGELOG").split(separator: "\n")[lineNumber - 1]
    let dateString = String(line.drop { $0 != "]" }.dropFirst(4))
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    let date = df.date(from: dateString) ?? Date.distantPast
    var c = Calendar.init(identifier: .gregorian)
    c.timeZone = TimeZone(abbreviation: "GMT-4") ?? c.timeZone

    let changelogDate = c.date(from: c.dateComponents([.year, .month, .day], from: date))!
    let actualDate = c.date(from: c.dateComponents([.year, .month, .day], from: Date()))!

    if actualDate != changelogDate {
        fail("The latest date in the CHANGELOG is not today!")
        fail(message: "The latest date in the CHANGELOG is not today!", file: "CHANGELOG", line: lineNumber)
    } else {
        message("The latest date in the CHANGELOG is today, \(changelogDate.description)")
    }
} else {
    if FileManager.default.fileExists(atPath: "CHANGELOG") {
        fail("The CHANGELOG was not updated")
    } else {
        warn("There is no CHANGELOG!")
    }
}
message("These files have changed: \(editedFiles)")

//danger.github.pullRequest.title
