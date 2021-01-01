import Foundation
import MapKit

struct User{
    var userID: String?
    var name:String?
    var age:Int?
    var sex:String?
    var isDeleted:Bool=false
    var currentShiritoriID: String?
}

struct Shiritori{
    var shiritoriID: String?
    var month: String? // YYYYMM
    var shiritoriWords: [ShiritoriWord]?
    var totalDistanceKM: Int?
}




struct ShiritoriWord:Identifiable{
    var id: Int
    var userID: String
    var name: String?
    var word: String
    var lat: Double
    var long: Double
    var location:CLLocation{
        CLLocation(latitude: self.lat, longitude: self.long)
    }
    var address: String?
    var answerDate: Date
    var answerDateStr:String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy/MM/dd"
        let dateStr = formatter.string(from: self.answerDate)
        return dateStr
    }
    var is_location_masked: Bool = false
    var is_word_masked: Bool = false
    var is_name_masked: Bool = false
    var is_reported: Bool = false
    var masked_address: String?{
        if(is_location_masked || is_reported){
            return "【非公開】"
        }else{
            return address
        }
    }
    var masked_name: String?{
        if(is_name_masked || is_reported){
            return "【非公開】"
        }else{
            return name
        }
    }
    var masked_word: String{
        if(is_word_masked || is_reported){
            return "【非公開】"
        }else{
            return word
        }
    }
    func toFirestoreMap()->[String:Any]{
        [
            "order": self.id,
            "user_id": self.userID,
            "name": self.name as Any,
            "word": self.word,
            "lat": self.lat,
            "long": self.long,
            "answer_date": self.answerDate,
            "is_location_masked": self.is_location_masked,
            "is_name_masked": self.is_name_masked,
            "is_word_masked": self.is_word_masked
        ]
    }
}
