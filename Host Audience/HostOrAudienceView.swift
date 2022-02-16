//
//  HostOrAudience.swift
//  Host Audience
//
//  Created by shaun on 2/16/22.
//

import SwiftUI

struct HostOrAudienceView: View {
    var body: some View {
        NavigationView {
            choiceView
        }
    }

    private var choiceView: some View {
        VStack {
            Text("What type of user are you?")
                .font(.title2)
            NavigationLink("Host") {
                HostView()
            }.padding()
            NavigationLink("Audience") {
                AudienceView()
            }
        }.buttonStyle(.borderedProminent)
        .fixedSize(horizontal: true, vertical: false)
        .navigationTitle(Text("Who are you?"))
    }
}

struct HostOrAudience_Previews: PreviewProvider {
    static var previews: some View {
        HostOrAudienceView()
    }
}
