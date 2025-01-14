(* Taken from sertop / Coq *)
let get_all_proof_names () =
  (Vernacstate.Declare.get_all_proof_names () [@ocaml.warning "-3"])

let ensure_no_pending_proofs ~in_file ~st =
  match st.Vernacstate.lemmas with
  | Some _lemmas ->
    let pfs = get_all_proof_names () in
    CErrors.user_err
      Pp.(
        str "There are pending proofs in file "
        ++ str in_file ++ str ": "
        ++ (pfs |> List.rev |> prlist_with_sep pr_comma Names.Id.print)
        ++ str ".")
  | None ->
    let pm = st.Vernacstate.program in
    let what_for = Pp.str ("file " ^ in_file) in
    NeList.iter
      (fun pm -> Declare.Obls.check_solved_obligations ~what_for ~pm)
      pm

let save_vo ~st ~ldir ~in_file =
  let st = State.to_coq st in
  let () = ensure_no_pending_proofs ~in_file ~st in
  let out_vo = Filename.(remove_extension in_file) ^ ".vo" in
  let output_native_objects = false in
  let todo_proofs = Library.ProofsTodoNone in
  let () =
    Library.save_library_to todo_proofs ~output_native_objects ldir out_vo
  in
  ()
