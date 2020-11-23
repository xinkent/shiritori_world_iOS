import SwiftUI

struct ShiritoriListView: View {
    @EnvironmentObject var sf:ShiritoriFetcher
    @State var selectedStyle = 0
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Thonburi-Bold", size: 20)!]
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Picker("", selection: self.$selectedStyle) {
                            Text("全てのしりとり").tag(0)
                            Text("自分のしりとり").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                ShiritoriListRows(selectedStyle: $selectedStyle)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ShiritoriListRows: View{
    @EnvironmentObject var sf:ShiritoriFetcher
    @Binding var selectedStyle:Int
    var body: some View{
        if (selectedStyle == 0){
            List(self.sf.shiritori.shiritoriWords!){ shiritoriWord in
                VStack(alignment: .leading){
                Text("順番:\(shiritoriWord.id)")
                .font(.body)
                .padding()
                    Text("回答者:\(shiritoriWord.name ?? "取得中...")")
                .font(.body)
                .padding()
                    Text("回答場所:\(shiritoriWord.address ?? "???")")
                .font(.body)
                .padding()
                Text("回答ワード:\(shiritoriWord.word)")
                .font(.body)
                .padding()
                Text("回答日時:\(shiritoriWord.answerDateStr)")
                .font(.body)
                .padding()
                }
            }.navigationBarTitle("しりとり履歴", displayMode: .inline)
        } else if (selectedStyle == 1){
            List(self.sf.shiritori.shiritoriWords!.filter{$0.userID == sf.user.userID}){ shiritoriWord in
                VStack(alignment: .leading){
                Text("順番:\(shiritoriWord.id)")
                .font(.body)
                .padding()
                    Text("回答者:\(shiritoriWord.name ?? "取得中...")")
                .font(.body)
                .padding()
                    Text("回答場所:\(shiritoriWord.address ?? "???")")
                .font(.body)
                .padding()
                Text("回答ワード:\(shiritoriWord.word)")
                .font(.body)
                .padding()
                Text("回答日時:\(shiritoriWord.answerDateStr)")
                .font(.body)
                .padding()
                }
            }.navigationBarTitle("しりとり履歴", displayMode: .inline)
        } else {
            EmptyView()
        }
    }
}

struct ShiritoriListView_Previews: PreviewProvider {
    static var previews: some View {
        ShiritoriListView()
    }
}
