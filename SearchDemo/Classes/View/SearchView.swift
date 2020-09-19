//
//  SearchView.swift
//  SearchDemo
//
//  Created by WeiHan on 2020/9/16.
//  Copyright © 2020 WillHan. All rights reserved.
//
//  Search bar appearance including the textfield and accessory views.
//

import SwiftUI

struct SearchView: View {
    @Binding var text: String
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            if !isEditing {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
            }

            TextField("Tap here to search", text: $text, onEditingChanged: { (isEditing) in
                print("isEditing: \(isEditing)")
                withAnimation { self.isEditing = isEditing }
            }, onCommit: {
                print("onCommit")
            })

            if isEditing {
                Button(action: {
                    self.text = ""
                    self.isEditing = false

                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Image(systemName: "xmark")
                    .padding(10)
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
        .foregroundColor(.primary)
        .background(Color(.systemGray5))
        .cornerRadius(10.0)
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(text: .constant(""), isEditing: .constant(false))
    }
}
#endif
