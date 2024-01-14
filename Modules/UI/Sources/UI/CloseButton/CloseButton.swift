//
//  SwiftUIView.swift
//  
//
//  Created by Dev on 14.01.24.
//

import SwiftUI

public struct CloseButton: View {
    
    public init() {}
    
    public var body: some View {
        Image(systemName: "xmark.circle.fill")
            .resizable()
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white, .black)
            .frame(width: 33, height: 33)
            .overlay(Circle().stroke(lineWidth: 0.5).fill(.red))
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 24)
            .padding(.top)
            .ignoresSafeArea()
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton()
    }
}
