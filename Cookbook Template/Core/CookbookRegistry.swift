//
//  CookbookRegistry.swift
//  Cookbook Template
//
//  Created by Renchi Liu on 1/28/26.
//

import UIKit
import ObjectiveC.runtime

final class CookbookRegistry {
    
    static func discover() -> [CookbookDemo] {
        var count: UInt32 = 0
        guard let classList = objc_copyClassList(&count) else { return [] }
        defer { free(UnsafeMutableRawPointer(classList)) }
        
        var demos: [CookbookDemo] = []
        demos.reserveCapacity(Int(count))
        
        let buffer = UnsafeBufferPointer(start: classList, count: Int(count))
        for clsAny in buffer {
            let cls = clsAny
            
            guard Bundle(for: cls) == .main else { continue }
            
            guard let vcType = cls as? UIViewController.Type else { continue }
            guard vcType != UIViewController.self else { continue }
            
            guard let provider = vcType as? CookbookDemoProvider.Type else { continue }
            
            demos.append(provider.cookbookDemo)
        }
        
        demos.sort {
            if $0.category != $1.category { return $0.category < $1.category }
            if $0.order != $1.order { return $0.order < $1.order }
            return $0.title.localizedCompare($1.title) == .orderedAscending
        }
        
        return demos
    }


}
