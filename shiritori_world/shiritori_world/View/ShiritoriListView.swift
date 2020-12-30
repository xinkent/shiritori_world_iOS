import SwiftUI

struct ShiritoriListView: View {
    @EnvironmentObject var sf:ShiritoriFetcher
    @State var selectedStyle = 0
    @ObservedObject var vm:ShiritoriListViewModel
    init(vm: ShiritoriListViewModel) {
        self.vm = vm
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Thonburi-Bold", size: 20)!]
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Picker("", selection: self.$selectedStyle) {
                            Text("全てのしりとり").tag(0)
                            Text("自分のしりとり").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                ShiritoriListRows(vm: vm, selectedStyle: $selectedStyle)
                listAlertView(vm:vm)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ShiritoriListRows: View{
    @EnvironmentObject var sf:ShiritoriFetcher
    @ObservedObject var vm: ShiritoriListViewModel
    @Binding var selectedStyle:Int
    var body: some View{
        if (selectedStyle == 0){
            List(self.sf.shiritori.shiritoriWords!){ shiritoriWord in
                VStack(alignment: .leading){
                Text("順番:\(shiritoriWord.id)")
                .font(.body)
                .padding()
                    Text("回答者:\(shiritoriWord.masked_name ?? "取得中...")")
                .font(.body)
                .padding()
                    Text("回答場所:\(shiritoriWord.masked_address ?? "???")")
                .font(.body)
                .padding()
                    Text("回答ワード:\(shiritoriWord.masked_word)")
                .font(.body)
                .padding()
                Text("回答日時:\(shiritoriWord.answerDateStr)")
                .font(.body)
                .padding()
                }
            }.navigationBarTitle("しりとり履歴", displayMode: .inline)
        } else if (selectedStyle == 1){
            List(self.sf.shiritori.shiritoriWords!.filter{$0.userID == sf.user.userID}){ shiritoriWord in
//                NavigationLink(destination:ChangeShiritoriAttributeView(shiritoriWord:shiritoriWord)){
                    VStack(alignment: .leading){
                        Text("順番:\(shiritoriWord.id)")
                        .font(.body)
                        .padding()
                            Text("回答者:\(shiritoriWord.masked_name ?? "取得中...")")
                        .font(.body)
                        .padding()
                            Text("回答場所:\(shiritoriWord.masked_address ?? "???")")
                        .font(.body)
                        .padding()
                        Text("回答ワード:\(shiritoriWord.masked_word)")
                        .font(.body)
                        .padding()
                        Text("回答日時:\(shiritoriWord.answerDateStr)")
                        .font(.body)
                        .padding()
                        Text("変更").onTapGesture {
                            vm.beforeSend(order:shiritoriWord.id)
                        }
                    }
//                }
            }.navigationBarTitle("しりとり履歴", displayMode: .inline)
        } else {
            EmptyView()
        }
    }
}

struct listAlertView: View{
    @ObservedObject var vm: ShiritoriListViewModel
    @EnvironmentObject var sf:ShiritoriFetcher
    
    var body: some View{
        Spacer().alert(isPresented:$vm.beforeSent){
            Alert(
                title: Text("Message"),
                message: Text("情報を変更しますか？"),
                primaryButton: .default(Text("Yes"),
                                        action:{
                                            vm.updateShiritoriFlag(sf:sf)
                                        }),
                secondaryButton: .cancel(Text("cancel"))
                
            )
        }
    }
    
}
