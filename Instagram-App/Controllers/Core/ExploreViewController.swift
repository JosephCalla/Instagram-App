//
//  ExploreViewController.swift
//  Instagram-App
//
//  Created by Joseph Estanislao Calla Moreyra on 18/10/22.
//

import UIKit

class ExploreViewController: UIViewController, UISearchResultsUpdating {
    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
    private let colletionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { index, _ -> NSCollectionLayoutSection? in
            let item =  NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .fractionalHeight(1))
            )
            
            let fullItem =  NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1))
            )
                        
            let thirdItem =  NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                                   heightDimension: .fractionalHeight(1))
            )
            
            let verticalgroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1)
                ),
                subitem: fullItem,
                count: 2
            )
            
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(160)
                ),
                subitems: [
                    item,
                    verticalgroup
                ])
            
            let threeItemGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(160)
                ),
                subitem: thirdItem,
                count: 3
            )
            
            let finalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(320)
                ),
                subitems: [
                    horizontalgroup,
                    threeItemGroup
                ])
            
            return NSCollectionLayoutSection(group: finalGroup)
        }
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Explore"
        view.backgroundColor = .systemBackground
        (searchVC.searchResultsController  as? SearchResultsViewController)?.delegate = self
        searchVC.searchBar.placeholder = "Search..."
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        view.addSubview(colletionView)
        colletionView.delegate = self
        colletionView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        colletionView.frame = view.bounds
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultVC = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        DatabaseManager.shared.findUsers(with: query) { results in
            DispatchQueue.main.async {
                resultVC.update(with: results)
            }
        }
    }
}

extension ExploreViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectResultWith user: User) {
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
                                                            for: indexPath) as? PhotoCollectionViewCell else {
            fatalError()
        }
        
        cell.configure(with: UIImage(named: "test"))
        return cell
    }
}
