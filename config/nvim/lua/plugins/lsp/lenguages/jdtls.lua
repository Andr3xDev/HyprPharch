---------------------------------------------------------------------------
--- LSP configuration for Java using jdtls
---------------------------------------------------------------------------

return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local jdtls = require("jdtls")
    local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
    local root_dir = jdtls.setup.find_root(root_markers)
    local home = os.getenv("HOME")
    local workspace = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
    local lombok_path = vim.fn.stdpath("data") .. "/lombok/lombok.jar"

    if vim.fn.filereadable(lombok_path) == 0 then
      vim.fn.mkdir(vim.fn.fnamemodify(lombok_path, ":h"), "p")
      vim.fn.system({
        "curl",
        "-Lo",
        lombok_path,
        "https://projectlombok.org/downloads/lombok.jar",
      })
    end

    jdtls.start_or_attach({
      cmd = {
        "jdtls",
        "-data",
        workspace,
        "--jvm-arg=-javaagent:" .. mason_path,
      },
      root_dir = root_dir,
      capabilities = require("blink.cmp").get_lsp_capabilities(),
      settings = {
        java = {
          format = { enabled = false },
          signatureHelp = { enabled = true },
          completion = { importOrder = {} },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
        },
      },
    })
  end,
}
