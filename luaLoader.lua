local function loadV2(chunk, chunkname, env)
    local OP = {
        MOVE = 0, LOADK = 1, LOADBOOL = 2, LOADNIL = 3, GETUPVAL = 4,
        GETTABUP = 5, GETTABLE = 6, SETTABUP = 7, SETUPVAL = 8, SETTABLE = 9,
        NEWTABLE = 10, SELF = 11, ADD = 12, SUB = 13, MUL = 14, DIV = 15,
        MOD = 16, POW = 17, UNM = 18, NOT = 19, LEN = 20, CONCAT = 21,
        JMP = 22, EQ = 23, LT = 24, LE = 25, TEST = 26, TESTSET = 27,
        CALL = 28, TAILCALL = 29, RETURN = 30, FORLOOP = 31, FORPREP = 32,
        TFORCALL = 33, TFORLOOP = 34, SETLIST = 35, CLOSURE = 36, VARARG = 37
    }

    local function Lexer(input)
        local pos = 1
        local tokens = {}
        local keywords = {
            ["and"]=1,["break"]=1,["do"]=1,["else"]=1,["elseif"]=1,["end"]=1,
            ["false"]=1,["for"]=1,["function"]=1,["goto"]=1,["if"]=1,["in"]=1,
            ["local"]=1,["nil"]=1,["not"]=1,["or"]=1,["repeat"]=1,["return"]=1,
            ["then"]=1,["true"]=1,["until"]=1,["while"]=1
        }
        while pos <= #input do
            local c = input:sub(pos, pos)
            if c:match("%s") then
                pos = pos + 1
            elseif input:sub(pos, pos + 1) == "--" then
                pos = pos + 2
                while pos <= #input and input:sub(pos, pos) ~= "\n" do pos = pos + 1 end
            elseif c:match("[%a_]") then
                local s = pos
                while pos <= #input and input:sub(pos, pos):match("[%w_]") do pos = pos + 1 end
                local w = input:sub(s, pos - 1)
                table.insert(tokens, {t = keywords[w] and "KW" or "ID", v = w})
            elseif c:match("%d") then
                local s = pos
                while pos <= #input and input:sub(pos, pos):match("[%d%.xX%a]") do pos = pos + 1 end
                table.insert(tokens, {t = "NUM", v = tonumber(input:sub(s, pos - 1))})
            elseif c == '"' or c == "'" then
                local s = pos
                pos = pos + 1
                local res = ""
                while pos <= #input and input:sub(pos, pos) ~= c do
                    res = res .. input:sub(pos, pos)
                    pos = pos + 1
                end
                pos = pos + 1
                table.insert(tokens, {t = "STR", v = res})
            else
                local d = input:sub(pos, pos + 1)
                local ops = {["=="]=1,["~="]=1,["<="]=1,[">="]=1,[".."]=1,["//"]=1}
                if ops[d] then
                    table.insert(tokens, {t = "OP", v = d})
                    pos = pos + 2
                else
                    table.insert(tokens, {t = "OP", v = c})
                    pos = pos + 1
                end
            end
        end
        return tokens
    end

    local function Parser(tokens)
        local p = 1
        local function peek(n) return tokens[p + (n or 0)] end
        local function consume() local t = tokens[p]; p = p + 1; return t end
        
        local function expr(prec)
            prec = prec or 0
            local t = consume()
            local node
            if t.t == "NUM" or t.t == "STR" then node = {t = "LIT", v = t.v}
            elseif t.v == "nil" or t.v == "true" or t.v == "false" then node = {t = "LIT", v = t.v}
            elseif t.t == "ID" then
                node = {t = "VAR", v = t.v}
                if peek() and peek().v == "(" then
                    consume()
                    local args = {}
                    if peek().v ~= ")" then
                        repeat table.insert(args, expr(0)) until (peek().v ~= "," or not consume())
                    end
                    consume()
                    node = {t = "CALL", f = node, a = args}
                end
            elseif t.v == "(" then
                node = expr(0)
                consume()
            end
            
            while peek() and peek().t == "OP" do
                local op = peek().v
                local opprec = {["+"]=10,["-"]=10,["*"]=11,["/"]=11,["=="]=5,["~="]=5,["<"]=5,[">"]=5,["<="]=5,[">="]=5}
                local cur = opprec[op] or 0
                if cur <= prec then break end
                consume()
                node = {t = "BIN", o = op, l = node, r = expr(cur)}
            end
            return node
        end

        local function stmt()
            local t = peek()
            if not t then return end
            if t.v == "local" then
                consume()
                local name = consume().v
                consume()
                return {t = "LOC", n = name, v = expr(0)}
            elseif t.v == "if" then
                consume()
                local cond = expr(0)
                consume()
                local body = {}
                while peek().v ~= "end" and peek().v ~= "else" do table.insert(body, stmt()) end
                local eb
                if peek().v == "else" then consume(); eb = {}; while peek().v ~= "end" do table.insert(eb, stmt()) end end
                consume()
                return {t = "IF", c = cond, b = body, e = eb}
            elseif t.v == "return" then
                consume()
                return {t = "RET", v = expr(0)}
            else
                local e = expr(0)
                if e.t == "VAR" and peek() and peek().v == "=" then
                    consume()
                    return {t = "ASS", n = e.v, v = expr(0)}
                end
                return {t = "EXP", e = e}
            end
        end

        local ast = {}
        while p <= #tokens do table.insert(ast, stmt()) end
        return ast
    end

    local function Compiler(ast)
        local p = {code = {}, k = {}, locs = {}, up = {}}
        local function addk(v) for i,val in ipairs(p.k) do if val == v then return i-1 end end; table.insert(p.k, v); return #p.k-1 end
        local r_top = 0

        local function gen(node)
            if node.t == "LIT" then
                local r = r_top; r_top = r_top + 1
                table.insert(p.code, {o = OP.LOADK, a = r, b = addk(node.v)})
                return r
            elseif node.t == "VAR" then
                local r = r_top; r_top = r_top + 1
                if p.locs[node.v] then table.insert(p.code, {o = OP.MOVE, a = r, b = p.locs[node.v]})
                else table.insert(p.code, {o = OP.GETTABUP, a = r, b = 0, c = addk(node.v)}) end
                return r
            elseif node.t == "BIN" then
                local l = gen(node.l)
                local r = gen(node.r)
                local res = r_top; r_top = r_top + 1
                local opm = {["+"]=OP.ADD,["-"]=OP.SUB,["*"]=OP.MUL,["/"]=OP.DIV}
                table.insert(p.code, {o = opm[node.o] or OP.ADD, a = res, b = l, c = r})
                return res
            elseif node.t == "LOC" then
                local r = gen(node.v)
                p.locs[node.n] = r
            elseif node.t == "CALL" then
                local f = gen(node.f)
                local base = r_top
                for _,a in ipairs(node.a) do gen(a) end
                table.insert(p.code, {o = OP.CALL, a = f, b = #node.a + 1, c = 2})
                return f
            elseif node.t == "RET" then
                local r = gen(node.v)
                table.insert(p.code, {o = OP.RETURN, a = r, b = 2})
            end
        end

        for _,n in ipairs(ast) do r_top = 10; gen(n) end
        return p
    end

    local function VM(proto, _E)
        local regs = {}
        local pc = 1
        local up = { [0] = _E }
        while pc <= #proto.code do
            local i = proto.code[pc]
            if i.o == OP.MOVE then regs[i.a] = regs[i.b]
            elseif i.o == OP.LOADK then regs[i.a] = proto.k[i.b + 1]
            elseif i.o == OP.GETTABUP then regs[i.a] = up[i.b][proto.k[i.c + 1]]
            elseif i.o == OP.ADD then regs[i.a] = regs[i.b] + regs[i.c]
            elseif i.o == OP.SUB then regs[i.a] = regs[i.b] - regs[i.c]
            elseif i.o == OP.CALL then
                local args = {}
                for idx = 1, i.b - 1 do table.insert(args, regs[i.a + idx]) end
                local res = { regs[i.a](table.unpack(args)) }
                for idx = 1, i.c - 1 do regs[i.a + idx - 1] = res[idx] end
            elseif i.o == OP.RETURN then return regs[i.a] end
            pc = pc + 1
        end
    end

    local tokens = Lexer(chunk)
    local ast = Parser(tokens)
    local proto = Compiler(ast)
    return function(...) return VM(proto, env or _G) end
end
