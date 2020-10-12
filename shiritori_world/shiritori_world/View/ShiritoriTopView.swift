import SwiftUI

struct ShiritoriTopView: View{
    @EnvironmentObject var sf:ShiritoriFetcher
    @EnvironmentObject var lm:LocationManager
    @ObservedObject var vm = ShiritoriTopViewModel()
    
    var body: some View{
        VStack{
            currentShiritoriView()
            ShiritoriAnswerView(vm:vm)
            Spacer().frame(height:400)
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
    @State var name = "名無しさん"
    @State var word = ""
    
    var body: some View{
        VStack{
            // TODO: view modelのget_orderを採用できるように非同期処理させるような実装に変更する
            CustomTextFieldView(title:"回答者名入力",text: self.$name)
            CustomTextFieldView(title:"回答入力", text: self.$word)
            if !self.vm.validate(currentWord:self.word, prevWord: String(((self.sf.shiritori.shiritoriWords?.last!.word) ?? ""))).isValid{
                Text(self.vm.validate(currentWord:self.word, prevWord: String(((self.sf.shiritori.shiritoriWords?.last!.word) ?? ""))).message)
            }
            Button(action:{self.vm.send_answer(sf:self.sf, lm:self.lm, name:self.name, word:self.word)}){
                Text("送信")
            }.disabled(!self.vm.validate(currentWord:self.word, prevWord: String((self.sf.shiritori.shiritoriWords?.last!.word) ?? "")).isValid)
        }
        .frame(maxWidth:.infinity)
//            .frame(height:300)
    }
    
}


struct ShiritoriTopView_Preview: PreviewProvider {
    static var previews: some View {
        ShiritoriTopView().environmentObject(ShiritoriFetcher())
    }
}
