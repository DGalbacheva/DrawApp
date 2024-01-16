//
//  ContentView.swift
//  DrawApp
//
//  Created by Doroteya Galbacheva on 12.12.2023.
//

import SwiftUI

struct Line: Identifiable {
    var id = UUID()
    var points = [CGPoint]()
    var color: Color
    var thickness: CGFloat = 1.0
}

struct DrawingView: View {
    
    @State private var currentLine = Line(color: .black)
    @State private var lines: [Line] = []
    @State private var selectedColor: Color = .black
    @State private var selectedThickness: CGFloat = 2.0
    @State private var selectedTool: DrawingTool = .freehand
    enum DrawingTool {
        case freehand, straightLine
    }
    
    var body: some View {
        VStack {
            Canvas { context, size in
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)
                    context.stroke(path, with: .color(line.color), lineWidth: line.thickness)
                }
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged({ value in
                    handleDrawing(value: value)
                })
                    .onEnded({ _ in
                        endDrawing()
                    })
            )
            
            HStack(spacing: 10) {
                Picker("", selection: $selectedTool) {
                    Image("curvedLine")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    .tag(DrawingTool.freehand)
                    Image("straightLine")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .tag(DrawingTool.straightLine)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                ColorPicker("Color", selection: $selectedColor)
                
                Slider(value: $selectedThickness, in: 1...10, step: 1)
                Button(action: clearCanvas) {
                    Image("bin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    .padding()
                }
            }
            .padding()
        }
    }
    
    private func handleDrawing(value: DragGesture.Value) {
        let location = value.location
        switch selectedTool {
        case .freehand:
            handleFreehandDrawing(location: location)
        case .straightLine:
            handleStraightLineDrawing(location: location)
        }
    }
    
    private func handleFreehandDrawing(location: CGPoint) {
        currentLine.points.append(location)
    }
    
    private func handleStraightLineDrawing(location: CGPoint) {
        if let start = currentLine.points.last {
            currentLine.points = [start, location]
        } else {
            currentLine.points = [location, location]
        }
    }
    
    private func endDrawing() {
        if !currentLine.points.isEmpty {
            lines.append(currentLine)
        }
        currentLine = Line(color: selectedColor, thickness: selectedThickness)
    }
    
    private func clearCanvas() {
        lines.removeAll()
        currentLine = Line(color: selectedColor, thickness: selectedThickness)
    }
}

struct ContentView: View {
    var body: some View {
        DrawingView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
