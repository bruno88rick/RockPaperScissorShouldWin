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
    @State private var showingMatchButton = false
    @State private var userChoiceIsCorrect = false
    @State private var updateMachineMovement = false
    @State private var score = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Movimento da máquina:")
                .font(.system(size: 22).bold())
                .foregroundColor(.primary)
            Button {
                machineMoveChange()
                updateMachineMovement = true
                showingResult = false
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
                Text(userChoiceIsCorrect ? "Parabéns Você acertou!" : "Ih... escolha errada!")
                    .font(.system(size: 30).bold())
                    .hiddenConditionally(isHidden: showingResult)
                    .foregroundStyle(userChoiceIsCorrect ? .mint : .brown)
                ProgressView()
                    .hiddenConditionally(isHidden: !showingResult)
            }
            HStack {
                Button {
                    showingMatchButton = false
                    machineMoveChange()
                    shouldWin = Bool.random()
                } label: {
                    Text("Próxima Partida")
                }
                .frame(width: 200, height: 50)
                .foregroundStyle(.white)
                .font(.system(size:20).bold())
                .background(.blue)
                .clipShape(.rect(cornerRadius: 20, style: .circular))
                .alert("GameOver", isPresented: $showingGameOver){
                    Button("Reiniciar Jogo", action: resetGame)
                } message: {
                    Text("Sua pontuação foi de \(score) pontos!")
                }
            }
            .hiddenConditionally(isHidden: showingMatchButton)
            
            Spacer()
            Text(shouldWin ? "Qual irá ganhar da I.A.?": "Qual irá perder p/ a I.A.?")
                .font(.system(size: 25).bold())
                .foregroundStyle(shouldWin ? .green : .red)
            HStack(alignment: .center, spacing: 80) {
                ForEach(0..<3) { number in
                    Button {
                        gameLogic(userChoice: number)
                        updateMachineMovement = false
                    } label: {
                        Text(moves[number])
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
    
    func gameLogic (userChoice: Int) {
        let winnerMove = [1, 2, 0]
        let didWin: Bool
        
        if shouldWin {
            didWin = userChoice == winnerMove[machineMove]
        } else {
            didWin = winnerMove[userChoice] == machineMove
        }
        
        if didWin {
            userChoiceIsCorrect = true
            showingResult = true
            showingMatchButton = true
            score += 1
            numberOfQuestion += 1
        } else {
            userChoiceIsCorrect = false
            showingResult = true
            showingMatchButton = true
            score -= 1
            numberOfQuestion += 1
        }
        
        if numberOfQuestion == 8 {
            showingGameOver = true
        }
    }
    
    func machineMoveChange() {
        machineMove = Int.random(in: 0..<3)
    }
    
    func resetGame() {
        shouldWin = Bool.random()
        machineMove = Int.random(in: 0..<3)
        numberOfQuestion = 1
        showingGameOver = false
        showingResult = false
        showingMatchButton = false
        updateMachineMovement = false
        score = 0
    }
}

#Preview {
    ContentView()
}
