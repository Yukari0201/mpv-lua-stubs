# How to use? | 如何使用？

Clone this repository to any directory you like.
Avoid paths containing special characters.

克隆此存储库到你想要的任意目录中，
请避免路径中包含特殊字符。

---

## VS Code

Install the **Lua Language Server** extension:  
https://luals.github.io/#install

安装 **Lua Language Server** 扩展：  
https://luals.github.io/#install

Then open your VS Code settings and add the following configuration:

然后打开 VS Code 的配置文件，添加如下内容：

```jsonc
{
  "Lua.workspace.library": [
    "/absolute/path/to/mpv-lua-stubs/library"
  ]
}
```

> [!WARNING]  
> The path must be the absolute path to the library directory in this repository.  
> 路径 必须是 你克隆的此存储库中 library 目录的 绝对路径。

Enjoy 🎉