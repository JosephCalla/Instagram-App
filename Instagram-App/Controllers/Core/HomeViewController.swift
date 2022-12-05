//
//  ViewController.swift
//  Instagram-App
//
//  Created by Joseph Estanislao Calla Moreyra on 18/10/22.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView?
    private var viewModels = [[HomeFeedCellType]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Instagram"
        view.backgroundColor = .systemBackground
        configureCollectionView()
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func fetchPosts() {
        // Mock Data
        let postData: [HomeFeedCellType] = [
            .poster(viewModel: PosterCollectionViewCellViewModel(
                username: "Joseph",
                profilePictureURL: URL(string: "https://media-exp1.licdn.com/dms/image/D4E03AQGVidajZPPrtg/profile-displayphoto-shrink_400_400/0/1669220037749?e=1675900800&v=beta&t=4FPTeT9GJZA5UB_ksa7flC_I9AzjO15clxjnrYw0Tx8")!
                )
            ),
            .post(viewModel: PostCollectionViewCellViewModel(
                postURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVGHL9r9OucwArH8yO3rEDPryG4V3tSCBw-w&usqp=CAU")!
                )
            ),
            .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: true)),
            .likeCount(viewModel: PostLikesCollectionViewCellViewModel(likers: ["Girls :)"])),
            .caption(viewModel: PostCaptionCollectionViewCellViewModel(username: "Joseph", caption: "Fist Post")),
            .timestamp(viewModel: PostDatetimeCollectionViewCellViewModel(date: Date()))
        ]
        
        viewModels.append(postData)
        collectionView?.reloadData()
    }
    
    let colors: [UIColor] = [
        .systemBackground,
        .green,
        .blue,
        .yellow,
        .systemPink,
        .orange
    ]
    
}

extension HomeViewController {
    // CollectionView
    private func configureCollectionView() {
        let sectionHeight: CGFloat = 240 + view.width
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ in
            
            // Item
            let posterItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                       heightDimension: .absolute(60)))
            
            let postItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                     heightDimension: .fractionalWidth(1)))
            
            let actionsItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                        heightDimension: .absolute(40)))
            
            let likeCountItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                          heightDimension: .absolute(40)))
            
            let captionItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                        heightDimension: .absolute(60)))
            
            let timestampItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                          heightDimension: .absolute(40)))
            
            // Group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                            heightDimension: .absolute(sectionHeight)),
                                                         subitems: [posterItem,
                                                                    postItem,
                                                                    actionsItem,
                                                                    likeCountItem,
                                                                    captionItem,
                                                                    timestampItem
                                                                   ])
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
            return section
        }))
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: "PosterCollectionViewCell")
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionViewCell")
        collectionView.register(PostActionCollectionViewCell.self, forCellWithReuseIdentifier: "PostActionCollectionViewCell")
        collectionView.register(PostCaptionCollectionViewCell.self, forCellWithReuseIdentifier: "PostCaptionCollectionViewCell")
        collectionView.register(PostLikesCollectionViewCell.self, forCellWithReuseIdentifier: "PostLikesCollectionViewCell")
        collectionView.register(PostDateCollectionViewCell.self, forCellWithReuseIdentifier: "PostDateCollectionViewCell")
        self.collectionView = collectionView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.section][indexPath.row]
        switch cellType {
        case .poster(let viewModel):
           guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PosterCollectionViewCell", for: indexPath
            ) as? PosterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.contentView.backgroundColor = colors[indexPath.row]
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                 withReuseIdentifier: "PostCollectionViewCell", for: indexPath
             ) as? PostCollectionViewCell else {
                 fatalError()
             }
             cell.configure(with: viewModel)
             cell.contentView.backgroundColor = colors[indexPath.row]
             return cell
        case .actions(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                 withReuseIdentifier: "PostActionCollectionViewCell", for: indexPath
             ) as? PostActionCollectionViewCell else {
                 fatalError()
             }
             cell.configure(with: viewModel)
             cell.contentView.backgroundColor = colors[indexPath.row]
             return cell
        case .likeCount(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                 withReuseIdentifier: "PostLikesCollectionViewCell", for: indexPath
             ) as? PostLikesCollectionViewCell else {
                 fatalError()
             }
             cell.configure(with: viewModel)
             cell.contentView.backgroundColor = colors[indexPath.row]
             return cell
        case .caption(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                 withReuseIdentifier: "PostCaptionCollectionViewCell", for: indexPath
             ) as? PostCaptionCollectionViewCell else {
                 fatalError()
             }
             cell.configure(with: viewModel)
             cell.contentView.backgroundColor = colors[indexPath.row]
             return cell
        case .timestamp(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                 withReuseIdentifier: "PostDateCollectionViewCell", for: indexPath
             ) as? PostDateCollectionViewCell else {
                 fatalError()
             }
             cell.configure(with: viewModel)
             cell.contentView.backgroundColor = colors[indexPath.row]
             return cell
        }        
    }
}
