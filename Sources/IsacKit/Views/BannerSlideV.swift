//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/8/25.
//

import SwiftUI

@available(iOS 14.0, *)
public struct BannerSlideV: View {
    
    public enum Position: Equatable {
        case center
        case trailingBottom
        case leadingBottom
    }
    
    /// 오토 스크롤 설정
    let autoScrollEnabled: Bool = true // 자동 스크롤 활성화 여부
    let autoScrollInterval: TimeInterval = 3.0 // 3초 간격 자동 스크롤
    @State private var currentIndex = 0 // 현재 페이지
    @State private var timer: Timer? = nil
    
    let items: [String] // 이미지 URL
    let placeholderImage: UIImage? = nil // 플레이스홀더 이미지
    let showIndicator: Bool = true // 기본 인디케이터 표시 여부(커스텀 X)
    
    /// 커스텀 인디케이터 설정
    let customIndicator: Bool = true
    let customIndicatorSize: CGFloat = 8
    let customIndicatorCurrentColor: Color = .primary
    let customIndicatorColor: Color = Color.secondary.opacity(0.3)
    let customIndicatorSpacing: CGFloat = 8
    let customIndicatorPadding: CGFloat = 8
    
    /// 커스텀 인티케이터(숫자타입)
    let numIndicator: Bool = true
    let numIndicatorFont: Font = .system(size: 14, weight: .semibold)
    let numIndicatorColor: Color = .white
    let numIndicatorBgColor: Color = Color.black.opacity(0.5)
    let numIndicatorCornerRadius: CGFloat = 12
    let numIndicatorPosition: Position = .trailingBottom
    
    public var body: some View {
        GeometryReader { g in
            ZStack {
                VStack {
                    TabView(selection: $currentIndex) {
                        ForEach(items.indices, id: \.self) { index in
                            URLImageView(urlString: items[index],
                                         placeholderImage: placeholderImage) // 플레이스홀더 이미지 설정
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: showIndicator == true ? .always : .never))
                    
                    if customIndicator {
                        HStack(spacing: customIndicatorSpacing) {
                            ForEach(items.indices, id: \.self) { index in
                                Circle()
                                    .fill(index == currentIndex ? customIndicatorCurrentColor : customIndicatorColor)
                                    .frame(width: customIndicatorSize, height: customIndicatorSize)
                            }
                        }
                        .padding(.top, customIndicatorPadding)
                    }
                }
                
                if numIndicator {
                    Text("\(currentIndex + 1) / \(items.count)")
                        .font(numIndicatorFont)
                        .foregroundColor(numIndicatorColor)
                        .padding(8)
                        .background(numIndicatorBgColor)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: numIndicatorCornerRadius,
                                                                       height: numIndicatorCornerRadius)))
                        .offset(
                            x: {
                                switch numIndicatorPosition {
                                case .center:
                                    return 0
                                case .leadingBottom:
                                    return -g.size.width / 2 + 40
                                case .trailingBottom:
                                    return g.size.width / 2 - 40
                                }
                            }(),
                            y: {
                                switch numIndicatorPosition {
                                case .center:
                                    return g.size.height / 2 - 60
                                case .leadingBottom:
                                    return g.size.height / 2 - 60
                                case .trailingBottom:
                                    return g.size.height / 2 - 60
                                }
                            }()
                        )
                }
            }
        }
        .onAppear {
            currentIndex = 0
            if autoScrollEnabled {
                startAutoScroll()
            }
        }
        .onDisappear {
            if autoScrollEnabled {
                stopAutoScroll()
            }
        }
    }
    
    private func startAutoScroll() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { _ in
            Task {
                await MainActor.run {
                    withAnimation {
                        currentIndex = (currentIndex + 1) % items.count
                    }
                }
            }
        }
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
}

@available(iOS 14.0, *)
public struct URLImageView: View {
    let urlString: String
    let placeholderImage: UIImage?
    @State private var image: UIImage? = nil
    @State private var isShowLoading: Bool = true

    public var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            } else {
                ZStack {
                    Color.gray.opacity(0.2)
                    if isShowLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
        .onAppear {
            Task {
                if let loadedImage = await loadImage() {
                    await MainActor.run {
                        self.image = loadedImage
                    }
                } else {
                    if let placeholderImage = placeholderImage {
                        await MainActor.run {
                            self.image = placeholderImage
                        }
                    }
                }
            }
        }
    }

    private func loadImage() async -> UIImage? {
        isShowLoading = true
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            isShowLoading = false
            return UIImage(data: data)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
}

@available(iOS 14.0, *)
#Preview {
    BannerSlideV(items: [
        "https://picsum.photos/300/200",
        "https://picsum.photos/300/200333",
        "https://picsum.photos/300/200"
    ])
}
