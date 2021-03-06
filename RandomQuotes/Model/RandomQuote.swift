//
//  RandomQuote.swift
//  RandomQuotes
//
//  Created by Eunbi Shin on 2022-02-23.
//

import Foundation

struct RandomQuote: Decodable, Hashable, Encodable {
    let quoteText: String
    let quoteAuthor: String
    let senderName: String
    let senderLink: String
    let quoteLink: String 
}
