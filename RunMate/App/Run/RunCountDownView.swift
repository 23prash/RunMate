//
//  RunInProgressView.swift
//  RunMate
//
//  Created by Prashant Pukale on 2/2/22.
//

import SwiftUI

struct RunCountDownView: View {
    @EnvironmentObject var router: AppRouter
    private let timer = Timer.publish(every: 1.2,
                                      on: .main,
                                      in: .common).autoconnect()
    @State var count = 1

    var body: some View {
        Text("\(count)")
            .font(.system(size: 250))
            .onReceive(timer) { _ in
                count += 1
                if count > 3 {
                    router.go(to: .runInProgress, in: .none)
                }
            }
    }
}

struct RunCountDownView_Previews: PreviewProvider {
    static var previews: some View {
        RunCountDownView()
    }
}
