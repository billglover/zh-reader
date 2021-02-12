//
//  VocabEditView.swift
//  duzhe
//
//  Created by Bill Glover on 05/02/2021.
//

import SwiftUI

enum Mode {
    case new
    case edit
}

struct VocabEditView: View {
    
    @Binding var item: Vocab
    
    @Environment(\.presentationMode) private var presentationMode
    var mode: Mode = .edit
    
    var cancelButton: some View {
        Button(action: { self.handleCancelTapped() }) {
            Text("Cancel")
        }
    }
    
    var saveButton: some View {
        Button(action: { self.handleDoneTapped() }) {
            Text(mode == .new ? "Done" : "Save")
        }
        .disabled(false)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic")) {
                    TextField("Writing", text: $item.writing)
                    TextField("Reading", text: $item.reading ?? "")
                    TextField("Language", text: $item.language)
                }
                
                Section(header: Text("Extra")) {
                    TextField("Definition", text: $item.definition ?? "")
                    TextField("Heisig", text: $item.definition ?? "")
                }
            }
            .navigationTitle(mode == .new ? "New book" : item.writing)
            .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
            .navigationBarItems(
                leading: cancelButton,
                trailing: saveButton
            )
        }
    }
    
    func handleCancelTapped() {
        self.dismiss()
    }
    
    func handleDoneTapped() {
        // self.viewModel.handleDoneTapped()
        self.dismiss()
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}



struct VocabEditView_Previews: PreviewProvider {
    static var previews: some View {
        VocabEditView(item: .constant(Vocab(id: "id", language: "zh", writing: "中国", reading: "zhong1 guo2", definition: "China", heisigDefinition: "China")))
    }
}

// Make it easy to use Optionals in bindings.
// See: https://stackoverflow.com/a/61002589
func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
