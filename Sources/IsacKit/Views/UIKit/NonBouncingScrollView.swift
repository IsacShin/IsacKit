//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/10/25.
//

import SwiftUI
import UIKit

@available(iOS 14.0, *)
struct NonBouncingScrollView<Content: View>: UIViewRepresentable {
    let content: Content
    let axis: Axis.Set

    init(_ axis: Axis.Set = .vertical, @ViewBuilder content: () -> Content) {
        self.axis = axis
        self.content = content()
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false

        let hostedView = UIHostingController(rootView: content)
        hostedView.view.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(hostedView.view)

        NSLayoutConstraint.activate([
            hostedView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostedView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostedView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostedView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            axis == .vertical
                ? hostedView.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
                : hostedView.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // 업데이트 필요 시 처리
    }
}
