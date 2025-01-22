//
//  CharacterListViewModel.swift
//  Houses
//
//  Created by Vishal Kundaliya on 22/01/25.
//


import Foundation
import Observation
import SwiftUI

@Observable
class CharacterListViewModel {
    var characters: [Character] = []
    var isLoading = false
    var currentPage = 1
    let pageSize = 10
    var cache: [String: [Character]] = [:]

    func backgroundColor(for house: HouseType) -> Color {
        switch house {
        case .gryffindor: return .red
        case .slytherin: return .green
        case .ravenclaw: return .blue
        case .hufflepuff: return .yellow
        }
    }
    
    func fetchCharacters(house: String) async {
        if let cachedData = cache[house], !cachedData.isEmpty {
            self.characters = cachedData
            return
        }
        
        guard !isLoading else { return }
        isLoading = true
        
        let urlString = "https://hp-api.herokuapp.com/api/characters/house/\(house)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([Character].self, from: data)
            self.characters = Array(decodedData.prefix(pageSize))
            self.cache[house] = self.characters
        } catch {
            print(error.localizedDescription)
        }
        
        isLoading = false
    }
    
    func loadMoreCharacters(house: String) async {
        guard !isLoading else { return }
        isLoading = true
        
        let urlString = "https://hp-api.herokuapp.com/api/characters/house/\(house)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([Character].self, from: data)
            
            await MainActor.run {
                let startIndex = self.characters.count
                let endIndex = startIndex + pageSize
                let newCharacters = Array(decodedData[startIndex..<min(endIndex, decodedData.count)])
                
                self.characters.append(contentsOf: newCharacters)
            }
        } catch {
            print("Error fetching more data: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func refreshCharacters(house: String) async {
        cache.removeValue(forKey: house)
        characters.removeAll()
        await fetchCharacters(house: house)
    }
    
    func dateConverter(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let birthDate: Date? = dateFormatter.date(from: dateStr)
        
        if let birthDate = birthDate {
            var dateFormatterStr: DateFormatter {
                 let formatter = DateFormatter()
                 formatter.dateStyle = .medium
                 formatter.timeStyle = .none
                 return formatter
             }
            
            return dateFormatterStr.string(from: birthDate)
        }
        return nil
    }
}
