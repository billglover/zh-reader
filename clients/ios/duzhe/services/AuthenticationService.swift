//
//  AuthenticationService.swift
//  duzhe
//
//  Created by Bill Glover on 07/02/2021.
//

import Foundation
import Firebase

class AuthenticationService: ObservableObject {
  // 2
  @Published var user: User?
  private var authenticationStateHandler: AuthStateDidChangeListenerHandle?

  // 3
  init() {
    addListeners()
  }

  // 4
  static func signIn() {
    if Auth.auth().currentUser == nil {
      Auth.auth().signInAnonymously()
    }
  }

  private func addListeners() {
    // 5
    if let handle = authenticationStateHandler {
      Auth.auth().removeStateDidChangeListener(handle)
    }

    // 6
    authenticationStateHandler = Auth.auth()
      .addStateDidChangeListener { _, user in
        if let id = user?.uid {
            print("User changed to: \(id)")
        }
        self.user = user
      }
  }
}
