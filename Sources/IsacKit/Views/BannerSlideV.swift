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
    
    let items: [String] // 이미지 URL
    let placeholderImage: UIImage? // 기본 이미지
    let showIndicator: Bool // 기본 인디케이터 표시 여부(커스텀 X)
    
    /// 오토 스크롤 설정
    let autoScrollEnabled: Bool // 자동 스크롤 활성화 여부
    let autoScrollInterval: TimeInterval // 3초 간격 자동 스크롤
    @State private var currentIndex = 0 // 현재 페이지
    @State private var timer: Timer? = nil
    
    /// 커스텀 인디케이터 설정
    let customIndicator: Bool
    let customIndicatorSize: CGFloat
    let customIndicatorCurrentColor: Color
    let customIndicatorColor: Color
    let customIndicatorSpacing: CGFloat
    let customIndicatorPadding: CGFloat
    
    /// 커스텀 인티케이터(숫자타입)
    let numIndicator: Bool
    let numIndicatorFont: Font
    let numIndicatorColor: Color
    let numIndicatorBgColor: Color
    let numIndicatorCornerRadius: CGFloat
    let numIndicatorPosition: Position
    
    init(items: [String],
         placeholderImage: UIImage? = nil,
         showIndicator: Bool = true,
         autoScrollEnabled: Bool = true,
         autoScrollInterval: TimeInterval = 3.0,
         customIndicator: Bool = true,
         customIndicatorSize: CGFloat = 8,
         customIndicatorCurrentColor: Color = .primary,
         customIndicatorColor: Color = Color.secondary.opacity(0.3),
         customIndicatorSpacing: CGFloat = 8,
         customIndicatorPadding: CGFloat = 8,
         numIndicator: Bool = true,
         numIndicatorFont: Font = .system(size: 14, weight: .semibold),
         numIndicatorColor: Color = .white,
         numIndicatorBgColor: Color = Color.black.opacity(0.5),
         numIndicatorCornerRadius: CGFloat = 12,
         numIndicatorPosition: Position = .trailingBottom) {
        self.items = items
        self.placeholderImage = placeholderImage
        self.showIndicator = showIndicator
        self.autoScrollEnabled = autoScrollEnabled
        self.autoScrollInterval = autoScrollInterval
        self.customIndicator = customIndicator
        self.customIndicatorSize = customIndicatorSize
        self.customIndicatorCurrentColor = customIndicatorCurrentColor
        self.customIndicatorColor = customIndicatorColor
        self.customIndicatorSpacing = customIndicatorSpacing
        self.customIndicatorPadding = customIndicatorPadding
        self.numIndicator = numIndicator
        self.numIndicatorFont = numIndicatorFont
        self.numIndicatorColor = numIndicatorColor
        self.numIndicatorBgColor = numIndicatorBgColor
        self.numIndicatorCornerRadius = numIndicatorCornerRadius
        self.numIndicatorPosition = numIndicatorPosition
    }
    
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
