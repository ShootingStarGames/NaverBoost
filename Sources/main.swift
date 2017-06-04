import Foundation


var stringData = ""

let FILE = FileManager.default

let dir = URL(fileURLWithPath: NSHomeDirectory())

var path:String = dir.path+"/students.json"

var Stu:[String:String] = [:]

let data  = FILE.contents(atPath: path)
let json = try? JSONSerialization.jsonObject(with: data!) as? [Any]

var size:Int 

var aver:Int = 0
var averNum:Int = 0
var stu = 0
var mark:Double = 0
func Scoring(name: Any,score: Double) {
	var grade:String	
	switch score {
	case 90...100:
		grade = "A"
	case 80..<90:
	 	grade = "B"
	case 70..<80:
		grade = "C"
	case 60..<70:
		grade = "D"
	default:
		grade = "F"
	}
	if let name = name as? String {
		Stu[name] = grade
	}
}

if let arrJson = json as? [Any] {
	size = arrJson.count
	for i in 0..<size
	{
		if let item = arrJson[i] as? [String:Any]{
			if let sub = item["grade"] as? [String:Int]{
				averNum+=sub.count
				stu = 0
				for (key,value) in sub {
					aver+=value
				 	stu+=value
				}
				mark = Double(stu)/Double(sub.count)
			}
			Scoring(name:item["name"]!,score:mark)
		}
	}
}        

var round = String(format: "%.2f",(Double(aver)/Double(averNum)))

stringData+="성적결과표\n\n"

stringData+="전체 평균 : \(round)\n\n"

let sortedStu = Stu.sorted(by: { $0 < $1 } )
var comp:[String] = []
stringData+="개인별 학점\n"
for (key, value)  in sortedStu {
	stringData+="\(key.padding(toLength: 11,withPad:" ",startingAt: 0)): \(value)\n"
       if value == "A" || value == "B" || value == "C" {
                comp.append(key)
        }

}
stringData+="\n수료생\n\n"
var str:String = ""
for key in comp {
	str+=key
	str+=", "
}

str.remove(at: str.index(before: str.endIndex))
str.remove(at: str.index(before: str.endIndex))
stringData+=str

let fileurl = dir.appendingPathComponent("result.txt")
let D = stringData.data(using: .utf8, allowLossyConversion: false)!


try! D.write(to: fileurl, options: Data.WritingOptions.atomic)	
