local Frac = {}
Frac.autoCut = true -- trying to cut fraction after every operation

local shift
if bit32 then -- bit32 is Lua 5.2 feature
	shift = function(n) return bit32.rshift(n, 1) end
else
	shift = function(n) return n / 2 end
end

-- greatest common divisor
local function gcd(a, b)
	if a == 0 then return b	end
	if b == 0 then return a end
	if a == b then return a end
	if a == 1 or b == 1 then return 1 end
	if a % 2 == 0 and b % 2 == 0 then return 2 * gcd(shift(a), shift(b)) end
	if a % 2 == 0 and b % 2 ~= 0 then return gcd(shift(a), b) end
	if a % 2 ~= 0 and b % 2 == 0 then return gcd(a, shift(b)) end
	if a > b then return gcd(shift(a - b), b) end
	if a < b then return gcd(shift(b - a), a) end
end

local function isInteger(a)
	return math.floor(a) == a
end

-- Methods for fraction
local FracMethods = {}

function FracMethods:cut()
	local value = self:value()
	if isInteger(value) then
		return Frac:new(value, 1, true)
	end
	if isInteger(self.num) and isInteger(self.den) then
		local div = gcd(self.num, self.den)
		return Frac:new(self.num / div, self.den / div, true)
	else
		return self	
	end
end

function FracMethods:components()
	return self.num, self.den
end

function FracMethods:value()
	return self.num / self.den
end

--- Fraction's metatable
local FracMT = {}

FracMT.__index = FracMethods

-- Arithmetics
function FracMT.__add(f1, f2)
	if type(f2) == type(0) then
		return Frac:new(f1.num + f2 * f1.den, f1.den)
	else
		return Frac:new(f1.num * f2.den + f1.den * f2.num, f1.den * f2.den)
	end
end

function FracMT.__sub(f1, f2)
	return f1 + (-f2)
end

function FracMT.__mul(f1, f2)
	if type(f2) == type(0) then
		return Frac:new(f1.num * f2, f1.den)
	else
		return Frac:new(f1.num * f2.num, f1.den * f2.den)
	end
end

function FracMT.__div(f1, f2)
	if type(f2) == type(0) then
		return f1 * (1/f2)
	else
		return Frac:new(f1.num * f2.den, f1.den * f2.num)
	end
end

function FracMT.__pow(f1, f2)
	local power
	if type(f2) == type(0) then
		power = f2
	else
		power = f2:value()
	end
	return Frac:new(f1.num ^ power, f1.den ^ power)
end

function FracMT.__unm(f)
	return Frac:new(-f.num, f.den)
end

-- Comparison
function FracMT.__eq(f1, f2)
-- unfortunately, you cannot compare for equality fraction with number
	return f1.num * f2.den == f1.den * f2.num
end

function FracMT.__lt(f1, f2)
	local value
	if type(f2) == type(0) then
		value = f2
	else
		value = f2:value()
	end
	return f1:value() < value
end

function FracMT.__le(f1, f2)
	local value
	if type(f2) == type(0) then
		value = f2
	else
		value = f2:value()
	end
	return f1:value() <= value
end

function FracMT.__tostring(f)
	local value = f:value()
	if isInteger(value) then
		return tostring(value)
	else
		return tostring(f.num) .. " / " .. tostring(f.den)
	end
end

--- Constructor
function Frac:new(num, den, noCut)
	den = den or 1
	if den < 0 then
		num = -num
		den = -den
	end
	local frac = setmetatable({
		num = num,
		den = den
	}, FracMT)
	if self.autoCut and not noCut then
		frac = frac:cut()
	end
	return frac
end

return Frac
