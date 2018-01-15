//
//  IntroCollectionViewController.swift
//  CHD
//
//  Created by CenSoft on 11/01/18.
//  Copyright © 2018 CenSoft. All rights reserved.
//

import UIKit

struct Page {
    let imageName: String
}

private let reuseIdentifier = "Cell"

class IntroCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let pages = [
        Page(imageName: "first"),Page(imageName: "second"),Page(imageName: "third"),Page(imageName: "fourth")
    ]
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 4
        pc.currentPageIndicatorTintColor = .red
        pc.pageIndicatorTintColor = .gray
        return pc
    }()
    
    private lazy var skipButton: UIButton = {
        var button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window = UIWindow()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        setupBottomControls()
        window = appDelegate.window!
        //self.window.addSubview(skipButton)
        
        self.collectionView!.register(IntroPagesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.backgroundColor = .white
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.showsHorizontalScrollIndicator = false

        self.view.addSubview(skipButton)
        skipButton.addTarget(self, action: #selector(skipLogin), for: .touchUpInside)
        addConstraintsToSkipButton()
    
    }
    
    func addConstraintsToSkipButton() {
        if #available(iOS 11.0, *) {
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        } else {
            // Fallback on earlier versions
            skipButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func setupBottomControls() {
        pageControl.frame = CGRect(x: 0, y: view.frame.height - 80, width: view.frame.width, height: 50)
        view?.addSubview(pageControl)
    }

    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let currentPage = Int(x / view.frame.width)
        self.pageControl.currentPage = currentPage
        if currentPage == 3 {
            self.skipButton.setTitle("Done", for: .normal)
        } else {
            self.skipButton.setTitle("Skip", for: .normal)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IntroPagesCollectionViewCell
        let page = pages[indexPath.row]
        cell.page = page
        return cell
    }
    
    // MARK: UICollectionViewFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    // to reduce spacing between cells to zero
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func skipLogin(){
        print("Skip button did clicked")
        DispatchQueue.main.async {
            self.skipButton.removeFromSuperview()
        }
       // UserDefaults.standard.set(true, forKey: "isLoggedInSkipped")
        let homeViewCtrl = LoginViewController()
        self.navigationController?.pushViewController(homeViewCtrl, animated: true)
    }
}
