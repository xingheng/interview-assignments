//
//  ProductViewModel.swift
//  SearchDemo
//
//  Created by WeiHan on 2020/9/16.
//  Copyright © 2020 WillHan. All rights reserved.
//

import Foundation
import UIKit

class ProductViewModel: ObservableObject {
    @Published var results: [Category] = []
    @Published var hasMoreData: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var searchText: String = "" {
        didSet {
            print("Keywords: \(searchText)")
            search()
        }
    }

    private var pageIndex: Int = 0

    // Keep track of the instant keyboard layout changes to adjust the list view's height.
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentKeyboardHeight: CGFloat = 0

    // MARK: Public

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    func search(next: Bool = false) {
        isLoading = true

        if next {
            pageIndex += 1
        } else {
            pageIndex = 0
        }

        ProductRequest.search(name: searchText.trimmingCharacters(in: .whitespaces), page: pageIndex) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if next {
                        self.mergeResult(newResult: response.categories)
                    } else {
                        self.results = response.categories
                    }

                    self.hasMoreData = response.hasNextPage
                    print("Found \(response.categories.count) categor(ies) in result page \(self.pageIndex)")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error.localizedDescription)
                }

                self.isLoading = false
            }
        }
    }

    func collapsedMessage(after interval: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(interval)) {
            self.errorMessage = ""
        }
    }

    // MARK: Private

    private func mergeResult(newResult: [Category]) {
        var results = [Category]()

        self.results.forEach { (category) in
            var existingCategory: Category?

            newResult.forEach { (newCategory) in
                if newCategory.id == category.id {
                    existingCategory = category
                    existingCategory!.products.append(contentsOf: newCategory.products)
                }
            }

            if existingCategory != nil {
                results.append(existingCategory!)
            } else {
                results.append(category)
            }
        }

        self.results = results
    }

    // MARK: Keyboard Notification Selectors

    @objc private func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentKeyboardHeight = keyboardSize.height
        }
    }

    @objc private func keyBoardWillHide(notification: Notification) {
        currentKeyboardHeight = 0
    }
}
