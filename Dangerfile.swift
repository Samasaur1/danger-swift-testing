import Danger
import Foundation
let danger = Danger()
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
if editedFiles.contains("CHANGELOG") {
    message("CHANGELOG exists")
    print(7)
    let file = danger.utils.readFile("CHANGELOG")
    print(9)
    print()
    print(file)
    print()
    var lines = file.split(separator: "\n")
    print(14)
    print()
    print(lines)
    print()
    lines.removeAll { !$0.hasPrefix("## ") }
    print(19)
    print()
    print(lines)
    print()
    lines.removeFirst()
    print(24)
    print()
    print(lines)
    print()
    var line = lines.first!
    print(29)
    print()
    print(line)
    print()
    line = line.drop { $0 != "]" }
    print(34)
    print()
    print(line)
    print()
    line = line.dropFirst(4)
    print(39)
    print()
    print(line)
    print()
    let str = String(line)
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

//danger.github.pullRequest.title
