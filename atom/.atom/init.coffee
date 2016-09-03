# Set grammar to TIS if first line is @0
atom.workspace.observeTextEditors (editor) ->
  editor.onDidSave () ->
    if editor.lineTextForBufferRow(0) == '@0'
      editor.setGrammar(atom.grammars.grammarForScopeName('source.asm.TIS'))

atom.workspace.onDidOpen (editor) ->
  if editor.item.lineTextForBufferRow(0) == '@0'
    editor.item.setGrammar(atom.grammars.grammarForScopeName('source.asm.TIS'))
