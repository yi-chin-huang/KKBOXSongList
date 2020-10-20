//
//  SongWebViewController.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/19.
//

import UIKit
import WebKit
class SongWebViewController: UIViewController, WKNavigationDelegate {
    
    private let url: URL
    private let webView = WKWebView()
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        toolBar.items = [backButton]
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        return toolBar
    }()
    
    init(url: URL) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        installLayout()
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
    
    private func installLayout() {
        let guide = view.safeAreaLayoutGuide
        webView.addSubview(toolBar)
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    @objc private func goBack() {
      if webView.canGoBack {
        webView.goBack()
      }
    }
}
