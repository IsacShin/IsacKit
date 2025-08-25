//
//  BannerSlideView.swift
//  Demo
//
//  Created by shinisac on 8/22/25.
//

import SwiftUI
import IsacUIComponent

struct BannerSlideView: View {
    var body: some View {
        IsacBannerSlideView(items: ["https://picsum.photos/300/200",
                                    "https://picsum.photos/300/200333",
                                    "https://picsum.photos/300/200"],
                            showIndicator: false,
                            autoScrollEnabled: true)
        
        .frame(height: 200)
        .padding()
    }
}

#Preview {
    BannerSlideView()
}
