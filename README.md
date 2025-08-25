# IsacKit

**IsacKit**은 iOS 개발을 위한 통합 라이브러리로,  
UI 컴포넌트, 네비게이션 관리, 데이터 저장, 네트워크 유틸리티 등을 모듈화하여 제공합니다.  
`IsacUIComponent`, `IsacCore`, `IsacFoundation`, `IsacStorage`, `IsacNetwork` 등을 기반으로 만들어졌으며,  
공통 기능을 빠르고 일관성 있게 사용할 수 있도록 도와줍니다.

---

## 📦 모듈 구성

- **IsacFoundation**  
  - 공통 유틸리티, 타입 확장, 기본 인프라 제공  

- **IsacCore**  
  - 네비게이션 매니저, 로깅, 환경 매니저 등 앱 코어 관리  

- **IsacUIComponent**  
  - Alert, Banner, PagerTab, WebView 등 UI 컴포넌트 제공  

- **IsacStorage**  
  - 로컬 데이터 저장 및 관리 (UserDefaults, SwiftData, CoreData 등 래퍼)  

- **IsacNetwork**  
  - 네트워크 레이어 관리 (APIClient, 요청/응답 로깅, 에러 핸들링)  

- **IsacKit**  
  - 상위 모듈로써 Core / UIComponent / Foundation / Storage / Network 등을 통합  

---

## 🚀 설치

### Swift Package Manager (SPM)

Xcode → Project → Package Dependencies → Add: https://github.com/IsacShin/IsacKit.git

또는 `Package.swift` 에 추가:

```swift
dependencies: [
    .package(url: "https://github.com/IsacShin/IsacKit.git", from: "1.0.0")
]
```
## 📖 사용법 

1. UI 컴포넌트 예시

```swift
import IsacUIComponent

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Show Alert") {
                IsacAlertView(title: "Hello", message: "This is IsacKit!")
                    .show()
            }
            
            ISWebView(url: URL(string: "https://www.apple.com"))
                .frame(height: 300)
        }
    }
}
```

2. 네비게이션 매니저 사용
```swift
import IsacCore

IsacNavigationManager.shared.push(
    Text("Next View"),
    id: "NextView",
    style: .navigationLink
)
```

3. 네트워크 매니저 사용법
```swift
import IsacNetwork
import Combine

// ✅ API Router 정의 (예시)
enum IsacAPIRouter {
    case getUser(id: Int)
    case searchUsers(query: String)
}

extension IsacAPIRouter {
    var baseURL: String { "https://jsonplaceholder.typicode.com" }
    
    var path: String {
        switch self {
        case .getUser(let id):
            return "/users/\(id)"
        case .searchUsers:
            return "/users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser, .searchUsers: return .get
        }
    }
    
    var queryParameters: [URLQueryItem]? {
        switch self {
        case .searchUsers(let query):
            return [URLQueryItem(name: "q", value: query)]
        default:
            return nil
        }
    }
    
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
    
    var body: Data? { nil }
}

// ✅ 모델
struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

var cancellables = Set<AnyCancellable>()


// ✅ 1. Combine 기반 요청
IsacAPIProvider.shared.request(IsacAPIRouter.getUser(id: 1))
    .sink { completion in
        switch completion {
        case .finished:
            print("✅ 요청 완료")
        case .failure(let error):
            print("❌ 에러 발생:", error.localizedDescription)
        }
    } receiveValue: { (user: User) in
        print("받은 사용자:", user)
    }
    .store(in: &cancellables)


// ✅ 2. Async/Await 기반 요청
Task {
    do {
        let user: User = try await IsacAPIProvider.shared.request(IsacAPIRouter.getUser(id: 1))
        print("받은 사용자:", user)
    } catch {
        print("❌ 에러 발생:", error.localizedDescription)
    }
}
```

4. SwiftData 매니저 사용법(iOS 17+)
```swift
import IsacStorage
import SwiftData

// 모델 정의
@Model
final class TodoItem {
    var id: UUID
    var title: String
    var isDone: Bool
    
    init(id: UUID = UUID(), title: String, isDone: Bool = false) {
        self.id = id
        self.title = title
        self.isDone = isDone
    }
}

// 싱글톤 매니저 생성
let manager = IsacSwiftDataManager.makeShared(for: TodoItem.self)

// Create
Task {
    let todo = TodoItem(title: "SwiftData 학습")
    await manager.insert(todo)
}

// Read
Task {
    let todos: [TodoItem] = await manager.fetchAll()
    print("전체 할 일:", todos)
}

// Update
Task {
    if let first = (await manager.fetchAll()).first {
        await manager.update(id: first.id) { item in
            item.isDone = true
        }
    }
}

// Delete
Task {
    if let first = (await manager.fetchAll()).first {
        await manager.delete(first)
    }
}
```
