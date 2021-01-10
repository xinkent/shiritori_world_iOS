//
//  FirstView.swift
//  shiritori_world
//
//  Created by 辛剣徳 on 2021/01/01.
//  Copyright © 2021 辛剣徳. All rights reserved.
//

import SwiftUI

struct FirstView: View {
    @ObservedObject var vm: ContentViewModel
    @State var readPolicy:Bool = false
    var visit = UserDefaults.standard.bool(forKey: "visit")
    var body: some View {
        VStack{
            Spacer().frame(height:30)
            Text("本アプリを利用するためには、利用規約に同意する必要があります。下記の利用規約を読み、同意ボタンを押してください。")
            Spacer().frame(height:30)
            Text("利用規約").font(.title)
            Divider()
            EULAView()
            Divider()
            HStack{
                Toggle(isOn: $readPolicy){
                    Text("同意します")
                }.frame(width:150)
                Spacer()
            }
            Button(action:{
                self.vm.acceptPolicy()
            }){
                Text("送信")
            }.disabled(!readPolicy)
            Spacer().frame(height:50)
        }
    }
}
