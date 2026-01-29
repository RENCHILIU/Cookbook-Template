//
//  LayoutDemoViewController.swift
//  Cookbook Template
//
//  Created by Renchi Liu on 1/28/26.
//

import UIKit

final class LayoutDemoViewController: UIViewController, CookbookDemoProvider {
    
    static var cookbookDemo: CookbookDemo {
        CookbookDemo(
            id: "layout.stackview",
            title: "UIStackView Layout",
            subtitle: "demo stackview + spacing",
            category: "Layout",
            order: 10,
            tags: ["AutoLayout", "UIStackView"]
        ) {
            LayoutDemoViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let a = makeBox(text: "A")
        let b = makeBox(text: "B")
        let c = makeBox(text: "C")
        
        [a, b, c].forEach { stack.addArrangedSubview($0) }
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    private func makeBox(text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        
        let v = UIView()
        v.backgroundColor = .secondarySystemBackground
        v.layer.cornerRadius = 12
        v.translatesAutoresizingMaskIntoConstraints = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(label)
        
        NSLayoutConstraint.activate([
            v.heightAnchor.constraint(equalToConstant: 64),
            label.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        return v
    }
}
