//
//  Category.swift
//  Domain
//
//  Created by kana.sugimoto on 2025/05/27.
//

enum CategoryType {
    case work
    case personal
    case shopping
    case other
    case custom(String)
    
    var name : String {
        switch self {
        case .work: return "仕事"
        case .personal: return "プライベート"
        case .shopping: return "買い物"
        case .other: return "その他"
        case .custom(let name): return name
        }
        
    }
}


struct Category {
    var categoryType: CategoryType
    var color: String
}
