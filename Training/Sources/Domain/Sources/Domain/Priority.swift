//
//  Priority.swift
//  Domain
//
//  Created by kana.sugimoto on 2025/05/27.
//

enum Priority: Int, CaseIterable {
    case high
    case middle
    case low
    
    var name: String {
        switch self {
        case .high:
            return "高"
        case .middle:
            return "中"
        case .low:
            return "低"
        }
    }
}
