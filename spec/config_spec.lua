describe("migrate_old_config", function()
   local config, user_config

   setup(function()
      config = require("hardtime.config")
   end)

   before_each(function()
      user_config = {
         disabled_filetypes = {
            "a",
            b = true,
            c = false,
            ["d"] = true,
            ["e"] = false,
         },
         resetting_keys = { ["<Up>"] = {}, ["<Down>"] = { "n" } },
      }
   end)

   it(
      "should convert array elements in disabled_filetypes to key-value pairs",
      function()
         config.migrate_old_config(user_config)
         assert.are.same(
            { a = true, b = true, c = false, d = true, e = false },
            user_config.disabled_filetypes
         )
      end
   )

   it("should replace empty tables with false for options", function()
      config.migrate_old_config(user_config)
      assert.are.same({
         ["<Up>"] = false,
         ["<Down>"] = { "n" },
      }, user_config.resetting_keys)
   end)
end)
