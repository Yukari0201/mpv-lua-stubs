function CodeBlock(e)
  -- 强制将所有代码块转为带围栏的格式，并添加语言标识
  return pandoc.RawBlock('markdown', '```lua\n' .. e.text .. '\n```')
end