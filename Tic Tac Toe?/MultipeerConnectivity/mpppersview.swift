//
//  mpppersview.swift
//  Tic Tac Toe?
//
//  Created by Harish on 7/22/23.
//

import SwiftUI

struct mpppersview: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var game: GameService
    @Binding var startGame: Bool
    var body: some View {
        VStack{
            Text("Available Players")
            List(connectionManager.availablePeers, id: \.self) { peer in
                HStack {
                    Text(peer.displayName)
                    Spacer()
                    Button("select") {
                        game.gameType = .peer
                        connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 30)
                        game.player1.name = connectionManager.myPeerId.displayName
                        game.player2.name = peer.displayName
                    }
                    .buttonStyle(.borderedProminent)
                }
                .alert("Revieved Invitation from \(connectionManager.revievedInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManager.recieveInvite) {
                Button ("Accept") {
                    if let inivationHandler = connectionManager.invitiationHandler {
                        inivationHandler(true, connectionManager.session)
                        game.player1.name = connectionManager.revievedInviteFrom?.displayName ?? "Unkown"
                        game.player2.name = connectionManager.myPeerId.displayName
                        game.gameType = .peer
                    }
                }
                    Button("Reject") {
                        if let invitationHandler = connectionManager.invitiationHandler {
                            invitationHandler(false, nil)
                        }
                    }
                }
                
            }
        }
        .onAppear {
            connectionManager.isAvailableToPlay = true
            connectionManager.startBrowsing()
        }
        .onDisappear {
            connectionManager.stopBrowsing()
            connectionManager.stopAdvertising()
            connectionManager.isAvailableToPlay = false
        }
        .onChange(of: connectionManager.paired) { newValue in
            startGame = newValue
        }
    }
}
                            
                            

struct mpppersview_Previews: PreviewProvider {
    static var previews: some View {
        mpppersview(startGame: .constant(false))
            .environmentObject(MPConnectionManager(yourName: "Sample"))
            .environmentObject(GameService())
    }
}
