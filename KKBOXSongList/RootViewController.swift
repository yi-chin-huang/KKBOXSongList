//
//  RootViewController.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/15.
//

import UIKit

class RootViewController: UIViewController {    
    private var pageTabControllers: [UIViewController] = PageTab.allCases.map { $0.viewController }
    private lazy var contentViewController = pageTabControllers[segmentControl.selectedSegmentIndex]
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentItems = PageTab.allCases.map({ $0.title })
        let control = UISegmentedControl(items: segmentItems)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        installConstraits()
        setContentViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    @objc func segmentControl(_ segmentControl: UISegmentedControl) {
        removeContentViewController()
        setContentViewController()
    }
    
    private func setContentViewController() {
        contentViewController = pageTabControllers[segmentControl.selectedSegmentIndex]
        addChild(contentViewController)
        contentViewController.view.frame = contentView.bounds
        contentView.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }
    
    private func removeContentViewController() {
        contentViewController.willMove(toParent: nil)
        contentViewController.view.removeFromSuperview()
        contentViewController.removeFromParent()
    }
    
    private func installConstraits() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentControl.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

enum PageTab: Int, CaseIterable {
    case newRelease
    case musicCharts
    
    var title: String {
        switch self {
        case .newRelease:
            return "New Release"
        case .musicCharts:
            return "Music Charts"
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .newRelease:
            return NewReleaseViewController()
        case .musicCharts:
            return MusicChartsViewController()
        }
    }
}
