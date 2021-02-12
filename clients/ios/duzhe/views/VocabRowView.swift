//
//  VocabRowView.swift
//  duzhe
//
//  Created by Bill Glover on 04/02/2021.
//

import SwiftUI

struct VocabRowView: View {
    var vocabItem: Vocab
    
    var body: some View {
        HStack {
            Text(vocabItem.writing)
            Spacer()
        }
    }
}

struct VocabRowView_Previews: PreviewProvider {
    static var previews: some View {
        VocabRowView(vocabItem: Vocab(
                        id: UUID().uuidString,
                        language: "zh",
                        writing: "中国",
                        reading: "zhong1 guo2",
                        definition: "China",
                        heisigDefinition: nil)
        )
        .previewLayout(.sizeThatFits)
    }
}
