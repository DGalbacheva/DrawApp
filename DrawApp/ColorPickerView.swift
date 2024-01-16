//
//  ColorPickerView.swift
//  DrawApp
//
//  Created by Doroteya Galbacheva on 12.12.2023.
//

import SwiftUI

struct ColorPickerView: View {
    
    @State private var selectedColor: Color = .black
    @State private var selectedThickness: CGFloat = 2.0
    
    var body: some View {
        HStack {
            ColorPicker("Color", selection: $selectedColor)
                .padding()
            
            Slider(value: $selectedThickness, in: 1...10, step: 1)
                .padding()
        }
    }
}
