//
//  ContentView.swift
//  catchKenny
//
//  Created by Mehmet Tuna Arıkaya on 17.09.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var score = 0
    @State private var timeLeft = 10.0
    @State private var chosenPosition = (x: 200, y: 100)
    @State private var showAlert = false
    
    // Position tuples
    private let positions: [(x: Int, y: Int)] = [
        (200, 100), (70, 100), (330, 100), (200, 270), (70, 270), (330, 270),
        (200, -100), (70, -100), (330, -100)
    ]
    
    private var counterTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeLeft <= 0 {
                self.showAlert = true
            } else {
                self.timeLeft -= 1
            }
        }
    }
    
    private var positionTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.chosenPosition = self.randomPosition()
        }
    }
    
    private func randomPosition() -> (x: Int, y: Int) {
        let previousPosition = self.chosenPosition
        var newPosition: (x: Int, y: Int)
        
        repeat {
            newPosition = positions.randomElement()!
        } while newPosition == previousPosition
        
        return newPosition
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 130)
            
            Text("Catch The Kenny")
                .font(.largeTitle)
            
            HStack {
                Text("Time Left: ")
                    .font(.title)
                Text(String(format: "%.0f", self.timeLeft))
                    .font(.title)
            }
            
            HStack {
                Text("Score: ")
                    .font(.title)
                Text(String(self.score))
                    .font(.title)
            }
            
            Spacer()
            
            Image("kenny")
                .resizable()
                .frame(width: 100, height: 130)
                .position(x: CGFloat(self.chosenPosition.x), y: CGFloat(self.chosenPosition.y))
                .gesture(TapGesture().onEnded {
                    self.score += 1
                })
                .onAppear {
                    _ = self.positionTimer
                    _ = self.counterTimer
                }
            
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Time Over!"),
                message: Text("Want to Play Again?"),
                primaryButton: .default(Text("OK")) {
                    self.score = 0
                    self.timeLeft = 10.0
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
