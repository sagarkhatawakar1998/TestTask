//
//  WelcomeModel.swift
//  TestTask
//

import Foundation


struct WelcomeModel: Codable {
    let id, author: String
    let width, height: Int
    let url, download_url: String
}
