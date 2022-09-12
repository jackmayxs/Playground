//
//  BaseWebViewController.swift
//  zeniko
//
//  Created by Choi on 2022/8/25.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {
    
    lazy var webview = makeWebView()
    
    var fixedTitle: String? {
        willSet { title = newValue }
    }
    
    private weak var webviewTitleObservation: NSKeyValueObservation?
    
    override func loadView() {
        view = webview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webviewTitleObservation = webview.observe(\.title, options: [.initial, .new]) {
            [unowned self] web, change in
            guard let webTitle = change.newValue else { return }
            self.title = webTitle.validStringOrNone ?? fixedTitle
        }
    }
    
    @available(iOS 13, *)
    override func configureNavigationBarAppearance(_ barAppearance: UINavigationBarAppearance) {
        super.configureNavigationBarAppearance(barAppearance)
        barAppearance.configureWithTransparentBackground()
        barAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 16.0)
        ]
    }
    
    func makeWebView() -> WKWebView {
        /// 适配文字大小
        let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let userScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        config.preferences.minimumFontSize = 12.0
        
        
        let webview = WKWebView(frame: .zero, configuration: config)
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
        webviewTitleObservation = nil
    }
}
