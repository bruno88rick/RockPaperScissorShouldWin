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
    @State private var score = 0
    @State private var machineMoveAnimation = 1.0
    @State private var showingGameOver = false
    @State private var showingResult = false
    @State private var showingMatchButton = false
    @State private var userChoiceIsCorrect = false
    @State private var updateMachineMovement = false
    @State private var fadeInOutAnimation = false
    @State private var ShowigResultFrame = true
    @State private var blurEveryThing = false
   
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Movimento da máquina:")
                    .font(.system(size: 22).bold())
                    .foregroundColor(.primary)
                    .blur(radius: blurEveryThing ? 3 : 0, opaque: false)
                Button {
                    machineMoveChange()
                    showingResult = false
                } label: {
                    Text(moves[machineMove])
                        .font(.system(size: 200))
                        .overlay(
                            Circle()
                                .stroke(.cyan)
                                .scaleEffect(machineMoveAnimation)
                                .opacity(2 - machineMoveAnimation)
                                .animation(
                                    .easeOut(duration: 1)
                                    .repeatForever(autoreverses: false),
                                    value: machineMoveAnimation
                                )
                        )
                }
                .blur(radius: blurEveryThing ? 3 : 0, opaque: false)
                Text("Movimento da máquina atualizado!")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .hiddenConditionally(isHidden: updateMachineMovement)
                    .onAppear() {
                        withAnimation(Animation.easeInOut(duration: 0.6)
                        .repeatCount(2, autoreverses: true)) {
                            fadeInOutAnimation.toggle()
                        }
                    }.opacity(fadeInOutAnimation ? 0 : 1)
                    .hiddenConditionally(isHidden: updateMachineMovement)
                    .blur(radius: blurEveryThing ? 3 : 0, opaque: false)
                    
                Spacer()
                ZStack {
                    Text(userChoiceIsCorrect ? "Parabéns Você acertou!" : "Ih... escolha errada!")
                        .font(.system(size: 30).bold())
                        .foregroundStyle(userChoiceIsCorrect ? .mint : .brown)
                        .hiddenConditionally(isHidden: showingResult)
                    ProgressView("Esperando sua Jogada...")
                        .hiddenConditionally(isHidden: !showingResult)
                }
                HStack {
                    Button {
                        showingMatchButton = false
                        machineMoveChange()
                        shouldWin = Bool.random()
                        withAnimation() {
                            showingResult = false
                            blurEveryThing = false
                        }
                        
                    } label: {
                        Text("Contiuar...")
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
                    .blur(radius: blurEveryThing ? 3 : 0, opaque: false)
                HStack(alignment: .center, spacing: 80) {
                    ForEach(0..<3) { number in
                        Button {
                            gameLogic(userChoice: number)
                            machineMoveChange()
                            updateMachineMovement = false
                        } label: {
                            Text(moves[number])
                                .font(.system(size: 50))
                        }
                    }
                }
                .blur(radius: blurEveryThing ? 3 : 0, opaque: false)
                Spacer()
                Text("Pontuação: \(score)")
                    .font(.system(size: 30).bold())
            }
            .padding()
            .toolbar {
                Button("Reiniciar Game", action: resetGame)
                    .foregroundStyle(.red)
            }
            .onAppear {
                machineMoveAnimation = 2
            }
        }
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
            withAnimation() {
                showingResult = true
                blurEveryThing = true
            }
            showingMatchButton = true
            score += 1
            numberOfQuestion += 1
        } else {
            userChoiceIsCorrect = false
            withAnimation() {
                showingResult = true
                blurEveryThing = true
            }
            showingMatchButton = true
            score -= 1
            numberOfQuestion += 1
        }
        
        if numberOfQuestion == 11 {
            showingGameOver = true
        }
    }
    
    func machineMoveChange() {
        machineMove = Int.random(in: 0..<3)
        updateMachineMovement = true
    }
    
    func resetGame() {
        shouldWin = Bool.random()
        machineMove = Int.random(in: 0..<3)
        numberOfQuestion = 1
        showingGameOver = false
        withAnimation() {
            showingResult = false
            blurEveryThing = false
        }
        showingMatchButton = false
        updateMachineMovement = false
        score = 0
    }
}

#Preview {
    ContentView()
}
