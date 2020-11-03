import SwiftUI
import WebKit

struct SettingView: View {
    @State var showModal = false
    init() {
            UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Thonburi-Bold", size: 20)!]
    }
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("ご依頼・ご要望")) {
                   Button(action:{
                        self.showModal.toggle()
                    }){
                        HStack{
                            Spacer().frame(width: 5)
                            Image(systemName:"paperplane")
                            .foregroundColor(.black)
                            Spacer()
                            Text("不具合報告・ご意見・ご感想")
                                .foregroundColor(.black)
                            Spacer().frame(width: 15)
                        }
                        .sheet(isPresented: $showModal){
                            SafariView(url: URL(string: "https://forms.gle/j3tXg9xp9iDCzMf96")!)
                        }
                    }
                }
                Section(header: Text("利用規約")){
                    Button(action:{
                        self.showModal.toggle()
                    }){
                        HStack{
                            Spacer().frame(width:5)
                            Image(systemName:"gear")
                                .foregroundColor(.black)
                            Spacer()
                            Text("利用規約")
                            Spacer().frame(width: 15)
                        }
                        .sheet(isPresented: $showModal){
                            EULAView()
                        }
                    }
                    Button(action:{
                        self.showModal.toggle()
                    }){
                        HStack{
                            Spacer().frame(width:5)
                            Image(systemName:"gear")
                                .foregroundColor(.black)
                            Spacer()
                            Text("プライバシーポリシー")
                            Spacer().frame(width: 15)
                        }
                        .sheet(isPresented: $showModal){
                            SafariView(url: URL(string: "https://xinkent.github.io/shiritori_world_iOS/")!)
                        }
                    }
                }
                Section(header: Text("バージョン")) {
                    HStack{
                    Spacer().frame(width: 5)
                    Image(systemName:"gear")
                        .foregroundColor(.black)
                    Spacer()
                    Text("ver 1.0.3")
                    Spacer().frame(width: 15)
                        }
                }
            }.navigationBarTitle("オプション", displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SafariView: UIViewRepresentable {
    var url: URL
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView(frame: .zero)
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let req = URLRequest(url: url)
        uiView.load(req)
    }
}

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

struct EULAView:View{
    var html = ""
    init(){
        if let htmlPath: String = Bundle.main.path(forResource:"EULA", ofType: "html"){
            do{
                let content = try String(contentsOfFile: htmlPath)
                self.html = content
            } catch{
                print("ファイル内容の取得に失敗")
            }
        } else {
            print("指定されたファイルが見つかりません")
        }
    }
    var body: some View{
        HTMLStringView(htmlContent: html)
    }

}

