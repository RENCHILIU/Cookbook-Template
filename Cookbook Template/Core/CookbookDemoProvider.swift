//
//  CookbookDemoProvider.swift
//  Cookbook Template
//
//  Created by Renchi Liu on 1/28/26.
//

import UIKit

protocol CookbookDemoProvider: AnyObject {
    static var cookbookDemo: CookbookDemo { get }
}
