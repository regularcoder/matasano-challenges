#http://cryptopals.com/sets/1/challenges/1/ (Convert hex to base64)

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

#Convert to base64
def binToBase64(strBin)
    #Initialize Base64 index table
    base64IndexTable = 
    {
        0 => 'A',	16 => 'Q',	32 => 'g',	48 => 'w',
        1 => 'B',	17 => 'R',	33 => 'h',	49 => 'x',
        2 => 'C',	18 => 'S',	34 => 'i',	50 => 'y',
        3 => 'D',	19 => 'T',	35 => 'j',	51 => 'z',
        4 => 'E',	20 => 'U',	36 => 'k',	52 => '0',
        5 => 'F',	21 => 'V',	37 => 'l',	53 => '1',
        6 => 'G',	22 => 'W',	38 => 'm',	54 => '2',
        7 => 'H',	23 => 'X',	39 => 'n',	55 => '3',
        8 => 'I',	24 => 'Y',	40 => 'o',	56 => '4',
        9 => 'J',	25 => 'Z',	41 => 'p',	57 => '5',
        10 => 'K',	26 => 'a',	42 => 'q',	58 => '6',
        11 => 'L',	27 => 'b',	43 => 'r',	59 => '7',
        12 => 'M',	28 => 'c',	44 => 's',	60 => '8',
        13 => 'N',	29 => 'd',	45 => 't',	61 => '9',
        14 => 'O',	30 => 'e',	46 => 'u',	62 => '+',
        15 => 'P',	31 => 'f',	47 => 'v',	63 => '/'
    }
    
    base64Str = ""
    i = 0
    
    begin
        #Take 6 bit block from input stream and convert it to decimal
        #left pad to 6 digits
        decLookup = binToDec(strBin[i..(i+5)].ljust(6, '0'))
        
        base64Char = base64IndexTable[decLookup].to_s
                
        base64Str.concat(base64Char)
        
        i = i + 6
    end until i > strBin.length - 1
    
    #If we don't have 4-character sequences then pad with = at the end
    if base64Str.length % 4 != 0 then
        #Roll up to the nearest multiple of 4
        numTo4 = base64Str.length + (4 - (base64Str.length % 4)) 
        
        base64Str = base64Str.ljust(numTo4, '=')
        
        puts numTo4
    end
    
    return base64Str
end

puts "Please input hex"
hexString = gets.chomp

puts binToBase64(hexToBin(hexString.upcase))

#The end, wait until user hits Enter
gets