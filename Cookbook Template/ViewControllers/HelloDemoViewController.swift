//
//  HelloDemoViewController.swift
//  Cookbook Template
//
//  Created by Renchi Liu on 1/28/26.
//

import UIKit

final class HelloDemoViewController: UIViewController, CookbookDemoProvider {
    
    static var cookbookDemo: CookbookDemo {
        CookbookDemo(
            id: "hello.demo",
            title: "Hello UIKit",
            subtitle: "demo：label + button",
            category: "Basics",
            order: 0,
            tags: ["UIKit"]
        ) {
            HelloDemoViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Hello Cookbook"
        label.font = .preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .system)
        button.setTitle("Tap me", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { _ in
            print("Tapped")
        }, for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16)
        ])
    }
}
