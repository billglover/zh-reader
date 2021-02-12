//
//  VocabViewModel.swift
//  duzhe
//
//  Created by Bill Glover on 04/02/2021.
//

import Foundation
import FirebaseFirestore
import Combine

protocol VocabViewModelProtocol: ObservableObject, Identifiable {
    associatedtype ViewModelType
    var vocab: [Vocab] { get set }
    var trie: Trie { get set }
    
    func fetchData()
}

class VocabViewModel: VocabViewModelProtocol, ObservableObject, Identifiable {
    typealias ViewModelType = VocabViewModel
    
    @Published var vocab = [Vocab]()
    @Published var trie = Trie()
    
    private var db = Firestore.firestore()
    
    var userId = "sample"
    private let authenticationService = AuthenticationService()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
        
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { _ in self.fetchData() }
            .store(in: &cancellables)
            
    }
    
    func fetchData() {
        
        print("Fetching data for user: \(userId)")
        
        db.collection("users").document(userId).collection("vocab").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.vocab = documents.compactMap { queryDocumentSnapshot -> Vocab? in
                //print(queryDocumentSnapshot.data())
                //return try? queryDocumentSnapshot.data(as: Vocab.self)
                
                let data = queryDocumentSnapshot.data()
                if let writing = data["writing"] as? String {
                    let id = data["title"] as? String ?? ""
                    let language = data["author"] as? String ?? ""
                    
                    let reading = data["reading"] as? String
                    let heisig = data["heisigDefinition"] as? String
                    let definition = data["author"] as? String ?? ""
                    
                    return Vocab(id: id, language: language, writing: writing, reading: reading, definition: definition, heisigDefinition: heisig)
                } else {
                    return nil
                }
            }
            
            self.trie.reset()
            for item in self.vocab {
                self.trie.insert(word: item.writing)
            }
            
            print(self.vocab)
        }
    }
}
