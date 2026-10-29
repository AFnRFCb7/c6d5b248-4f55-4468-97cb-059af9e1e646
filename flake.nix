{
    inputs =
        {
        } ;
    outputs =
        { self } :
            {
                lib =
                    { input ? null , output ? null } :
                        let
                            implementation =
                                { lib , pkgs , ... } @module :
                                    let
                                        identified =
                                            if builtins.typeOf input == "lambda" then input module
                                            else if builtins.typeOf input == "null" then module
                                            else builtins.throw "6516125758865184" ;
                                        in
                                            with identified ;
                                                {
                                                    options =
                                                        {
                                                            gc-root =
                                                                lib.mkOption
                                                                    {
                                                                        default =
                                                                            {
                                                                                gc-roots-dir ,
                                                                                sequential-file ,
                                                                                sequential-lock
                                                                            } :
                                                                                config.lazy-shell-application
                                                                                    {
                                                                                        mounts = { gc-roots = { source = gc-roots-dir ; type = "bind" ; } ; } ;
                                                                                        name = "gc-root" ;
                                                                                        post = null ;
                                                                                        runtime-inputs =
                                                                                            { config , pkgs , ... } :
                                                                                                [
                                                                                                    ( config.failure { } )
                                                                                                    ( config.sequential { sequential-file = sequential-file ; sequential-lock = sequential-lock ; } )
                                                                                                    pkgs.coreutils
                                                                                                ] ;
                                                                                        text =
                                                                                            ''
                                                                                                TARGET="$1"
                                                                                                mkdir --parents /mounts/gc-root/$INDEX"
                                                                                                SEQUENCE="$( sequential )" failure 8686853400084478
                                                                                                ln --symbolic "$TARGET" "/mounts/gc-roots/$INDEX"
                                                                                            '' ;
                                                                                    } ;
                                                                        type = lib.types.functionTo lib.types.package ;
                                                                    } ;
                                                        } ;
                                                } ;
                            in
                                {
                                    check =
                                        {
                                            failure ,
                                            nixosTest ,
                                            obviated-by ,
                                            sequential
                                        } :
                                        {
                                            pre-test ,
                                            expected
                                        } :
                                        {
                                            index ,
                                            target
                                        } :
                                            let
                                                test =
                                                    nixosTest
                                                        {
                                                            name = "failure" ;
                                                            nodes.client =
                                                                { config , pkgs , ... } @module :
                                                                    let
                                                                        identified =
                                                                            if builtins.typeOf input == "lambda" then input module
                                                                            else if builtins.typeOf input == "null" then module
                                                                            else builtins.throw "1146402310165249" ;
                                                                        in
                                                                            with identified ;
                                                                                {
                                                                                    environment.systemPackages =
                                                                                        [
                                                                                            (
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "pre-test" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                        text = pre-test "/build/sequential.asc" "/build/sequential.lock" ;
                                                                                                    }
                                                                                            )
                                                                                            (
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "test-script" ;
                                                                                                        runtimeInputs =
                                                                                                            [
                                                                                                                ( config.failure { } )
                                                                                                                config.gc-root
                                                                                                            ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                gc-root ${ builtins.toString index } "${ target }"
                                                                                                                if [[ ! -L ${ target }/${ builtins.toString index }/${ builtins.toString expected } ]]
                                                                                                                then
                                                                                                                    failure 4155997642417285
                                                                                                                fi
                                                                                                                FILE="$( readlink ${ target }/${ builtins.toString index }/${ builtins.toString expected } )" || failure 3059492007086999
                                                                                                                if [[ "$FILE" != "${ target }" ]]
                                                                                                                then
                                                                                                                    failure 3606361944478177
                                                                                                                fi
                                                                                                            '' ;
                                                                                                    }
                                                                                            )
                                                                                        ] ;
                                                                                    imports = [ failure implementation sequential ] ;
                                                                                } ;
                                                            testScript =
                                                                ''
                                                                    client.wait_for_unit("multi-user.target")
                                                                    client.succeed("pre-test")
                                                                    client.succeed("test-script")
                                                                '' ;
                                                        } ;
                                                in
                                                    {
                                                        obviated-by = obviated-by ;
                                                        test = test ;
                                                        type = "failure" ;
                                                    } ;
                                    implementation =
                                        if builtins.typeOf output == "lambda" then output implementation
                                        else if builtins.typeOf output == "null" then implementation
                                        else builtins.throw "7073634666273476" ;
                                } ;
            } ;
}
