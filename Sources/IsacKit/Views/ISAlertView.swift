//
//  SwiftUIView.swift
//  IsacKit
//
//  Created by shinisac on 8/4/25.
//

import SwiftUI

@available(iOS 14.0, *)
public struct ISAlertView: View {
    enum ISAlertType {
        case ok
        case cancel
        case confirm
    }
    
    @State var dividerHeight: CGFloat = 0
    @Binding var isPresented: Bool
    var alertType: ISAlertType
    var title: String?
    var message: String?
    var customView: AnyView?
    var okAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    init(
        alertType: ISAlertType = .ok,
        title: String? = nil,
        customView: AnyView? = nil,
        message: String? = nil,
        isPresented: Binding<Bool>,
        okAction: (() -> Void)? = nil,
        cancelAction: (() -> Void)? = nil
    ) {
        self.alertType = alertType
        self.title = title
        self.message = message
        self.customView = customView
        self._isPresented = isPresented
        self.okAction = okAction
        self.cancelAction = cancelAction
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.black.opacity(0.48))
                        .padding(12)
                }
            }
            
            if let title = title {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                Spacer().frame(height: 12)
            }
            
            if let customView = customView {
                customView
                Spacer().frame(height: 12)
            }
            
            if let message = message {
                Text(message)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.black.opacity(0.58))
                Spacer().frame(height: 12)
            }
            
            Divider()
            
            getAlertButtonView(alertType, dividerHeight: $dividerHeight)
                .onPreferenceChange(SizePreferenceKey.self) { value in
                    dividerHeight = value.height
                }
            
        }
        .frame(maxWidth: .infinity)
        .border(Color.black.opacity(0.12), width: 1)
        
    }
    
    private func getAlertButtonView(_ alertType: ISAlertType = .ok,
                                    dividerHeight: Binding<CGFloat>) -> some View {
        
        switch alertType {
        case .ok:
            return AnyView(
                Button {
                    okAction?()
                } label: {
                    Text("확인")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity)
                }
            )
        case .cancel:
            return AnyView(
                Button {
                    cancelAction?()
                } label: {
                    Text("취소")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity)
                }
            )
        case .confirm:
            return AnyView(
                
                HStack {
                    Button {
                        okAction?()
                    } label: {
                        Text("확인")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity)
                    }
                    .measureSize()
                    
                    Divider()
                        .frame(height: dividerHeight.wrappedValue)
                    
                    Button {
                        cancelAction?()
                    } label: {
                        Text("취소")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black.opacity(0.48))
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity)
                    }
                }
            )
        }
    }
}

@available(iOS 14.0, *)
#Preview {
    ISAlertView(
        alertType: .confirm,
        title: "Alert Title 입니다",
        customView: AnyView(
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
        ),
        message: "Alert Message 입니다",
        isPresented: .constant(true),
        okAction: {
            print("OK Action")
        },
        cancelAction: {
            print("Cancel Action")
        }
    )
}
