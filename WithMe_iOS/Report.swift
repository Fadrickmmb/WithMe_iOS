//
//  Report.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/30/24.
//

import Foundation

struct Report {
    var reportId: String?
    var userId: String?
    var postId: String?
    var commentId: String?
    var postOwnerId: String?
    var commentOwnerId: String?
    var userReportingId: String?

    // report user
    init(reportId: String, userId: String, userReportingId: String) {
        self.reportId = reportId
        self.userId = userId
        self.userReportingId = userReportingId
    }

    // report post
    init(reportId: String, postId: String, postOwnerId: String, userReportingId: String) {
        self.reportId = reportId
        self.postId = postId
        self.postOwnerId = postOwnerId
        self.userReportingId = userReportingId
    }

    // report comment
    init(reportId: String, postId: String, commentId: String, postOwnerId: String, commentOwnerId: String, userReportingId: String) {
        self.reportId = reportId
        self.postId = postId
        self.commentId = commentId
        self.postOwnerId = postOwnerId
        self.commentOwnerId = commentOwnerId
        self.userReportingId = userReportingId
    }
}
