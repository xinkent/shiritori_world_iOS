import SwiftUI

struct ShiritoriTopView: View{
    @EnvironmentObject var sf:ShiritoriFetcher
    @EnvironmentObject var lm:LocationManager
    @ObservedObject var vm:ShiritoriTopViewModel
    @State var name = "名無しさん"
    @State var word = ""
    
    var body: some View{
        VStack{
            ZStack{
                Color.orange.opacity(0.8).frame(height:65)
                VStack{
                    Text("あなたは" + String((sf.shiritori.shiritoriWords?.count ?? 1) + 1) + "番目の回答者です").frame(height:30)
                }
            }
            // Spacer().frame(height:20)
            // Text("あなたは" + String((sf.shiritori.shiritoriWords?.count ?? 1) + 1) + "番目の回答者です")
            
            currentShiritoriView().frame(height:130)
            Divider()
            ShiritoriAnswerView(vm:vm, name:self.$name, word:self.$word)
            Spacer().frame(maxWidth:.infinity)
            topAlertView(vm:vm, name:self.$name, word:self.$word)
        }
    }
}

struct topAlertView: View{
    @ObservedObject var vm:ShiritoriTopViewModel
    @EnvironmentObject var sf: ShiritoriFetcher
    @EnvironmentObject var lm: LocationManager
    @Binding var name:String
    @Binding var word:String
    var body: some View{
        VStack{
            Spacer().alert(isPresented:$vm.beforeSent){
                Alert(
                    title: Text("Message"),
                    message: Text("送信しますか？"),
                    primaryButton:.default(Text("Yes"),
                        action:{
                            self.vm.send_answer(sf: sf, lm: lm, name: name, word: word)
                        }
                    ),
                    secondaryButton: .cancel(Text("cancel"))
                )
            }
            Spacer().alert(isPresented: $vm.isSent) {
                Alert(title: Text("Message"),
                      message: Text("回答が送信されました！"),
                      dismissButton: .default(Text("OK"),
                          action:{
                            self.name = ""
                            self.word = ""
                        }
                    )
                )
            }
            Spacer().alert(isPresented: $vm.isError) {
                Alert(title: Text("Message"),
                      message: Text("送信できませんでした"),
                      dismissButton: .default(Text("OK")
                    )
                )
            }
        }.frame(height:20)
    }
}

struct currentShiritoriView:View{
    @EnvironmentObject var sf: ShiritoriFetcher
    var body: some View{
        VStack(alignment:.center){
            HStack{
                Text("現在のワード")
                    .font(.headline)
                Spacer()
            }
            Spacer().frame(maxHeight:50)
                // .alignmentGuide(.leading, computeValue:{d in (d[explicit: .leading] ?? 0)})
                //.background(Color.gray)
                //.foregroundColor(Color.white)
            HStack{
                Text(String((self.sf.shiritori.shiritoriWords?.last!.name) ?? "-----"))
                    .font(.caption)
                Text(String((self.sf.shiritori.shiritoriWords?.last!.word) ?? "-----"))
                    .font(.title)
            }
        }
    }
}

struct ShiritoriAnswerView:View{
    @ObservedObject var vm:ShiritoriTopViewModel
    @EnvironmentObject var sf: ShiritoriFetcher
    @EnvironmentObject var lm: LocationManager
    @State var order: Int = 1
    @Binding var name:String
    @Binding var word:String
    
    var body: some View{
        VStack{
            // TODO: view modelのget_orderを採用できるように非同期処理させるような実装に変更する
            HStack{
                Text("あなたの回答")
                    .font(.headline)
                Spacer()
            }
            Spacer().frame(height:50)
            CustomTextFieldView(title:"回答者名入力",text: self.$name).border(Color.gray, width: 0.5).frame(width:300, height:40)
            CustomTextFieldView(title:"回答入力", text: self.$word).border(Color.gray, width:0.5).frame(width:300, height:40)
            if !self.vm.validate(currentWord:self.word, prevWord: String(((self.sf.shiritori.shiritoriWords?.last!.word) ?? "")), name:self.name).isValid{
                Text(self.vm.validate(currentWord:self.word, prevWord: String(((self.sf.shiritori.shiritoriWords?.last!.word) ?? "")), name:self.name).message)
            }
            Button(action:{
                self.vm.beforeSend()
                }
            ){
                Text("送信").bold()
            }.disabled(!self.vm.validate(currentWord:self.word, prevWord: String((self.sf.shiritori.shiritoriWords?.last!.word) ?? ""), name:self.name).isValid)
        }
        .frame(maxWidth:.infinity)
//            .frame(height:300)
    }
    
}


//struct ShiritoriTopView_Preview: PreviewProvider {
//    static var previews: some View {
//        ShiritoriTopView().environmentObject(ShiritoriFetcher())
//    }
//}
