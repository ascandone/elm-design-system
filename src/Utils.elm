module Utils exposing (getMakeConfig)


getMakeConfig :
    { unwrap : attribute -> config -> config
    , defaultConfig : config
    }
    -> List attribute
    -> config
getMakeConfig args =
    List.foldr
        (\attribute current -> args.unwrap attribute current)
        args.defaultConfig
