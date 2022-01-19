"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[996],{28222:function(e){e.exports=JSON.parse('{"functions":[{"name":"willUpdate","desc":"It\'s here to make sure that before the component updates, the new location\\nthat the tool edits in is binded.","params":[],"returns":[],"function_type":"method","source":{"line":74,"path":"src/App.lua"}},{"name":"willUnmount","desc":"To disconnect the event keeping track of changes.","params":[],"returns":[],"function_type":"method","source":{"line":81,"path":"src/App.lua"}},{"name":"render","desc":"Render.","params":[],"returns":[{"desc":"","lua_type":"RoactTree"}],"function_type":"method","source":{"line":92,"path":"src/App.lua"}},{"name":"HookOnTargetEditingInstance","desc":"Hooks onto target and ensures last target disconnects before doing so. Keeps\\ntrack of target if it gets deparented.","params":[{"name":"EditingIn","desc":"","lua_type":"Instance?"}],"returns":[],"function_type":"method","source":{"line":187,"path":"src/App.lua"}}],"properties":[{"name":"ROUTES","desc":"The list of avaliable routes. Currently, they are:\\n- Studder\\n- Painter","lua_type":"{ string }","source":{"line":23,"path":"src/App.lua"}}],"types":[{"name":"Props","desc":"","fields":[{"name":"SettingManager","lua_type":"Settings","desc":""},{"name":"Enabled","lua_type":"boolean","desc":""}],"source":{"line":57,"path":"src/App.lua"}}],"name":"App","desc":"The root for this plugin.\\n\\nThe app looks like this when EditingIn is valid.\\n\\n![App when EditingIn is valid.](/rendered/app.png)\\n\\nIf it isn\'t valid, it will render this menu instead.\\n\\n![App when EditingIn isn\'t valid.](/rendered/appUponInvalidEditingIn.png)\\n\\nTODO:\\n1.\\tThe way the component keeps track of \\"EditingIn\\" is hacky. Streamline it\\n\\tby extracting the logic to figure out of the \\"EditingIn is valid into a\\n\\tstatic function. In render, if it\'s invaild then set the state\\n\\taccordingly?\\n2.\\tInstanceQuerier needs to be fixed up as well, not sure why I set it up\\n\\tthe way I did. As soon I do, we\'ll get rid of the pcall.\\n3.\\tMake it so that the menu upon a invaild EditingIn is its own component.","source":{"line":49,"path":"src/App.lua"}}')}}]);