//
//  Vocab.swift
//  duzhe
//
//  Created by Bill Glover on 04/02/2021.
//

import Foundation
import FirebaseFirestoreSwift

struct Vocab: Identifiable, Codable {
    @DocumentID var id: String?
    var language: String
    var writing: String
    var reading: String?
    var definition: String?
    var heisigDefinition: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case language = "lang"
        case writing = "writing"
        case reading = "reading"
        case definition = "toughnessString"
        case heisigDefinition = "heisigDefinition"
    }
}
