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
                .padding(5)
                    Text("回答者:\(shiritoriWord.masked_name ?? "取得中...")")
                .font(.body)
                .padding(5)
                    Text("回答場所:\(shiritoriWord.masked_address ?? "???")")
                .font(.body)
                .padding(5)
                    Text("回答ワード:\(shiritoriWord.masked_word)")
                .font(.body)
                .padding(5)
                Text("回答日時:\(shiritoriWord.answerDateStr)")
                .font(.body)
                .padding(5)
                }
            }.navigationBarTitle("しりとり履歴", displayMode: .inline)
        } else if (selectedStyle == 1){
            List(self.sf.shiritori.shiritoriWords!.filter{$0.userID == sf.user.userID}){ shiritoriWord in
                    VStack(alignment: .leading){
                        HStack{
                            Text("順番:\(shiritoriWord.id)")
                            .font(.body)
                            .padding(5)
                            Spacer()
                            Group{
                                if shiritoriWord.is_location_masked{
                                    Image(systemName:"lock.fill")
                                } else {
                                    Image(systemName:"lock.open.fill")
                                }
                            }.onTapGesture {
                                vm.beforeSend(order: shiritoriWord.id, is_masked: shiritoriWord.is_location_masked)
                            }
                        }
                            Text("回答者:\(shiritoriWord.name ?? "取得中...")")
                        .font(.body)
                        .padding(5)
                            Text("回答場所:\(shiritoriWord.address ?? "???")")
                        .font(.body)
                        .padding(5)
                        Text("回答ワード:\(shiritoriWord.word)")
                        .font(.body)
                        .padding(5)
                        Text("回答日時:\(shiritoriWord.answerDateStr)")
                        .font(.body)
                        .padding(5)
                    }
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
                message: Text(vm.is_masked ? "投稿を公開しますか？":"投稿を非公開にしますか？"),
                primaryButton: .default(Text("Yes"),
                                        action:{
                                            vm.updateShiritoriFlag(sf:sf)
                                        }),
                secondaryButton: .cancel(Text("cancel"))
                
            )
        }
        Spacer().alert(isPresented: $vm.isSent) {
            Alert(title: Text("Message"),
                  message: Text("送信されました\n(反映まで時間がかかる場合があります)"),
                  dismissButton: .default(Text("OK"))
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
