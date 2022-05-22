//
//  TextField.swift
//  RunMate
//
//  Created by Prashant Pukale on 5/22/22.
//

import SwiftUI

struct TextInputViewData {
    var text: String
    var placeholder: String
    var errorString: String?
    var type: TextInputType

    var isValid: Bool {
        return text.isValid(inputType: type)
    }
}

struct TextInputView: View {
    private var data: Binding<TextInputViewData>

    init(data: Binding<TextInputViewData>) {
        self.data = data
    }

    var body: some View {
        VStack(alignment: .leading) {

            if data.wrappedValue.type.isSecure {
                SecureField(data.wrappedValue.placeholder, text: data.text)
                    .padding()
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(8)
                    .padding(.horizontal)
            } else {
                TextField(data.wrappedValue.placeholder, text: data.text)
                    .padding()
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }


            if let error = data.wrappedValue.errorString {
                Text("🚫" + error)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
    }
}

struct TextField_Previews: PreviewProvider {
    @State static var data = TextInputViewData(text: "", placeholder: "Example text", errorString: nil, type: .plainText(required: false))
    static var previews: some View {
        TextInputView(data: $data)
    }
}
