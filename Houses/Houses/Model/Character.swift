//
//  Character.swift
//  Houses
//
//  Created by Vishal Kundaliya on 22/01/25.
//

import Foundation

struct Character: Codable, Identifiable {
    let id = UUID()
    let name: String
    let image: String?
    let species: String?
    let gender: String?
    let house: String?
    let dateOfBirth: String?
    let hogwartsStaff: Bool

    enum CodingKeys: String, CodingKey {
        case name, image, species, gender, house, dateOfBirth, hogwartsStaff
    }
}
