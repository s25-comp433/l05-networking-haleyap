//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct GameResponse: Codable {
    var results: [Game]
}

struct Game: Codable {
    struct Score: Codable {
        var unc: Int
        var opponent: Int
    }

    var opponent: String
    var id: Int
    var score: Score
    var team: String
    var date: String
    var isHomeGame: Bool
}

struct ContentView: View {
    @State private var games = [Game]()
    var body: some View {
        List(games, id: \.id) { game in
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("UNC vs. \(game.opponent)")
                    Text("\(game.team)")
                        .font(.footnote)
                    Text("\(game.date)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack(alignment: .center) {
                        if game.score.unc > game.score.opponent {
                            Image(systemName: "checkmark.circle")
                                .foregroundStyle(.green)
                        } else {
                            Image(systemName: "x.circle")
                                .foregroundStyle(.red)
                        }
                        Text("\(game.score.unc) - \(game.score.opponent)")
                    }
                    Text(game.isHomeGame ? "Home" : "Away")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .listRowBackground(game.team == "Men" ? Color.gray.opacity(0.2) : Color.clear)
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([Game].self, from: data) {
                DispatchQueue.main.async {
                    games = decodedResponse
                }
            } else {
                print("Fail")
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
