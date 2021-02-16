//
//  ReaderView.swift
//  duzhe
//
//  Created by Bill Glover on 06/02/2021.
//

import SwiftUI

struct ReaderView<ViewModelType: VocabViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModelType
    @State var text: String = "森林里有一棵好大好大的树，树杈上有一个鸟窝，那是乌鸦的家。 "
    
    var body: some View {
        VStack {
            ReaderSummaryView(text: $text, viewModel: viewModel)
            
            Divider()
            
            HighlightedEditor(text: $text, viewModel: viewModel)
                .onAppear(){
                    viewModel.fetchData()
                }
                .padding()
        }
        .accentColor(.pink)
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReaderView(viewModel: DesignTimeVocabViewModel())
            ReaderView(viewModel: DesignTimeVocabViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
