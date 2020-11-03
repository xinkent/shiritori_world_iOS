import SwiftUI

struct ShiritoriListView: View {
    @EnvironmentObject var shiritoriFetcher:ShiritoriFetcher
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Thonburi-Bold", size: 20)!]
    }
    
    var body: some View {
        NavigationView{
            List(self.shiritoriFetcher.shiritori.shiritoriWords!){ shiritoriWord in
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
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ShiritoriListView_Previews: PreviewProvider {
    static var previews: some View {
        ShiritoriListView()
    }
}
