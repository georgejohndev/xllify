-- ================================
-- xllify Demo Functions
-- ================================

xllify.ExcelFunction({
    name = "xllify.Hello",
    description = "Says hello!",
    category = "xllify Starter",
    parameters = {
        { name = "name", description = "Name to greet" },
    },
}, function(name: string)
    name = name or "World"
    return "Hello there, " .. name .. "!"
end)

-- ================================
-- Peso Amount to Words Logic
-- ================================

local ONES = {
    "", "ONE", "TWO", "THREE", "FOUR", "FIVE",
    "SIX", "SEVEN", "EIGHT", "NINE"
}

local TEENS = {
    "TEN", "ELEVEN", "TWELVE", "THIRTEEN", "FOURTEEN",
    "FIFTEEN", "SIXTEEN", "SEVENTEEN", "EIGHTEEN", "NINETEEN"
}

local TENS = {
    "", "", "TWENTY", "THIRTY", "FORTY",
    "FIFTY", "SIXTY", "SEVENTY", "EIGHTY", "NINETY"
}

local THOUSANDS = { "", "THOUSAND", "MILLION", "BILLION" }


local function numberToWords(num: number): string
    if num == 0 then
        return ""
    end

    if num < 10 then
        return ONES[num + 1]
    end

    if num < 20 then
        return TEENS[num - 9]
    end

    if num < 100 then
        local tensPart = TENS[math.floor(num / 10) + 1]
        local onesPart = num % 10
        return onesPart == 0
            and tensPart
            or tensPart .. "-" .. ONES[onesPart + 1]
    end

    if num < 1000 then
        local remainder = num % 100
        local result = ONES[math.floor(num / 100) + 1] .. " HUNDRED"
        return remainder == 0
            and result
            or result .. " " .. numberToWords(remainder)
    end

    for i = 2, #THOUSANDS do
        local power = 1000 ^ (i - 1)
        if num < power * 1000 then
            local major = math.floor(num / power)
            local remainder = num % power
            local result = numberToWords(major) .. " " .. THOUSANDS[i]
            return remainder == 0
                and result
                or result .. " " .. numberToWords(remainder)
        end
    end

    return ""
end


-- ================================
-- Excel Function: Peso Amount to Words
-- ================================

xllify.ExcelFunction({
    name = "xllify.PesoAmountToWords",
    description = "Converts a numeric amount to Philippine peso words",
    category = "Payroll / Finance",
    parameters = {
        { name = "amount", description = "Peso amount (e.g. 34065.94)" },
    },
}, function(amount: number)
    if amount == nil then
        return ""
    end

    local pesos = math.floor(amount)
    local cents = math.floor((amount - pesos) * 100 + 0.5)

    local pesoWords = numberToWords(pesos)
    if pesoWords == "" then
        pesoWords = "ZERO"
    end

    return pesoWords .. " PESOS AND "
        .. string.format("%02d", cents)
        .. "/100 ONLY"
end)
