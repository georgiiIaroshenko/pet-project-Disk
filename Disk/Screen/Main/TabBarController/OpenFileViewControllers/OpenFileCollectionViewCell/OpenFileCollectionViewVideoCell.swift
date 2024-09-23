//
//import AVKit
//import AVFoundation
//import UIKit
//
//class OpenFileCollectionViewVideoCell: UICollectionViewCell {
//    
//    private var fileURL: URL? // URL для хранения временного файла
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupDocument(with data: Data, fileName: String, fileExtension: String) {
//        // Сохраните данные во временный файл
//        self.fileURL = saveDataToTemporaryFile(data: data, fileName: fileName, fileExtension: fileExtension)
//    }
//    
//    private func saveDataToTemporaryFile(data: Data, fileName: String, fileExtension: String) -> URL? {
//        // Получаем путь до временной директории
//        let tempDirectory = FileManager.default.temporaryDirectory
//        
//        // Создаем временный файл
//        let fileURL = tempDirectory.appendingPathComponent("\(fileName).\(fileExtension)")
//        
//        // Записываем данные в файл
//        do {
//            try data.write(to: fileURL)
//            return fileURL
//        } catch {
//            print("Ошибка при сохранении файла: \(error.localizedDescription)")
//            return nil
//        }
//    }
//    
//    // Метод для показа документа через QuickLook
//    func showDocumentPreview(from viewController: UIViewController) {
//
//    }
//}
