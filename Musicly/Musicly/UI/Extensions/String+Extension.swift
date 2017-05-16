import Foundation

extension String {
    static func constructTimeString(time: Int) -> String {
        var timeString = String(describing: time)
        var timerString = ""
        if timeString.characters.count < 2 {
            timerString = "0:0\(timeString)"
        } else if timeString.characters.count <= 2 {
            timerString = "0:\(timeString)"
        }
        return timerString
    }
}
