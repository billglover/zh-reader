//
//  VocabDetailsView.swift
//  duzhe
//
//  Created by Bill Glover on 04/02/2021.
//

import SwiftUI

struct VocabDetailsView: View {
    
    @Binding var vocabItem: Vocab
    
    var body: some View {
        VStack {
            Text(vocabItem.writing)
            
            vocabItem.reading.map { text in Text(text) }
            Divider()
            
            vocabItem.definition.map { text in Text(text) }
            
            vocabItem.heisigDefinition.map { text in
                Group{
                    Divider()
                    Text(text)
                }
            }
            
        }
        .navigationTitle(vocabItem.writing)
    }
}

struct VocabDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VocabDetailsView(vocabItem: .constant(Vocab(
                                id: UUID().uuidString,
                                language: "zh",
                                writing: "中国",
                                reading: "zhong1 guo2",
                                definition: "China",
                                heisigDefinition: nil))
            )
        }
    }
}
