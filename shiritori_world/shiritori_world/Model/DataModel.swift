import Foundation

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

struct ShiritoriWord{
    var order: Int
    var userID: String
    var lat: Double
    var long: Double
    var word: String
}
