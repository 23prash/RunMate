//
//  SignInView.swift
//  RunMate
//
//  Created by Prashant Pukale on 4/16/22.
//

import SwiftUI
import Firebase

struct SignInView: View {
    @State private var userEmail: String = ""
    @State private var password: String = ""
    @State private var showLoading: Bool = false
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack {
            Color.white

            VStack {
                Spacer()
                TextField("Email-Id", text: $userEmail)
                    .padding()
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(8)
                    .padding([.bottom], 20)
                    .padding([.horizontal], 16)
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(8)
                    .padding([.bottom], 20)
                    .padding([.horizontal], 16)
                Button {
                    login()
                } label: {
                    ActionButtonLabel(title: "Login", type: .primary)
                }
                Spacer()
                Spacer()
                Spacer()
            }.opacity(showLoading ? 0 :  1)

            if showLoading {
                FullScreenLoader()
            }
        }

    }

    private func login() {
        showLoading = true
        Auth.auth().signIn(withEmail: userEmail, password: password) { result, error in
            showLoading = false
            if error == nil {
                router.go(to: .startRun, in: .startRun)
            } else {
                print("failed \(error?.localizedDescription)")
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
