import Foundation
import MapKit

struct User{
    var userID: String
    var name:String
    var age:Int
    var sex:String
    var is_deleted:Bool
}

struct Shiritori{
    var shiritoriID: Int
    var month: String // YYYYMM
    var shiritoriWords: [ShiritoriWord]
}




struct ShiritoriWord:Identifiable{
  var id: Int
  var userID: String
  var word: String
  var lat: Double
  var long: Double
  var location:CLLocation{
    CLLocation(latitude: self.lat, longitude: self.long)
  }
  var address: String?
}
