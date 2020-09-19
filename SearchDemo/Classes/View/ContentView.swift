//
//  ContentView.swift
//  SearchDemo
//
//  Created by WeiHan on 2020/9/16.
//  Copyright © 2020 WillHan. All rights reserved.
//
//  The default container view for searching.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ProductViewModel()
    @State private var isEditing: Bool = false

    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorInset = .zero
        UITableView.appearance().separatorColor = UIColor(white: 0.1, alpha: 0.1)
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Apply the light gray as background color for fullscreen.
                Color.gray.opacity(0.05).edgesIgnoringSafeArea(.all)

                VStack {
                    HStack(spacing: 10) {
                        Spacer()
                        SearchView(text: $viewModel.searchText, isEditing: $isEditing)
                        Spacer()
                    }

                    resultListView
                }
                .padding(.bottom, viewModel.currentKeyboardHeight)
                .navigationBarTitle("Search")
                .navigationBarHidden(isEditing)

                #if swift(>=5.3) // For Xcode 12 and above
                if #available(iOS 14.0, *) {
                    ProgressView().opacity(isEditing && viewModel.isLoading ? 1 : 0)
                } else {
                    loadingIndicatorViewForiOS13
                }
                #else
                    loadingIndicatorViewForiOS13
                #endif

                resultMessageView
            }
        }
    }

    // MARK: Component Views

    private var resultListView: some View {
        return Group {
            if viewModel.results.count > 0 {
                List {
                    ForEach(viewModel.results) { category in
                        Section(header:
                            Text(category.name)
                            .font(.headline)
                            .foregroundColor(.gray)
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))) {
                            ForEach(category.products) { product in
                                CellView(data: product)
                                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                                    .listRowBackground(Color.white)
                            }
                        }
                    }

                    if (viewModel.hasMoreData) {
                        HStack {
                            Spacer()
                            Text("Loading more data...")
                                .foregroundColor(.secondary)
                            Spacer()
                        }.onAppear {
                            print("Fetching data")
                            self.viewModel.search(next: true)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            } else if (isEditing) {
                Group {
                    Text("No result")
                        .foregroundColor(.gray)
                        .frame(height: 200)
                    Spacer()
                }
            } else {
                Spacer()
            }
        }
    }

    private var loadingIndicatorViewForiOS13: some View {
        return VStack(spacing: 10) {
            Text("Loading...")
            ActivityIndicator(isAnimating: .constant(true), style: .large)
        }
        .padding(40)
        .background(Color.secondary.colorInvert())
        .foregroundColor(Color.primary)
        .cornerRadius(20)
        .opacity(isEditing && viewModel.isLoading ? 1 : 0)
    }

    private var resultMessageView: some View {
        return Group {
            if viewModel.errorMessage.count > 0 {
                Text(viewModel.errorMessage)
                    .padding(30)
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(20)
                    .onAppear {
                        self.viewModel.collapsedMessage(after: 3)
                    }
                    .onTapGesture {
                        self.viewModel.collapsedMessage(after: 0)
                    }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
