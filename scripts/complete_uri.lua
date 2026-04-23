local BASE_URL = "https://mpv.io/manual/stable/"

function Link(el)
    local target = el.target
    
    -- 情况 1: 链接是空的 [List of events]()
    if target == "" then
        -- 获取链接内的纯文字，转为小写并将空格换成连字符
        local text = pandoc.utils.stringify(el.content)
        local anchor = text:lower():gsub(" ", "-")
        el.target = BASE_URL .. "#" .. anchor
        return el
    end

    -- 情况 2: 链接已有锚点 [Events](#events)
    if target:sub(1, 1) == "#" then
        el.target = BASE_URL .. target
        return el
    end

    return el
end