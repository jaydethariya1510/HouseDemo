//
//  HouseView.swift
//  Houses
//
//  Created by Vishal Kundaliya on 22/01/25.
//

import SwiftUI

enum HouseType: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case gryffindor
    case slytherin
    case ravenclaw
    case hufflepuff
    
    var img: ImageResource {
        switch self {
        case .gryffindor:
            return .gryffindor
        case .slytherin:
            return .slytherin
        case .ravenclaw:
            return .ravenclaw
        case .hufflepuff:
            return .hufflepuff
        }
    }
    
    var name: String {
        switch self {
        case .gryffindor:
            return "Gryffindor"
        case .slytherin:
            return "Slytherin"
        case .ravenclaw:
            return "Ravenclaw"
        case .hufflepuff:
            return "Hufflepuff"
        }
    }
}

struct HouseView: View {
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    @State var navigationDestination: HouseType?
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Houses".uppercased())
                    .font(.system(size: 30, weight: .bold))
                    .padding()
                ScrollView {
                    Spacer()
                        .frame(height: 10)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(HouseType.allCases) { item in
                            NavigationLink(destination: {
                                CharacterListView(house: item)
                            }) {
                                HouseContainerView(img: item.img, name: item.name)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
        }
    }
}

struct HouseContainerView: View {
    let img: ImageResource
    let name: String
    
    var body: some View {
        VStack {
            Image(img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 170)
                .padding()
            Text(name)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.black)
                .padding()
        }
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1.5)
                .fill(Color.black)
        }
    }
}

#Preview {
    HouseView()
}
