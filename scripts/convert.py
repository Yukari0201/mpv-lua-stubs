import re
import os

# 二级标题黑名单
# ! 一定要加 \n
blacklist_title = [
    "## Example\n",
    "## Script location\n",
    "## Details on the script initialization and lifecycle\n",
]

# 要扫描的 .md 文件路径
lua_md = "lua.md"


class Module:
    """所有模块的基类"""

    name = ""  # 模块名
    keyword = r""  # 标题关键字
    path = "library/"  # 模块路径
    content_arr = []

    def __init__(self, name, keyword, path_append):
        self.name = name
        self.path = self.path + path_append
        self.keyword = keyword
        self.content_arr = []


# 目前(v0.41.0) 需要捕获的所有 regex: (mp|mp\..*)
mp = Module("mp", "", "mp.lua")
mp_msg = Module("msg", r"^##\s+mp\.msg.*", "mp/msg.lua")
mp_options = Module("options", r"^##\s+mp\.options.*", "mp/options.lua")
mp_utils = Module("utils", r"^##\s+mp\.utils.*", "mp/utils.lua")
mp_input = Module("input", r"^##\s+mp\.input.*", "mp/input.lua")

modules = [mp, mp_msg, mp_options, mp_utils, mp_input]


def check_dir_exists():
    if not os.path.exists("library/mp"):
        os.makedirs("library/mp", exist_ok=True)


def open_md_file(md_file):
    with open(md_file, encoding="utf-8") as f:
        return f.readlines()


def scan_string_arr(string_arr, keyword_regex):
    """
    通用索引扫描：返回匹配行在数组中的索引
    """
    keywords_index = []
    index = 0
    for line in string_arr:
        if re.match(keyword_regex, line) and line not in blacklist_title:
            keywords_index.append(index)
        index += 1
    return keywords_index


def split_arr_by_keyword(string_arr, keywords_index):
    """
    通用分割方法：根据索引列表将一维数组切分为多个子数组（Block）
    """
    if not keywords_index:
        return string_arr

    new_arr = []
    if keywords_index[0] != 0:
        new_arr.append(string_arr[: keywords_index[0]])
    # 算出每个块的结束位置
    ends = keywords_index[1:] + [len(string_arr)]
    for start, end in zip(keywords_index, ends):
        block = string_arr[start:end]
        # 只有 block 不为空才添加
        if block:
            new_arr.append(block)

    return new_arr


def write_file(filepath, string_arr):
    """
    将一维数组写入文件
    """
    with open(filepath, "w") as f:
        for line in string_arr:
            f.write(line)


def write_module(module):
    arr = ["---@meta\n"]
    if module.name == "mp":
        arr.append("mp = mp\n\n")
    else:
        arr.append(f"{module.name} = {{}}\n\n")

    for block in module.content_arr:
        for sub_block in block:
            arr.extend(sub_block)
        arr.append("\n")

    arr.append(f"return {module.name}\n")
    write_file(module.path, arr)


"""
流水线...
"""
print("开始处理...")
check_dir_exists()
md_arr = open_md_file(lua_md)


title_regex = r"^##.*"
title_index_arr = scan_string_arr(md_arr, title_regex)
block_arr = split_arr_by_keyword(md_arr, title_index_arr)

for block in block_arr:
    match_title = False
    for mod in modules[1:]:
        if re.match(mod.keyword, block[0]):
            mod.content_arr.append(block)
            match_title = True
            break
    if not match_title:
        modules[0].content_arr.append(block)

code_regex = r"^`[a-zA-Z0-9_\.]+\(.*?\)`"

for mod in modules:
    new_mod_blocks = []
    for i in range(len(mod.content_arr)):
        block = mod.content_arr[i]
        code_index_arr = scan_string_arr(block, code_regex)
        # 细分这个标题块
        sub_blocks = split_arr_by_keyword(block, code_index_arr)
        # print(sub_blocks)
        new_sub_blocks = []
        for sb in sub_blocks:
            if re.match(code_regex, sb[0]):
                func_line = sb[0]
                # 提取括号内的内容，例如 "str [, trail]"
                param_match = re.search(r"\((.*?)\)", func_line)
                params_str = param_match.group(1) if param_match else ""

                # --- 生成 @param 注释 ---
                # 简单处理：提取所有单词作为参数名
                param_names = re.findall(r"[a-zA-Z0-9_]+", params_str)
                param_annotations = []
                for p in param_names:
                    # 如果原始字符串里带 [ ]，则标记为可选 ?
                    is_optional = "?" if f"[{p}]" in params_str.replace(" ", "") else ""
                    param_annotations.append(f"---@param {p}{is_optional} any\n")

                # --- 处理重载 (可选参数与联合类型) ---
                # 获取基础函数名 (例如 mp.utils.get_property)
                base_name = re.match(r"`([a-zA-Z0-9_\.]+)", func_line).group(1)

                overloads = []
                if "[" in params_str or "|" in params_str:
                    # 【完整版】：用刚才抓取的干净单词重新 join
                    # 处理联合类型：如果是 a|b，findall 会抓成 ['a', 'b']，我们需要特殊处理
                    # 所以完整版建议先做一次 | 的替换再抓词
                    full_params_clean = params_str.replace("|", "_")
                    full_list = re.findall(r"[a-zA-Z0-9_]+", full_params_clean)
                    full_params = ", ".join(full_list)
                    overloads.append(f"function {base_name}({full_params}) end\n")

                    # 【基础版】：去掉所有 [] 及其内部内容
                    base_raw = re.sub(r"\[.*?\]", "", params_str)
                    base_list = re.findall(r"[a-zA-Z0-9_]+", base_raw)
                    base_params = ", ".join(base_list)

                    if base_params != full_params:
                        overloads.append(f"function {base_name}({base_params}) end\n")
                else:
                    # 普通无可选参数的方法
                    overloads.append(f"function {base_name}({params_str}) end\n")

                desc_arr = []
                for desc in sb[1:]:
                    desc_arr.append("-- " + desc)
                # 最终重组：[描述文本] + [Param注释] + [所有重载版本] + [换行]
                # desc_arr 是原来的描述文本
                reordered = desc_arr + param_annotations + overloads + ["\n"]
                new_sub_blocks.append(reordered)
        mod.content_arr[i] = new_sub_blocks

for mod in modules:
    write_module(mod)
    print("Module：", mod.name, "write success")


print("处理完成！")
