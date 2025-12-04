return {
  {
    'yetone/avante.nvim',
    opts = {
      provider = 'lmstudio',
      providers = {
        lmstudio = {
          __inherited_from = 'openai',
          endpoint = 'http://localhost:1234/v1',
          model = 'openai/gpt-oss-120b',
          api_key_name = 'TERM',
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
      },
      selection = {
        hint_display = 'none',
      },
      behaviour = {
        auto_set_keymaps = false,
      },
      acp_providers = {
        ['opencode'] = {
          command = 'opencode',
          args = { 'acp' },
          -- env = {
          --   OPENCODE_API_KEY = os.getenv("OPENCODE_API_KEY")
          -- }
        },
      },
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    config = function()
      require('neo-tree').setup {
        filesystem = {
          commands = {
            avante_add_files = function(state)
              local node = state.tree:get_node()
              local filepath = node:get_id()
              local relative_path = require('avante.utils').relative_path(filepath)

              local sidebar = require('avante').get()

              local open = sidebar:is_open()
              -- ensure avante sidebar is open
              if not open then
                require('avante.api').ask()
                sidebar = require('avante').get()
              end

              sidebar.file_selector:add_selected_file(relative_path)

              -- remove neo tree buffer
              if not open then
                sidebar.file_selector:remove_selected_file 'neo-tree filesystem [1]'
              end
            end,
          },
          window = {
            mappings = {
              ['oa'] = 'avante_add_files',
            },
          },
        },
      }
    end,
  },
}
