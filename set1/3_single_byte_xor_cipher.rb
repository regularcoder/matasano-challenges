#http://cryptopals.com/sets/1/challenges/3/ (Single-byte XOR cipher)

#https://www.branah.com/ascii-converter was invaluable in figuring out hex encoding

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

#XOR a hex-encoded string against a single byte of hex
def singleByteXOR(hexStr, keyChar)
    #ASCII character -> 1 byte of binary (8 bit) -> 2-digit hex
    hexKeyChar = binToHex(decToBin(keyChar.ord).rjust(8, '0'))
        
    #XOR output (hex)
    xorOutput = ""
    
    i = 0
    begin
        #Take 2 characters of hex from input stream
        hexStrChunk = hexStr[i..(i+1)]
                
        xorOutput.concat(hex_XOR(hexStrChunk, hexKeyChar))
        
        i = i + 2
    end until i > hexStr.length - 1
    
    return xorOutput
end

#Converts a hex-encoded string to an ASCII string
def hexToASCII(hexStr)
    asciiOutput = ""
    
    i = 0
    begin
        #2-digit hix -> 1 byte of binary -> decimal -> ASCII character
        convertedChar = binToDec(hexToBin(hexStr[i..(i+1)].rjust(8, '0'))).chr
                
        asciiOutput.concat(convertedChar)
        
        i = i + 2
    end until i > hexStr.length - 1
    
    return asciiOutput
end

#Derive a score to judge validity of plaintext
def scorePlaintext(plaintext)
    #Check for legible characters first, lots of junk data will be returned so we
    #can score well just by looking for valid chars
    charCount = plaintext.scan(/[a-zA-Z]/).length
    numCount = plaintext.scan(/[0-9]/).length
    spaceCount = plaintext.scan(/\s/).length
    
    return charCount + numCount + spaceCount
end

#Tries various single-character keys in order to break the plaintext
def breakXORCipher(cipherText)
    scoredTexts = Hash.new
    
    #Try all ASCII keys from 
    for i in 32..126 do
        keyChar = i.chr
        
        possiblePlaintext = hexToASCII(singleByteXOR(cipherText.upcase, keyChar))
        scoredTexts[keyChar] = scorePlaintext(possiblePlaintext)
        
        puts keyChar + " scored " + scoredTexts[keyChar].to_s
    end
end

puts "Please input hex string"
hexStr = gets.chomp

breakXORCipher hexStr

#X returned one of the highest scores
puts hexToASCII(singleByteXOR(hexStr.upcase, "X"))

#The end, wait until user hits Enter
gets