//
//  File.swift
//  
//
//  Created by Guillermo Fernandez on 21/12/2020.
//

import Foundation

#if os(macOS)

class DiffMergReporter: ApprovalFailureReporter {

    func report(received: String, approved: String) {
        var workingReceived = received
        var workingApproved = approved

        let newApproved = workingApproved.replacingOccurrences(of: ":::", with: "")
        workingApproved = newApproved

        let newReceived = workingReceived.replacingOccurrences(of: ":::", with: "")
        workingReceived = newReceived

        let newApproved2 = workingApproved.replacingOccurrences(of: " ", with: "\\ ")
        workingApproved = newApproved2

        let newReceived2 = workingReceived.replacingOccurrences(of: " ", with: "\\ ")
        workingReceived = newReceived2

        let process = Process()
        process.executableURL = URL(fileURLWithPath:"/usr/local/bin/diffmerge")
        process.arguments = [workingReceived, workingApproved, "--nosplash"]
        process.terminationHandler = { (process) in
            print("\ndidFinish: \(!process.isRunning)")
        }
        do {
            try process.run()
        } catch {}
    }
}

#elseif canImport(UIKit)
import XCTest

class XCTReporter: ApprovalFailureReporter {
    
    func report(received: String, approved: String) {
        // read the files into strings
        let approvedUrl = URL(fileURLWithPath: approved)
        let receivedUrl = URL(fileURLWithPath: received)
        
        var aText = ""
        var rText = ""
        do {
            aText = try String(contentsOf: approvedUrl)
            rText = try String(contentsOf: receivedUrl)
        } catch { }

        let workingReceived = cleanPathString(received)
        let workingApproved = cleanPathString(approved)
        
        let command: String = String(format: "mv %@ %@", workingReceived, workingApproved )

        // copy to pasteboard
        let pasteboard = UIPasteboard.general
        pasteboard.string = command
        
        // send command to system out
        let approveCommand = "To approve run : " + command
        print(approveCommand);
        XCTAssertEqual(aText, rText)
    }
    
    private func cleanPathString(_ pathString: String) -> String {
        var workingPathString = pathString

        let removedColons = workingPathString.replacingOccurrences(of: ":::", with: "")
        workingPathString = removedColons

        let escapedSpaces = workingPathString.replacingOccurrences(of: " ", with: "\\ ")
        workingPathString = escapedSpaces
        
        return workingPathString
    }
}

#endif
