//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/8/25.
//

import Foundation

extension Date {
    /// "YYYY년 M월 dd일" 형식 문자열을 반환하는 함수
    public func toYearMonthDayString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: self)
    }

    /// "YYYY년 M월" 형식 문자열을 반환하는 함수
    public func toYearMonthString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: self)
    }
    
    /// "M월 dd일" 형식 문자열을 반환하는 함수
    public func toMonthDayString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: self)
    }
}
