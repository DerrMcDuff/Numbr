import Foundation


//-------------------------------------------------

let digits = CharacterSet.decimalDigits
var letters = CharacterSet.letters
let shouldBDigits:CharacterSet = CharacterSet(charactersIn: ".")



enum type {
    case num
    case ltr
    case sym
}


let alphaB = ["aa","bb","cc","dd","ee","ff","gg","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz"]


class Element: NSObject, NSCopying {
    
    var typeOf: type
    var letters: String
    var number: Double?
    
    init(_ a: String, ofType t: type) {
        letters = a
        typeOf = t
    }
    
    func printAns() {
        if let n = self as? Numeral {
            print("letters: \(n.letters), number: \(n.number)")
        } else {
            print("letters: \(self.letters)")
        }
    }
    
    init(_ a: String) {
        number = Double(a)
        letters = a
        typeOf = type.num
    }
    
    init(double a: Double) {
        number = a
        letters = String(a)
        typeOf = type.num
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Element(letters, ofType: typeOf)
        return copy
    }
    
}

class Numeral: Element {
    
    
    override func copy(with zone: NSZone?) -> Any {
        let copy = Numeral(letters)
        return copy
    }
    
}



class Variable {
    var letters:String
    var number:Double
    init(_ l:String,_ n:Double) {
        letters = l
        number = n
    }
}

var dictio:[(Variable)] = []

var reference:[(Element)] = []

func stringType (_ c:UnicodeScalar)->type {
    if digits.contains(c) || shouldBDigits.contains(c){
        return type.num
    } else if letters.contains(c) {
        return type.ltr
    } else {
        return type.sym
    }
}

func segment (_ t:String)-> [Element] {
    
    let tc = t.components(separatedBy: " ")
    
    
    var segmented:[(Element)] = []
    var one = ""
    for k in tc {
        let b = k.trimmingCharacters(in: .whitespaces)
        
        if b == "" {
            continue
        }
        
        one=""
        var currentType:type = stringType(b.unicodeScalars.first!)
        for c in b.unicodeScalars {
            let newType = stringType(c)
            if (newType != currentType) {
                if currentType == type.num {
                    segmented.append(Numeral(one))
                } else {
                    segmented.append(Element(one, ofType: currentType))
                }
                
                currentType = newType
                one = c.description
            } else {
                one.append(c.description)
            }
        }
        if currentType == type.num {
            segmented.append(Numeral(one))
        } else {
            segmented.append(Element(one, ofType: currentType))
        }
        
    }
    return segmented
}

extension String {
    var expression: NSExpression {
        return NSExpression(format:self)
    }
}

func isEquation(_ g:[Element])-> ([AnyHashable:Any],String){
    
    
    let justRef:Bool = (g.count == 1)&&(g[0].typeOf==type.ltr)
    
    var toCompute:String = ""
    var converted:[(Element)] = g
    var current = g[0]
    var dic:[AnyHashable:Any] = [:]
    
    for (ii, e) in g.enumerated() {

        if (ii != 0 && (current.typeOf == e.typeOf)){
            if !(current.letters == "*" && e.letters == "*") {
                return (dic,"")
            }
        }
        
        if e.typeOf == type.ltr && !dictio.isEmpty{
            var found = false
            for word in dictio {
                if e.letters == word.letters {
                    let newNum = Numeral(double: word.number)
                    converted[ii] = newNum
                    found = true
                }
                if (found) {break}
            }
            if (!found) {return (dic,"")}
        }
        
        if justRef {
            return (dic,converted[ii].letters)
        }
        
        
        current = e
        
        
        let funStuff = alphaB[ii]
        
        switch converted[ii].typeOf {
        case type.num:
            if converted[ii].number != nil {
                reference.append(Element(double:converted[ii].number!))
                dic["\(funStuff)"] = reference.last?.number
                toCompute.append("\(funStuff)")
            } else {
                return(dic,"")
            }
            
        case type.ltr:
            // Will take care of kinds!
            reference.append(Element(converted[ii].letters, ofType: type.ltr))
        case type.sym:
            reference.append(Element(converted[ii].letters, ofType: type.sym))
            toCompute.append("\(converted[ii].letters)")
        }
        
    }
    return (dic,toCompute)
}


func compute(_ e: [Element],_ affectation:String = "")->Element {
    
    let answer = isEquation(e)
    
    
    if answer.1 != "" {
        if let oreo = answer.1.expression.expressionValue(with: answer.0, context: nil)  as? Double {
            if affectation != "" {
                dictio.append(Variable(affectation, oreo))
            }
            return Numeral(double:oreo)
        }
    } else if ((answer.0.isEmpty) && (reference.isEmpty)){
            return Element(answer.1, ofType: type.num)
    }
     return Element("",ofType:type.ltr)
}

func processAction(of d:[(Element)]) -> Element {
    
    var cpa:Element
    
    
    // Is the d too short?
    
    
    //association
    if ((d.count > 1) && (d[0].typeOf == type.ltr) && (d[1].letters == "=")){
        
        let part = Array(d[2..<d.endIndex])
        
        cpa = compute(part, d[0].letters)
    }
    else
    {
        //computation
        cpa = compute(d)
    }
    
    return cpa
}

func mainAlgo (_ input:[Line]) {
    for line in input {
        if line.getContent() != "" {
            let segmentedInput = segment(line.getContent())
            let algoAns:Element = processAction(of: segmentedInput)
            if algoAns.letters.hasSuffix(".0"){
                let endex = algoAns.letters.index(algoAns.letters.endIndex, offsetBy: -2)
                algoAns.letters = algoAns.letters.substring(to: endex)
            }
            if (algoAns.letters != "") {
                line.setAnswer(" \(algoAns.letters)")
                algoAns.printAns()
            }
        }
        reference.removeAll()
    }
    // until better implementation
    
}

