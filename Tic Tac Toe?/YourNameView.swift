//
//  YourNameView.swift
//  Tic Tac Toe?
//
//  Created by Harish on 7/14/23.
//

import SwiftUI

struct YourNameView: View {
    @AppStorage("yourName") var yourName = ""
    @State private var userName = ""
    var body: some View {
        VStack {
            Text("Your device name?")
            TextField("Your Name", text: $userName)
                .textFieldStyle(.roundedBorder)
            Button("Set") {
                yourName = userName
            }
            .buttonStyle(.borderedProminent)
            .disabled(userName.isEmpty)
            Image("sub")
                .resizable()
                .scaledToFit()
            Spacer()
        }
        .padding()
        .navigationTitle("Tic Tac Toe?")
        .inNavigationStack()
    }
}

struct YourNameView_Previews: PreviewProvider {
    static var previews: some View {
        YourNameView()
    }
}
