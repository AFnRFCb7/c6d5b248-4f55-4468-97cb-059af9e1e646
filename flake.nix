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
                                                                            config.lazy-shell-application
                                                                                {
                                                                                    mounts = { gc-roots = { source = gc-roots-dir ; type = "bind" ; } ; } ;
                                                                                    name = "gc-root" ;
                                                                                    post = null ;
                                                                                    runtime-inputs = { config , pkgs , ... } : [ ( config.failure { } ) config.sequential pkgs.coreutils ] ;
                                                                                    text =
                                                                                        ''
                                                                                            INDEX=$INDEX
                                                                                            TARGET="$1"
                                                                                            mkdir --parents /mounts/gc-root/$INDEX"
                                                                                            SEQUENCE="$( sequential )" failure 8686853400084478
                                                                                            ln --symbolic "$TARGET" "/mounts/gc-roots/$INDEX"
                                                                                        '' ;
                                                                                } ;
                                                                        type = lib.types.package ;
                                                                    } ;
                                                        } ;
                                                } ;
                            in
                                {
                                    check =
                                        {
                                            nixosTest ,
                                            obviated-by
                                        } :
                                        {
                                            compile-time-arguments ,
                                            planned-error ,
                                            unplanned-error
                                        } :
                                        {
                                            run-time-arguments ? [ ]
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
                                                                                                        name = "test-script" ;
                                                                                                        runtimeInputs =
                                                                                                            [
                                                                                                                pkgs.coreutils
                                                                                                                pkgs.diffutils
                                                                                                                pkgs.jq
                                                                                                                (
                                                                                                                    config.failure
                                                                                                                        {
                                                                                                                            compile-time-arguments = compile-time-arguments ;
                                                                                                                            planned-error = planned-error ;
                                                                                                                            unplanned-error = unplanned-error ;
                                                                                                                        }
                                                                                                                )
                                                                                                            ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                OUT=/build/test
                                                                                                                COMPILE_TIME_ARGUMENTS="$( cat ${ builtins.toFile "compile-time-arguments.json" ( builtins.toJSON compile-time-arguments ) } )" || exit ${ builtins.toString unplanned-error }
                                                                                                                RUN_TIME_ARGUMENTS="$( cat ${ builtins.toFile "run-time-arguments.json" ( builtins.toJSON run-time-arguments ) } )" || exit ${ builtins.toString unplanned-error }
                                                                                                                mkdir --parents "$OUT/expected"
                                                                                                                jq \
                                                                                                                    --null-input \
                                                                                                                    --sort-keys \
                                                                                                                    --argjson COMPILE_TIME_ARGUMENTS "$COMPILE_TIME_ARGUMENTS" \
                                                                                                                    --argjson RUN_TIME_ARGUMENTS "$RUN_TIME_ARGUMENTS" \
                                                                                                                    '{
                                                                                                                        "arguments" :
                                                                                                                            {
                                                                                                                                "compile" : $COMPILE_TIME_ARGUMENTS ,
                                                                                                                                "run" : $RUN_TIME_ARGUMENTS
                                                                                                                            } ,
                                                                                                                        "inputs" : { }
                                                                                                                    }' > "$OUT/expected/standard-error"
                                                                                                                echo -n "" > "$OUT/expected/standard-output"
                                                                                                                echo -n ${ builtins.toString planned-error } > "$OUT/expected/status"
                                                                                                                mkdir --parents "$OUT/observed"
                                                                                                                if failure ${ builtins.concatStringsSep " " run-time-arguments } > "$OUT/observed/standard-output" 2> "$OUT/observed/standard-error"
                                                                                                                then
                                                                                                                    echo -n "$?" > "$OUT/observed/status"
                                                                                                                else
                                                                                                                    echo -n "$?" > "$OUT/observed/status"
                                                                                                                fi
                                                                                                                diff --unified "$OUT/expected" "$OUT/observed"
                                                                                                            '' ;
                                                                                                    }
                                                                                            )
                                                                                        ] ;
                                                                                    imports = [ implementation ] ;
                                                                                } ;
                                                            testScript =
                                                                ''
                                                                    client.wait_for_unit("multi-user.target")
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
