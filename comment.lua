function Image(comment)
      if comment.classes:find('comment',1) then
        local f = io.open("comments/" .. comment.src, 'r')
        local doc = pandoc.read(f:read('*a'))
        f:close()
        local comment = pandoc.utils.stringify(doc.meta.comments) or "Comment has not been set"
        local author = pandoc.utils.stringify(doc.meta.author) or "Author has not been set"
        local commentation = "> " .. comment .. " " .. author
        return pandoc.RawInline('markdown',commentation)
      end
end
