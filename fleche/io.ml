module CallBack = struct
  type t =
    { log_error : string -> string -> unit
    ; send_diagnostics :
        uri:string -> version:int -> Types.Diagnostic.t list -> unit
    ; send_fileProgress :
        uri:string -> version:int -> (Types.Range.t * int) list -> unit
    }

  let default =
    { log_error = (fun _ _ -> ())
    ; send_diagnostics = (fun ~uri:_ ~version:_ _ -> ())
    ; send_fileProgress = (fun ~uri:_ ~version:_ _ -> ())
    }

  let cb = ref default
  let set t = cb := t
end

module Log = struct
  let error d m = !CallBack.cb.log_error d m
end

module Report = struct
  let diagnostics ~uri ~version d =
    !CallBack.cb.send_diagnostics ~uri ~version d

  let fileProgress ~uri ~version d =
    !CallBack.cb.send_fileProgress ~uri ~version d
end