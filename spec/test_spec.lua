describe("Busted unit testing framework", function()
   describe("should be awesome", function()
      it("should be easy to use", function()
         vim.print("hi")
         assert.truthy("Yup.")
      end)

      it("should have lots of features", function()
         -- deep check comparisons!
         assert.same({ table = "great" }, { table = "great" })

         -- or check by reference!
         assert.is_not.equals({ table = "great" }, { table = "great" })

         assert.falsy(nil)
         assert.error(function()
            error("Wat")
         end)
      end)

      it("should provide some shortcuts to common functions", function()
         assert.unique({ { thing = 1 }, { thing = 2 }, { thing = 3 } })
      end)
   end)
end)
