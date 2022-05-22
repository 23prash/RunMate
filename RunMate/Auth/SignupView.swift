//
//  SignupView.swift
//  RunMate
//
//  Created by Prashant Pukale on 4/16/22.
//

import SwiftUI
import Firebase

struct SignUpView: View {
//    @State private  var userName: String = ""
    @State private var userNameInputData: TextInputViewData = .init(text: "", placeholder: "Full name", errorString: nil, type: .name)
    @State private  var userEmail: String = ""
    @State private var userEmailInputData: TextInputViewData = .init(text: "", placeholder: "Email-Id", errorString: nil, type: .email)
    @State private  var password: String = ""
    @State private var passwordInputData: TextInputViewData = .init(text: "", placeholder: "Password", errorString: nil, type: .password)
    @State private var showLoading: Bool = false

    @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack {
            Color.white

            VStack {
                Spacer()

                TextInputView(data: $userNameInputData)
                    .padding(.vertical, 8)

                TextInputView(data: $userEmailInputData)
                    .padding(.vertical, 8)

                TextInputView(data: $passwordInputData)
                    .padding(.vertical, 8)

                Button {
                    signup()
                } label: {
                    ActionButtonLabel(title: "Sign-Up", type: .primary)
                }
                Spacer()
                Spacer()
                Spacer()
            }.opacity(showLoading ? 0 : 1)

            if showLoading {
                FullScreenLoader()
            }
        }

    }
    private func validate() -> Bool {
        var error = false
        if userNameInputData.isValid == false {
            userNameInputData.errorString = "Valid name needs to have at-least 2 characters."
            error = true
        } else {
            userNameInputData.errorString = nil
        }

        if userEmailInputData.isValid == false {
            userEmailInputData.errorString = "Enter a valid email address."
            error = true
        } else {
            userEmailInputData.errorString = nil
        }
        if passwordInputData.isValid == false {
            passwordInputData.errorString = "Valid password needs to have at-least 10 characters."
            error = true
        } else {
            passwordInputData.errorString = nil
        }
        return !error
    }

    private func signup() {
        guard validate() else { return }
        showLoading = true
        Auth.auth().createUser(withEmail: userEmailInputData.text, password: passwordInputData.text) { _, error in
            showLoading = false
            if error == nil {
                router.go(to: .startRun, in: .startRun)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
