//
//  WebView.swift
//  Penn Dining
//  Simple WebView class that loads the webpage when the NavigationLink is clicked
//

import Foundation
import SwiftUI
import WebKit

// `WebView` struct conforms to `UIViewRepresentable` to allow usage of UIKit's `WKWebView` in SwiftUI.
struct WebView: UIViewRepresentable {
    
    // passed URL to load in the WebView
    let url: URL

    // create the initial `WKWebView` instance
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    // updates the WebView with new data or URL and called whenever SwiftUI updates the view
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
