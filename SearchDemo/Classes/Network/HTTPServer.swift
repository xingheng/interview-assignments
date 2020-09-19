//
//  HTTPServer.swift
//  SearchDemo
//
//  Created by WeiHan on 2020/9/16.
//  Copyright © 2020 WillHan. All rights reserved.
//

import Foundation
import Swifter

struct HTTPServer {
    private static var server: HttpServer?

    static func initialize() {
        if server != nil {
            return
        }

        let server = HttpServer()
        self.server = server

        server.GET["/search"] = { request in
            guard let keywords = request.queryParams.first(where: { $0.0 == "q"})?.1 else {
                return .ok(.json(["categories": nil]))
            }

            let pageIndex = Int(request.queryParams.first(where: { $0.0 == "page"})?.1 ?? "0")
            let result = Category.searchSampleProducts(keywords: keywords, page: pageIndex)

            switch result {
            case .success(let response):
                do {
                    let jsonData = try JSONEncoder().encode(response)
                    return .ok(.data(jsonData))
                } catch {
                    print("encode error: \(error)")
                    return .internalServerError
                }
            case .failure(let error):
                print("error: \(error)")
                return .internalServerError
            }
        }

        do {
            print("Launching http server...")
            try server.start()
        } catch {
            print("HttpServer error: \(error)")
            self.server = nil
        }
    }
}
