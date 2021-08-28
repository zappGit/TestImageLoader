//
//  Model.swift
//  TestImageLoader
//
//  Created by Артем Хребтов on 28.08.2021.
//

import Foundation

struct ImageReguest: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let description: String?
    let user: User
    let urls: Urls
}

struct User: Codable {
    let username: String
}

struct Urls: Codable {
    let small: String
}
