
import Foundation

class ChangeDate {
    
    private let dateString: String
    
    private static let fixedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }()
    
    private static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()
    
    init(dateString: String) {
        self.dateString = dateString
    }
    
    func changeDate() -> String {
        guard let dateFixed = ChangeDate.fixedFormatter.date(from: dateString) else { return "" }
        return ChangeDate.displayFormatter.string(from: dateFixed)
    }
}

class ConvertWeight {
    
    private let sizeString: String
    private static let units: [String] = ["б", "кб", "мб", "г", "тб", "PB", "EB", "ZB", "YB"]

    init(sizeString: String) {
        self.sizeString = sizeString
    }
    
    func convertWeight() -> String {
        guard let initialSize = Double(sizeString) else { return "" }
        
        var size = initialSize
        var index = 0
        
        while size > 1024 && index < ConvertWeight.units.count - 1 {
            size /= 1024
            index += 1
        }
        
        return String(format: "%4.2f %@", size, ConvertWeight.units[index])
    }
}
