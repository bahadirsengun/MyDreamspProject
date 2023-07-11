//
//  Symbols_Model.swift
//  myDream
//
//  Created by Bahadır Sengun on 6.07.2023.
//

import Foundation

// Sembollerin Json Formatına Çevirirken Kullanılan Tanımlamaların Tanımlandığı  Yer.

struct Symbol: Codable {
    let başlık: String
    let açıklama: String
}

struct Symbols: Codable {
    let symbols: [Symbol]
}
