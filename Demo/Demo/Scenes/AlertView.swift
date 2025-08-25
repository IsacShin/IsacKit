//
//  AlertView.swift
//  Demo
//
//  Created by shinisac on 8/22/25.
//

import SwiftUI
import IsacUIComponent

struct AlertView: View {
    private enum AlertType: CaseIterable {
        case ok
        case cancel
        case confirm
    }

    @State private var isShowAlert = false
    @State private var alertType: AlertType = .ok
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ForEach(AlertType.allCases, id: \.self) { type in
                    Button {
                        alertType = type
                        withAnimation {
                            isShowAlert.toggle()
                        }
                    } label: {
                        Text("\(type.self) Button")
                    }
                }
            }
            
            if isShowAlert {
                IsacAlertView(alertType: getAlertType(),
                              title: "Title",
                              message: "This is a demo alert view. You can customize it as needed.",
                              isPresented: $isShowAlert,
                              okAction: {
                    withAnimation {
                        isShowAlert.toggle()
                    }
                }, cancelAction: {
                    withAnimation {
                        isShowAlert.toggle()
                    }
                })
                .background(Color.white)
                .padding()
            }
        }
    }
    
    func getAlertType() -> IsacAlertView.IsacAlertType {
        var type: IsacAlertView.IsacAlertType = .ok
        switch alertType {
        case .ok: type = .ok
        case .cancel: type = .cancel
        case .confirm: type = .confirm
        }
        return type
    }
}

#Preview {
    AlertView()
}
