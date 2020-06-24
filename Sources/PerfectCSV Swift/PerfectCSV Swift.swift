import Foundation
import FoundationNetworking

public struct CSVSwift {

    
    public let hasHeaders : Bool
    public var headers : [String]?
 
    private var decoder : CSVDecoder
    public var csvContents : CSV?


   public init(filePath : String, hasHeaders : Bool){
        

        self.decoder = CSVDecoder(filePath: filePath)
        self.csvContents = self.decoder.decodedCSV

        self.hasHeaders = hasHeaders
        self.headers = [String]()

        if self.hasHeaders == true {

           self.headers = csvContents!.contentsOfRow(0)

        } else {

           self.headers = nil

        }

   } 
         
  public init(downloadFile _url : String , fileName : String , saveAt _path : String , hasHeaders : Bool) {

       self.decoder = CSVDecoder(downloadFile: _url, fileName: fileName, save: _path)
       self.csvContents = self.decoder.decodedCSV

        self.hasHeaders = hasHeaders
        self.headers = [String]()

        if self.hasHeaders == true {

           self.headers = csvContents!.contentsOfRow(0)

        } else {

           self.headers = nil

        }
    }
    
}


public struct CSV {
    
   fileprivate var arrayContent : [[String]]


    public init(){

      self.arrayContent = [[String]]()
  }
    public init(contentOf : [[String]]){
      
      self.arrayContent = contentOf   
  }


  public mutating func contentAt(row : Int , column : Int ) -> String? {
   
    let content : String? = arrayContent[row][column]

      if let content = content {
        
          return content

         } else {

        return nil
           
    }
  }
  
  public mutating func contentsOfRow(_ row : Int ) -> [String]? {

          let contents : [String]? = arrayContent[row]

         if let content = contents{

          return content   
        
         } else {

          return nil
    
         }
     }

   public mutating func contentsOfColumn(_ column : Int ) -> [String]? {
        
           var columnContents : [String] = []

      for i in 0...arrayContent.count - 1 {

           let rows = contentsOfRow(i)

        if let rows = rows {

           columnContents.append(rows[column])
              
                }
            }

       return columnContents

   }  
}



public struct CSVDecoder {

    
    public var decodedCSV : CSV


  public init(filePath : String){

      self.decodedCSV = CSV()
      self.decodedCSV = decodeCSV(path: filePath)

   }

  public init(downloadFile _url : String , fileName : String , save _at: String ) {
       
      self.decodedCSV = CSV()
    
    let decoded = downloadCSVFile(from: _url, saveAt: _at, fileName: fileName)
    
     if let decoded = decoded {
  
       self.decodedCSV = decoded     
     
     }
     
   }
    
     private func decodeCSV(path : String) -> CSV {
           
             let fileURL = URL(fileURLWithPath: path)
             var csvArray : [[String]] = [[]]

         do{  
               let data = try Data(contentsOf: fileURL)
               let strCSV = String.init(data: data, encoding: .utf8)
               let rows : [String] = strCSV?.components(separatedBy: "\n") ?? ["Error"]
           
        for row in rows {
           
            if row.contains(",") == true {
              
                 csvArray.append(row.components(separatedBy: ","))             // SEPARATING WITH ; OR , DEPENDING OF THE CSV FILE 
           
              } else if row.contains(";") == true {

                 csvArray.append(row.components(separatedBy: ";"))             

              }
           
           }     

        } catch {
                   
            print("Unexpected error while decoding file")

         }
        
        //CLEAN DATA FROM FIRST EMPTY ROW


        if csvArray[0] == [] {

            csvArray.removeFirst()


         }

             return CSV(contentOf:csvArray)
     }

     private func downloadCSVFile(from _url: String , saveAt _path : String, fileName : String) -> CSV? {
         
         let ext = ".csv"
            
         let fileURL = URL(string: _url)
         let saveFolder = _path  + "/\(fileName)+ \(ext)"
         let savePath = URL(fileURLWithPath: saveFolder)

    do {

           let data = try Data(contentsOf: fileURL!)
  
      try data.write(to: savePath, options: [])

         } catch {

            print("Unexpected error : Couldn't download file")

         }

            print("Downloading file...")        
    
           let verification = verifyFileExistence(path: savePath)

    if verification == true {
          
            print("Download file : done ")
            
         return  decodeCSV(path: saveFolder)
        
         } else {
 
            print("Unexpected error : Downloaded file isn't where expected")     
        
         return nil
         
         }

     }

  private func verifyFileExistence(path : URL) -> Bool {

      do{

           var data = try Data(contentsOf: path)
        
    } catch {

          print("Unexpected error")
         
            return false
        
        }

    return true       

  }

}




public struct CSVEncoder {


    public init(saveAtPath : String , withName : String , contentOf : [[String]] ){

      saveAt(contentOf: contentOf, path: saveAtPath , fileName: withName)

   }

    public mutating func saveAt(contentOf : [[String]] , path : String, fileName : String)  {
          
            let ext = ".csv"

            var str = String()
            let saveFileURL = URL(fileURLWithPath: path + "/" + fileName + ext)
 
        for rows in contentOf {

            let row =  rows.joined(separator: ",") + "\n"

            str += row

        }

        do{

          try  str.write(to: saveFileURL, atomically: true , encoding:.utf8)
       

        } catch {

            print("Unexpected error : Couldn't save file")

        }

    }
     
}


