const { contextBridge } = require('electron')

contextBridge.exposeInMainWorld('electronAPI', {
  // 必要なAPIのみ公開
})
