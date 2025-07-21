//
//  SwiftUIView.swift
//  IsacKit
//
//  Created by shinisac on 7/15/25.
//

import SwiftUI

@available(iOS 14.0, *)
public struct SubView<Content: View>: Identifiable {
    public let id = UUID()
    public let content: AnyView
    
    public init<V: View>(@ViewBuilder content: () -> V) {
        self.content = AnyView(content())
    }
}

@available(iOS 14.0, *)
public struct ImageHeaderScrollV<Content: View>: View {
    @State private var offsetY: CGFloat = CGFloat.zero
    
    let imageUrlString: String // 이미지 URL
    let placeholderImage: UIImage? = nil // 기본 이미지
    let imageHeight: CGFloat = 250 // 이미지 높이
    let imageSubView: SubView<Content> // 이미지뷰 위에 표시될 뷰
    let stickyHeaderView: SubView<Content> // 고정 헤더 뷰
    let contentView: [SubView<Content>] // 스크롤뷰 아래에 표시될 콘텐츠
    var isStickyHeader: Bool = false // 고정 여부
    
    public var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let offset = geometry.frame(in: .global).minY
                setOffset(offset: offset)
                ZStack(alignment: .bottom) {
                    URLImageView(urlString: imageUrlString,
                                 placeholderImage: placeholderImage)
                    .overlay(Color.white.opacity(min(1, max(0, -offsetY / 100))))
                    
                    imageSubView.content
                    
                }
                .frame(
                    width: geometry.size.width,
                    height: imageHeight + (offset > 0 ? offset : 0)
                )
                .offset(y: (offset > 0 ? -offset : 0))
            }
            .frame(minHeight: imageHeight)
            
            if isStickyHeader {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section(header: stickyHeaderView.content) {
                        listVStackView(contentView: contentView)
                    }
                }
            } else {
                LazyVStack {
                    listVStackView(contentView: contentView)
                }
            }
            
        }
        .overlay(
            Rectangle()
                .foregroundColor(.white)
                .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                .edgesIgnoringSafeArea(.all)
                .opacity(min(1, max(0, (-offsetY) / 100)))
            , alignment: .top
        )
    }
    
    func listVStackView(contentView: [SubView<Content>]) -> some View {
        VStack {
            ForEach(contentView, id: \.id) { subView in
                subView.content
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
        }
    }
    
    func setOffset(offset: CGFloat) -> some View {
        DispatchQueue.main.async {
            print("Offset: \(offset)")
            self.offsetY = offset
        }
        return EmptyView()
    }
}

@available(iOS 14.0, *)
#Preview {
    ImageHeaderScrollV<AnyView>(imageUrlString: "https://picsum.photos/375/250",
                                imageSubView: SubView(content: {
        Text("Example Image Header")
            .foregroundColor(.white)
            .font(.title)
            .fontWeight(.bold)
            .padding(.vertical, 20)

    }),
                                stickyHeaderView: SubView(content: {
        VStack {
            Spacer()
            Text("Example Sticky Header")
                .fontWeight(.bold)
            Text("Sticky")
            Spacer()
            Divider()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 52)
        .background(Rectangle().foregroundColor(.white))
    }),
                                contentView: [
                                    SubView(content: {
                                        ZStack {
                                            Image("title")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                                .frame(height: 250)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            RoundedRectangle(cornerRadius: 12)
                                                .foregroundColor(.black)
                                                .opacity(0.5)
                                            Text("title")
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                    }),
                                    SubView(content: {
                                        ZStack {
                                            Image("title")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                                .frame(height: 250)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            RoundedRectangle(cornerRadius: 12)
                                                .foregroundColor(.black)
                                                .opacity(0.5)
                                            Text("title")
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                    }),
                                    SubView(content: {
                                        ZStack {
                                            Image("title")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                                .frame(height: 250)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            RoundedRectangle(cornerRadius: 12)
                                                .foregroundColor(.black)
                                                .opacity(0.5)
                                            Text("title")
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                    }),
                                    SubView(content: {
                                        ZStack {
                                            Image("title")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                                .frame(height: 250)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            RoundedRectangle(cornerRadius: 12)
                                                .foregroundColor(.black)
                                                .opacity(0.5)
                                            Text("title")
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                    })
                                ])
}
