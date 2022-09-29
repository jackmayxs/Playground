//
//  BaseWebViewController.swift
//  zeniko
//
//  Created by Choi on 2022/8/25.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {
    
    private lazy var webview = makeWebView()
    private lazy var progressView = UIProgressView(progressViewStyle: .bar).configure { make in
        make.progressTintColor = .accentColor
    }
    
    var fixedTitle: String? {
        willSet { title = newValue }
    }
    
    private var titleObservation: NSKeyValueObservation?
    private var progressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(webview, progressView)
        
        /// 观察网页标题
        titleObservation = webview.observe(\.title, options: [.initial, .new]) {
            [unowned self] web, change in
            guard let webTitle = change.newValue else { return }
            title = webTitle.validStringOrNone ?? fixedTitle
        }
        
        /// 观察网页加载进度
        progressObservation = webview.observe(\.estimatedProgress, options: [.initial, .new]) {
            [unowned self] web, change in
            guard let progress = change.newValue else {
                progressView.isHidden = true
                return
            }
            progressView.progress = Float(progress)
            progressView.isHidden = progress == 1.0
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        webview.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
        progressView.snp.updateConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1.0)
        }
    }
    
    @available(iOS 13, *)
    override func configureNavigationBarAppearance(_ barAppearance: UINavigationBarAppearance) {
        super.configureNavigationBarAppearance(barAppearance)
        barAppearance.backgroundColor = 0xF5F5F5.uiColor
        barAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.Ox333333,
            .font: UIFont.systemFont(ofSize: 16.0)
        ]
    }
    
    func makeWebView() -> WKWebView {
//        /// 适配文字大小
//        let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
//        let userScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//
//        let userContentController = WKUserContentController()
//        userContentController.addUserScript(userScript)
        
        let config = WKWebViewConfiguration()
//        config.userContentController = userContentController
        config.preferences.minimumFontSize = 12.0
        if #available(iOS 13, *) {
            /// 适配手机页面
            let pref = WKWebpagePreferences()
            pref.preferredContentMode = .mobile
            config.defaultWebpagePreferences = pref
        }
        
        
        let webview = WKWebView(frame: .zero, configuration: config)
        webview.isOpaque = false
        webview.backgroundColor = .white
        webview.uiDelegate = self
        webview.navigationDelegate = self
        webview.allowsBackForwardNavigationGestures = true
        return webview
    }
    
    func load(_ url: URL?) {
        load { url }
    }
    
    func load(@SingleValueBuilder<URL?> buildURL: () -> URL?) {
        guard let url = buildURL() else {
            trackError("无法加载")
            return
        }
        let request = URLRequest(url: url)
        webview.load(request)
    }
    
    override func goBack(animated: Bool = true) {
        if webview.canGoBack {
            webview.goBack()
        } else {
            super.goBack(animated: animated)
        }
    }
    
    deinit {
        titleObservation = nil
        progressObservation = nil
    }
}

extension BaseWebViewController {
    convenience init(url: URL?) {
        self.init()
        load(url)
    }
}
