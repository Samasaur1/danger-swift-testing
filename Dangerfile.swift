import Danger
import Foundation
let danger = Danger()
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles

if danger.github.pullRequest.base.ref == "master" {
    let newVersion: String
    if let range = danger.github.pullRequest.title.range(of: #"(?<=Version )\d+\.\d+\.\d+(?=: .+)"#, options: .regularExpression) {
        newVersion = String(danger.github.pullRequest.title[range])
        message("The new version is v\(newVersion)")
    } else {
        fail("There is no version in the pull request title!")
        newVersion = "0.0.0"
    }

    if danger.github.pullRequest.title.contains("$DESCRIPTION") {
        fail("$DESCRIPTION placeholder has not been filled in!")
    }

    containsChangelog: if editedFiles.contains("CHANGELOG") {
        let lineNumber = danger.utils.lines(for: "## ", inFile: "CHANGELOG")[1]
        let line = danger.utils.readFile("CHANGELOG").split(separator: "\n").filter { $0.hasPrefix("## ") }[1]
        let dateString = String(line.drop { $0 != "]" }.dropFirst(4))
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let todaysDate = df.string(from: Date())
        guard df.date(from: dateString) != nil else {
            fail("Illegal date string in CHANGELOG!: '\(dateString)'")
            fail(message: "Illegal date string in CHANGELOG!", file: "CHANGELOG", line: lineNumber)
            suggestion(code: "## [\(newVersion)] - \(todaysDate)", file: "CHANGELOG", line: lineNumber)
            break containsChangelog
        }
        if todaysDate != dateString {
            fail("The latest date in the CHANGELOG is not today!")
            fail(message: "The latest date in the CHANGELOG is not today!", file: "CHANGELOG", line: lineNumber)
            suggestion(code: "## [\(newVersion)] - \(todaysDate)", file: "CHANGELOG", line: lineNumber)
        } else {
            message("The latest date in the CHANGELOG is today, \(dateString)")
        }
    } else {
        if FileManager.default.fileExists(atPath: "CHANGELOG") {
            fail("The CHANGELOG was not updated")
        } else {
            warn("There is no CHANGELOG!")
        }
    }
} else {
    if editedFiles.contains("CHANGELOG") {
        message("The CHANGELOG was updated!")
    } else {
        if FileManager.default.fileExists(atPath: "CHANGELOG") {
            fail("The CHANGELOG was not updated")
        } else {
            warn("There is no CHANGELOG!")
        }
    }
}

for file in editedFiles where file.hasPrefix("Sources/") {
    let testsFile = "Tests/\(file.dropFirst("Sources/".count).dropLast(".swift".count))Tests.swift"
    if editedFiles.contains(testsFile) {
        message("\(file) has had corresponding changes in its test file")
    } else {
        if FileManager.default.fileExists(atPath: testsFile) {
            fail("\(file) was changed, but \(testsFile) wasn't!")
        } else {
            warn("\(file) was changed, but there is no file at path \(testsFile). Maybe it's under a different path, or maybe there's no tests")
        }
    }
}
