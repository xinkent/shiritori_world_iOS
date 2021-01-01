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
    var visit = UserDefaults.standard.bool(forKey: "visit")
    var body: some View {
        VStack{
            Button(action:{
                self.vm.accept_policy()
            }){
                Text("accept")
            }
            Text("\(self.visit ? "visit is true": "visit is false")")
        }
    }
}
