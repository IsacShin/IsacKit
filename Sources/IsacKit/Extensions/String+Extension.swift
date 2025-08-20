//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 8/20/25.
//

import Foundation

public extension String {
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        let regex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
    
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }
    
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    func toURL() -> URL? {
        URL(string: self)
    }
}
