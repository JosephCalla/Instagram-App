//
//  PostEditViewController.swift
//  Instagram-App
//
//  Created by Joseph Estanislao Calla Moreyra on 5/12/22.
//

import UIKit

class PostEditViewController: UIViewController {

    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let image : UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Edit"
        imageView.image = image
        view.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height)
    }
}
