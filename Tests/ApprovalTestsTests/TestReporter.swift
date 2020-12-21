import Foundation
//#if os(OSX)
//@testable import ApprovalTests_Swift
//#elseif os(iOS)
//@testable import ApprovalTests_iOS
//#endif
@testable import ApprovalTests

class TestReporter: ApprovalFailureReporter {
    func report(received: String, approved: String) {
        self.received = received
        self.approved = approved
    }
    
    public var received: String = ""
    public var approved: String = ""
}
