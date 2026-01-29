//
//  CookbookRegistry.swift
//  Cookbook Template
//
//  Created by Renchi Liu on 1/28/26.
//

import UIKit

@MainActor
final class CookbookHomeViewController: UITableViewController {
    
    private typealias Section = String
    private typealias DemoID = String
    private typealias DataSource = UITableViewDiffableDataSource<Section, DemoID>
    
    private var dataSource: DataSource!
    
    private var allDemos: [CookbookDemo] = []
    private var visibleDemos: [CookbookDemo] = []
    private var demosByID: [DemoID: CookbookDemo] = [:]
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cookbook"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.keyboardDismissMode = .onDrag
        
        configureSearch()
        configureDataSource()
        configureNavItems()
        
        reloadDemos()
    }
    
    private func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search demos"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureNavItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .refresh,
            primaryAction: UIAction { [weak self] _ in
                Task { @MainActor in
                    self?.reloadDemos()
                }
            }
        )
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, DemoID>(tableView: tableView) { [weak self] tableView, indexPath, demoID in
            let reuseID = "demoCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseID)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
            
            guard let demo = self?.demosByID[demoID] else { return cell }
            
            cell.textLabel?.text = demo.title
            
            let tagText = demo.tags.isEmpty ? nil : demo.tags.joined(separator: " · ")
            let secondaryParts = [demo.subtitle, tagText].compactMap { $0 }.filter { !$0.isEmpty }
            cell.detailTextLabel?.text = secondaryParts.isEmpty ? demo.category : secondaryParts.joined(separator: " — ")
            
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }

    
    private func reloadDemos() {
        allDemos = CookbookRegistry.discover()
        
        var dict: [DemoID: CookbookDemo] = [:]
        for d in allDemos { dict[d.id] = d }
        demosByID = dict
        
        applyFilterAndSnapshot()
    }
    
    private func applyFilterAndSnapshot() {
        let keyword = searchController.searchBar.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if keyword.isEmpty {
            visibleDemos = allDemos
        } else {
            visibleDemos = allDemos.filter { demo in
                let haystack = [
                    demo.title,
                    demo.subtitle ?? "",
                    demo.category,
                    demo.tags.joined(separator: " ")
                ].joined(separator: " | ")
                return haystack.localizedCaseInsensitiveContains(keyword)
            }
        }
        
        let grouped = Dictionary(grouping: visibleDemos, by: { $0.category })
        let sortedSections = grouped.keys.sorted { $0.localizedCompare($1) == .orderedAscending }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, DemoID>()
        snapshot.appendSections(sortedSections)
        
        for section in sortedSections {
            let items = (grouped[section] ?? []).sorted { a, b in
                if a.order != b.order { return a.order < b.order }
                return a.title.localizedCompare(b.title) == .orderedAscending
            }
            snapshot.appendItems(items.map(\.id), toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let demoID = dataSource.itemIdentifier(for: indexPath),
              let demo = demosByID[demoID] else { return }
        
        let vc = demo.makeViewController()
        if vc.title == nil || vc.title?.isEmpty == true { vc.title = demo.title }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CookbookHomeViewController: UISearchResultsUpdating {
    nonisolated func updateSearchResults(for searchController: UISearchController) {
        Task { @MainActor [weak self] in
            self?.applyFilterAndSnapshot()
        }
    }
}
