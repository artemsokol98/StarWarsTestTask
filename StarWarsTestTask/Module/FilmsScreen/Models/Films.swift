//
//  Films.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 14.12.2022.
//

import Foundation

struct Films: Decodable {
    let count: Int?
    let next: Int?
    let previous: Int?
    let results: [Results]?
}

struct Results: Decodable {
    let title: String?
    let episodeID: Int?
    let openingCrawl, director, producer, releaseDate: String?
    let characters, planets, starships, vehicles: [String]
    let species: [String]
    let created, edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case episodeID = "episode_id"
        case openingCrawl = "opening_crawl"
        case director, producer
        case releaseDate = "release_date"
        case characters, planets, starships, vehicles, species, created, edited, url
    }
}
