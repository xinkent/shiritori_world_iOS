import SwiftUI
import Firebase

class ShiritoriTopViewModel: ObservableObject {
//    @Published var isValid: Bool = true
    @Published var isHidden: Bool = false
    @Published var word: String = ""
    @Published var shiritori: Shiritori?
//    @EnvironmentObject var sf: ShiritoriFetcher
    
    
    let db = Firestore.firestore()
    func send_answer(sf: ShiritoriFetcher){
        
        var shiritoriList:[ShiritoriWord] = sf.shiritori.shiritoriWords ?? []
        shiritoriList.append(
            ShiritoriWord(id:shiritoriList.count + 1, userID:sf.user.userID!, word:self.word, lat:100, long:100, answerDate: Date())
        )
        db.collection("shiritori_test").document(sf.user.currentShiritoriID!).setData(
            ["month":"202006",
             "shiritori_id":sf.user.currentShiritoriID!,
            "shiritori_word": shiritoriList.map{$0.toFirestoreMap()}]
            ,merge:false
        )
    }
    
    func isHiraganaOrKatakana() -> Bool{
        let regex = "^([ぁ-ゞ]|[ァ-ヾ])+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: self.word)
    }
    
    func isBlank() -> Bool{
        self.word == ""
    }
    
    func isContainedBlank() -> Bool{
        let regex = ".*\\s.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: self.word)
    }
    
    func isSequentialWord(prevWord:String) -> Bool{
        prevWord.toHiragana().suffix(1) == self.word.toHiragana().prefix(1)
    }
    
    func isEndN() -> Bool{
        self.word.toHiragana().hasSuffix("ん")
    }
    
    func validate(prevWord:String) -> (isValid:Bool, message:String){
        if self.isBlank(){
            return (false, "")
        } else if self.isContainedBlank(){
            return (false, "文字中に空白が含まれています")
        } else if !self.isHiraganaOrKatakana(){
            return (false, "入力はひらがな・カタカナにしてください")
        } else if !self.isSequentialWord(prevWord:prevWord){
            return (false, "しりとりしてください")
        } else if isEndN(){
            return (false, "しりとりを終わらせないでください")
        }
        else {
            return(true, "")
        }
    }
}


extension String {
    func toKatakana() -> String {
        var str = ""

        for c in unicodeScalars {
            if c.value >= 0x3041 && c.value <= 0x3096 {
                str += String(describing: UnicodeScalar(c.value + 96)!)
            } else {
                str += String(c)
            }
        }

        return str
    }

    func toHiragana() -> String {
        var str = ""

        for c in unicodeScalars {
            if c.value >= 0x30A1 && c.value <= 0x30F6 {
                str += String(describing: UnicodeScalar(c.value - 96)!)
            } else {
                str += String(c)
            }
        }

        return str
    }
    
    func get_order(sf: ShiritoriFetcher)->Int{
        return (sf.shiritori.shiritoriWords?.count ?? 0  + 1)
    }
}
