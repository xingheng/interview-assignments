//
//  StockRequest.swift
//  SearchDemo
//
//  Created by WeiHan on 2020/9/16.
//  Copyright © 2020 WillHan. All rights reserved.
//

import Foundation

enum ResponseError: Error {
    case invalidPath
}

struct ProductListResponse: Codable {
    var categories: [Category]
    var hasNextPage: Bool
}

struct ProductRequest {
    static func search(name: String, page: Int?, completion: @escaping ((Result<ProductListResponse, Error>) -> Void)) {
        #if true
        let keywords = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "http://127.0.0.1:8080/search?q=\(keywords ?? "")&page=\(page ?? 0)")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let err = error {
                print("error:\(err)")
                completion(.failure(error!))
                return
            }

            // sleep(1) // For testing with a slow network condition.

            do {
                let data = try JSONDecoder().decode(ProductListResponse.self, from: data!)
                completion(.success(data))
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                completion(.failure(error))
            }
        })
        task.resume()
        #else
        // Simulate a dummy search request
        DispatchQueue.global().async {
            let result = Category.searchSampleProducts(keywords: name)
            completion(result)
        }
        #endif
    }
}

extension Category {

    static func searchSampleProducts(keywords: String, page: Int?) -> Result<ProductListResponse, Error> {
        guard let url = Bundle.main.url(forResource: "sample-data", withExtension: "json") else {
            return .failure(ResponseError.invalidPath)
        }

        do {
            let data = try Data(contentsOf: url)
            let totalCategories = try JSONDecoder().decode([Category].self, from: data)
            let keywords = keywords.lowercased()

            let pageIndex = page != nil ? page! : 0
            let pageCount = 20
            let offset = pageIndex * pageCount
            var currentOffset = 0
            var categories = [Category]()
            var hasNextPage = false

            for category in totalCategories {
                let matchCategory = category.name.lowercased().contains(keywords) || category.brand.lowercased().contains(keywords)
                var products = [Product]()

                for product in category.products {
                    if matchCategory || product.name.lowercased().contains(keywords) {
                        currentOffset += 1

                        if offset <= currentOffset {
                            if currentOffset < offset + pageCount {
                                products.append(product)
                                // print("Add \(product.name) to page \(pageIndex)")
                            } else {
                                hasNextPage = true
                                break
                            }
                        }
                    }
                }

                if products.count > 0 {
                    var filteredCategory = category
                    filteredCategory.products = products
                    categories.append(filteredCategory)
                }
            }

            return .success(ProductListResponse(categories: categories, hasNextPage: hasNextPage))
        } catch {
            return .failure(error)
        }
    }
}
