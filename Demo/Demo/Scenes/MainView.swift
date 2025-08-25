//
//  ContentView.swift
//  Demo
//
//  Created by shinisac on 8/22/25.
//

import SwiftUI
import IsacUIComponent
import IsacCore

enum ExampleCase: CaseIterable {
    case isacAlertView
    case isacBannerSlideView
    case isacImageHeaderScrollView
    case isacPagerTabView
    case isacPresentModalView
    case isacTabView
    case isacWebView
    
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .isacAlertView:
            AlertView()
        case .isacBannerSlideView:
            BannerSlideView()
        case .isacImageHeaderScrollView:
            ImageScrollView()
        case .isacPagerTabView:
            PagerTabView()
        case .isacTabView:
            ISTabView()
        case .isacWebView:
            ISWebView()
        default:
            Text("\(self) is not implemented yet.")
                .font(.title)
                .foregroundColor(.gray)
        }
    }
}

struct MainView: View {
    @State private var isPresentingModal = false
    var body: some View {
        IsacNavigationView(navigationTitle: "Example List") {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Spacer()
                            .frame(height: 45)
                        ForEach(ExampleCase.allCases, id: \.self) { example in
                            let title = "\(example.self)".replacingCharacters(in: "\(example.self)".startIndex..."\(example.self)".startIndex, with: "I")
                            Button {
                                if example == .isacPresentModalView {
                                    withAnimation {
                                        isPresentingModal.toggle()
                                    }
                                } else {
                                    IsacNavigationManager.shared.push(
                                        example.destinationView
                                            .navigationBarBackButtonHidden()
                                            .customBackButton(buttonColor: .black,
                                                              action: {
                                                                  IsacNavigationManager.shared.pop()
                                                              }),
                                        id: title,
                                        style: .navigationLink
                                    )
                                }
                                
                            } label: {
                                Text(title)
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                    .padding(8)
                                    .background(Color.orange)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isPresentingModal) {
                IsacPresentModalView(contetnView: AnyView(Text("ModalContent")),
                                     isPresented: $isPresentingModal)
            }
        }
    }
}

#Preview {
    MainView()
}
