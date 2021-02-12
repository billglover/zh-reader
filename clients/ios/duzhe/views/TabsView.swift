import SwiftUI

struct TabsView<ViewModelType: VocabViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModelType
    
    @State var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            ReaderView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "text.book.closed")
                    Text("Reader")
                }
                .tag(1)
            VocabListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Vocab")
                }
                .tag(2)
        }
        .font(.headline)
        .onAppear(){
            
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView(viewModel: DesignTimeVocabViewModel(), selection: 1)
    }
}
