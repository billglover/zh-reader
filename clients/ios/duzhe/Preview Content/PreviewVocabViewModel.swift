//
//  DesignTimeVocabViewModel.swift
//  duzhe
//
//  Created by Bill Glover on 04/02/2021.
//

import Foundation

class DesignTimeVocabViewModel: VocabViewModelProtocol, ObservableObject {
    typealias ViewModelType = DesignTimeVocabViewModel
    
    @Published var vocab = [Vocab]()
    @Published var trie = Trie()
    
    
    func fetchData() {
        let previewData = [
            Vocab(id: UUID().uuidString, language: "zh", writing: "森"),
            Vocab(id: UUID().uuidString, language: "zh", writing: "家"),
            Vocab(id: UUID().uuidString, language: "zh", writing: "好"),
            Vocab(id: UUID().uuidString, language: "zh", writing: "大"),
            Vocab(id: UUID().uuidString, language: "zh", writing: "中国", reading: "zhong1 guo2"),
            Vocab(id: UUID().uuidString, language: "zh", writing: "我", reading: "wo3", definition: "I"),
            Vocab(id: UUID().uuidString, language: "zh", writing: "你", reading: "ni3", definition: "You", heisigDefinition: "You"),
            Vocab(id: UUID().uuidString, language: "zh", writing: "是")
        ]
        
        vocab = previewData
        
        for item in previewData {
            trie.insert(word: item.writing)
        }
    }
}
