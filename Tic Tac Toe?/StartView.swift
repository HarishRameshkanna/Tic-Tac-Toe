//
//  ContentView.swift
//  Tic Tac Toe?
//
//  Created by Harish on 7/9/23.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var game: GameService
    @StateObject var connectionManager: MPConnectionManager
    @State private var gameType: GameType = .undetermined
    @AppStorage("yourName") var yourName = ""
    @State private var opponentName = ""
    @FocusState private var focus: Bool
    @State private var startGame = false
    @State private var changeName = false
    @State private var newName = ""
    init(yourName: String) {
        self.yourName = yourName
        _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName))
    }
    var body: some View {
        VStack {
            Picker("Select Game", selection: $gameType) {
                Text("Game Type").tag(GameType.undetermined)
                Text("1v1").tag(GameType.single)
                Text("Bots").tag(GameType.bot)
                Text("1v1 Nearby").tag(GameType.peer)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20, style:.continuous).stroke(lineWidth:0))
            Text(gameType.description)
                .padding()
            VStack {
                switch gameType {
                case .single:
                    VStack{
                        TextField("Opponent Name", text: $opponentName)
                    }
                case .bot:
                    EmptyView()
                case .peer:
                    mpppersview(startGame: $startGame)
                        .environmentObject(connectionManager)
                case .undetermined:
                    EmptyView()
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .focused($focus)
            .frame(width: 350)
            if gameType != .peer {
                Button("Play") {
                    game.setupGame(gameType: gameType, player1Name: yourName, player2Name: opponentName)
                    focus = false
                    startGame.toggle()
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    gameType == .undetermined ||
                    gameType == .single &&  opponentName.isEmpty
                )
                
                Image("sub")
                    .resizable()
                    .scaledToFit()
                Text("Your name is \(yourName)")
                Button("Change my name") {
                    changeName.toggle()
                }
                .buttonStyle(.bordered)
                
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Tic Tac Toe?")
        .fullScreenCover(isPresented: $startGame) {
            GameView()
                .environmentObject(connectionManager)
        }
        .alert("Change Name", isPresented: $changeName, actions: { TextField("New Name", text: $newName)
            Button("OK", role: .destructive) {
                yourName = newName
                exit(-1)
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Clicking the OK button will exit the app so you can relaunch it and use your changed name.")
        })
        .inNavigationStack()
    }
}


struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(yourName: "Sample")
            .environmentObject(GameService())
    }
}
