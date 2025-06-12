//
//  Status.swift
//  Domain
//
//  Created by kana.sugimoto on 2025/05/27.
//

enum Status: Int, CaseIterable {
    case notStart
    case inProgress
    case finished
    
    var name: String {
        switch self {
        case .notStart:
            return "未着手"
        case .inProgress:
            return "進行中"
        case .finished:
            return "完了"
        }
    }
}
