//
//  SimilarMovies.swift
//  PremierSwift
//
//  Created by Kashan Qamar on 23/11/2020.
//  Copyright © 2020 Deliveroo. All rights reserved.
//

import Foundation


struct SimilarMovies: Decodable {
    
    let results: [Results]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
}

struct Results: Decodable {
    let id: Int
    let original_title: String
    let overview: String
    let backdrop_path: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case original_title
        case overview
        case backdrop_path = "poster_path"
    }
}


extension SimilarMovies {
    static func details(for movie: Movie) -> Request<SimilarMovies> {
        return Request(method: .get, path: "/movie/\(movie.id)/similar", pars: [:])
    }
}
