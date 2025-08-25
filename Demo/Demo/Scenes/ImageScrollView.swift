//
//  ImageScrollView.swift
//  Demo
//
//  Created by shinisac on 8/22/25.
//

import SwiftUI
import IsacUIComponent

struct ImageScrollView: View {
    var body: some View {
        IsacImageHeaderScrollView<AnyView>(imageUrlString: "https://picsum.photos/375/250",
                                    imageSubView: IsacSubView(content: {
            Text("Example Image Header")
                .foregroundColor(.white)
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 20)

        }),
                                    stickyHeaderView: IsacSubView(content: {
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
                                        IsacSubView(content: {
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
                                        IsacSubView(content: {
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
                                        IsacSubView(content: {
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
                                        IsacSubView(content: {
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
}

#Preview {
    ImageScrollView()
}
