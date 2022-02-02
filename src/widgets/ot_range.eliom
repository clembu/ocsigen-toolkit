(* Ocsigen
 * http://www.ocsigen.org
 * Copyright (C) 2015
 * Vasilis Papavasileiou
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

[%%shared.start] (* shared by default, override as necessary *)

open Eliom_content.Html
open Eliom_shared.React.S.Infix

let display_aux (_, _, a) v =
  let v = match a with Some a -> a.(v) | None -> string_of_int v
  and a = [D.a_class ["ot-r-value"]] in
  D.div ~a [D.txt v]

let%client go_up (lb, ub, a) r (f : ?step:_ -> _) =
  let v = Eliom_shared.React.S.value r in
  assert (v <= ub - 1);
  f (if v = ub - 1 then lb else v + 1)

let%client go_down (lb, ub, a) r (f : ?step:_ -> _) =
  let v = Eliom_shared.React.S.value r in
  assert (v >= lb);
  f (if v = lb then ub - 1 else v - 1)

let display_aux e r = r >|= [%shared display_aux ~%e] |> R.node

let display ?(txt_up = "up") ?(txt_down = "down") e (v, f) =
  let open D in
  div
    ~a:[a_class ["ot-range"]]
    [ div
        ~a:
          [ a_class ["ot-r-up"]
          ; a_onclick [%client (fun _ -> go_up ~%e ~%v ~%f : _ -> _)] ]
        [txt txt_up]
    ; display_aux e v
    ; div
        ~a:
          [ a_class ["ot-r-down"]
          ; a_onclick [%client (fun _ -> go_down ~%e ~%v ~%f : _ -> _)] ]
        [txt txt_down] ]

let make ?txt_up ?txt_down ?f ?(lb = 0) ub =
  assert (ub > lb);
  let ((v, _) as rp) = Eliom_shared.React.S.create lb
  and a =
    match f with
    | Some f ->
        let f i = f (i + lb) in
        Some (Array.init (ub - lb) f)
    | None -> None
  in
  display ?txt_up ?txt_down (lb, ub, a) rp, v
