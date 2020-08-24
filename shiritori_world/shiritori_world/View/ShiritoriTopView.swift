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
    var body: some View{
        VStack{
            Spacer().frame(height:50)
            Text("現在のワード")
                .font(.title)
                .background(Color.gray)
                .foregroundColor(Color.white)
            Text(String((self.sf.shiritori.shiritoriWords?.last!.word) ?? "-----"))
            Spacer().frame(height:50)
            TextField("解答入力",text: $vm.word)
            
            if !self.vm.validate(prevWord: String(((self.sf.shiritori.shiritoriWords?.last!.word) ?? ""))).isValid{
                Text(self.vm.validate(prevWord: String(((self.sf.shiritori.shiritoriWords?.last!.word) ?? ""))).message)
            }
            Spacer()
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
