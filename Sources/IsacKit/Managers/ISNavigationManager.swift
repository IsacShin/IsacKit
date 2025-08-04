//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/15/25.
//

import SwiftUI
/*
 - ISNavigationStackManager.swift
    - 싱글톤 패턴을 사용하여 앱 전역에서 네비게이션 상태를 관리하는 클래스입니다.
    - NavigationPath를 사용하여 현재 네비게이션 경로를 추적합니다.
    - 주요 기능
        - push: 새로운 뷰를 네비게이션 스택에 추가합니다.
        - pop: 현재 뷰를 네비게이션 스택에서 제거합니다.
        - popToRoot: 네비게이션 스택을 루트 뷰로 되돌립니다.
    - Example
    struct RootView: View {
        @StateObject private var navManager = NavigationManager.shared

        var body: some View {
            NavigationStack(path: $navManager.path) {
                VStack {
                    Button("Go to Detail") {
                        navManager.push("DetailView")
                    }
                }
                .navigationDestination(for: String.self) { value in
                    if value == "DetailView" {
                        Text("This is Detail View")
                    }
                }
            }
        }
    }
 */
@available(iOS 16.0, *)
@MainActor
public final class ISNavigationStackManager: ObservableObject {
    public static let shared = ISNavigationStackManager() // 싱글톤 인스턴스
    
    @Published var path = NavigationPath()
    
    private init() {}
    
    public func push<T: Hashable>(_ value: T) {
        path.append(value)
    }
    
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
}

@available(iOS 13.0, *)
@MainActor
final class ISNavigationManager: ObservableObject {
    static let shared = ISNavigationManager()
    
    @Published private(set) var viewStack: [ViewItem] = []
    
    private init() {}
    
    struct ViewItem: Identifiable, Equatable {
        let id: String
        let view: AnyView
        let presentationStyle: PresentationStyle
        
        enum PresentationStyle {
            case navigationLink
            case sheet
            case fullScreenCover
        }

        static func == (lhs: ViewItem, rhs: ViewItem) -> Bool {
            lhs.id == rhs.id
        }
    }

    var activeView: ViewItem? {
        viewStack.last
    }

    func push<V: View>(_ view: V, id: String, style: ViewItem.PresentationStyle = .navigationLink) {
        if !viewStack.contains(where: { $0.id == id }) {
            let item = ViewItem(id: id, view: AnyView(view), presentationStyle: style)
            viewStack.append(item)
        }
    }

    func pop() {
        _ = viewStack.popLast()
    }

    func popToRoot() {
        viewStack.removeAll()
    }
}
