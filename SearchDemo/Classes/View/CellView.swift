//
//  CellView.swift
//  SearchDemo
//
//  Created by WeiHan on 2020/9/16.
//  Copyright © 2020 WillHan. All rights reserved.
//
//  Cell view for the List.
//

import SwiftUI

struct CellView: View {
    var data: Product

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(data.name)
                    .font(.system(size: 17, weight: .semibold))
                Text(data.status.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(data.localizedPrice)
                .font(.subheadline)
                .foregroundColor(priceColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(priceColor.opacity(0.1))
                .cornerRadius(12)
        }
        .padding(.vertical, 8)
    }

    var priceColor: Color {
        switch data.status {
        case .inStock: return .blue
        case .outOfStock: return .gray
        }
    }
}

#if DEBUG
struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(data: Product(id: 1, name: "product name", price: 100.10, status: .inStock))
    }
}
#endif
