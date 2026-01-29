//
//  CookbookDemo.swift
//  Cookbook Template
//
//  Created by Renchi Liu on 1/28/26.
//

import UIKit

struct CookbookDemo: Identifiable {
    let id: String
    let title: String
    let subtitle: String?
    let category: String
    let order: Int
    let tags: [String]
    let makeViewController: @MainActor () -> UIViewController
    
    init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String? = nil,
        category: String,
        order: Int = 0,
        tags: [String] = [],
        makeViewController: @escaping @MainActor () -> UIViewController
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.category = category
        self.order = order
        self.tags = tags
        self.makeViewController = makeViewController
    }
}
