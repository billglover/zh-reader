//
//  ContentView.swift
//  duzhe
//
//  Created by Bill Glover on 04/02/2021.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    init(){
        FirebaseApp.configure()
        AuthenticationService.signIn()
    }
    
    var body: some View {
        TabsView(viewModel: VocabViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
