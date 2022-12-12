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
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        DatabaseManager.shared.posts(for: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    //print("\n\n\n Posts: \(posts.count)")
                    let group = DispatchGroup()
                    
                    posts.forEach { model in
                        group.enter()
                        self?.createViewModel(model: model, username: username, completion: { success in
                            defer {
                                group.leave()
                            }
                            
                            if !success {
                                print("Failed to create VM")
                            }
                        }
                        )
                    }
                    
                    group.notify(queue: .main) {
                        self?.collectionView?.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func createViewModel(
        model: Post,
        username: String,
        completion: @escaping(Bool) -> Void
    ) {
       
        StorageManager.shared.profilePictureURL(for: username) { [weak self] profilePictureURL in
            guard let postURL = URL(string: model.postURLString),
            let profilePhotoURL = profilePictureURL else {
                fatalError("Failed to get URLs")
                return
            }
            
            let postData: [HomeFeedCellType] = [
                .poster(
                    viewModel: PosterCollectionViewCellViewModel(
                        username: username,
                        profilePictureURL: profilePhotoURL
                    )
                ),
                .post(viewModel: PostCollectionViewCellViewModel(
                    postURL: postURL
                )
                ),
                .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: false)),
                .likeCount(viewModel: PostLikesCollectionViewCellViewModel(likers: [])),
                .caption(viewModel: PostCaptionCollectionViewCellViewModel(
                    username: username,
                    caption: model.caption
                )),
                .timestamp(
                    viewModel: PostDatetimeCollectionViewCellViewModel(
                        date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()
                    )
                )
            ]
            
            self?.viewModels.append(postData)
            completion(true)
        }
    }
    
    let colors: [UIColor] = [
        .systemBackground,
        .systemBackground,
        .systemBackground,
        .systemBackground,
        .systemBackground,
        .systemBackground
    ]
    
}
extension HomeViewController {
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
}

extension HomeViewController {
    // CollectionView
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
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PostCollectionViewCell", for: indexPath
            ) as? PostCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .actions(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PostActionCollectionViewCell", for: indexPath
            ) as? PostActionCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .likeCount(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PostLikesCollectionViewCell", for: indexPath
            ) as? PostLikesCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .caption(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PostCaptionCollectionViewCell", for: indexPath
            ) as? PostCaptionCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
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


extension HomeViewController: PosterCollectionViewCellDelegate {
    func posterCollectionViewCellDelegateDidTapMore(_ cell: PosterCollectionViewCell) {
        let sheet = UIAlertController(title: "Post Actions", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Share Post", style: .default))
        sheet.addAction(UIAlertAction(title: "Report Post", style: .destructive))
        present(sheet, animated: true)
    }
    
    func posterCollectionViewCellDelegateDidTapUsername(_ cell: PosterCollectionViewCell) {
        print("Tapped username")
        let vc = ProfileViewController(user: User(username: "jose", email: "jose@gmail.com"))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: PostCollectionViewCellDelegate {
    func postCollectionViewCellDidLike(_ cell: PostCollectionViewCell) {
        print("Double Tapped")
    }
}


extension HomeViewController: PostActionCollectionViewCellDelegate {
    func postActionCollectionViewCellDidTapComment(_ cell: PostActionCollectionViewCell) {
//        let vc = PostViewController(post: post)
//        vc.title = "Post"
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func postActionCollectionViewCellDidTapShare(_ cell: PostActionCollectionViewCell) {
        let vc = UIActivityViewController(activityItems: ["Sharing from Joseph's App"], applicationActivities: [])
        present(vc, animated: true)
    }
    
    func postActionCollectionViewCellDidTapLike(_ cell: PostActionCollectionViewCell, isLiked: Bool) {
        // Call DB to update like state
    }
}

extension HomeViewController: PostCaptionCollectionViewCellDelegate {
    func postCaptionCollectionViewCellDidTapCaption(_ cell: PostCaptionCollectionViewCell) {
        print("User tapped caption")
    }
}

extension HomeViewController: PostLikesCollectionViewCellDelegate {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell) {
        let vc = ListViewController()
        vc.title = "Liked By"
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
