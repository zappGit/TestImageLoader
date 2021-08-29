//
//  ModelPixalbay.swift
//  TestImageLoader
//
//  Created by Артем Хребтов on 28.08.2021.
//

import Foundation

struct Pixabay: Codable {
    let total: Int
    let totalHits: Int
    let hits: [Hit]
}

struct Hit: Codable {
    let id: Int
    let tags: String?
    let webformatURL: String
}


