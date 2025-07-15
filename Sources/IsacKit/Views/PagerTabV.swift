//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/9/25.
//

import SwiftUI

@available(iOS 14.0, *)
public struct TabItem<Content: View>: Identifiable {
    public let id = UUID()
    public let title: String
    public let content: AnyView

    public init<V: View>(title: String, @ViewBuilder content: () -> V) {
        self.title = title
        self.content = AnyView(content())
    }
}

@available(iOS 14.0, *)
public struct PagerTabV<Content: View>: View {
    @State private var currentIndex = 0
    public let tabs: [TabItem<Content>]
    public let titleColor: Color
    public let selectedTitleColor: Color
    public let titleFont: Font
    public let indicatorColor: Color
    
    init(tabs: [TabItem<Content>],
         titleColor: Color = .secondary,
         selectedTitleColor: Color = .black,
         titleFont: Font = .system(size: 16, weight: .semibold),
         indicatorColor: Color = .black) {
        self.tabs = tabs
        self.titleColor = titleColor
        self.selectedTitleColor = selectedTitleColor
        self.titleFont = titleFont
        self.indicatorColor = indicatorColor
    }

    public var body: some View {
        VStack(spacing: 0) {
            PagerTabBarV(currentIndex: $currentIndex,
                         tabs: tabs.map { $0.title },
                         titleColor: titleColor,
                         selectedTitleColor: selectedTitleColor,
                         titleFont: titleFont,
                         indicatorColor: indicatorColor)

            TabView(selection: $currentIndex) {
                ForEach(tabs.indices, id: \.self) { index in
                    tabs[index].content
                        .tag(index)
                        .frame(maxHeight: .infinity)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Spacer()
        }
    }
}

@available(iOS 14.0, *)
public struct PagerTabBarV: View {
    @Binding var currentIndex: Int // 현재페이지
    public let tabs: [String] // 화면 리스트
    public let titleColor: Color
    public let selectedTitleColor: Color
    public let titleFont: Font
    public let indicatorColor: Color
    @State private var tabFrames: [Int: CGRect] = [:]
    public var body: some View {
        // 탭 버튼
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            NonBouncingScrollView(.horizontal) {
                HStack(spacing: 20) {
                    Spacer().frame(width: 0)
                    ForEach(tabs.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                currentIndex = index
                            }
                            print("currentIndex set to \(index)")

                        }) {
                            Text(tabs[index])
                                .foregroundColor(currentIndex == index ? selectedTitleColor : titleColor)
                                .font(titleFont)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 0)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .preference(key: TabItemPreferenceKey.self,
                                                        value: [index: geo.frame(in: .named("TabBarSpace"))])
                                    }
                                )
                        }
                    }
                }
                .onPreferenceChange(TabItemPreferenceKey.self) { value in
                    self.tabFrames = value
                }
            }
            
            if let frame = tabFrames[currentIndex] {
                indicatorColor
                    .frame(width: frame.width, height: 2)
                    .offset(x: frame.minX, y: 0)
                    .animation(.easeInOut, value: currentIndex)
            }
            
            // 그림자 설정
            Color.black.opacity(0.1).frame(height: 1)
                .shadow(color: Color.black, radius: 1, x: 1, y: 1)
        }
        .frame(height: 54)
    }
}

// PreferenceKey to measure tab frames
private struct TabItemPreferenceKey: PreferenceKey {
    static let defaultValue: [Int: CGRect] = [:]
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

@available(iOS 14.0, *)
#Preview {
    PagerTabV<AnyView>(tabs: [
        TabItem(title: "Tab 1") {
            Text("Content for Tab 1")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red.opacity(0.3))
        },
        TabItem(title: "Tab 2") {
            Text("Content for Tab 2")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.green.opacity(0.3))
        },
        TabItem(title: "Tab 3") {
            Text("Content for Tab 3")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.opacity(0.3))
        }
    ])
}
