//
//  Test.swift
//  Count
//
//  Created by Michael Phelan on 11/11/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct Test: View {
    @State var theTesxt = "he did"
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack{
            Form{
                TextField("ya", text:self.$theTesxt)
                TextField("yo", text:self.$theTesxt)
                TextField("hehe", text:self.$theTesxt)
                TextField("bah", text:self.$theTesxt)
                TextField("co", text:self.$theTesxt)
            }.frame(height:300)
            Spacer()
            HStack{
                Spacer()
                Button(action:{}){
                    VStack{
                        Image(systemName: "camera")
                            .font(.system(size: 40))
                        Text("Scan").padding(2)
                    }.padding()
                }
                Spacer()
                Button(action:{}){
                    VStack{
                        Image(systemName: "plus")
                            .font(.system(size: 40))
                        Text("Add").padding(2)
                    }.padding()
                }
                Spacer()
            }
            Spacer()
        }.background(lightModeGray)
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
