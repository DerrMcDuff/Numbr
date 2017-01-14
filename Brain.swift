import Foundation

let digits = CharacterSet.decimalDigits
var letters = CharacterSet.letters

class Variable {
    var name:String
    var value:Double
    
    init(_ n:String,_ v:Double) {
        name = n
        value = v
    }
}

var dictio:[(Variable)] = []



class Answer {
    var number:Double?
    var letters:String
    
    init(is a: String) {
        letters = a
    }
    
    init(is a: String, valueOf b: Double) {
        letters = a
        number = b
    }
    
    func printAns() {
        if ((self.number) != nil){
            print("letters: \(self.letters), number: \(self.number)")
        } else {
            print("letters: \(self.letters)")
        }
        
    }
}

enum type {
    case num
    case ltr
    case sym
}


func stringType (_ c:UnicodeScalar)->type {
    if digits.contains(c) {
        return type.num
    } else if letters.contains(c) {
        return type.ltr
    } else {
        return type.sym
    }
}

func segment (_ t:String)->[(String, type)] {
    
    let tc = t.components(separatedBy: " ")
    var segmented:[(String,type)] = []
    var one = ""
    for b in tc {
        one=""
        var currentType:type = stringType(b.unicodeScalars.first!)
        for c in b.unicodeScalars {
            let newType = stringType(c)
            if (newType != currentType) {
                segmented.append((one, currentType))
                currentType = newType
                one = c.description
            } else {
                one.append(c.description)
            }
        }
        segmented.append((one, currentType))
    }
    return segmented
}

func isEquation(_ g:[(String,type)])-> String {
    var converted:[(String,type)] = g
    var current = g[0]
    var toCompute:String = ""
    
    for (ii, e) in g.enumerated() {
        
        if (ii != 0 && (current.1 == e.1)){
            if !(current.0 == "*" && e.0 == "*") {
                return ""
            }
        }
        
        if e.1 == type.ltr {
            var found = false
            for word in dictio {
                if e.0 == word.name {
                    converted[ii].0 = String(word.value)
                    converted[ii].1 = type.num
                    found = true
                }
            }
            if (!found) {return ""}
        }
        
        current = e
        toCompute.append(converted[ii].0)
    }
    print(toCompute)
    return toCompute
}

func processAction(of s:[(String,type)]) -> Answer{
    
    let cpa = Answer(is: "")
    
    //association
    if (s[0].1 == type.ltr && s[1] == ("=",type.sym)) {
        
        let part = Array(s[2..<s.endIndex])
        let answer = isEquation(part)
        if answer != "" {
            let exp = NSExpression(format: answer)
            let sq = exp.expressionValue(with: nil, context: nil)
            let uw = sq as! Double
            cpa.number = uw
            cpa.letters = "\(uw)"
            let nv = Variable(s[0].0,uw)
            dictio.append(nv)
        }
    }
    else
    {
        //computation
        let ans = isEquation(s)
        if ans != "" {
            let s = NSExpression(format: ans)
            let sq = s.expressionValue(with: nil, context: nil)
            let uw = sq as! Double
            cpa.number = uw
            cpa.letters = "\(uw)"
        }
    }
    
    return cpa
}


func mainAlgo (_ input:[Line]) {
    for line in input {
        if line.getContent() != "" {
            let segmentedInput = segment(line.getContent())
            let algoAns:Answer = processAction(of: segmentedInput)
            line.setAnswer(algoAns.letters)
            algoAns.printAns()
        }
    }
    
}

