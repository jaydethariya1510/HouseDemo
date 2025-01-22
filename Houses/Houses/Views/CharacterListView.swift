//
//  CharacterListView.swift
//  Houses
//
//  Created by Vishal Kundaliya on 22/01/25.
//

import SwiftUI


struct CharacterCellView: View {
    var keys: String
    var value: String?
    var bgColor: Color?
    var fgColor: Color = .black
    
    var body: some View {
        HStack(spacing: 0) {
            Text(keys)
                .font(.system(size: 16, weight: .medium))
                .padding(6)
                .frame(maxWidth: .infinity)
                .border(.black, width: 1)
            Text(value ?? "")
                .foregroundStyle(fgColor)
                .font(.system(size: 16, weight: .medium))
                .padding(6)
                .frame(maxWidth: .infinity)
                .background(bgColor ?? .clear)
                .border(.black, width: 1)
        }
    }
}

struct CharacterListView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = CharacterListViewModel()
    let house: HouseType
    
    var body: some View {
        VStack {
            HStack(spacing: 18) {
                Image(systemName: "arrow.backward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .onTapGesture { dismiss() }
                
                Text(house.name)
                    .font(.system(size: 20, weight: .medium))
                Spacer()
            }
            .padding()
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.characters) { character in
                        CharacterRowView(character: character, house: house, viewModel: viewModel)
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    } else {
                        Button("Load More") {
                            Task {
                                await viewModel.loadMoreCharacters(house: house.name.lowercased())
                            }
                        }
                        .padding()
                    }
                }
            }
            .refreshable {
                await viewModel.refreshCharacters(house: house.name.lowercased())
            }
        }
        .task {
            await viewModel.fetchCharacters(house: house.name.lowercased())
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct CharacterRowView: View {
    var character: Character
    let house: HouseType
    let viewModel: CharacterListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Text(character.name)
                    .font(.title3)
                    .padding(12)
                if character.hogwartsStaff {
                    Image(systemName: "graduationcap")
                }
            }
            .foregroundStyle(.white)
            
            VStack(spacing: 0) {
                AsyncImage(url: URL(string: character.image ?? "")) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 250)
                .padding(.vertical, 8)
                
                VStack(spacing: 0) {
                    CharacterCellView(keys: "Species", value: character.species)
                    CharacterCellView(keys: "Gender", value: character.gender)
                    CharacterCellView(keys: "House", value: character.house, bgColor: viewModel.backgroundColor(for: house), fgColor: .white)
                    if let dob = character.dateOfBirth {
                        CharacterCellView(keys: "Date of Birth", value: viewModel.dateConverter(dateStr: dob))
                    }
                }
                .padding([.horizontal, .bottom], 12)
            }
            .background(Color.white)
            .padding(6)
        }
        .background(viewModel.backgroundColor(for: house))
        .padding()
    }
}
