return {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = { ".git", "compile_commands.json", "compile_flags.txt" },
  settings = {
    clangd = {
    }
  }
}
