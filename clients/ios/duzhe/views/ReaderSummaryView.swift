//
//  ReaderSummaryView.swift
//  duzhe
//
//  Created by Bill Glover on 15/02/2021.
//

import SwiftUI

struct ReaderSummaryView<ViewModelType: VocabViewModelProtocol>: View {
    
    @Binding var text: String
    @ObservedObject var viewModel: ViewModelType
        
    let readabilityFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter
    }()
    
    var body: some View {
        HStack {
            let (_, l, r) = viewModel.trie.knownPhrases(text: text)
            Text("Length: \(l)")
            Spacer()
            Text("Readability: \(NSNumber(value: r), formatter: readabilityFormatter)")
        }
        .padding()
        .foregroundColor(.accentColor)
        .background(Color(UIColor.systemBackground))
    }
}

struct ReaderSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReaderSummaryView(text: .constant("你好，世界！"), viewModel: DesignTimeVocabViewModel())
            ReaderSummaryView(text: .constant("你好，世界！"), viewModel: DesignTimeVocabViewModel())
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
}
