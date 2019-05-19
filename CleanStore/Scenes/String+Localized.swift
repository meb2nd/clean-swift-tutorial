//
//  String+Localized.swift
//  CleanStore
//
//  Created by Pete Barnes on 4/9/19.
//  Copyright © 2019 Pete Barnes. All rights reserved.
//

import Foundation

public extension String {
    
    /// Returns a localized version of the string
    var localized: String {
        
        return NSLocalizedString(self, comment: "")
    }
    
    /// Returns a localized version of this string with an optional comment. String can be a key in the Localized stings file.
    ///
    /// - Parameter comment: Comment is printed in documentation generation.
    /// - Returns: Localized string.
    func localize(withComment comment: String? = nil) -> String {
        
        return NSLocalizedString(self, comment: comment ?? "")
    }
}
