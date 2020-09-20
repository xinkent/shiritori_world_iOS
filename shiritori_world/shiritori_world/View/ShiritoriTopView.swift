import SwiftUI

struct ShiritoriTopView: View{
    @EnvironmentObject var sf:ShiritoriFetcher
    @EnvironmentObject var lm:LocationManager
    @ObservedObject var vm:ShiritoriTopViewModel
    @State var name = "名無しさん"
    @State var word = ""
    
    var body: some View{
        VStack{
            currentShiritoriView()
            ShiritoriAnswerView(vm:vm, name:self.$name, word:self.$word)
            topAlertView(vm:vm, name:self.$name, word:self.$word)
            Spacer().frame(height:400)
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
        }
    }
}

struct currentShiritoriView:View{
    @EnvironmentObject var sf: ShiritoriFetcher
    var body: some View{
        Text("あなたは" + String((sf.shiritori.shiritoriWords?.count ?? 1) + 1) + "番目の回答者です")
//        Spacer()
        Text("現在のワード")
            .font(.headline)
            //.background(Color.gray)
            //.foregroundColor(Color.white)
        Text(String((self.sf.shiritori.shiritoriWords?.last!.name) ?? "-----"))
            .font(.caption)
        Text(String((self.sf.shiritori.shiritoriWords?.last!.word) ?? "-----"))
            .font(.title)
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
            CustomTextFieldView(title:"回答者名入力",text: self.$name)
            CustomTextFieldView(title:"回答入力", text: self.$word)
            if !self.vm.validate(currentWord:self.word, prevWord: String(((self.sf.shiritori.shiritoriWords?.last!.word) ?? ""))).isValid{
                Text(self.vm.validate(currentWord:self.word, prevWord: String(((self.sf.shiritori.shiritoriWords?.last!.word) ?? ""))).message)
            }
            Button(action:{
                self.vm.beforeSend()
                }
            ){
                Text("送信")
            }.disabled(!self.vm.validate(currentWord:self.word, prevWord: String((self.sf.shiritori.shiritoriWords?.last!.word) ?? "")).isValid)
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
