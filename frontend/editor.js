function registerVerilogLanguage() {
  monaco.languages.register({ id: 'verilog' });
  monaco.languages.setMonarchTokensProvider('verilog', {
    tokenizer: {
      root: [
        [/\b(always|assign|begin|case|default|else|end|endcase|endmodule|for|forever|if|initial|input|module|negedge|output|posedge|reg|wire)\b/, 'keyword'],
        [/[+\-*/=<>!&|^~?:]+/, 'operator'],
        [/\d+'[bhd][0-9a-fA-F_xzXZ]+/, 'number'],
        [/\d+/, 'number'],
        [/"([^"\\]|\\.)*"/, 'string'],
        [/\/\/.*$/, 'comment'],
        [/\/\*/, 'comment', '@comment'],
        [/[a-zA-Z_]\w*/, 'identifier'],
      ],
      comment: [
        [/[^\/*]+/, 'comment'],
        [/\*\//, 'comment', '@pop'],
        [/[\/*]/, 'comment'],
      ],
    },
  });
}

window.initEditor = function initEditor(initialCode, onReady) {
  require.config({ paths: { vs: 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.44.0/min/vs' } });
  require(['vs/editor/editor.main'], function () {
    registerVerilogLanguage();
    window.editorInstance = monaco.editor.create(document.getElementById('editor'), {
      value: initialCode,
      language: 'verilog',
      theme: 'vs-dark',
      automaticLayout: true,
      fontSize: 14,
      minimap: { enabled: false },
      scrollBeyondLastLine: false,
      tabSize: 2,
      insertSpaces: true,
      wordWrap: 'on',
    });
    if (typeof onReady === 'function') {
      onReady(window.editorInstance);
    }
  });
};
