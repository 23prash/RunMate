//
//  SignInView.swift
//  RunMate
//
//  Created by Prashant Pukale on 4/16/22.
//

import SwiftUI
import Firebase

struct SignInView: View {
    @State private var userEmailData = TextInputViewData(text: "", placeholder: "Email-Id", errorString: nil, type: .email)
    @State private var passwordData = TextInputViewData(text: "", placeholder: "Password", errorString: nil, type: .password)
    @State private var showLoading: Bool = false
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white

            Button  {
                router.go(to: .landing)
            } label: {
                RoundedButtonImage(title: .cross, subtitle: nil, style: .tertiary)
            }.frame(width: 60, height: 60, alignment: .topLeading)
                .padding(.horizontal, 16)
                .padding(.vertical, 44)

            VStack {
                Spacer()
                TextInputView(data: $userEmailData)
                    .padding(.vertical)
                TextInputView(data: $passwordData)
                    .padding(.vertical)

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

    private func validate() -> Bool {
        var error = false
        if userEmailData.isValid == false {
            userEmailData.errorString = "Enter a valid email-id."
            error = true
        } else {
            userEmailData.errorString = nil
        }

        if passwordData.isValid == false {
            passwordData.errorString = "Valid password has at-least 10 characters."
            error = true
        }
        return !error
    }
    private func login() {
        guard validate() else { return }
        showLoading = true
        Auth.auth().signIn(withEmail: userEmailData.text, password: passwordData.text) { result, error in
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
