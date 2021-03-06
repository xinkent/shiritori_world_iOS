import SwiftUI
import KeyboardObserving

struct ShiritoriTopView: View{
    @EnvironmentObject var sf:ShiritoriFetcher
    @EnvironmentObject var lm:LocationManager
    @ObservedObject var vm:ShiritoriTopViewModel
    @State var name = UserDefaults.standard.value(forKey: "username") as? String ?? "名無しさん"
    @State var word = ""
    init(vm: ShiritoriTopViewModel) {
        self.vm = vm
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Thonburi-Bold", size: 20)!]
    }
    
    var body: some View{
        
        NavigationView{
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
                .keyboardObserving()
                Spacer().frame(maxWidth:.infinity)
                topAlertView(vm:vm, name:self.$name, word:self.$word)
            }.navigationBarTitle("しりとり回答", displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle())
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
                    title: Text("回答を送信"),
                    message: Text(vm.allowLocation ? "位置情報と合わせて送信されます": "しりとりを送信しますか？"),
                    primaryButton:.default(Text("Yes"),
                        action:{
                            self.vm.send_answer(sf: sf, lm: lm, name: name, word: word)
                        }
                    ),
                    secondaryButton: .cancel(Text("cancel"))
                )
            }
            Spacer().alert(isPresented: $vm.isSent) {
                Alert(title: Text("送信成功"),
                      message: Text("回答が送信されました！"),
                      dismissButton: .default(Text("OK"),
                          action:{
                            // 送信成功した場合は入力文字を初期化
                            self.word = ""
                        }
                    )
                )
            }
            Spacer().alert(isPresented: $vm.isError) {
                Alert(title: Text("送信失敗"),
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
                Text(String((self.sf.shiritori.shiritoriWords?.last!.masked_name) ?? "-----"))
                    .font(.caption)
                Text(String((self.sf.shiritori.shiritoriWords?.last!.masked_word) ?? "-----"))
                    .font(.title)
            }
            Spacer().frame(height:20)
            HStack{
                Text("次の頭文字")
                    .font(.headline)
                Spacer()
            }
            Text(String((self.sf.shiritori.shiritoriWords?.last!.word.suffix(1)) ?? ""))
                .font(.title)
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
            HStack{
                Toggle(isOn: $vm.allowLocation){
                    Text("位置情報も送信する")
                }.frame(width:250)
                Spacer()
            }
            Button(action:{
                self.vm.beforeSend()
                }
            ){
                Text("送信").bold()
            }.disabled(!self.vm.validate(currentWord:self.word, prevWord: String((self.sf.shiritori.shiritoriWords?.last!.word) ?? ""), name:self.name).isValid)
        }.frame(maxWidth:.infinity)
    }
}
