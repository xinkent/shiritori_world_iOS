import SwiftUI

struct ShiritoriTopView: View{
    @EnvironmentObject var sf:ShiritoriFetcher
    @ObservedObject var vm = ShiritoriTopViewModel()
    @State var longitude = 139.745451
    @State var latitude = 35.658577
    
    var body: some View{
        VStack{
            ShiritoriAnswerView(vm:vm)
            MapView()
        }
    }
}


struct ShiritoriAnswerView:View{
    @ObservedObject var vm:ShiritoriTopViewModel
    @EnvironmentObject var sf: ShiritoriFetcher
    @State var order: Int = 1
    
    var body: some View{
        VStack{
            Spacer().frame(height:50)
            // TODO: view modelのget_orderを採用できるように非同期処理させるような実装に変更する
            Text("あなたは" + String((sf.shiritori.shiritoriWords?.count ?? 1) + 1) + "番目の回答者です")
            Spacer()
            Text("現在のワード")
                .font(.headline)
                //.background(Color.gray)
                //.foregroundColor(Color.white)
            Text(String((self.sf.shiritori.shiritoriWords?.last!.name) ?? "-----"))
                .font(.caption)
            Text(String((self.sf.shiritori.shiritoriWords?.last!.word) ?? "-----"))
                .font(.title)
            // Spacer().frame(height:50)
            Spacer()
            TextField("解答入力",text: $vm.word)
            
            if !self.vm.validate(prevWord: String(((self.sf.shiritori.shiritoriWords?.last!.word) ?? ""))).isValid{
                Text(self.vm.validate(prevWord: String(((self.sf.shiritori.shiritoriWords?.last!.word) ?? ""))).message)
            }
            // Spacer()
            Button(action:{self.vm.send_answer(sf:self.sf)}){
                Text("送信")
            }.disabled(!self.vm.validate(prevWord: String((self.sf.shiritori.shiritoriWords?.last!.word) ?? "")).isValid)
        }.frame(maxWidth:.infinity)
            .frame(height:300)
    }
}



//struct ShiritoriTopView: View {
//    @State dynamic var longitude:Double = 139.745451
//    @State dynamic var latitude:Double = 35.658577
//    var targetLongitude:Double = 143.1212
//    var body: some View {
//        VStack{
//            Button(action:{
//                self.move()
//            }){
//                Text("Move")
//            }
//            AnimationMapView(lon:self.$longitude, lat:self.$latitude)
//        }
//    }
//
//    func move(){
//        self.longitude = self.targetLongitude
//    }
//}


struct ShiritoriTopView_Preview: PreviewProvider {
    static var previews: some View {
        ShiritoriTopView().environmentObject(ShiritoriFetcher())
    }
}
