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
        let config = WKWebViewConfiguration()
        let webview = WKWebView(frame: .zero, configuration: config)
        webview.uiDelegate = self
        webview.navigationDelegate = self
        return webview
    }
    
    func load(_ url: URL?) {
        load { url }
    }
    
    func load(@SingleValueBuilder<URL?> buildURL: () -> URL?) {
        guard let url = buildURL() else {
            popError("无法加载")
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
