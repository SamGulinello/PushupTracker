//
//  SwiftUIView.swift
//  Pushup Tracker
//
//  Created by Sam Gulinello on 2/9/22.
//

import SwiftUI

struct IncrementButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0.99, green: 0.34, blue: 0.39))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}
