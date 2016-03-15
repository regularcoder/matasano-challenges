#http://cryptopals.com/sets/1/challenges/2/ (Fixed XOR)

#Convert decimal to binary
def decToBin(inputNum, padLen = 4)
    binStr = ""
    tempNum = inputNum
    
    while tempNum > 0 do
        binStr.concat((tempNum % 2).to_s)
        tempNum = tempNum / 2    
    end
    
    return binStr.reverse.rjust(padLen, '0')
end

#Converts a hexadecimal *character* to decimal
def hexToDec(hexChar)
    #Between 0 and 9
    if hexChar.match(/\d/)
        return hexChar.to_i
    else
        case hexChar        
            when 'A'
                return 10    
            when 'B'
                return 11    
            when 'C'
                return 12    
            when 'D'
                return 13    
            when 'E'
                return 14    
            when 'F'
                return 15
        end
    end        
end

#Converts binary to hexadecimal
def decToHex(decNum)
 #Between 0 and 9
 if decNum >= 0 and decNum <= 9
    return decNum.to_s
    else
        case decNum        
            when 10
                return 'A'    
            when 11
                return 'B'    
            when 12
                return 'C'    
            when 13
                return 'D'    
            when 14
                return 'E'    
            when 15
                return 'F'
        end
    end        
end

#Converts hexadecimal string to a binary string
def hexToBin(hexStr)
    binStr = ""
    
    hexStr.split("").each do |c|
        binStr.concat(decToBin(hexToDec(c)))
    end
    
    return binStr
end

#Convert binary to decimal
def binToDec(binStr)
    decNum = 0
    powerMult = binStr.length - 1
    
    binStr.split("").each do |b|
        decNum += b.to_i * (2**powerMult)
        
        powerMult = powerMult - 1
    end
    
    return decNum
end

#Convert bin to hex (chunking 4 digits)
def binToHex(binStr)
    hexStr = ""
    
    i = 0
        
    begin
        #Take 4 bit block from input stream and convert it to decimal
        decValue = binToDec(binStr[i..(i+3)])
                
        hexChar = decToHex(decValue)
                        
        hexStr.concat(hexChar)
        
        i = i + 4
    end until i > binStr.length - 1
    
    return hexStr
end

#Perform XOR of two hex strings
def hex_XOR(hex1, hex2)
    bin1 = hexToBin(hex1)
    bin2 = hexToBin(hex2)
    
    #XOR result in binary
    xorBin = ""
    
    for i in 0..bin1.length-1 do
        xorBitResult = bin1[i].to_i ^ bin2[i].to_i
        xorBin.concat(xorBitResult.to_s)
    end
    
    return binToHex(xorBin)
end

puts "Please input hex 1"
hex1 = gets.chomp

puts "Please input hex 2"
hex2 = gets.chomp

puts hex_XOR(hex1.upcase, hex2.upcase)

#The end, wait until user hits Enter
gets