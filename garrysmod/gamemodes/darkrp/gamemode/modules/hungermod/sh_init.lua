local plyMeta = FindMetaTable("Player")
plyMeta.isCook = fn.Compose{fn.Curry(fn.GetValue, 2)("cook"), plyMeta.getJobTable}
