//
//  SearchResultDTO.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/04.
//

import Foundation

struct SearchResultDTO: Codable {
    let resultCount: Int
    let results: [AppItemDTO]
}
