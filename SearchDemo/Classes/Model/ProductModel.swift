//
//  StockModel.swift
//  SearchDemo
//
//  Created by WeiHan on 2020/9/16.
//  Copyright © 2020 WillHan. All rights reserved.
//

import Foundation

struct Category: Codable, Identifiable {
    var id: Int
    var name: String
    var brand: String
    var products: [Product]
}

struct Product: Codable, Identifiable {
    var id: Int
    var name: String
    var price: Decimal
    var status: Status

    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return "$\(formatter.string(from: self.price as NSDecimalNumber) ?? "")"
    }
}

enum Status: Int, Codable {
    case inStock = 1
    case outOfStock

    var description: String {
        switch self {
        case .inStock:
            return "In-stock"
        case .outOfStock:
            return "Out-of-stock"
        }
    }
}
