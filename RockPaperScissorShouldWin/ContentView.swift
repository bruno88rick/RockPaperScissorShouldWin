//
//  ContentView.swift
//  RockPaperScissorShouldWin
//
//  Created by Bruno Oliveira on 03/02/24.
//

import SwiftUI

extension View {
    func hiddenConditionally(isHidden: Bool) -> some View {
        isHidden ? AnyView(self) : AnyView(self.hidden())
    }
}

struct ContentView: View {
    let moves = ["👊🏻", "🖐🏻", "✌🏻"]
    
    @State private var shouldWin = Bool.random()
    @State private var machineMove = Int.random(in: 0..<3)
    @State private var userMove = 0
    @State private var numberOfQuestion = 1
    @State private var showingGameOver = false
    @State private var showingResult = false
    @State private var updateMachineMovement = false
    @State private var score = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Movimento da máquina:")
                .font(.system(size: 22).bold())
                .foregroundColor(.primary)
            Button {
                
            } label: {
                Text(moves[machineMove])
                    .font(.system(size: 200))
            }
            Text("Movimento da máquina atualizado!")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .hiddenConditionally(isHidden: updateMachineMovement)
            Spacer()
            ZStack {
                Text("Parabéns! Você Ganhou!")
                    .font(.system(size: 30).bold())
                    .hiddenConditionally(isHidden: showingResult)
                ProgressView()
                    .hiddenConditionally(isHidden: !showingResult)
            }
            Spacer()
            Spacer()
            Text(shouldWin ? "Você precisa Ganhar! Escolha:": "Você precisa Perder! Escolha:")
                .font(.system(size: 20).bold())
                .foregroundStyle(shouldWin ? .green : .red)
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 80) {
                ForEach(moves, id: \.self) { number in
                    Button {
                        
                    } label: {
                        Text(number)
                            .font(.system(size: 50))
                    }
                }
            }
            Spacer()
            Text("Score: \(score)")
                .font(.system(size: 30).bold())
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
