//
//  Errors.swift
//  CleanStore
//
//  Created by Pete Barnes on 4/9/19.
//  Copyright © 2019 Pete Barnes. All rights reserved.
//

import Foundation

enum OrderError: Error {
    case cancelled(orderNumber: String)
    case failed(orderNumber: String)
}

extension OrderError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
            
        case .cancelled(let orderNumber):
            return "The order:\(orderNumber) was cancelled".localize(withComment: "Cancelled order message")
        case .failed(let orderNumber):
            return "The order:\(orderNumber) failed to process.".localize(withComment: "Failed order message")
        }
    }
}
