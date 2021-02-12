//
//  VocabListView.swift
//  duzhe
//
//  Created by Bill Glover on 04/02/2021.
//

import SwiftUI

struct VocabListView<ViewModelType: VocabViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModelType
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.vocab.indices, id: \.self) { index in
                    NavigationLink(destination: VocabDetailsView(vocabItem: $viewModel.vocab[index])){
                        VocabRowView(vocabItem: viewModel.vocab[index])
                    }
                }
            }
            .navigationTitle("Vocab")
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

struct VocabListView_Previews: PreviewProvider {
    static var previews: some View {
        VocabListView(viewModel: DesignTimeVocabViewModel())
    }
}
